@echo off
echo UniDsproc testing suite.
echo ------------------------

SET thumb=%1
SET dsproc=%2

::SET thumb="f0 43 bb 22 44 ad 2e 45 87 ae 7c b9 4d 5d bf 3d 45 09 c6 65"
::SET dsproc="d:\!_Coding\!_Win\C#\!_UNIDSPROC\UniDsproc\UniDsproc\bin\Debug\UniDsproc.exe"

echo %thumb%
echo %dsproc%
::==================================================================SIGNING
echo Testing signing
echo ------------------------
echo rsa_sha256.string
	%dsproc% sign -ignore_expired=true -signature_type=rsa_sha256.string -thumbprint=%thumb% input_string.txt signed.txt
pause
echo ------------------------
echo rsa2048_sha256.string
	%dsproc% sign -ignore_expired=true -signature_type=rsa2048_sha256.string -thumbprint=%thumb% input_string.txt signed.txt
pause
echo ------------------------



echo sig_detached
	%dsproc% sign -ignore_expired=true -signature_type=sig_detached -thumbprint=%thumb% smev2.base.xml signed.sig
pause
echo ------------------------
echo sig_detached.nocert
	%dsproc% sign -ignore_expired=true -signature_type=sig_detached.nocert -thumbprint=%thumb% smev2.base.xml signed.sig
pause
echo ------------------------
echo sig_detached.allcert
	%dsproc% sign -ignore_expired=true -signature_type=sig_detached.allcert -thumbprint=%thumb% smev2.base.xml signed.sig
pause
echo ------------------------



echo pkcs7.string
	%dsproc% sign -ignore_expired=true -signature_type=pkcs7.string -thumbprint=%thumb% input_string.txt signed.txt
pause
echo ------------------------
echo pkcs7.string.nocert
	%dsproc% sign -ignore_expired=true -signature_type=pkcs7.string.nocert -thumbprint=%thumb% input_string.txt signed.txt
pause
echo ------------------------
echo pkcs7.string.allcert
	%dsproc% sign -ignore_expired=true -signature_type=pkcs7.string.allcert -thumbprint=%thumb% input_string.txt signed.txt
pause
echo ------------------------



echo smev2_sidebyside.detached
	%dsproc% sign -ignore_expired=true -signature_type=smev2_sidebyside.detached -thumbprint=%thumb% -node_id="SIGNED_BY_SERVER" smev2.sidebyside.xml smev2.sidebyside.signed.xml
pause
echo ------------------------
echo smev2_sidebyside.detached gost_2012_256
	%dsproc% sign -ignore_expired=true -signature_type=smev2_sidebyside.detached -gost_flavor=Gost2012_256 -thumbprint=%thumb% -node_id="SIGNED_BY_SERVER" smev2.sidebyside.xml smev2.sidebyside.gost2012.256.signed.xml
pause
echo ------------------------
echo smev2_charge.enveloped
	%dsproc% sign -ignore_expired=true -signature_type=smev2_charge.enveloped -thumbprint=%thumb% smev2.charge.xml smev2.charge.signed.xml
pause
echo ------------------------
echo smev2_charge.enveloped gost_2012_256
	%dsproc% sign -ignore_expired=true -signature_type=smev2_charge.enveloped -gost_flavor=Gost2012_256 -thumbprint=%thumb% smev2.charge.xml smev2.charge.gost2012.256.signed.xml
pause
echo ------------------------
echo smev2_base.detached
	%dsproc% sign -ignore_expired=true -signature_type=smev2_base.detached -thumbprint=%thumb% smev2.base.xml smev2.base.signed.xml
pause
echo ------------------------
echo smev2_base.detached gost_2012_256
	%dsproc% sign -ignore_expired=true -signature_type=smev2_base.detached -gost_flavor=Gost2012_256 -thumbprint=%thumb% smev2.base.xml smev2.base.gost2012.256.signed.xml
pause
echo ------------------------



echo smev3_base.detached
	%dsproc% sign -ignore_expired=true -signature_type=smev3_base.detached -thumbprint=%thumb% -node_id="SIGNED_BY_SERVER" smev3.base.xml smev3.base.signed.xml
pause
echo ------------------------
echo smev3_base.detached gost_2012_256
	%dsproc% sign -ignore_expired=true -signature_type=smev3_base.detached -gost_flavor=Gost2012_256 -thumbprint=%thumb% -node_id="SIGNED_BY_SERVER" smev3.base.xml smev3.base.gost2012.256.signed.xml
pause
echo ------------------------
echo smev3_sidebyside.detached
	%dsproc% sign -ignore_expired=true -signature_type=smev3_sidebyside.detached -thumbprint=%thumb% -node_id="SIGNED_BY_SERVER" smev3.sidebyside.xml smev3.sidebyside.signed.xml
pause
echo ------------------------
echo smev3_sidebyside.detached gost_2012_256
	%dsproc% sign -ignore_expired=true -signature_type=smev3_sidebyside.detached -gost_flavor=Gost2012_256 -thumbprint=%thumb% -node_id="SIGNED_BY_SERVER" smev3.sidebyside.xml smev3.sidebyside.gost2012.256.signed.xml
pause
echo ------------------------
echo smev3_ack
	%dsproc% sign -ignore_expired=true -signature_type=smev3_ack -thumbprint=%thumb% -node_id="SIGNED_BY_SERVER" smev3.ack.xml smev3.ack.signed.xml
pause
echo ------------------------
echo smev3_ack gost_2012_256
	%dsproc% sign -ignore_expired=true -signature_type=smev3_ack -gost_flavor=Gost2012_256 -thumbprint=%thumb% -node_id="SIGNED_BY_SERVER" smev3.ack.xml smev3.ack.gost2012.256.signed.xml
pause
echo ------------------------

::==================================================================SIGNING USING CERTIFICATE NICK

echo smev3_base.detached
	%dsproc% sign -ignore_expired=true -signature_type=smev3_base.detached -cert_nick=sig3 -node_id="SIGNED_BY_SERVER" smev3.base.xml smev3.base.signed.xml
pause
echo ------------------------


::==================================================================EXTRACTION
echo Testing certificate extraction
pause
echo ------------------------
echo extract from XML
	%dsproc% extract -certificate_source=xml -node_id="SIGNED_BY_SERVER" smev2.sidebyside.signed.xml
pause
echo ------------------------
echo extract from SMEV2 XML
	%dsproc% extract -certificate_source=xml -node_id="body" smev2.base.signed.xml
pause
echo ------------------------
echo extract from base64
	%dsproc% extract -certificate_source=base64 base64.txt
pause
echo ------------------------
echo extract from cer base64 encoding
	%dsproc% extract -certificate_source=cer base_64_cert.cer
pause
echo ------------------------
echo extract from cer DER encoding
	%dsproc% extract -certificate_source=cer der_cert.cer
pause
echo ------------------------
echo extract from cer PKCS#7
	%dsproc% extract -certificate_source=cer pkcs_cert.p7b
pause
echo ------------------------
echo extract from cer PKCS#7 multiple certs in container
	%dsproc% extract -certificate_source=cer rptr_pkcs.p7b
pause
echo ------------------------
::==================================================================VERIFICATION
echo Testing signature verification
pause
echo ------------------------
echo smev2_sidebyside.detached
	%dsproc% verify -signature_type=smev2_sidebyside.detached -node_id="SIGNED_BY_SERVER" smev2.sidebyside.signed.xml
pause
echo ------------------------
echo smev2_charge.enveloped
	%dsproc% verify -signature_type=smev2_charge.enveloped smev2.charge.signed.xml
pause
echo ------------------------
echo smev2_base.detached
	%dsproc% verify -signature_type=smev2_base.detached smev2.base.signed.xml
pause
echo ------------------------
echo smev3_base.detached
	%dsproc% verify -signature_type=smev3_base.detached -node_id="SIGNED_BY_SERVER" smev3.base.signed.xml
pause
echo ------------------------
echo smev3_sidebyside.detached
	%dsproc% verify -signature_type=smev3_sidebyside.detached -node_id=SIGNED_BY_SERVER smev3.sidebyside.signed.xml
pause
echo ------------------------
echo smev3_ack
	%dsproc% verify -signature_type=smev3_ack -node_id="SIGNED_BY_SERVER" smev3.ack.signed.xml
pause
echo ------------------------
::==================================================================VERIFY AND EXTRACT
echo Testing signature verification AND extraction
pause
echo ------------------------
echo smev2_sidebyside.detached
	%dsproc% verifyAndExtract -signature_type=smev2_sidebyside.detached -node_id="SIGNED_BY_SERVER" smev2.sidebyside.signed.xml
pause
echo ------------------------
echo smev2_charge.enveloped
	%dsproc% verifyAndExtract -signature_type=smev2_charge.enveloped smev2.charge.signed.xml
pause
echo ------------------------
echo smev2_base.detached
	%dsproc% verifyAndExtract -signature_type=smev2_base.detached smev2.base.signed.xml
pause
echo ------------------------
echo smev3_base.detached
	%dsproc% verifyAndExtract -signature_type=smev3_base.detached -node_id="SIGNED_BY_SERVER" smev3.base.signed.xml
pause
echo ------------------------
echo smev3_sidebyside.detached
	%dsproc% verifyAndExtract -signature_type=smev3_sidebyside.detached -node_id="SIGNED_BY_SERVER" smev3.sidebyside.signed.xml
pause
echo ------------------------
echo smev3_ack
	%dsproc% verifyAndExtract -signature_type=smev3_ack -node_id="SIGNED_BY_SERVER" smev3.ack.signed.xml
pause
echo ------------------------
echo DONE.
pause