From: "K. Posern" <quickhelp@gmail.com>
Subject: Re: intel fakeraid (imsm) linux kernel support
Date: Wed, 18 Aug 2010 13:49:42 -0400
Message-ID: <4C6C1D36.2040200@gmail.com>
References: <4C69D525.4060404@gmail.com> <4C6ABD7D.7050909@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms070008000303030407090702"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C6ABD7D.7050909@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, dave.jiang@intel.com
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms070008000303030407090702
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Dear Mr. Williams,

Thank you *very* much... you added very valueable pieces to my imsm=20
RAID(-0) puzzle.

I just used the term "fakeraid" because it is *short* :) ... I did not=20
mean it negative. Plus a lot of people use this term:
	https://secure.wikimedia.org/wikipedia/en/wiki/RAID#Firmware.2Fdriver-ba=
sed_RAID_.28.22FakeRAID.22.29
	The Ubuntu FakeRAID HowTo
	ArchLinux FakeRaid Howto

I would really like a new point on the raid-wikis first page named along =

these lines:
	"[Intel] Firmware-based/BIOS-supported RAID ("FakeRAID")"
And I can do this if you want (aready created account yesterday).

On there should be a
	- short description about what what a "fakeraid" is
	- then for INTEL the info you get when you google for "intel linux raid"=

	- the info from Dan's answer below. Especially the part with "the=20
option-rom installs a bios int13 handler" (because there /is/ confusion=20
about that out there :).
	- Also the answer to the belows question: "How to install a bootloader" =

should be on there.

And of course the more technical details the better. Eg.
	- that (and maybe why) the primary partitions setup within the imsm=20
raid(-0) will be created on the first physical drive (/dev/sda), but not =

on the other drives.
	- maybe even more in depth details on the external metadata format
	- maybe some commonly used commandlines for mdadm and dmraid to check=20
the raid status ... or at least links to their howtos/wikis...

You mentioned:
  > One of the primary benefits of using the Intel(R) RST (mdadm-imsm)
  > format is that you can use the platform bios option-rom to boot from
  > raid.
2 questions:
	a) What does RST stand for?
	b) Does the (mdadm-imsm) mean, that the device-mappers "dmraid -f isw"=20
does not the same (or does intel just officially only support mdadm imsm?=
)

And finally: Can anyone tell me which solution:
	dmraid -f isw
	mdadm with imsm container support
is better in the sense:
	- faster (higher throughput)
	- less load (e.g. on cpu)
	- more stable
	- more features
I already posted this question to the dm-devel@redhat.com mailing list=20
but (afaik) never got an answer.

Also: What I find odd with the dmraid solution: In fdisk it shows you=20
e.g. /dev/dm-0p6, but there is no /dev/dm-0p6, there is only /dev/dm-0=20
to /dev/dm-11 and many /dev/mapper/LONGNAME symlinks to the /dev/dm-*.=20
But the /dev/mapper/Volume_HASH_06 points to /dev/dm-4 ?!.... IMHO:=20
total mess.

--------------

"How to install a bootloader"?

You mentioned:
 > One of the primary benefits of using the Intel(R) RST (mdadm-imsm)
 > format is that you can use the platform bios option-rom to boot from
 > raid. So grub, grub2, lilo, or any other bootloader can boot from raid=
=2E
 > This is because the option-rom installs a bios int13 handler that allo=
ws
 > the bootloader to read from a raid volume as if it were a standalone=20
disk.

Which sounds great, but I can send you the chatlog from the #grub=20
channel this morning... they don't seem to have an idea about that.

Could you/someone be so kind to provide me with the steps to manually=20
install grub (legacy v0.97) or grub2 (v1.98) on a linux that accesses=20
the raid via mdadm-imsm (/dev/md126, /dev/md127)?

Because for me it seems: "Intel" says: grub, gub2: No problem. "Grub"=20
says: ???
I know that this is not a grub mailing list, but maybe just a small=20
hint? Like: What should be in /boot/grub/device.map?
/dev/md126?
Do I install grub to the container (/dev/md127) or to the volume=20
(/dev/md126)?
E.g.
- grub legacy gave me a "Error 22" on "setup (hd0)" with "/dev/md126 as=20
(hd0) in device.map
- grub2: 1st it seems unclear what should be in the /dev/md, because=20
grub assembles /dev/mdadm raids (independent of the BIOS), 2nd it seems=20
unclear how this internal mdadm assembly interferes with "accessing the=20
RAID via the int13 handler as a standalone disk"
- lilo: I would prefer a grub based solution

Again: Maybe this information is somewhere out there, but that's the=20
problem: There are bits and pieces [about Intel BIOS supported RAID=20
imsm] all over the place --> That's why I would love to (help to) create =

this wiki page I mentioned earlier to just assemble the most basic=20
things in one place.
=2E. Also that next time a guy like me (with a lot of half-knowledge ;)=20
comes along and asks many "stupid" questions about imsm integration you=20
can hopefully just point him to this wiki page.
Does this make sense to you too?


Any hint will be greatly appreciated!

K. Posern

--

On 17/08/10 12:49, Dan Williams wrote:
> [ added linux-raid with permission ]
>
> On 8/16/2010 5:17 PM, K. Posern wrote:
>> Dear Mr. Williams,
>
=2E.. <relevant parts pasted above>
> Regards,
> Dan




--------------ms070008000303030407090702
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
Fw0xMDA4MTgxNzQ5NDJaMCMGCSqGSIb3DQEJBDEWBBSz/M0Xs1P5dsNYU2vInh6TNfP/rTBf
BgkqhkiG9w0BCQ8xUjBQMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgIC
AIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQ
BDGBgzCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2Vy
dC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0B
CQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDBibzMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAw
DgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNV
BAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRA
Y2FjZXJ0Lm9yZwIDBibzMA0GCSqGSIb3DQEBAQUABIIBAHjzStKvS4aCxWWDSjoxxW7/Ek2w
LBRywOV7ErS0Zpg38TaGFEzIASB1X8byFW5hZRfJzt6YKWrpNNdQDkFI8it5+qxE8uCKlQ5n
8hFU1T5TMhcT4Yzq3Rk2EjSld40sPhZaAUvYDZCNs/pLU2frcSwBn9ZCQlb3eTKan4WTezNC
Za7dpab3ZL2mvU5g4BhKlRVYWWjpVG3U9lj4sch9nSjs2rRm62142eVyLYsMN+MhMBZl32l0
HdXLl2rmNyOotdupke6yLxPaxLlp4ke065JXT5LqSoDjdGkQFU2GVq3zdHqe3NXZZ1O37mvs
aqY7FFT/4uQXel+ghhKZWVrvrIkAAAAAAAA=
--------------ms070008000303030407090702--
