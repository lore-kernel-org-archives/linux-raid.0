From: Vandalon <joris@vandalon.nl>
Subject: Recovering failed raid6 with 3 failing devices.
Date: Wed, 24 Feb 2016 21:29:35 +0100
Message-ID: <1E25F099-6730-4A26-9805-C5F547B42276@vandalon.nl>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: multipart/signed; boundary="Apple-Mail=_9CC6853A-6083-4D02-A161-44D4A659D6EB"; protocol="application/pkcs7-signature"; micalg=sha1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Apple-Mail=_9CC6853A-6083-4D02-A161-44D4A659D6EB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi,

I am trying to recover a 10 disk raid6-set, but to no succes.

After reading https://raid.wiki.kernel.org/index.php/RAID_Recovery, I =
tried the following but the =E2=80=94force option does not seem to work:=20=


root@kvm:/var/log# mdadm --assemble --verbose --force /dev/md127 =
/dev/sd[q-z]
mdadm: looking for devices for /dev/md127
mdadm: /dev/sdq is identified as a member of /dev/md127, slot 2.
mdadm: /dev/sdr is identified as a member of /dev/md127, slot 3.
mdadm: /dev/sds is identified as a member of /dev/md127, slot 4.
mdadm: /dev/sdt is identified as a member of /dev/md127, slot 5.
mdadm: /dev/sdu is identified as a member of /dev/md127, slot 6.
mdadm: /dev/sdv is identified as a member of /dev/md127, slot 7.
mdadm: /dev/sdw is identified as a member of /dev/md127, slot 1.
mdadm: /dev/sdx is identified as a member of /dev/md127, slot 0.
mdadm: /dev/sdy is identified as a member of /dev/md127, slot 8.
mdadm: /dev/sdz is identified as a member of /dev/md127, slot 9.
mdadm: added /dev/sdw to /dev/md127 as 1
mdadm: added /dev/sdq to /dev/md127 as 2
mdadm: added /dev/sdr to /dev/md127 as 3
mdadm: added /dev/sds to /dev/md127 as 4
mdadm: added /dev/sdt to /dev/md127 as 5
mdadm: added /dev/sdu to /dev/md127 as 6
mdadm: added /dev/sdv to /dev/md127 as 7 (possibly out of date)
mdadm: added /dev/sdy to /dev/md127 as 8 (possibly out of date)
mdadm: added /dev/sdz to /dev/md127 as 9 (possibly out of date)
mdadm: added /dev/sdx to /dev/md127 as 0
mdadm: /dev/md127 assembled from 7 drives - not enough to start the =
array.

The Event differences between the devices is not that much:

root@kvm:/var/log# mdadm -E /dev/sd[q-z] |grep Event
         Events : 9979
         Events : 9979
         Events : 9979
         Events : 9979
         Events : 9979
         Events : 9974
         Events : 9979
         Events : 9979
         Events : 9971
         Events : 9976

I=E2=80=99m running=20
Linux kvm.wiebel.nl 4.2.0-30-generic #35-Ubuntu SMP Fri Feb 19 13:52:26 =
UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

and using mdadm - v3.3 - 3rd September 2013

Any help here would be very much appreciated, I=E2=80=99m guessing i=E2=80=
=99m overlooking something :)

Best regards,
Joris=20



--Apple-Mail=_9CC6853A-6083-4D02-A161-44D4A659D6EB
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIMXTCCBiEw
ggUJoAMCAQICAw4ZwTANBgkqhkiG9w0BAQUFADCBjDELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0
YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcx
ODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDEgUHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENB
MB4XDTE1MDUxOTE3MTI0NVoXDTE2MDUyMDAxNDIxNlowPjEaMBgGA1UEAwwRam9yaXNAdmFuZGFs
b24ubmwxIDAeBgkqhkiG9w0BCQEWEWpvcmlzQHZhbmRhbG9uLm5sMIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEA1KjsFVORSVPpwr4ZqJb/fSANMe39T2sSBmDGNjAuhgH5P+IG0uGAlTcG
Q/G5dJac+cY74b6XL1T8iQjh+Z8bcSpRsAvMTXqPeKtBih1mkrEYdYCvOibAN7GDEuUkLqp1zWLa
uh4+SPCgGibJYBrs2KC9OxbROxP8P0s9vorFgwSPNmlJlVIFPjinZDzxRh1HxH3uMg4TNw8ovdPl
K+feXg4H40BQEdR/oriBLndLYqJajbh/ZCVua/Da6Qh/Vv8rRkJJj/hlxCexrjISR9bKi63oXKOT
jw4ivF4UaXstlDy9hwkfsuOhGeNKFa0rpzseZzZiEYOlRAOQ9PXbcZ4DbQIDAQABo4IC1zCCAtMw
CQYDVR0TBAIwADALBgNVHQ8EBAMCBLAwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMB0G
A1UdDgQWBBR/iukuL2poIHToeniB4nUN5eqm+TAfBgNVHSMEGDAWgBRTcu2SnODaywFcfH6WNU7y
1LhRgjAcBgNVHREEFTATgRFqb3Jpc0B2YW5kYWxvbi5ubDCCAUwGA1UdIASCAUMwggE/MIIBOwYL
KwYBBAGBtTcBAgMwggEqMC4GCCsGAQUFBwIBFiJodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xp
Y3kucGRmMIH3BggrBgEFBQcCAjCB6jAnFiBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTADAgEBGoG+VGhpcyBjZXJ0aWZpY2F0ZSB3YXMgaXNzdWVkIGFjY29yZGluZyB0byB0aGUgQ2xh
c3MgMSBWYWxpZGF0aW9uIHJlcXVpcmVtZW50cyBvZiB0aGUgU3RhcnRDb20gQ0EgcG9saWN5LCBy
ZWxpYW5jZSBvbmx5IGZvciB0aGUgaW50ZW5kZWQgcHVycG9zZSBpbiBjb21wbGlhbmNlIG9mIHRo
ZSByZWx5aW5nIHBhcnR5IG9ibGlnYXRpb25zLjA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3Js
LnN0YXJ0c3NsLmNvbS9jcnR1MS1jcmwuY3JsMIGOBggrBgEFBQcBAQSBgTB/MDkGCCsGAQUFBzAB
hi1odHRwOi8vb2NzcC5zdGFydHNzbC5jb20vc3ViL2NsYXNzMS9jbGllbnQvY2EwQgYIKwYBBQUH
MAKGNmh0dHA6Ly9haWEuc3RhcnRzc2wuY29tL2NlcnRzL3N1Yi5jbGFzczEuY2xpZW50LmNhLmNy
dDAjBgNVHRIEHDAahhhodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS8wDQYJKoZIhvcNAQEFBQADggEB
AEp4q91dgYzCoCRwhIOwdQy5rTQRI6dcPJ5U/i7k09WnvF1dE2NKyICziu8gYgJgcOSvlNQwtQsf
zUX8vI96G7NgqDv/Oy3z5MbxCLX5A4iW5RmELw0m21BXD2DGdVUW8EDSv0CdEPVdJNfPEy51MYAG
J0vxocmc74RsSdzr6CAmS71ibN6PIhVOZ+RAQFI5cozfNDNuTzyBF0B1oAM4kht36W086gQS3Gbl
EFyTP4oVbqdBW2nHojmupGzFshTcE28F3Tn7FLBXmTFhlcDFOiXytGG7OLdhKiU3a4bhRgKWJ89q
31nf1tmDlFI/lVTxXwyg/qtU8swWfpVBFq6zYNkwggY0MIIEHKADAgECAgEeMA0GCSqGSIb3DQEB
BQUAMH0xCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1
cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMSkwJwYDVQQDEyBTdGFydENvbSBDZXJ0aWZp
Y2F0aW9uIEF1dGhvcml0eTAeFw0wNzEwMjQyMTAxNTVaFw0xNzEwMjQyMTAxNTVaMIGMMQswCQYD
VQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwg
Q2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IElu
dGVybWVkaWF0ZSBDbGllbnQgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDHCYPM
zi3YGrEppC4Tq5a+ijKDjKaIQZZVR63UbxIP6uq/I0fhCu+cQhoUfE6ERKKnu8zPf1Jwuk0tsvVC
k6U9b+0UjM0dLep3ZdE1gblK/1FwYT5Pipsu2yOMluLqwvsuz9/9f1+1PKHG/FaR/wpbfuIqu54q
zHDYeqiUfsYzoVflR80DAC7hmJ+SmZnNTWyUGHJbBpA8Q89lGxahNvuryGaC/o2/ceD2uYDX9U8E
g5DpIpGQdcbQeGarV04WgAUjjXX5r/2dabmtxWMZwhZna//jdiSyrrSMTGKkDiXm6/3/4ebfeZuC
YKzN2P8O2F/Xe2AC/Y7zeEsnR7FOp+uXAgMBAAGjggGtMIIBqTAPBgNVHRMBAf8EBTADAQH/MA4G
A1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUU3Ltkpzg2ssBXHx+ljVO8tS4UYIwHwYDVR0jBBgwFoAU
TgvvGqRAW6UXaYcwyjRoQ9BBrvIwZgYIKwYBBQUHAQEEWjBYMCcGCCsGAQUFBzABhhtodHRwOi8v
b2NzcC5zdGFydHNzbC5jb20vY2EwLQYIKwYBBQUHMAKGIWh0dHA6Ly93d3cuc3RhcnRzc2wuY29t
L3Nmc2NhLmNydDBbBgNVHR8EVDBSMCegJaAjhiFodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9zZnNj
YS5jcmwwJ6AloCOGIWh0dHA6Ly9jcmwuc3RhcnRzc2wuY29tL3Nmc2NhLmNybDCBgAYDVR0gBHkw
dzB1BgsrBgEEAYG1NwECATBmMC4GCCsGAQUFBwIBFiJodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9w
b2xpY3kucGRmMDQGCCsGAQUFBwIBFihodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9pbnRlcm1lZGlh
dGUucGRmMA0GCSqGSIb3DQEBBQUAA4ICAQAKgwh9eKssBly4Y4xerhy5I3dNoXHYfYa8PlVLL/qt
XnkFgdtY1o95CfegFJTwqBBmf8pyTUnFsukDFUI22zF5bVHzuJ+GxhnSqN2sD1qetbYwBYK2iyYA
5Pg7Er1A+hKMIzEzcduRkIMmCeUTyMyikfbUFvIBivtvkR8ZFAk22BZy+pJfAoedO61HTz4qSfQo
CRcLN5A0t4DkuVhTMXIzuQ8CnykhExD6x4e6ebIbrjZLb7L+ocR0y4YjCl/Pd4MXU91y0vTipgr/
O75CDUHDRHCCKBVmz/Rzkc/b970MEeHt5LC3NiWTgBSvrLEuVzBKM586YoRD9Dy3OHQgWI270g+5
MYA8GfgI/EPT5G7xPbCDz+zjdH89PeR3U4So4lSXur6H6vp+m9TQXPF3a0LwZrp8MQ+Z77U1uL7T
elWO5lApsbAonrqASfTpaprFVkL4nyGH+NHST2ZJPWIBk81i6Vw0ny0qZW2Niy/QvVNKbb43A43n
y076khXO7cNbBIRdJ/6qQNq9Bqb5C0Q5nEsFcj75oxQRqlKf6TcvGbjxkJh8BYtv9ePsXklAxtm8
J7GCUBthHSQgepbkOexhJ0wP8imUkyiPHQ0GvEnd83129fZjoEhdGwXV27ioRKbj/cIq7JRXun0N
beY+UdMYu9jGfIpDLtUUGSgsg2zMGs5R4jGCA28wggNrAgEBMIGUMIGMMQswCQYDVQQGEwJJTDEW
MBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNh
dGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0
ZSBDbGllbnQgQ0ECAw4ZwTAJBgUrDgMCGgUAoIIBrzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0xNjAyMjQyMDI5MzVaMCMGCSqGSIb3DQEJBDEWBBRVWibSqq6XoL5u
BBbT7w/iigcRmDCBpQYJKwYBBAGCNxAEMYGXMIGUMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMN
U3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmlu
ZzE4MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQg
Q0ECAw4ZwTCBpwYLKoZIhvcNAQkQAgsxgZeggZQwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
dGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5n
MTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAxIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBD
QQIDDhnBMA0GCSqGSIb3DQEBAQUABIIBAHMqETZBDBalnbuhTrUmbDdC4e8iDtn2/aA4VQzQ9iA8
5leLr41xEfQoW40DzS8OiODTJkebQXG0po+k3Ox5cH6M57Jmw2PBrzZKb3ZM8fUcYqKrkZaG3+un
Hbc0haNNP1EXoeqCnZ82AKiZ+5s+ZfIFCNttWcPGKbX7LTiCNcp7WBDP6r1VBOtS45aS+h74is3B
DPB1j1T/du1vKMTRW6zexVfzk1rbhL+2yI5KkMdQtz2IEdfrMY2pdgP0lWJ/v3WG7cITCX46cGts
ELGfi7X1p5nUBtbgo9fVEVkImnL9/j076EY1bl5oj7Sf7zfUBkxhD97sw9/cngOVb5ujVzIAAAAA
AAA=
--Apple-Mail=_9CC6853A-6083-4D02-A161-44D4A659D6EB--
