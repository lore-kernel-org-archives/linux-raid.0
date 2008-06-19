From: Jon Buckingham <jbuckingham@blueyonder.co.uk>
Subject: mdadm: making a spare actie
Date: Thu, 19 Jun 2008 10:23:39 +0100
Message-ID: <485A259B.9040106@blueyonder.co.uk>
Reply-To: jbuckingham@blueyonder.co.uk
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms000106090009010304040800"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jon Buckingham <jon.buckingham@hp.com>
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms000106090009010304040800
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I have had a corruption of some sort on my raid5 setup,
and have not quite been able to solve it.

A previously failed disk partition is now a spare,
but I cannot get it made active again!

My array is /dev/md0
The components of this are /dev/sda5, sdb5, sdc5, sdd5

/dev/sdb5 was failed, and is now spare.
(NB: something got corrupted on that parition I think,
other partitions on that disk function ok)

Here is some output...

nas:~ # mdadm -E /dev/sdb5 (the "spare")
--------------------------
/dev/sdb5:
           Magic : a92b4efc
         Version : 00.90.03
            UUID : b54e46e1:b6a6e6ea:3ae5a5a5:04e207e4
   Creation Time : Fri Aug  4 22:42:14 2006
      Raid Level : raid5
   Used Dev Size : 244380672 (233.06 GiB 250.25 GB)
      Array Size : 733142016 (699.18 GiB 750.74 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 0

     Update Time : Wed Jun 18 20:58:38 2008
           State : clean
  Active Devices : 3
Working Devices : 4
  Failed Devices : 1
   Spare Devices : 1
        Checksum : f11b2114 - correct
          Events : 0.3796128

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     4       8       21        4      spare   /dev/sdb5

    0     0       8        5        0      active sync   /dev/sda5
    1     1       0        0        1      faulty removed
    2     2       8       37        2      active sync   /dev/sdc5
    3     3       8       53        3      active sync   /dev/sdd5
    4     4       8       21        4      spare   /dev/sdb5

nas:~ # mdadm -E /dev/sda5 (an "ok" partition)
--------------------------
/dev/sda5:
           Magic : a92b4efc
         Version : 00.90.03
            UUID : b54e46e1:b6a6e6ea:3ae5a5a5:04e207e4
   Creation Time : Fri Aug  4 22:42:14 2006
      Raid Level : raid5
   Used Dev Size : 244380672 (233.06 GiB 250.25 GB)
      Array Size : 733142016 (699.18 GiB 750.74 GB)
    Raid Devices : 4
   Total Devices : 3
Preferred Minor : 0

     Update Time : Thu Jun 19 09:51:45 2008
           State : clean
  Active Devices : 3
Working Devices : 3
  Failed Devices : 1
   Spare Devices : 0
        Checksum : f11bd635 - correct
          Events : 0.3796148

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     0       8        5        0      active sync   /dev/sda5

    0     0       8        5        0      active sync   /dev/sda5
    1     1       0        0        1      faulty removed
    2     2       8       37        2      active sync   /dev/sdc5
    3     3       8       53        3      active sync   /dev/sdd5

------------------------------
nas:~ # mdadm -A /dev/md0 -U summaries /dev/sda5 /dev/sdb5 /dev/sdc5 /dev/sdd5
mdadm: /dev/md0 has been started with 3 drives (out of 4) and 1 spare.

------------------------------
nas:~ # mdadm --grow --raid-devices=4 /dev/md0
mdadm: /dev/md0: Cannot reshape array without increasing size (yet).

------------------------------
I have also done
mdadm /dev/md0 -a /dev/sdb5
and this results in a recovery...

nas:~ # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdb5[4] sda5[0] sdd5[3] sdc5[2]
       733142016 blocks level 5, 64k chunk, algorithm 2 [4/3] [U_UU]
       [=>...................]  recovery =  7.3% (17900780/244380672) finish=174.1min speed=21666K/sec

unused devices: <none>

Which I've been through before, but still ends up as a spare.

Any ideas?

Thanks!!

Jon B

--------------ms000106090009010304040800
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
MDgwNjE5MDkyMzM5WjAjBgkqhkiG9w0BCQQxFgQUnetYCBLzzWs+LgFDesbkH5jGu+MwUgYJ
KoZIhvcNAQkPMUUwQzAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgYUGCSsGAQQBgjcQBDF4MHYwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhA/tp1SdARusHi2hoSW40yu
MIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBD
b25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFp
bCBJc3N1aW5nIENBAhA/tp1SdARusHi2hoSW40yuMA0GCSqGSIb3DQEBAQUABIIBALQ01g7J
hIzuCq3Bx4uoFG12sf5R7h5v+K7WUDCof9OFc30zX+vTq/R1VjdyQQLGAupov/fnqP4mAoTd
I9aeqJBvdabMCL4dAvKt/ZfxFVzczyQyzi7gh39ufTq7sVIYTQGJDnWDwsGdWRtd0FZDbu6I
im/yGDjSZlipFRooBphaf4O6LDRUNENEeuL9iXhQcoN7XF+NmG90UQyHmbIq1Jl9rg0j9ZDG
m5RC4Y5XYopN80zESeTUI4h7s6FRj1pPnykVV8jLXS3vECmaigBobxWLlsb/YHE72E+rrAHx
tlyyxH4VFPvF963C5xP6b14Vy+cmWYDvLR1z/PlM0/9iCJoAAAAAAAA=
--------------ms000106090009010304040800--

