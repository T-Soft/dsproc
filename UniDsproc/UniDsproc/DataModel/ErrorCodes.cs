﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UniDsproc.DataModel {
	public static class ErrorCodes {
		#region [CONFIG PARSING]
		public static string ArgumentInvalidValue = "ArgumentInvalidValue";
		public static string ArgumentNullValue = "ArgumentNullValue";
		public static string UnknownArgument = "UnknownArgument";
		public static string UnknownFunction = "UnknownComand";
		public static string FileNotExist = "FileNotExist";
		#endregion

		#region [SIGNING]
		public static string SigningFailed = "SigningFailed";
		#endregion

		#region [SIGNATURE VERIFICATION]

		#endregion

		#region [CERT EXTRACTION]
		public static string CertificateExtractionException = "CertificateEatractionException";
		
		#endregion



		#region [UNKNOWN EXCEPTIONS]
		public static string UnknownException = "UnknownException";
		#endregion

	}
}
