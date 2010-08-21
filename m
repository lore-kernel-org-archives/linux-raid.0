From: "K. Posern" <quickhelp@gmail.com>
Subject: Re: getting a linux boot loader (preferably grub) installed on an
 intel imsm raid
Date: Sat, 21 Aug 2010 16:44:37 -0400
Message-ID: <4C703AB5.5040605@gmail.com>
References: <AANLkTimXLWC5RzNQgJ_M9aY4Lmy30tZOVmWX_pmjzyCJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms070705040004070801060805"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimXLWC5RzNQgJ_M9aY4Lmy30tZOVmWX_pmjzyCJ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: gabe peters <gabe.peters@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms070705040004070801060805
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Gabe,

On 21/08/10 03:53, gabe peters wrote:
 > Any insight will be welcome, I suppose this message amounts to nothing=

 > more than a simple "me, too!" though!

I got it working! Thanks to the *great* support of phcoder from the=20
grub2 community!

He developed a patch that allows the user a sane way to override=20
auto-detection mechanisms by supplying right device.map. It should get=20
merged to bzr in the next couple of days :) (it is not yet ideally=20
coded, but works :)

--> Basically allowing me to use /dev/md126 (the imsm Volume) as a grub=20
device, even though grub can't assemble it --> hence to use the int13=20
OROM assembled version of the raid-0 :)

If you want to give it a try:
     # http://www.gnu.org/software/grub/grub-download.en.html
     bzr branch http://bzr.savannah.gnu.org/r/grub/trunk/grub
     # Apply this patch: http://pastebin.com/raw.php?i=3Dtgfqp9Hn
     # e.g. download it to file "phcoder.patch"
     # and run cat phcoder.patch|patch -p 0 in the "grub" directory that =

you received by the bzr command

     # I think without any parameters it should be fine:
     ./configure
     make
     # this command triggered for me that /boot/grub got populated:
     # for me /dev/mdYOURVOLUME was /dev/md126 (the imsm Volume)
     ./grub-probe /dev/mdYOURVOLUME
     # make sure that /boot/grub/device.map contains:
	(hd0) /dev/mdYOURVOLUME
     ./grub-probe /dev/mdYOURVOLUME -v
     ./grub-probe -t partmap /boot -v
     # until know we changed NOTHING...
     # ... so if you can also do this:
     ./grub-install /dev/mdYOURVOLUME
     reboot

Hope this helps you as well.


Best,

Knuth


--------------ms070705040004070801060805
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIKajCC
BTEwggMZoAMCAQICAwYm8zANBgkqhkiG9w0BAQUFADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0wODEy
MTIxOTEzNDFaFw0xMDEyMTIxOTEzNDFaMDsxFTATBgNVBAMTDEtudXRoIFBvc2VybjEiMCAG
CSqGSIb3DQEJARYTcXVpY2toZWxwQGdtYWlsLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBAM/XLQlhOxcmVwIU0kEDlqL9OiNezGZpMhzB/c1ibGEfBxC0v6GfQd+k00a0
tL4uzwNHquu3Lk49cc9AJbIUbppd9H0RY1dD9FpjjC8SmPlb9ZofRSr7lPlDfD4A8EqLw7KB
sp3yUs1kl7SYKAlX7JJgCqzo+CxxOEuO11dnv/ruezOMyGRPOBBMCPiPLyr7iOjkvWObgIoC
82f4EhfsXNPTV3z2b2s1k/0JPIr1t2klk8bta/8MdjSF6E3SjJyyXp0mq48izityMpi5J0U3
Gz2G9EIUBRILVSY/ZZQz2W8Ur2jhItSbpY1qLv6aSCFsrPsFOyc8HEHUaJ+SwF0WbD0CAwEA
AaOB/zCB/DAMBgNVHRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24g
Y2VydGlmaWNhdGUgZm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9y
ZzBABgNVHSUEOTA3BggrBgEFBQcDBAYIKwYBBQUHAwIGCisGAQQBgjcKAwQGCisGAQQBgjcK
AwMGCWCGSAGG+EIEATAyBggrBgEFBQcBAQQmMCQwIgYIKwYBBQUHMAGGFmh0dHA6Ly9vY3Nw
LmNhY2VydC5vcmcwHgYDVR0RBBcwFYETcXVpY2toZWxwQGdtYWlsLmNvbTANBgkqhkiG9w0B
AQUFAAOCAgEAzBJqLQB9q+ZEfvidFXWVNyfEiRmvDbvOdsg+6Pl38RqKHchoZpdqsfyZV3Lv
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
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAwYm8zAJ
BgUrDgMCGgUAoIIB6DAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEP
Fw0xMDA4MjEyMDQ0MzdaMCMGCSqGSIb3DQEJBDEWBBSyYcaDIPemka6y6O8eyraC5g/G5jBf
BgkqhkiG9w0BCQ8xUjBQMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgIC
AIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQ
BDGBgzCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2Vy
dC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0B
CQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDBibzMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAw
DgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNV
BAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRA
Y2FjZXJ0Lm9yZwIDBibzMA0GCSqGSIb3DQEBAQUABIIBAEmRhUpT5GX0j61mLq+lCv7cfV/3
M7JR87iCxpcy2/eAe50o+FbBAOmTN6Wls+pqVkqH2iukHIvh2B+FuzkRi96o69/SEqeH4CkM
fdY4P3g63y/K3WXoOeRRPpWiAYqYI93RCkMxkt/Q5okeLqFbOyhNGSRrPJaLxqhX7hUIVyyD
LHCrXzuNS7QWVu0YDmqCLDtS2pMHSPDAH2XC+5cZ2MC1IPRUODz+YgALPiTuMENlUUDMm6sM
hC14CGi0Cki8fi5BATUONER99vVyenQ/4Txs99pnYwCUYVqjk4HbAGq0HEiKetLS0IxDUwRL
1JZr/dJFnK9nqPw3cwJf6C+p6eYAAAAAAAA=
--------------ms070705040004070801060805--
