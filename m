From: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Subject: Re: The chunk size paradox
Date: Thu, 02 Jan 2014 23:56:15 +0100
Message-ID: <52C5EE8F.3090204@aei.mpg.de>
References: <52C1C01A.7010407@ubuntu.com> <52C57C7B.80400@shiftmail.org> <52C588A7.6010207@hardwarefreak.com> <52C59468.6080200@ubuntu.com> <52C5A9AA.9090300@hardwarefreak.com> <52C5BC28.2020003@gmail.com> <52C5EB62.1090807@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms040409000700090405030708"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C5EB62.1090807@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Joe Landman <joe.landman@gmail.com>, Phillip Susi <psusi@ubuntu.com>, joystick <joystick@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms040409000700090405030708
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi

sorry late in joining the thread

On 01/02/2014 11:42 PM, Stan Hoeppner wrote:
>=20
> Damn, you had me salivating Joe.  These are both AF 512e drives, not
> native 4K.
>=20
>> and many others.
>=20
> I've not yet seen an announcement from anyone.  I'm not all seeing, but=

> I'd think such an announcement would cross my RADAR.
>=20

Just look around:


http://www.wdc.com/wdproducts/library/SpecSheet/ENG/2879-771475.pdf

and then the FAQ about "Advanced Format":

https://wdc.custhelp.com/app/answers/detail/a_id/5655

Why would one need to align to 4k if the on disk layout would be 512bytes=
?

Or did I miss something?

Cheers

Carsten


--------------ms040409000700090405030708
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIE8DCC
BOwwggPUoAMCAQICAk/QMA0GCSqGSIb3DQEBBQUAMDYxCzAJBgNVBAYTAkRFMRMwEQYDVQQK
EwpHZXJtYW5HcmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0EwHhcNMTMwNTA2MTU1OTM4WhcNMTQw
NjA1MTU1OTM4WjA9MRMwEQYDVQQKEwpHZXJtYW5HcmlkMQwwCgYDVQQLEwNBRUkxGDAWBgNV
BAMTD0NhcnN0ZW4gQXVsYmVydDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJzM
vu6K/4EHUx/JuCoansTOW8cSyuPbvElm7IfuuEfXHJ1/m/Lbkv/C7oA+0Pvk4WCOLBx1OVUk
4vVZ0Lq6G9ekTgeZVaqFvHXKlFdUvdp3b5/nlAGc3z7GaDG/F6LdI5Iu374cTdeSvkuNseRg
KZP6Qq4GIMAZZ2hv1JC/xDxZs/59ACuL0IsjmdZPEiR8uiF01ZejehmdFiPJJP8at+PJgnoW
hW21Gh72CYI3CjvfB37Q5fUOqF1gMsfJmsJokwYfLLy8BcWbmP5BQ8IOL42F2RsuPTctnnbS
hhYj73Qyp4/Mxzeg1r34ZevEqM1pX6ceW7I/7Aos8HmhbcW71KMCAwEAAaOCAfswggH3MAwG
A1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgSwMB0GA1UdDgQWBBTeMPDcRbuXT/FdxHmf8kNH
EWVOVjAfBgNVHSMEGDAWgBTGdckorNEL/Dz/ubUe0187gGISNDAlBgNVHREEHjAcgRpDYXJz
dGVuLkF1bGJlcnRAYWVpLm1wZy5kZTAcBgNVHRIEFTATgRFncmlka2EtY2FAa2l0LmVkdTA1
BgNVHR8ELjAsMCqgKKAmhiRodHRwOi8vZ3JpZC5memsuZGUvY2EvZ3JpZGthLWNybC5kZXIw
KAYDVR0gBCEwHzAPBg0rBgEEAZQ2qywBAQEIMAwGCiqGSIb3TAUCAgEwEQYJYIZIAYb4QgEB
BAQDAgWgME4GCWCGSAGG+EIBDQRBFj9DZXJ0aWZpY2F0ZSBpc3N1ZWQgdW5kZXIgQ1AvQ1BT
IHYuIDEuOCBhdCBodHRwOi8vZ3JpZC5memsuZGUvY2EwJAYJYIZIAYb4QgECBBcWFWh0dHA6
Ly9ncmlkLmZ6ay5kZS9jYTAzBglghkgBhvhCAQgEJhYkaHR0cDovL2dyaWQuZnprLmRlL2Nh
L2dyaWRrYS1jcHMucGRmMDMGCWCGSAGG+EIBAwQmFiRodHRwOi8vZ3JpZC5memsuZGUvY2Ev
Z3JpZGthLWNybC5kZXIwDQYJKoZIhvcNAQEFBQADggEBALkdDvMzLkK1EpFkRPxEA4GpbYyy
5p59V9057HT/QUYvD7rO5KiayiRoDqgKeDW59Fek1N5W0d2IuN+j+VWLDqlBI1THd33F3Dqc
08Me/q6OkpHDjhCDnuH353n2gyxnsmXEEMozhx4onJbX0N3kZxjgNKEiP9R+zOq6Qq+CgKFS
O5w/wdtCTQ5Tpfr/n90KWYwVQ2er5dnKowu6j9YIj/dD8jJGk3T13rgzdnRzWtSQhjP8YIRf
ql08NsUgDShjNiBo289K7fpBNdVLGNI/pIA8P1ratofCGBPvMdjp+cjhulQX5//qS1ctP0ux
8MhY3kBMGynLkwibH5MiLfVSip0xggLOMIICygIBATA8MDYxCzAJBgNVBAYTAkRFMRMwEQYD
VQQKEwpHZXJtYW5HcmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0ECAk/QMAkGBSsOAwIaBQCgggFn
MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDEwMjIyNTYx
NVowIwYJKoZIhvcNAQkEMRYEFMaTnC4ehwC0TVDQgyeEgUuwvnZ1MEsGCSsGAQQBgjcQBDE+
MDwwNjELMAkGA1UEBhMCREUxEzARBgNVBAoTCkdlcm1hbkdyaWQxEjAQBgNVBAMTCUdyaWRL
YS1DQQICT9AwTQYLKoZIhvcNAQkQAgsxPqA8MDYxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpH
ZXJtYW5HcmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0ECAk/QMGwGCSqGSIb3DQEJDzFfMF0wCwYJ
YIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYI
KoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggEA
GQ6aco+kT8YMcfpH3c6jw8tAq7B9LnatpdvvUMhORQuT7C78IJEz/Ym85Ut0KP7QzGTFydxj
67Qy7NgelzRWKcNZNkA/EG4T9iuHRNxXyTUXLSBfQMyMXXamsa/AvQe00tPByONBAWbvdjaf
OV+etbf9/0WpRp9hrtHdAaCMUSeja1K7YA4BCHieIungtkOV2RkImvOltCIdxZAQ/dKVnELG
gVMBrgUD41G6AyAGFqL0IaYoBIYvytwj0+p4/HA/NFApW/nQCePSQKuSjIhwHtkldH+rSlnY
YZgJh+bQj8Wa8UKpyx0Ktq4pwo8nNwGrKTfNZ2awgyKbPm9KcQaLlQAAAAAAAA==
--------------ms040409000700090405030708--
