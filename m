From: "Rene Scherer" <rene@scherer-online.com>
Subject: strange mdstat output
Date: Tue, 18 Jun 2002 01:23:28 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <BJEGJNFFDPGMGFNGEGLLIEDMCLAA.rene@scherer-online.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
	micalg=SHA1;
	protocol="application/x-pkcs7-signature";
	boundary="----=_NextPart_000_0002_01C21666.BFF31790"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.

------=_NextPart_000_0002_01C21666.BFF31790
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hi all

I've setup a RAID 1 array between 2 of my external disks (/dev/sda1 and
/dev/sdb1).

But for some reason "cat /proc/mdstat" doesn't show the first disk as
sda1[0]. Instead it shows [dev 08:01][0].

md0 : active raid1 sdb1[1] [dev 08:01][0]
      10241280 blocks [2/2] [UU]

Does anyone have any idea why?

Many thanks,
Rene



BTW: Here is my /etc/raidtab:

raiddev /dev/md0
   raid-level        1
   nr-raid-disks     2
   nr-spare-disks    0
   persistent-superblock 1
   chunk-size        4
   device   /dev/sda1
   raid-disk 0
   device   /dev/sdb1
   raid-disk 1


------=_NextPart_000_0002_01C21666.BFF31790
Content-Type: application/x-pkcs7-signature;
	name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIF0DCCAp8w
ggIIoAMCAQICAwUiPTANBgkqhkiG9w0BAQIFADCBkjELMAkGA1UEBhMCWkExFTATBgNVBAgTDFdl
c3Rlcm4gQ2FwZTESMBAGA1UEBxMJQ2FwZSBUb3duMQ8wDQYDVQQKEwZUaGF3dGUxHTAbBgNVBAsT
FENlcnRpZmljYXRlIFNlcnZpY2VzMSgwJgYDVQQDEx9QZXJzb25hbCBGcmVlbWFpbCBSU0EgMjAw
MC44LjMwMB4XDTAxMDYyOTIyMjY1OVoXDTAyMDYyOTIyMjY1OVowYDEQMA4GA1UEBBMHU2NoZXJl
cjENMAsGA1UEKhMEUmVuZTEVMBMGA1UEAxMMUmVuZSBTY2hlcmVyMSYwJAYJKoZIhvcNAQkBFhdy
ZW5lQHNjaGVyZXItb25saW5lLmNvbTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA4K2FNaht
EGrBcMcyjHIxn7UIBqAZ0vamHgPbYw7bFknOghXIs1OoLqws+OGQJvWJF++qxI2DlVSNz5SnNeJl
27ARazkJoEq0WMNAcC4LiZE5CeJq+QJobSr/JPFDOuZrkcMqyxgyXDIGuQzMBW1Lh8Wy3dCUE+3C
C5f3W8NFH5kCAwEAAaM0MDIwIgYDVR0RBBswGYEXcmVuZUBzY2hlcmVyLW9ubGluZS5jb20wDAYD
VR0TAQH/BAIwADANBgkqhkiG9w0BAQIFAAOBgQB7QoxHjMs5z/wsYpXEQ3xYuCuC456/IWKpgjWM
JpS0xDaQ8uUgTCA70VYGrWNtdaFAXxeVB7Gmw0wSe+eH+Kj0HqbKmwINQC1ErfmTv2SlAcewG/RN
G+EIM0Y6kVIzkzQsF6+ueRG+a8hPYto89MYaVqngzfgCnUHLsTd4u2MKYDCCAykwggKSoAMCAQIC
AQwwDQYJKoZIhvcNAQEEBQAwgdExCzAJBgNVBAYTAlpBMRUwEwYDVQQIEwxXZXN0ZXJuIENhcGUx
EjAQBgNVBAcTCUNhcGUgVG93bjEaMBgGA1UEChMRVGhhd3RlIENvbnN1bHRpbmcxKDAmBgNVBAsT
H0NlcnRpZmljYXRpb24gU2VydmljZXMgRGl2aXNpb24xJDAiBgNVBAMTG1RoYXd0ZSBQZXJzb25h
bCBGcmVlbWFpbCBDQTErMCkGCSqGSIb3DQEJARYccGVyc29uYWwtZnJlZW1haWxAdGhhd3RlLmNv
bTAeFw0wMDA4MzAwMDAwMDBaFw0wMjA4MjkyMzU5NTlaMIGSMQswCQYDVQQGEwJaQTEVMBMGA1UE
CBMMV2VzdGVybiBDYXBlMRIwEAYDVQQHEwlDYXBlIFRvd24xDzANBgNVBAoTBlRoYXd0ZTEdMBsG
A1UECxMUQ2VydGlmaWNhdGUgU2VydmljZXMxKDAmBgNVBAMTH1BlcnNvbmFsIEZyZWVtYWlsIFJT
QSAyMDAwLjguMzAwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAN4zMqZjxwklRT7SbngnZ4HF
2ogZgpcO40QpimM1Km1wPPrcrvfudG8wvDOQf/k0caCjbZjxw0+iZdsN+kvx1t1hpfmFzVWaNRqd
knWoJ67Ycvm6AvbXsJHeHOmr4BgDqHxDQlBRh4M88Dm0m1SKE4f/s5udSWYALQmJ7JRr6aFpAgMB
AAGjTjBMMCkGA1UdEQQiMCCkHjAcMRowGAYDVQQDExFQcml2YXRlTGFiZWwxLTI5NzASBgNVHRMB
Af8ECDAGAQH/AgEAMAsGA1UdDwQEAwIBBjANBgkqhkiG9w0BAQQFAAOBgQBzG28mZYv/FTRLWWKK
7US+ScfoDbuPuQ1qJipihB+4h2N0HG23zxpTkUvhzeY42e1Q9DpsNJKs5pKcbsEjAcIJp+9LrnLd
Bmf1UG8uWLi2C8FQV7XsHNfvF7bViJu3ooga7TlbOX00/LaWGCVNavSdxcORL6mWuAU8Uvzd6WID
SDGCAqowggKmAgEBMIGaMIGSMQswCQYDVQQGEwJaQTEVMBMGA1UECBMMV2VzdGVybiBDYXBlMRIw
EAYDVQQHEwlDYXBlIFRvd24xDzANBgNVBAoTBlRoYXd0ZTEdMBsGA1UECxMUQ2VydGlmaWNhdGUg
U2VydmljZXMxKDAmBgNVBAMTH1BlcnNvbmFsIEZyZWVtYWlsIFJTQSAyMDAwLjguMzACAwUiPTAJ
BgUrDgMCGgUAoIIBZTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0w
MjA2MTgwMDIzMjhaMCMGCSqGSIb3DQEJBDEWBBSxFZCcIhYz6kQ5iuboqEAWL8Wc/zBYBgkqhkiG
9w0BCQ8xSzBJMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDAHBgUrDgMCBzANBggqhkiG9w0D
AgIBKDAHBgUrDgMCGjAKBggqhkiG9w0CBTCBqwYJKwYBBAGCNxAEMYGdMIGaMIGSMQswCQYDVQQG
EwJaQTEVMBMGA1UECBMMV2VzdGVybiBDYXBlMRIwEAYDVQQHEwlDYXBlIFRvd24xDzANBgNVBAoT
BlRoYXd0ZTEdMBsGA1UECxMUQ2VydGlmaWNhdGUgU2VydmljZXMxKDAmBgNVBAMTH1BlcnNvbmFs
IEZyZWVtYWlsIFJTQSAyMDAwLjguMzACAwUiPTANBgkqhkiG9w0BAQEFAASBgDvuE97/KmVECARt
keQ5Yz3esl+nfuRt8Gk4gnbkncVyNDQr9W4IZyz2N8mN89esXjctdhs8n/LTN1I83lkWWi7NymCA
16xyfm65FrUNQX2BJhxjq8NfKNabhg49FCtYWXMxMTbln+6marPOICYqXVaG1CHIVVlRcPHjByft
CuBqAAAAAAAA

------=_NextPart_000_0002_01C21666.BFF31790--

