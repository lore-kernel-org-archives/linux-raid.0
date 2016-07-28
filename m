From: =?UTF-8?Q?Andreas_Dr=c3=b6scher?= <raid@anticat.ch>
Subject: Re: SOLVED [was Re: GPT corruption on Primary Header, backup OK,
 fixing primary nuked array -- help?]
Date: Thu, 28 Jul 2016 22:51:55 +0200
Message-ID: <e4fd0e83-5157-1cba-184d-cb9d0b71bfdc@droescher.ch>
References: <5796B46B.6060905@suddenlinkmail.com>
 <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
 <5796F4E0.9070206@suddenlinkmail.com> <57971D3C.8040602@suddenlinkmail.com>
 <ff6872cd-98eb-aad2-a71a-7af52050ff30@websitemanagers.com.au>
 <5797C415.8010206@suddenlinkmail.com>
 <CAJCQCtSkE+-C5U9OEm0-zazLW2KHCMUqduDTA=UHsMxmf4DVrQ@mail.gmail.com>
 <5797E869.8080403@suddenlinkmail.com>
 <CAJCQCtQpGVf2Tj13o57T4=raF=czYr-V99tEDSkJ-_buk7JtTg@mail.gmail.com>
 <57985F10.4070706@suddenlinkmail.com>
 <ac25abf7-b97e-1db4-d227-2ee57a02ed90@youngman.org.uk>
 <57993F58.1050704@suddenlinkmail.com>
 <0d00162b-6726-924a-a84d-016871563d09@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="=_bugfree-18603-1469739117-0001-2"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0d00162b-6726-924a-a84d-016871563d09@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bugfree-18603-1469739117-0001-2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Am 28.07.16 um 14:53 schrieb Anthony Youngman:
> On 28/07/16 00:10, David C. Rankin wrote:
>> On 07/27/2016 08:04 AM, Anthony Youngman wrote:
>>> WD Blacks? Do they support SCT/ERC? I think these are desktop drives =
(like my
>>> Barracudas) so you WILL get bitten by the timeout problem if anything=
 goes
>>> wrong. Do you know what you're doing here?
>> Yes, WD Blacks, and yes, at least for the last 16 years I've managed, =
somehow,
>> to provide a complete open-source backend for my law office. So I woul=
d answer
>> the 2nd question in the affirmative as well. You can poo-poo drive X v=
erses
>> drive Y all you want, but I get a consistent 5 years out of each WD bl=
ack and
>> plan on a replacement cycle of 1/2 that. Go with what works for you.
>>
> I'll just say I don't think the past 16 years is a good guide at all ..=
=2E (but I
> will add I'm doing exactly the same as you - two 3TB desktop drives in =
a mirror
> :-).
>=20
> The timeout problem seems to be relatively recent. MOST 1TB or less dri=
ves don't
> seem to have an issue. It's bigger drives that will bite you.
>=20

All drives are tailored to a use case: price, power consumption (e.g. WD =
Green),
desktop performance (WD Black) and Raid (WD Red or WD Enterprise Storage =
- also
black label). One of the key feature of raid drives is TLER (Time Limited=
 error
recovery). Note: the name my vary by brand.

My WD-ES drive shows:
smartctl -l scterc /dev/sda
smartctl 6.6 2016-05-07 r4319 [...] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.o=
rg

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

server ~ #

That means that a drive will report a media error after 7 seconds and lea=
ve it
to the raid controller / raid subsystem to recover it. Linux-Raid usually=

re-covers and re-writes the bad block from the remaining drives, fixing t=
he
issue (The drives firmware relocates the sector).

Non raid optimized drives may spend a long time trying to recover such a =
sector.
Hence the raid controller will not simply fix the sector but fail the ent=
ire
drive for not responding. For this reason, an array can fail, that would =
have
not with proper.

The issue can be relaxed by tuning SCT or /sys/block/sda/device/timeout.

- Andreas


--=_bugfree-18603-1469739117-0001-2
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
CuYwggT8MIID5KADAgECAhBGi3yrh9suNX/FVge3/cLnMA0GCSqGSIb3DQEBCwUAMHUxCzAJ
BgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBD
ZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMSBDbGll
bnQgQ0EwHhcNMTYwNDAzMTUzMDQ0WhcNMTcwNDAzMTUzMDQ0WjBEMR0wGwYDVQQDDBRhbmRy
ZWFzQGRyb2VzY2hlci5jaDEjMCEGCSqGSIb3DQEJARYUYW5kcmVhc0Bkcm9lc2NoZXIuY2gw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDKnsYxYnWY8gMeA5vjpnhTEtVU8MqT
wPntRyI+zQxFQUhl8YNfuc58CCr+qjpSLp3Jun0eCs3bkhSE67/QduJuLVXkJO+SWx1+dlrr
23HG5xx5UtDFMEP0lJe3AM2mHkvjQxiBx34oEmXeZK+anlVrUtfbC+q2G4VSTc+Udg9TSrzV
R/bLCL8on8pj0btCBdZPjpkvkhF/OFDLMaQNSaZ5KkdIiauNRNSoUWSWTd0h5JbxzFfAak/T
4ClCAKHK2cX9d6FgfvIEes76uWvxa1ORtEbBpumXOWfORVGoz4w5MVOK4yV9dajXnedD9bYB
Gu8N1oq4pDW1GyOpTvFenHwPAgMBAAGjggG3MIIBszAOBgNVHQ8BAf8EBAMCBLAwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMAkGA1UdEwQCMAAwHQYDVR0OBBYEFKjcL3mUAe3F
zhh5KYTN3SPYYx91MB8GA1UdIwQYMBaAFCSBbDlhvkkPj7cbRivJKLUnSG1oMG8GCCsGAQUF
BwEBBGMwYTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3Auc3RhcnRzc2wuY29tMDkGCCsGAQUF
BzAChi1odHRwOi8vYWlhLnN0YXJ0c3NsLmNvbS9jZXJ0cy9zY2EuY2xpZW50MS5jcnQwOAYD
VR0fBDEwLzAtoCugKYYnaHR0cDovL2NybC5zdGFydHNzbC5jb20vc2NhLWNsaWVudDEuY3Js
MB8GA1UdEQQYMBaBFGFuZHJlYXNAZHJvZXNjaGVyLmNoMCMGA1UdEgQcMBqGGGh0dHA6Ly93
d3cuc3RhcnRzc2wuY29tLzBGBgNVHSAEPzA9MDsGCysGAQQBgbU3AQIFMCwwKgYIKwYBBQUH
AgEWHmh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeTANBgkqhkiG9w0BAQsFAAOCAQEA
PlW2uzhnhgg9a7cRYLRYQVB9BnrItR1TYOZ8rX9gHqU6dxlgWuLrdeOfYt5LwngwDMc/53cf
n7/dWeNflDv+e79aPvEYflxNbvf42qj4IneWsfgwUowRLRLU3aobJEab8X39jJJ4ZCFK9FJ6
/+HVRZYkVSI7oKkE/B37KrNPC4RO0iy1dai8ekTmCXLBmRhvL+R5YgyMxLbzCntoWw5k3rds
Q+m0IVlu+RX7jw318FjqBqzRLi5t5Z5KciI4ChNn74CYhgJl3NTqlfJN9iNAi6511p7YCRWH
u222xywvlksA2tBSOCmkAl7HN34AwIAZPtfxiZKfnUl40ZAOS8w56DCCBeIwggPKoAMCAQIC
EGunin0K14jWUQr5WeTntOEwDQYJKoZIhvcNAQELBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNV
BAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRl
IFNpZ25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4X
DTE1MTIxNjAxMDAwNVoXDTMwMTIxNjAxMDAwNVowdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9y
aXR5MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAxIENsaWVudCBDQTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAL192vfDon2D9luC/dtbX64eG3XAtRmvmCSsu1d52DXsCR58
zJQbCtB2/A5uFqNxWacpXGGtTCRk9dEDBlmixEd8QiLkUfvHpJX/xKnmVkS6Iye8wUbYzMsD
zgnpazlPg19dnSqfhM+Cevdfa89VLnUztRr2cgmCfyO9Otrh7LJDPG+4D8ZnAqDtVB8MKYJL
6QgKyVhhaBc4y3bGWxKyXEtx7QIZZGxPwSkzK3WIN+VKNdkiwTubW5PIdopmykwvIjLPqbJK
7yPwFZYekKE015OsW6FV+s4DIM8UlVS8pkIsoGGJtMuWjLL4tq2hYQuuN0jhrxK1ljz50hH2
3gA9cbMCAwEAAaOCAWQwggFgMA4GA1UdDwEB/wQEAwIBBjAdBgNVHSUEFjAUBggrBgEFBQcD
AgYIKwYBBQUHAwQwEgYDVR0TAQH/BAgwBgEB/wIBADAyBgNVHR8EKzApMCegJaAjhiFodHRw
Oi8vY3JsLnN0YXJ0c3NsLmNvbS9zZnNjYS5jcmwwZgYIKwYBBQUHAQEEWjBYMCQGCCsGAQUF
BzABhhhodHRwOi8vb2NzcC5zdGFydHNzbC5jb20wMAYIKwYBBQUHMAKGJGh0dHA6Ly9haWEu
c3RhcnRzc2wuY29tL2NlcnRzL2NhLmNydDAdBgNVHQ4EFgQUJIFsOWG+SQ+PtxtGK8kotSdI
bWgwHwYDVR0jBBgwFoAUTgvvGqRAW6UXaYcwyjRoQ9BBrvIwPwYDVR0gBDgwNjA0BgRVHSAA
MCwwKgYIKwYBBQUHAgEWHmh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeTANBgkqhkiG
9w0BAQsFAAOCAgEAi+P3h+wBi4StDwECW5zhIycjBL008HACblIf26HY0JdOruKbrWDsXUsi
I0j/7Crft9S5oxvPiDtVqspBOB/y5uzSns1lZwh7sG96bYBZpcGzGxpFNjDmQbcM3yl3WFIR
S4WhNrsOY14V7y2IrUGsvetsD+bjyOngCIVeC/GmsmtbuLOzJ606tEc9uRbhjTu/b0x2Fo+/
e7UkQvKzNeo7OMhijixaULyINBfCBJb+e29bLafgu6JqjOUJ9eXXj20p6q/CW+uVrZiSW57+
q5an2P2i7hP85jQJcy5j4HzA0rSiF3YPhKGAWUxKPMAVGgcYoXzWydOvZ3UDsTDTagXpRDIK
QLZo02wrlxY6iMFqvlzsemVf1odhQJmi7Eh5TbxI40kDGcBOBHhwnaOumZhLP+SWJQnjpLpS
lUOj95uf1zo9oz9e0NgIJoz/tdfrBzez76xtDsK0KfUDHt1/q59BvDI7RX6gVr0fQoCyMczN
zCTcRXYHY0tq2J0oT+bsb6sH2b4WVWAiJKnSYaWDjdA70qHX4mq9MIjO/ZskmSY8wtAk24or
Ac0vwXgYanqNsBX5Yv4sN4Z9VyrwMdLcusP7HJgRdAGKpkR2I9U4zEsNJQJewM7S4Jalo1Dy
PrLpL2nTET8ZrSl5Utp1UeGp/2deoprGevfnxWB+vHNQiu85o6MxggPMMIIDyAIBATCBiTB1
MQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjEpMCcGA1UECxMgU3RhcnRD
b20gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxIzAhBgNVBAMTGlN0YXJ0Q29tIENsYXNzIDEg
Q2xpZW50IENBAhBGi3yrh9suNX/FVge3/cLnMA0GCWCGSAFlAwQCAQUAoIICEzAYBgkqhkiG
9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNjA3MjgyMDUxNTVaMC8GCSqG
SIb3DQEJBDEiBCC+4QZCvPq2qVSEHx7Wa5/9ZPRv1Ocn0yhGWWP9d27ffjBsBgkqhkiG9w0B
CQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcN
AwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGaBgkrBgEE
AYI3EAQxgYwwgYkwdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAn
BgNVBAsTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFy
dENvbSBDbGFzcyAxIENsaWVudCBDQQIQRot8q4fbLjV/xVYHt/3C5zCBnAYLKoZIhvcNAQkQ
AgsxgYyggYkwdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNV
BAsTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENv
bSBDbGFzcyAxIENsaWVudCBDQQIQRot8q4fbLjV/xVYHt/3C5zANBgkqhkiG9w0BAQEFAASC
AQBm+5Kw85qLCW5V3R+aKRcIdxh0N7GyIZRvdPsVUnbyTAC4jMP9KHphWFR3Q+FMQ2O2xOuY
YHda7aQ65zd6vK298Xa0ukJdZ5XJxEWmAdK2CjhCNlOBLpDanzf8k6PXEt4sGmD+iLrGU7kG
cGL8yHuHam5BqYh8aPRUsXjy99T3Kus4PTXFofQ8haxte/US2nN2zVpa4OJKZxAX/ssJsPDF
tBkVt9cB5WpmU63RXbFrxOdEbkhfabr0fzVKUejYoL5zY5krZ8Ggbc/p7asQ6nXxsks/4vFp
iUf0qJ8OHNwB0u852QbswpzIb82E7eXbEvAedrRcXoUau2k1Qn1SRiUxAAAAAAAA
--=_bugfree-18603-1469739117-0001-2--
