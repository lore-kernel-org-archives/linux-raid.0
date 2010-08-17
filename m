From: "K. Posern" <quickhelp@gmail.com>
Subject: intel fakeraid (imsm) linux kernel support
Date: Tue, 17 Aug 2010 12:19:56 -0400
Message-ID: <4C6AB6AC.40904@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020702030503030402070008"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms020702030503030402070008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi all,

I am trying to find out if it is possible to:

	a) Have the linux kernel autodetect / auto-assemble the fakeraid (to=20
avoid having an initrd (for speed and KISS))

	b) Boot linux kernel from a fakeraid this: grub2? lilo? ... anything?=09

About (a):
Is it possible to autodetect any intel fakeraid (imsm)?
If yes: What RAID-Levels are supported? Especially what would I need to=20
do to get my RAID-0 auto-assembled?
If no: Are there plans?

About (b):
What boot-loader support to assemble the intel fakeraid to read the=20
kernel from it - e.g. are able to assemble the /boot partition on the=20
RAID (especially: level 0)?
According to this wiki entry:
	http://wiki.neuralbs.com/index.php/Gentoo_Quick_Install_notes#GRUB2
grub2 should support imsm (but grep for imsm in the Bazaar checkout does =

not yield any hit) <<< I also contacted the grub2 mailing-list for=20
clarification
I learned today that Ubuntu seems to be able to boot from a RAID-0 with=20
grub2 (v1.98-1ubuntu7) and seemingly installed to /dev/mapper/isw_*.
So far I only tried to install vanilla grub 1.98 to the mdadm v3 devices =

/dev/md12[67], without success.
In the documentation of grub2 (afaik) they don't distinguish between=20
mdadm/dmraid software raid, they just state that grub2 works with=20
software raid.

Side-Question:
To be able to have the kernel auto-assemble / autodetect any [e.g.=20
mdadm] linux software RAID-0 you need *partions*, right?
--> You can't assemble a software raid-0 using two complete drives:
	/dev/sda
	/dev/sdb
But you need to create e.g.:
	/dev/sda1 <<< type set to FD
	/dev/sdb1 <<< type set to FD


It would be great and very kind if someone could clarify these things=20
for me (just a link to read the answers somewhere would work too ;).
Thanks a lot!


Knuth

P.S.:
I adore Intels engagement for linux. Unfortunately is there no website=20
(yet?) "intellinuxraid.org" (like there is: intellinuxgraphics.org).

The only official information from intel (google: intel raid linux) I=20
could dig up so fare states: imsm is supported with mdadm >=3Dv3 and=20
dmraid >=3Dv1. That leaves a lot of questions (eg. I never saw any detail=
s=20
on how the intel software raid format works - e.g. I noticed that the=20
first physical device of my RAID-0 seems to have the primary paritions,=20
all the other RAID-0 devices are unpartitioned).



--------------ms020702030503030402070008
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
Fw0xMDA4MTcxNjE5NTZaMCMGCSqGSIb3DQEJBDEWBBTZq24oiVphK0KeBKzeKyjSR3fjrzBf
BgkqhkiG9w0BCQ8xUjBQMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgIC
AIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQ
BDGBgzCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2Vy
dC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0B
CQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDBibzMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAw
DgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNV
BAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRA
Y2FjZXJ0Lm9yZwIDBibzMA0GCSqGSIb3DQEBAQUABIIBADddAVGXqYwb0XK2MVoTEL2oLv23
K1WmaRLL949bC+qUCJeFAAvo+g8rbBH8kZH9W1Dkg8mB0i574KNCEHKdnmPLMOyhCyWW+0Ii
T+TAzO7R4IAzUP9oDze9YgPzXxGwcDqc5foSu7MYUHU5iTvYM3elyYfN1IeHzE5T8kijyljK
sZjlGLM6aCu6zkTxlS0aO6sO+KjSkU0AjdRr7Eqoutd95dcccfLWGVhtpuOC8/BScaG9s1Jd
a+qL+4BQZD02I+Wpu8FZo3tadbfGophK28RRbUIhl+/MNxCK1APM8zoNUWBq6D0zNp1z5v2A
GHHewrp/qQ5wkXkIFpAigtXEWgoAAAAAAAA=
--------------ms020702030503030402070008--
