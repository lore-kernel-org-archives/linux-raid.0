From: "K. Posern" <quickhelp@gmail.com>
Subject: Re: getting a linux boot loader (preferably grub) installed on an
 intel imsm raid
Date: Thu, 19 Aug 2010 21:15:49 -0400
Message-ID: <4C6DD745.8010507@gmail.com>
References: <4C6CB965.7000905@gmail.com> <D010E79907AF0D4E90B603DE907837D504666ADB3D@azsmsx504.amr.corp.intel.com> <4C6D78BF.1060603@gmail.com> <D010E79907AF0D4E90B603DE907837D504666ADCD3@azsmsx504.amr.corp.intel.com> <4C6DB04A.4060702@gmail.com> <D010E79907AF0D4E90B603DE907837D504669C5B31@azsmsx504.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms070509090000050304080700"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D010E79907AF0D4E90B603DE907837D504669C5B31@azsmsx504.amr.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Jiang, Dave" <dave.jiang@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms070509090000050304080700
Content-Type: multipart/mixed;
 boundary="------------080501080402000209020409"

This is a multi-part message in MIME format.
--------------080501080402000209020409
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Thanks again!

On 19/08/10 20:46, Jiang, Dave wrote:
>> -----Original Message-----
> So I created a RAID0 like your setup. I have md0 as the container and m=
d127 as the RAID0 volume. Fedora 12 installed grub on /dev/md127. The gru=
b version from F12 is 0.97. I was able to rerun grub-install on /dev/md12=
7 successfully. My device map contains:
> (hd0)		/dev/md127
>
> Do you have to use grub2?
No.

Attached my results with grub-0.97 (-r10).
The error 22 I mentioned... maybe I am just not seeing it... like=20
something /very/ obvious... ?

/dev/md/126 is my volume with the partitions, /dev/md127 is my container

I can give you ssh access to the machine, just send me your pub key.

XMPP chat: tormen@jabber.org

Knuth

--------------080501080402000209020409
Content-Type: text/plain;
 name="grub-1.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="grub-1.txt"


/vola # grub-install /dev/md126                                   $1 #367=
 root@sysresccd pts/1

expr: non-integer argument


    GNU GRUB  version 0.97  (640K lower / 9216K upper memory)

 [ Minimal BASH-like line editing is supported.  For the first word, TAB
   lists possible command completions.  Anywhere else TAB lists the possi=
ble
   completions of a device/filename. ]
grub> root (hd0,0)
 Filesystem type is ext2fs, partition type 0x83
grub> setup  --stage2=3D/boot/grub/stage2 --prefix=3D/grub (hd0,)
 Checking if "/grub/stage1" exists... yes
 Checking if "/grub/stage2" exists... yes
 Checking if "/grub/e2fs_stage1_5" exists... yes
 Running "embed /grub/e2fs_stage1_5 (hd0,0)"... failed (this is not fatal=
)
 Running "embed /grub/e2fs_stage1_5 (hd0,0)"... failed (this is not fatal=
)
 Running "install --stage2=3D/boot/grub/stage2 /grub/stage1 (hd0,0) /grub=
/stage2 p /grub/menu.lst "... failed

Error 22: No such partition
grub> quit

--------------080501080402000209020409
Content-Type: text/plain;
 name="grub-2.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="grub-2.txt"

Ci92b2xhICMgZ3J1YiAtLWRldmljZS1tYXA9L2Rldi9udWxsICAgICAgICAgICAgICAgICQx
ICMzNjcgcm9vdEBzeXNyZXNjY2QgcHRzLzEKCgogICAgR05VIEdSVUIgIHZlcnNpb24gMC45
NyAgKDY0MEsgbG93ZXIgLyA5MjE2SyB1cHBlciBtZW1vcnkpCgogWyBNaW5pbWFsIEJBU0gt
bGlrZSBsaW5lIGVkaXRpbmcgaXMgc3VwcG9ydGVkLiAgRm9yIHRoZSBmaXJzdCB3b3JkLCBU
QUIKICAgbGlzdHMgcG9zc2libGUgY29tbWFuZCBjb21wbGV0aW9ucy4gIEFueXdoZXJlIGVs
c2UgVEFCIGxpc3RzIHRoZSBwb3NzaWJsZQogICBjb21wbGV0aW9ucyBvZiBhIGRldmljZS9m
aWxlbmFtZS4gXQoKZ3J1Yj4gZGV2aWNlKGhkMCkgL2Rldi9tZDEyNgoKRXJyb3IgMjc6IFVu
cmVjb2duaXplZCBjb21tYW5kCgpncnViPiBkZXZpY2UgKGhkMCkgL2Rldi9tZDEyNgoKZ3J1
Yj4gcm9vdCAoaGQwLAogUG9zc2libGUgcGFydGl0aW9ucyBhcmU6CiAgIFBhcnRpdGlvbiBu
dW06IDAsICBGaWxlc3lzdGVtIHR5cGUgaXMgZXh0MmZzLCBwYXJ0aXRpb24gdHlwZSAweDgz
CiAgIFBhcnRpdGlvbiBudW06IDIsICBGaWxlc3lzdGVtIHR5cGUgdW5rbm93biwgcGFydGl0
aW9uIHR5cGUgMHg3CiAgIFBhcnRpdGlvbiBudW06IDQsICBGaWxlc3lzdGVtIHR5cGUgdW5r
bm93biwgcGFydGl0aW9uIHR5cGUgMHg4MgogICBQYXJ0aXRpb24gbnVtOiA1LCAgRmlsZXN5
c3RlbSB0eXBlIGlzIGV4dDJmcywgcGFydGl0aW9uIHR5cGUgMHg4MwogICBQYXJ0aXRpb24g
bnVtOiA2LCAgRmlsZXN5c3RlbSB0eXBlIHVua25vd24sIHBhcnRpdGlvbiB0eXBlIDB4ODMK
ICAgUGFydGl0aW9uIG51bTogNywgIEZpbGVzeXN0ZW0gdHlwZSB1bmtub3duLCBwYXJ0aXRp
b24gdHlwZSAweDgzCiAgIFBhcnRpdGlvbiBudW06IDgsICBGaWxlc3lzdGVtIHR5cGUgdW5r
bm93biwgcGFydGl0aW9uIHR5cGUgMHg4MwogICBQYXJ0aXRpb24gbnVtOiA5LCAgRmlsZXN5
c3RlbSB0eXBlIHVua25vd24sIHBhcnRpdGlvbiB0eXBlIDB4NwoKZ3J1Yj4gcm9vdCAoaGQw
LDApCiBGaWxlc3lzdGVtIHR5cGUgaXMgZXh0MmZzLCBwYXJ0aXRpb24gdHlwZSAweDgzCgpn
cnViPiBzZXR1cCAoaGQwKQogQ2hlY2tpbmcgaWYgIi9ib290L2dydWIvc3RhZ2UxIiBleGlz
dHMuLi4geWVzCiBDaGVja2luZyBpZiAiL2Jvb3QvZ3J1Yi9zdGFnZTIiIGV4aXN0cy4uLiB5
ZXMKIENoZWNraW5nIGlmICIvYm9vdC9ncnViL2UyZnNfc3RhZ2UxXzUiIGV4aXN0cy4uLiB5
ZXMKIFJ1bm5pbmcgImVtYmVkIC9ib290L2dydWIvZTJmc19zdGFnZTFfNSAoaGQwKSIuLi4g
IDE4IHNlY3RvcnMgYXJlIGVtYmVkZGVkLgpzdWNjZWVkZWQKIFJ1bm5pbmcgImluc3RhbGwg
L2Jvb3QvZ3J1Yi9zdGFnZTEgKGhkMCkgKGhkMCkxKzE4IHAgKGhkMCwwKS9ib290L2dydWIv
c3RhZ2UyCi9ib290L2dydWIvbWVudS5sc3QiLi4uIGZhaWxlZAoKRXJyb3IgMjI6IE5vIHN1
Y2ggcGFydGl0aW9uCgpncnViPg==
--------------080501080402000209020409--

--------------ms070509090000050304080700
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
Fw0xMDA4MjAwMTE1NDlaMCMGCSqGSIb3DQEJBDEWBBTHTf7j3qEqbhAPBB6Yrjqb2g8sLjBf
BgkqhkiG9w0BCQ8xUjBQMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgIC
AIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQ
BDGBgzCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2Vy
dC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0B
CQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDBibzMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAw
DgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNV
BAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRA
Y2FjZXJ0Lm9yZwIDBibzMA0GCSqGSIb3DQEBAQUABIIBADEH4EqjMVqIpE16vOSGXXUgmGR/
FogQmt5dwduMpbO2PYCQWqmLDJgZ0gEeG5MbdbjoU6kpKFykwtk4M7mhpKynC+C/dI3AXXNe
dAtRVNkAUzxJ8vPO6ErKFtFq7Jpd3D/Q8ubbd7xAalw2YQu6MGg+JIDhNxn3KKYQBzKKbEIA
ay1FEt0c96esB/CbJtqtNTS8pEOds8z1mAcI/J23mo3M2UQ5GjO5edSyFbHpqIo0W4oHSia9
iLJ+hF00IGS6I9eRLKOk65sMaYEK9zd+ZT+95Rq/bM5Sz0kTJYZ3u2TvFnGKmDhzDt8j7qu8
dYDtkDlZVU2kysABuPe+0g0KmOcAAAAAAAA=
--------------ms070509090000050304080700--
