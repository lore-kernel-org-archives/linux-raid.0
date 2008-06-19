From: Jon Buckingham <jbuckingham@blueyonder.co.uk>
Subject: Re: mdadm: making a spare actie
Date: Thu, 19 Jun 2008 23:24:13 +0100
Message-ID: <485ADC8D.2010708@blueyonder.co.uk>
References: <485A259B.9040106@blueyonder.co.uk> <18522.18111.182249.694308@notabene.brown>
Reply-To: jbuckingham@blueyonder.co.uk
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms000907070802030602090501"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18522.18111.182249.694308@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Jon Buckingham <jon.buckingham@hp.com>
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms000907070802030602090501
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Neil Brown wrote:
> On Thursday June 19, jbuckingham@blueyonder.co.uk wrote:
>> I have also done
>> mdadm /dev/md0 -a /dev/sdb5
>> and this results in a recovery...
>>
>> nas:~ # cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4]
>> md0 : active raid5 sdb5[4] sda5[0] sdd5[3] sdc5[2]
>>        733142016 blocks level 5, 64k chunk, algorithm 2 [4/3] [U_UU]
>>        [=>...................]  recovery =  7.3% (17900780/244380672) finish=174.1min speed=21666K/sec
>>
>> unused devices: <none>
>>
>> Which I've been through before, but still ends up as a spare.
> 
> That suggests that it hits some IO error during recovery and aborts.
> 
> Are there any kernel log messages during the time that it is
> recovering?
> 
> NeilBrown
> 
> 
No.
After the "add" completed, and a reboot it seems it is still a
"spare".
Strange.

Then from dmesg:

device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
md: md0 stopped.
md: bind<sdc5>
md: bind<sdd5>
md: bind<sdb5>
md: bind<sda5>
md: kicking non-fresh sdb5 from array!
md: unbind<sdb5>
md: export_rdev(sdb5)
raid5: automatically using best checksumming function: pIII_sse
    pIII_sse  :  5640.000 MB/sec
raid5: using function: pIII_sse (5640.000 MB/sec)

raid5: device sda5 operational as raid disk 0
raid5: device sdd5 operational as raid disk 3
raid5: device sdc5 operational as raid disk 2
raid5: allocated 4204kB for md0
raid5: raid level 5 set md0 active with 3 out of 4 devices, algorithm 2
RAID5 conf printout:
  --- rd:4 wd:3
  disk 0, o:1, dev:sda5
  disk 2, o:1, dev:sdc5
  disk 3, o:1, dev:sdd5

I am tempted to rebuild the whole thing now, since I have tried
quite a few variations and not solved it. There must be some deeper rooted problem that
is causing this issue on the disk.

Thanks again,

Jon B

--------------ms000907070802030602090501
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJLzCC
AvIwggJboAMCAQICED+2nVJ0BG6weLaGhJbjTK4wDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA4MDMxNzIwNDcyM1oX
DTA5MDMxNzIwNDcyM1owTjEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjErMCkG
CSqGSIb3DQEJARYcamJ1Y2tpbmdoYW1AYmx1ZXlvbmRlci5jby51azCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAMpt089Gj6mNQnCzJzLATutrPfBKs8EgZz+I0Id+fiiwSCbp
zDnOay4itz4EyXgsUw/zcZyMNwT+JJQiznaSlHagGZs5AiA059yvLuLb6C0FrMOFjpREHJDf
mdA6lSEeNjCHUEPNkvZvrAapQdK2QtCQhJcoacYAy97+FLSOaRlFO99Ggq6/ROvF2SU2kPQj
omE5t3uOHtm4GbGblbwaUztHFWB7d6WKyLJF8AeDHSKVqBMd1I4JhttdZsTz6lLc6csVB+do
6+EYWkrttS14Nyprw91a9OxtY6m8zFBNgQR460IvdEmCwHdTF4krE0LSTVXRvyrmvpdz3oN2
HVBGlY0CAwEAAaM5MDcwJwYDVR0RBCAwHoEcamJ1Y2tpbmdoYW1AYmx1ZXlvbmRlci5jby51
azAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBBQUAA4GBAAq+YglaqniAq4ToNKx/yTvPTdT3
eo34CLo1IoYz5b0e23QgiOxPWdahf59uxytDE0oq9GGj4HvrQazG9oKd+pEMikT9FJnIrjRW
02jCYrO90/060ovsQX1KPYpSC9WtCLQlg7LRmq9a8sYkbpbu/qx5KdtixduIs/ZyPV5ZyOcW
MIIC8jCCAlugAwIBAgIQP7adUnQEbrB4toaEluNMrjANBgkqhkiG9w0BAQUFADBiMQswCQYD
VQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UE
AxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0EwHhcNMDgwMzE3MjA0NzIz
WhcNMDkwMzE3MjA0NzIzWjBOMR8wHQYDVQQDExZUaGF3dGUgRnJlZW1haWwgTWVtYmVyMSsw
KQYJKoZIhvcNAQkBFhxqYnVja2luZ2hhbUBibHVleW9uZGVyLmNvLnVrMIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEAym3Tz0aPqY1CcLMnMsBO62s98EqzwSBnP4jQh35+KLBI
JunMOc5rLiK3PgTJeCxTD/NxnIw3BP4klCLOdpKUdqAZmzkCIDTn3K8u4tvoLQWsw4WOlEQc
kN+Z0DqVIR42MIdQQ82S9m+sBqlB0rZC0JCElyhpxgDL3v4UtI5pGUU730aCrr9E68XZJTaQ
9COiYTm3e44e2bgZsZuVvBpTO0cVYHt3pYrIskXwB4MdIpWoEx3UjgmG211mxPPqUtzpyxUH
52jr4RhaSu21LXg3KmvD3Vr07G1jqbzMUE2BBHjrQi90SYLAd1MXiSsTQtJNVdG/Kua+l3Pe
g3YdUEaVjQIDAQABozkwNzAnBgNVHREEIDAegRxqYnVja2luZ2hhbUBibHVleW9uZGVyLmNv
LnVrMAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQEFBQADgYEACr5iCVqqeICrhOg0rH/JO89N
1Pd6jfgIujUihjPlvR7bdCCI7E9Z1qF/n27HK0MTSir0YaPge+tBrMb2gp36kQyKRP0Umciu
NFbTaMJis73T/TrSi+xBfUo9ilIL1a0ItCWDstGar1ryxiRulu7+rHkp22LF24iz9nI9XlnI
5xYwggM/MIICqKADAgECAgENMA0GCSqGSIb3DQEBBQUAMIHRMQswCQYDVQQGEwJaQTEVMBMG
A1UECBMMV2VzdGVybiBDYXBlMRIwEAYDVQQHEwlDYXBlIFRvd24xGjAYBgNVBAoTEVRoYXd0
ZSBDb25zdWx0aW5nMSgwJgYDVQQLEx9DZXJ0aWZpY2F0aW9uIFNlcnZpY2VzIERpdmlzaW9u
MSQwIgYDVQQDExtUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgQ0ExKzApBgkqhkiG9w0BCQEW
HHBlcnNvbmFsLWZyZWVtYWlsQHRoYXd0ZS5jb20wHhcNMDMwNzE3MDAwMDAwWhcNMTMwNzE2
MjM1OTU5WjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0
eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0Ew
gZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMSmPFVzVftOucqZWh5owHUEcJ3f6f+jHuy9
zfVb8hp2vX8MOmHyv1HOAdTlUAow1wJjWiyJFXCO3cnwK4Vaqj9xVsuvPAsH5/EfkTYkKhPP
K9Xzgnc9A74r/rsYPge/QIACZNenprufZdHFKlSFD0gEf6e20TxhBEAeZBlyYLf7AgMBAAGj
gZQwgZEwEgYDVR0TAQH/BAgwBgEB/wIBADBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3Js
LnRoYXd0ZS5jb20vVGhhd3RlUGVyc29uYWxGcmVlbWFpbENBLmNybDALBgNVHQ8EBAMCAQYw
KQYDVR0RBCIwIKQeMBwxGjAYBgNVBAMTEVByaXZhdGVMYWJlbDItMTM4MA0GCSqGSIb3DQEB
BQUAA4GBAEiM0VCD6gsuzA2jZqxnD3+vrL7CF6FDlpSdf0whuPg2H6otnzYvwPQcUCCTcDz9
reFhYsPZOhl+hLGZGwDFGguCdJ4lUJRix9sncVcljd2pnDmOjCBPZV+V2vf3h9bGCE6u9uo0
5RAaWzVNd+NWIXiC3CEZNd4ksdMdRv9dX2VPMYIDZDCCA2ACAQEwdjBiMQswCQYDVQQGEwJa
QTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhh
d3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECED+2nVJ0BG6weLaGhJbjTK4wCQYF
Kw4DAhoFAKCCAcMwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcN
MDgwNjE5MjIyNDEzWjAjBgkqhkiG9w0BCQQxFgQUrM3DTBOgjaZSsTQT8BCJ2F4aksowUgYJ
KoZIhvcNAQkPMUUwQzAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgYUGCSsGAQQBgjcQBDF4MHYwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhA/tp1SdARusHi2hoSW40yu
MIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBD
b25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFp
bCBJc3N1aW5nIENBAhA/tp1SdARusHi2hoSW40yuMA0GCSqGSIb3DQEBAQUABIIBAJWZS1FY
aAlv/ytdUTyTvSy5olZXK6QQzMNWzEn+ZN8uQTg/m5CByqWW3VEDxaPv+l60gqom+XQkWMqs
okO5dNCXS6jFvPFoq4XaGGEl0ZMf1omgZdvjF4+x3eXwBGtll0JgDtDbUWGTFNZF2dWjJ3EH
6nv6wIXOPaMn/RrfkdDiLzjLazUJsV05XwzpgeDVCILqh0rQojzh4wXMHEgfpbON2RxgvmdY
k3EXbHpmhEZ3jq6/+dqO5yit0tXWQUSGEp6XkTcXG8BG/UIydV+rx6gdqnmII5Eqg3YnsTea
0JZfM7pLlqf72cJccUFLCIIsWzTn7Zk41VWSrVW6JPNmBUoAAAAAAAA=
--------------ms000907070802030602090501--

