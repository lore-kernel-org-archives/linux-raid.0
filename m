From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: mdadm: sending ioctl 1261 to a partition!
Date: Tue, 06 Mar 2012 13:38:18 +1100
Message-ID: <4F55789A.1070505@crc.id.au>
References: <4F54B997.3060207@crc.id.au> <4F54D314.9060504@anonymous.org.uk> <4F550BA8.3010306@crc.id.au> <20120306070143.4f8abc0e@notabene.brown> <4F556FA1.5020006@crc.id.au> <20120306132701.1b9600f4@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010509010305080900040300"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120306132701.1b9600f4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms010509010305080900040300
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 6/03/2012 1:27 PM, NeilBrown wrote:
> On Tue, 06 Mar 2012 13:00:01 +1100 Steven Haigh<netwiz@crc.id.au>  wrot=
e:
>
>> On 6/03/2012 7:01 AM, NeilBrown wrote:
>>> On Tue, 06 Mar 2012 05:53:28 +1100 Steven Haigh<netwiz@crc.id.au>   w=
rote:
>>>
>>>> On 6/03/2012 1:52 AM, John Robinson wrote:
>>>>> On 05/03/2012 13:03, Steven Haigh wrote:
>>>>>> I've noticed that recently I've managed to get a ton of messages l=
ike
>>>>>> this at boot:
>>>>>>
>>>>>> mdadm: sending ioctl 1261 to a partition!
>>>>>> mdadm: sending ioctl 800c0910 to a partition!
>>>>>
>>>>> It's probably harmless.
>>>>>
>>>>> http://lists.debian.org/debian-kernel/2012/01/msg01105.html says "T=
his
>>>>> warning was introduced as part of the fix for CVE-2011-4127"
>>>>>
>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=3D783955#c4 says "Actua=
lly,
>>>>> the warning seems a false positive to me"
>>>>
>>>> I did see these - and I probably should have mentioned it in the
>>>> original post. Naughty me for posting at times I should really be as=
leep.
>>>>
>>>> The general jist of it seemed to be "it always failed before, now we=

>>>> just know about it". What makes me wonder is that if it always faile=
d
>>>> before, why do we do it in the first place?
>>>>
>>>
>>> 800c0910 is 'are you an md device'.  So failure is a valid response.
>>>
>>> 1261 is flush-bufs.  I hope that does still work on partitions....
>>
>> Thanks Neil, Any ideas how I can test this to check if flush-bufs is
>> working? While I'm not a code junkie these days - I'm great at picking=

>> holes in thing ;)
>
> Read the code....

Easier said than done.

> In block/ioctl.c
> 	case BLKFLSBUF:
> 		if (!capable(CAP_SYS_ADMIN))
> 			return -EACCES;
>
> 		ret =3D __blkdev_driver_ioctl(bdev, mode, cmd, arg);
> 		/* -EINVAL to handle old uncorrected drivers */
> 		if (ret !=3D -EINVAL&&  ret !=3D -ENOTTY)
> 			return ret;
>
> 		lock_kernel();
> 		fsync_bdev(bdev);
> 		invalidate_bdev(bdev);
> 		unlock_kernel();
> 		return 0;

You know that look when peoples eyes glaze over - commonly referred to=20
in the BOFH stories as *IDIOT MODE ON*. Thats what I get when I look at=20
that code ;)

>
> So it is still called fsync_bdev and invalidate_bdev as long as the ioc=
tl
> function for the underlying disk returns -EINVAL or -ENOTTY.
>
> The function that shows that warning is scsi_verify_blk_ioctl in
> block/scsi_ioctl.c
> The worst it can do is return -ENOTTY, and that is safe.

I recognise a lot of those words, but I have no idea what they mean in=20
that sequence. This proves that this list is great for people=20
understanding that code. It also means that I can trust exactly what is=20
going on :) I don't want to burden you with trying to explain it to=20
someone like me, but its comforting to know all is right :)

> So the warning is bogus, the code still works.

Awesome! Means I can safely ignore it, and this gets archived for proper =

reference on the archive lists and should probably appear in googles=20
searches on the subject soon to stop it from being asked here again :)

--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299


--------------ms010509010305080900040300
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIOSjCC
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
5j5R0xi72MZ8ikMu1RQZKCyDbMwazlHiMIIIDjCCBvagAwIBAgIDA7ikMA0GCSqGSIb3DQEB
BQUAMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMi
U2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20g
Q2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0EwHhcNMTIwMjEzMTMzODE0
WhcNMTMwMjEzMTc1NjUzWjBXMRkwFwYDVQQNExB3bjVlU1RNM2RWOUIwMEk5MRkwFwYDVQQD
DBBuZXR3aXpAY3JjLmlkLmF1MR8wHQYJKoZIhvcNAQkBFhBuZXR3aXpAY3JjLmlkLmF1MIIC
IjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAzTaLiL78pm4Hqp7Pou4C60jt2wdvDiPt
Sq6hspKk6oaST7BFeDOfoed3mvzytkjNr3C1gds3zsHulAMzRjuX2M1zPkfaj5QFkmlqQcxr
+tnaf8QFpn9PrUcjpbYDYPxdcGR+SeClKzmjdxicHuYDrD8YXnbk+k8dWDaCuv5sKRQHJmIR
maqUIGoVML+/kUR+sqkMpnbhOsL+E84Hg4fxLzpV3Tjf9bZbKgaspvg+BeJJCYKThBxMnZJI
cQ9JzDGL4rO2BEuTXI9Ofl0+AAttBEpZeqc2rePCfA9NivKTCZ0qaFKmvM5SN7TiZUqv80rD
ewTp+OLXNZEd5aa5jEDPNlznkcX0WfuKCmtyIEzT7PgHl1tOWTx7nw6FVWcB8qjC6xlyaL6W
1oS7Om3b2ka+9vSiz7DrPZzUDZuS91Fr2zIIMrrRzhN8q/JdQf8lGTydpmoRUB0z+BAcH8V/
nOcMMDogqV6/dCfywi7zFQK4AsiPSpyBAZyO53J4uPgoIzSpFj54f83KRIobHCWDU1BaU2+6
CfEoAD3iMId1tcFWTXikEThL+3oHQullq9EbPR4f3ToAU7aTZYWG4KNKrmG93KAfyCUFb+bf
mt3hf1BprKIUJnpOxdZHi0KwLXVwURiB4XQKZpEWL8mRbHRdxVATKrrJAHOFTl3/s37VLprP
J9kCAwEAAaOCA6swggOnMAkGA1UdEwQCMAAwCwYDVR0PBAQDAgSwMB0GA1UdJQQWMBQGCCsG
AQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQUS9is0NdoOI3DZ/36Zlq78IrSedgwHwYDVR0j
BBgwFoAUU3Ltkpzg2ssBXHx+ljVO8tS4UYIwGwYDVR0RBBQwEoEQbmV0d2l6QGNyYy5pZC5h
dTCCAiEGA1UdIASCAhgwggIUMIICEAYLKwYBBAGBtTcBAgIwggH/MC4GCCsGAQUFBwIBFiJo
dHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kucGRmMDQGCCsGAQUFBwIBFihodHRwOi8v
d3d3LnN0YXJ0c3NsLmNvbS9pbnRlcm1lZGlhdGUucGRmMIH3BggrBgEFBQcCAjCB6jAnFiBT
dGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTADAgEBGoG+VGhpcyBjZXJ0aWZpY2F0
ZSB3YXMgaXNzdWVkIGFjY29yZGluZyB0byB0aGUgQ2xhc3MgMSBWYWxpZGF0aW9uIHJlcXVp
cmVtZW50cyBvZiB0aGUgU3RhcnRDb20gQ0EgcG9saWN5LCByZWxpYW5jZSBvbmx5IGZvciB0
aGUgaW50ZW5kZWQgcHVycG9zZSBpbiBjb21wbGlhbmNlIG9mIHRoZSByZWx5aW5nIHBhcnR5
IG9ibGlnYXRpb25zLjCBnAYIKwYBBQUHAgIwgY8wJxYgU3RhcnRDb20gQ2VydGlmaWNhdGlv
biBBdXRob3JpdHkwAwIBAhpkTGlhYmlsaXR5IGFuZCB3YXJyYW50aWVzIGFyZSBsaW1pdGVk
ISBTZWUgc2VjdGlvbiAiTGVnYWwgYW5kIExpbWl0YXRpb25zIiBvZiB0aGUgU3RhcnRDb20g
Q0EgcG9saWN5LjA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9j
cnR1MS1jcmwuY3JsMIGOBggrBgEFBQcBAQSBgTB/MDkGCCsGAQUFBzABhi1odHRwOi8vb2Nz
cC5zdGFydHNzbC5jb20vc3ViL2NsYXNzMS9jbGllbnQvY2EwQgYIKwYBBQUHMAKGNmh0dHA6
Ly9haWEuc3RhcnRzc2wuY29tL2NlcnRzL3N1Yi5jbGFzczEuY2xpZW50LmNhLmNydDAjBgNV
HRIEHDAahhhodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS8wDQYJKoZIhvcNAQEFBQADggEBABL6
TyHlAHW0kkHb0ZLcd/pn7Ue0B5mIWBhmta4dK8qd0hXw+/lhpWaJWR/RltCSPabxSd+Lm9Iw
NWm7WP73GHAGby0TC+siwDJSk7CwDBqnVM1T3XQ5TgjfVX7h9qjVixsSWzAD++dXFmpf/344
Uf3zcG/hKJSeRtOvM/88nn4eJtrn7QFnIm4AJpHEgrqwU/0pmQBLwmEYS1G5cr04Oact2v6W
L3JHOlEP8lPBAO9GtZD8UZGmBoDTNG0Rf4TnVTBGdw1sLZqpXnkcVI+rDUaFk/jb7AtCB30N
8tbm2I5ALevgjv+vNMZIQD/0AgOaylGrQwbP852lgOvMo2AdpGExggTQMIIEzAIBATCBlDCB
jDELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3Vy
ZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNz
IDEgUHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENBAgMDuKQwCQYFKw4DAhoFAKCCAhAw
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTIwMzA2MDIzODE4
WjAjBgkqhkiG9w0BCQQxFgQUaWT+MD/EtXeZJGpOV3njBhcsvGUwXwYJKoZIhvcNAQkPMVIw
UDALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGlBgkrBgEEAYI3EAQxgZcwgZQwgYwxCzAJ
BgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGln
aXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAxIFBy
aW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQQIDA7ikMIGnBgsqhkiG9w0BCRACCzGBl6CB
lDCBjDELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNl
Y3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENs
YXNzIDEgUHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENBAgMDuKQwDQYJKoZIhvcNAQEB
BQAEggIAFtDQHkfgIHkSCuck2l87KPyyDEzofsd+22PfJWiU7bVee7so9b2CTcN3HC4jMMJo
FgwcmaBDE7zwwnbARh4c7bZ1PTZyIM7VvDG2WlKikUkgwyza3+qNKYzPFWt15//VjvFbtybm
iC17yVAN08M0NPgru9RyrUHE+GgtMZcK8CdqE7enAdYKtHT4+bOnw1tldlCnFG8wILEpYBwA
14D5VzqdIFUv4sNSTcsLQ+e3lkLuiicuKu14fy3Qlp2kS6+s1PgttPRcdnwVNz7s5zFZkGWV
zHo541f+S0eoFbCqDVavzq0rXgI4dWtc99bLte18WP3MFYXlW5A0OFUSMRui6IJd1ZieiCXD
VyRCLw3958Vijs2gPJ+kmxWNIDyNndPTX1/ElFl21WU2nVhxVx5sWclSafcnXqvSGu3VLOMb
DWoHqhPAenusn64wPjiJ0WwlXXLi3fop4mBUyd3lQ7Owm5465dmzy238OopLvFclbeqKPgui
j77bWQ11yRQbEvZ3IefpUUIGExKGT+GUXZP8xNd5DfZO8srFOnXZw2cV3O4gFVo9X12ZTiak
V8lRw/NdzmkUBVpkoXQ6xMDSVeCE/AkB55QyxblQq+UtHRm2Y4MCSc1Qtv2GHza37MTmLzj4
jL8hp0pQcQEVmDGMGZ87ECZYkNFgmO3JtaS385OTOdoAAAAAAAA=
--------------ms010509010305080900040300--
