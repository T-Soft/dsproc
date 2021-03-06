﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace Space.Core.Communication
{
	public class VerifierResponse
	{
		public bool IsSignatureMathematicallyValid { set; get; }
		public bool IsSignatureSigningDateValid { set; get; }
		public string Message { set; get; }
		[JsonProperty("IsSignatureValid")]
		public bool IsSignatureValid => IsSignatureMathematicallyValid && IsSignatureSigningDateValid;

		public static VerifierResponse Invalid(string message) => new VerifierResponse()
		{
			IsSignatureMathematicallyValid = false,
			IsSignatureSigningDateValid = false,
			Message = message
		};

		public static VerifierResponse Valid => new VerifierResponse()
		{
			IsSignatureMathematicallyValid = true,
			IsSignatureSigningDateValid = true,
			Message = "Signature is valid"
		};
	}
}
