﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Instrumentation;
using System.Net;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Results;
using System.Xml.Linq;
using Serilog;
using Space.Core;
using Space.Core.Interfaces;
using UniDsproc.Api.Helpers;
using UniDsproc.Api.Infrastructure;
using UniDsproc.Api.Model;
using UniDsproc.DataModel;

namespace UniDsproc.Api.Controllers.V1
{
	[RoutePrefix("api/v1")]
	public class CommandController : ApiController
	{
		private readonly ISigner _signer;

		public CommandController()
		{ 
			_signer = new Signer();
		}

		[HttpGet]
		[Route(("{command}"))]
		public async Task<IHttpActionResult> Command(string command)
		{
			if (!Request.IsAuthorized())
			{
				Log.Logger.Fatal($"Blocked WebApiHost request from {Request.GetRemoteIp()}.");
				return StatusCode(HttpStatusCode.Forbidden);
			}

			Program.WebApiHost.ClientConnected();

			SignerInputParameters input = await ReadSignerParameters(Request, command);

			var validationResult = ValidateParameters(input);

			if (!validationResult.isParametersOk)
			{
				return BadRequest(validationResult.errorReason);
			}

			try
			{
				switch (input.ArgsInfo.Function)
				{
					case ProgramFunction.Sign:
						var signerResult = _signer.Sign(
							input.ArgsInfo.SigType,
							input.ArgsInfo.GostFlavor,
							input.ArgsInfo.CertThumbprint,
							input.DataToSign,
							input.ArgsInfo.NodeId,
							input.ArgsInfo.IgnoreExpiredCert,
							input.ArgsInfo.IsAddSigningTime);

						return signerResult.IsResultBase64Bytes
							? (IHttpActionResult) Content(
								HttpStatusCode.OK,
								Convert.FromBase64String(signerResult.SignedData),
								new FormUrlEncodedMediaTypeFormatter(),
								"application/x-binary")
							: (IHttpActionResult) Content(
								HttpStatusCode.OK,
								signerResult.SignedData,
								new FormUrlEncodedMediaTypeFormatter(),
								"text/plain;base64");
					case ProgramFunction.Verify:
					case ProgramFunction.Extract:
					case ProgramFunction.VerifyAndExtract:
					default:
						return BadRequest($"Command {command} not supported.");
				}
			}
			catch (Exception ex)
			{
				Log.Logger.Error(ex, "Error occured during signing process");
				return BadRequest(ex.Message);
			}
			finally
			{
				Program.WebApiHost.ClientDisconnected();
			}

		}

		#region Test methods

		[HttpGet]
		[Route("test")]
		public async Task<IHttpActionResult> Test()
		{
			Program.WebApiHost.ClientConnected();
			await Task.Delay(TimeSpan.FromSeconds(1));
			Program.WebApiHost.ClientDisconnected();
			return Json(DateTime.UtcNow);
		}

		#endregion

		#region Service methods
		
		private (bool isParametersOk, string errorReason) ValidateParameters(SignerInputParameters parameters)
		{
			if (parameters.DataToSign == null)
			{
				return (false, $"No data to sign.");
			}

			return (true, string.Empty);
		}

		private async Task<SignerInputParameters> ReadSignerParameters(HttpRequestMessage request, string command)
		{
			var clientDisconnected = request.GetOwinContext()?.Request?.CallCancelled ?? CancellationToken.None;

			//NOTE: this is not an in-memory way of doing the same thing
			//var root = HttpContext.Current.Server.MapPath("~/App_Data/");
			//var streamProvider = new MultipartFormDataStreamProvider(root);

			var streamProvider = new InMemoryMultipartFormDataStreamProvider();
			await request.Content.ReadAsMultipartAsync(streamProvider, clientDisconnected);

			var querySegments = request.RequestUri.ParseQueryString();

			List<string> args = new List<string>()
			{
				command
			};
			foreach (var key in querySegments.AllKeys)
			{
				var value = querySegments[key];
				args.Add($"-{key}={value}");
			}

			ArgsInfo argsInfo = new ArgsInfo(args.ToArray(), true);

			var dataToSignFile = streamProvider.Files.FirstOrDefault(f => f.Headers.ContentDisposition.Name == "data_to_sign");

			byte[] dataToSign = null;
			if (dataToSignFile != null)
			{
				dataToSign = await dataToSignFile.ReadAsByteArrayAsync();
			}

			SignerInputParameters ret = new SignerInputParameters()
			{
				ArgsInfo = argsInfo,
				DataToSign = dataToSign
			};

			return ret;
		}
		
		#endregion
	}
}