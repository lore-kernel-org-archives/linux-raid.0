From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: What layout with 6x2TB, Intel Atom?
Date: Tue, 05 Feb 2013 09:59:59 +1100
Message-ID: <51103D6F.8060602@crc.id.au>
References: <CADNH=7EUc7z-E=uo74-QqaKEUcrZiAYKaZqtSfFVbLKpfvt7og@mail.gmail.com> <20130205031232.61813f6c@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms040407010001000802010903"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130205031232.61813f6c@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms040407010001000802010903
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 5/02/2013 8:12 AM, Roman Mamedov wrote:
> On Mon, 4 Feb 2013 20:27:42 +0000
> Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:
>
>> I read that the far layout gives faster read performance compared to
>> standard RAID1 in a 2 HDD array, so that's why I used it. I then
>> created yet another RAID10 f2 layout of the 3x 2 disk RAID10 volumes,
>> giving me /dev/md124. Filesystem doesn't matter, I need something
>> that's stable with good performance over the RAID set.
>> I just realized that out of 12 TB raw space I now only have 3TB
>> available, heh. So I suppose I'm going for a different layout.
>>
>> Any opinions?
>
> Hello,
>
> Why won't you even consider RAID6? To me it seems like the perfect choi=
ce,
> given the details you described (mostly reads, large files, few clients=
).
> And the disk count is perfect, not too few and not too many, so to say =
:D
>

I was going to say the same. I run a 4 x 2Tb SATA RAID6. The read speeds =

will *easily* saturate GigE. Random seeks slow things down quite a bit - =

but you'll get that with any setup except SSD.

If its mainly sequential reads, then RAID6 will be fine.

And as I know someone will ask... Why 4 drives in RAID6? Firstly, you=20
still get the redundancy of surviving 2 drive failures - but also when I =

start to run low on space I can easily add another 2Tb disk and reshape=20
to 5 drives, then 6. My chassis has 8 x SATA hot swap bays - 2 x 80Gb=20
RAID1 leaving the other 6 for the RAID6. By the time I fill up 6 x 2Tb=20
drives, there will be other cheap multi-Tb drives to use.

--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299


--------------ms040407010001000802010903
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIMdTCC
BjQwggQcoAMCAQICAR4wDQYJKoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA3
MTAyNDIxMDE1NVoXDTE3MTAyNDIxMDE1NVowgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
dGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWdu
aW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAxIFByaW1hcnkgSW50ZXJtZWRpYXRlIENs
aWVudCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMcJg8zOLdgasSmkLhOr
lr6KMoOMpohBllVHrdRvEg/q6r8jR+EK75xCGhR8ToREoqe7zM9/UnC6TS2y9UKTpT1v7RSM
zR0t6ndl0TWBuUr/UXBhPk+Kmy7bI4yW4urC+y7P3/1/X7U8ocb8VpH/Clt+4iq7nirMcNh6
qJR+xjOhV+VHzQMALuGYn5KZmc1NbJQYclsGkDxDz2UbFqE2+6vIZoL+jb9x4Pa5gNf1TwSD
kOkikZB1xtB4ZqtXThaABSONdfmv/Z1pua3FYxnCFmdr/+N2JLKutIxMYqQOJebr/f/h5t95
m4JgrM3Y/w7YX9d7YAL9jvN4SydHsU6n65cCAwEAAaOCAa0wggGpMA8GA1UdEwEB/wQFMAMB
Af8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBRTcu2SnODaywFcfH6WNU7y1LhRgjAfBgNV
HSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jBmBggrBgEFBQcBAQRaMFgwJwYIKwYBBQUH
MAGGG2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9jYTAtBggrBgEFBQcwAoYhaHR0cDovL3d3
dy5zdGFydHNzbC5jb20vc2ZzY2EuY3J0MFsGA1UdHwRUMFIwJ6AloCOGIWh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL3Nmc2NhLmNybDAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5jb20v
c2ZzY2EuY3JsMIGABgNVHSAEeTB3MHUGCysGAQQBgbU3AQIBMGYwLgYIKwYBBQUHAgEWImh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93
d3cuc3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwDQYJKoZIhvcNAQEFBQADggIBAAqD
CH14qywGXLhjjF6uHLkjd02hcdh9hrw+VUsv+q1eeQWB21jWj3kJ96AUlPCoEGZ/ynJNScWy
6QMVQjbbMXltUfO4n4bGGdKo3awPWp61tjAFgraLJgDk+DsSvUD6EowjMTNx25GQgyYJ5RPI
zKKR9tQW8gGK+2+RHxkUCTbYFnL6kl8Ch507rUdPPipJ9CgJFws3kDS3gOS5WFMxcjO5DwKf
KSETEPrHh7p5shuuNktvsv6hxHTLhiMKX893gxdT3XLS9OKmCv87vkINQcNEcIIoFWbP9HOR
z9v3vQwR4e3ksLc2JZOAFK+ssS5XMEoznzpihEP0PLc4dCBYjbvSD7kxgDwZ+Aj8Q9PkbvE9
sIPP7ON0fz095HdThKjiVJe6vofq+n6b1NBc8XdrQvBmunwxD5nvtTW4vtN6VY7mUCmxsCie
uoBJ9OlqmsVWQvifIYf40dJPZkk9YgGTzWLpXDSfLSplbY2LL9C9U0ptvjcDjefLTvqSFc7t
w1sEhF0n/qpA2r0GpvkLRDmcSwVyPvmjFBGqUp/pNy8ZuPGQmHwFi2/14+xeSUDG2bwnsYJQ
G2EdJCB6luQ57GEnTA/yKZSTKI8dDQa8Sd3zfXb19mOgSF0bBdXbuKhEpuP9wirslFe6fQ1t
5j5R0xi72MZ8ikMu1RQZKCyDbMwazlHiMIIGOTCCBSGgAwIBAgIDBdMXMA0GCSqGSIb3DQEB
BQUAMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMi
U2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20g
Q2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0EwHhcNMTMwMTI5MTIyMTM0
WhcNMTQwMTMwMjIzNjE4WjBXMRkwFwYDVQQNExA0MzM5TjFVWjZFS2ZBa0Y2MRkwFwYDVQQD
DBBuZXR3aXpAY3JjLmlkLmF1MR8wHQYJKoZIhvcNAQkBFhBuZXR3aXpAY3JjLmlkLmF1MIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqz7eWA7Oi1ES6IIWwtRNtOa6cSj6GSio
72D26TkCPm/vYamqS/9pluIyMO2TbGjMyveGxWZB9bDt+MnuI6yJ3spD6br5TUXQSqsgp1/g
NXicgNmUHESd/A7+POEdYKMyTtXjVEqmR8R6uPtD78MBhIKQVZdBYGFuRBhrjoFMOnWARmXD
47FG6eLH8jyeBi+RGEYEpBgTe1gFcoU1dCrjBqxAj47ALNgcHP4ffNX47DLvyhW2pMMaOYUh
ga/UyQuPOpZcMAJdVI7dTIkbdipboEEE5pTdoIRI+F+XDLzO8bNkGLa1xLTWrbP048xxw3SL
Aw/DmLYqQ+oC8vabAAqBIwIDAQABo4IC1jCCAtIwCQYDVR0TBAIwADALBgNVHQ8EBAMCBLAw
HQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMB0GA1UdDgQWBBR/FxImYCufSdz0pG5w
A8VPzNyaujAfBgNVHSMEGDAWgBRTcu2SnODaywFcfH6WNU7y1LhRgjAbBgNVHREEFDASgRBu
ZXR3aXpAY3JjLmlkLmF1MIIBTAYDVR0gBIIBQzCCAT8wggE7BgsrBgEEAYG1NwECAzCCASow
LgYIKwYBBQUHAgEWImh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwgfcGCCsG
AQUFBwICMIHqMCcWIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MAMCAQEagb5U
aGlzIGNlcnRpZmljYXRlIHdhcyBpc3N1ZWQgYWNjb3JkaW5nIHRvIHRoZSBDbGFzcyAxIFZh
bGlkYXRpb24gcmVxdWlyZW1lbnRzIG9mIHRoZSBTdGFydENvbSBDQSBwb2xpY3ksIHJlbGlh
bmNlIG9ubHkgZm9yIHRoZSBpbnRlbmRlZCBwdXJwb3NlIGluIGNvbXBsaWFuY2Ugb2YgdGhl
IHJlbHlpbmcgcGFydHkgb2JsaWdhdGlvbnMuMDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9j
cmwuc3RhcnRzc2wuY29tL2NydHUxLWNybC5jcmwwgY4GCCsGAQUFBwEBBIGBMH8wOQYIKwYB
BQUHMAGGLWh0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9zdWIvY2xhc3MxL2NsaWVudC9jYTBC
BggrBgEFBQcwAoY2aHR0cDovL2FpYS5zdGFydHNzbC5jb20vY2VydHMvc3ViLmNsYXNzMS5j
bGllbnQuY2EuY3J0MCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cuc3RhcnRzc2wuY29tLzANBgkq
hkiG9w0BAQUFAAOCAQEAwsdSJioQIH5mEXlMBkQBZN9qrqCvDn4e92NKIX2LMPhVH01o0weH
MEgkFMOBypbcPrwnZD51IL+ZfPmuDrcFJR9SPk4W95p3wLakMUBmvDPJ3IC+pa97+fU/GYsh
q4dth+VlAIWJarpPV5ee6hAXGQEZvC2jyy5ukcjlr/oQxegb4hufgkLhKjqaq5UDs2be5q1N
CBewezVmAbb/VDNVogP1xacnHn4rhllskMfGAda2DPCCaSMaJ3LcC5JRyfMkpKe5UxpVmVeM
vGP8hYGI9DlFjwpqRCmIvD/Wl6oWWJc0HaLl6k+U3dngqEHhunzh3H6b/3lWOmEKQuI3Piy+
oDGCA90wggPZAgEBMIGUMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRk
LjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UE
AxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0ECAwXT
FzAJBgUrDgMCGgUAoIICHTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0xMzAyMDQyMjU5NTlaMCMGCSqGSIb3DQEJBDEWBBRNTOQo7O+zDiXbfWB0ak4MP72C
7DBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcN
AwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMC
AgEoMIGlBgkrBgEEAYI3EAQxgZcwgZQwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFy
dENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5n
MTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAxIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVu
dCBDQQIDBdMXMIGnBgsqhkiG9w0BCRACCzGBl6CBlDCBjDELMAkGA1UEBhMCSUwxFjAUBgNV
BAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRl
IFNpZ25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDEgUHJpbWFyeSBJbnRlcm1lZGlh
dGUgQ2xpZW50IENBAgMF0xcwDQYJKoZIhvcNAQEBBQAEggEARcZVlXB/JtB60Vm7OBu5RSzC
QksRdImb3mVSYJI4p6yMUvTUkS7bztURn4086Z4gOd2qx1Dih2BfQBlivVBpO55pCqfNNT+i
nyDl5sSbI4VowWed2CXb91CcCzKVux1j9rc0vCvJK/0LuQSMlq4PuMHCQteagA64pjZWQucf
4LB8zLfQKLV/S0Qu1enmv6RwTuSQQbO/ik4Kvs1r15xePMV2B6OuAm3vUoGTFJXSrurJXfFe
KtgQCauWQ0jh2QyqOkMBYM/+tmoqJmVXz1GfGlW8AMe9RY18AEqCVpagKRcOd6q1z3bH4MJN
LXm3IcrSZ/lRB/GNRaBlpguMw9cM2wAAAAAAAA==
--------------ms040407010001000802010903--
