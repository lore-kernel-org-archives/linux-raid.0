From: "K. Posern" <quickhelp@gmail.com>
Subject: Re: getting a linux boot loader (preferably grub) installed on an
 intel imsm raid
Date: Thu, 19 Aug 2010 14:32:31 -0400
Message-ID: <4C6D78BF.1060603@gmail.com>
References: <4C6CB965.7000905@gmail.com> <D010E79907AF0D4E90B603DE907837D504666ADB3D@azsmsx504.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms060801010400050705030800"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D010E79907AF0D4E90B603DE907837D504666ADB3D@azsmsx504.amr.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Jiang, Dave" <dave.jiang@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms060801010400050705030800
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Thanks for your answer!

So it seems I might have found somebody to fight through this RAID/grub=20
jungle? :)


/// about my hardware ///

What I have (and can offer as a test-platform): Sony VAIO notebook where
CTRL+I during startup brings me to
	Intel(R) Rapid Storage Technology - Option ROM - 9.5.0.1037
At the moment I have 1 RAID-0 on all 4 SATA drives.
I think this version (Sony limited?) only supports RAID-0 and maybe 1.

mdadm --examine on the container /dev/md127 gives me:
	Magic : Intel Raid ISM Cfg Sig
	Version : 1.2.01
	Faimily : ba0a95b0
	Generation : 0000025c

lspci shows me:
	00:1f.2 RAID bus controller: Intel Corporation Mobile 82801 SATA RAID=20
Controller (rev. 05)


/// about Fedora (13) ////

My core goal was more to explore and document the MANUAL setup of=20
grub/grub2 (for people compiling from source or using Gentoo).
Basically to document the knowledge needed to do-it-yourself in order to =

save people like me some precious time in collecting all the bits and=20
pieces themselves.
For the several distributions out there: I would have probably just=20
linked to their own HowTos once we get information that it works (like I =

got this information for Ubuntu for example).

I personally use Gentoo --> no fancy GUI/install-scripts, but everything =

manual :)

As I said: Ubuntu has a device-mapper based binary package of grub2 that =

seems to install itsself in a way that allows to boot from an Intel OROM =

RAID (fakeraid). But that doesn't help me with Gentoo.

But I am really stuck alone, so I am willing to throw a Fedora on my=20
machine if in exchange I would get the grub commands to make grub boot=20
my intel RAID-0 :)

 > Just FYI Intel is moving forward with MDRAID.
Nice :)

Do you happen to know if mdadm just integrated (parts of) the dmraid code=
?
Because that's one of the many /rumors/ I picked up ;)
(and that I would like to put to an end ;)

Let me know.

Thanks!

Knuth

---

On 19/08/10 13:49, Jiang, Dave wrote:
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of K. Posern
>> Sent: Wednesday, August 18, 2010 9:56 PM
>> To: linux-raid@vger.kernel.org
>> Subject: getting a linux boot loader (preferably grub) installed on an=

>> intel imsm raid
>>
>> 	b) based on mdadm-imsm. Just there seems really /no/
>> documentation out
>> there on how to do it (or I successfully managed to google around it
>> since days now ;).
>
> There is a section in regards to external metadata
> https://raid.wiki.kernel.org/index.php/RAID_setup#External_Metadata
>
> But I guess I need to update with additional information on how to inst=
all to it.
>
> Do you have Intel MSM Option ROM on your system? If so, then you create=
 a RAID volume in the RAID optionROM and then when you do a install say f=
or example Fedora 12, you specifiy you have "advanced storage device" (I =
think?) and you will see the RAID volume available for installation. I ha=
d issues with Fedora 13. There is a bug that causes crash when you attemp=
t to install to an IMSM volume. And yes you install to the volume. The co=
ntainer can have 2 different RAID volumes.
>
>> P.S.: I would be still interested to hear how the two solutions that
>> support an intel BIOS-supported (mdadm-imsm>=3Dv3 and dmraid>=3Dv1) ra=
id
>> compare to each other in terms of: speed (throughput), load/overhead
>> (cpu/ram), stability, features.
>
> Just FYI Intel is moving forward with MDRAID.



--------------ms060801010400050705030800
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
Fw0xMDA4MTkxODMyMzFaMCMGCSqGSIb3DQEJBDEWBBT1pyysJYEa0F/UXM3Nd0CXKIlBTzBf
BgkqhkiG9w0BCQ8xUjBQMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgIC
AIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQ
BDGBgzCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2Vy
dC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0B
CQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDBibzMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAw
DgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNV
BAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRA
Y2FjZXJ0Lm9yZwIDBibzMA0GCSqGSIb3DQEBAQUABIIBAB0EH6ynjhe/hGhXkji4iCKVRIwS
c8uI6kQVuKFjS2ziMHM1pXr87F/jT8EHQqV66McUFmw53ZBSUGpUrGth4uXsiTCOYYRgQGng
5TSSjmJY+saWsRW3x+WJzKzHOZMkLcPLArSue20taVRU7RARGFqd/H1oAcWFb/tlOu0aWxEB
kVH/ST6a44CLMet9xulaFRKE5DRtQH14DG83zgXyjNzx4nAnjW1NIyx4kePc/fnV9Xj6voO6
dy52iWvpa9glAxhqtJzJcYbM9t0vh5rcKqUpqW09tHE0oraBqqVxJkoPxWbVu/mrsQ+ZyufL
0DlUWpjKqcmUplEsd1xw50DKWBAAAAAAAAA=
--------------ms060801010400050705030800--
