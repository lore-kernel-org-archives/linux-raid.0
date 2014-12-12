From: Peter Kieser <peter@kieser.ca>
Subject: raid10: 6 out of 8 disks marked as stale on every restart
Date: Fri, 12 Dec 2014 09:04:51 -0800
Message-ID: <548B2033.5030803@kieser.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms040104020909080007000507"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms040104020909080007000507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hello,

I have a 8 disk RAID10 array, 6 of the disks are on an LSISAS2008=20
controller and 2 are on a  82801JI (ICH10 Family) SATA AHCI controller.  =

I upgraded the kernel from 3.17.1 to 3.17.6 when the issue I am having=20
started to occur, but reverting to an older kernel does not resolve the=20
issue.

Restarting the machine causes the array not to start (or be visible in=20
/proc/mdstat or any mention in kernel messages.) If I try to assemble=20
the drives, mdraid complains that 6 out of the 8 disks (coincidentally=20
all on the LSISAS2008 controller) are non-fresh:

root@kvm:~# mdadm --assemble /dev/md3 /dev/sde /dev/sdf /dev/sdg=20
/dev/sdh /dev/sdi /dev/sdj /dev/sda /dev/sdb

Dec 11 21:08:25 kvm kernel: [  528.503736] md: kicking non-fresh sdi=20
from array!
Dec 11 21:08:25 kvm kernel: [  528.503747] md: unbind<sdi>
Dec 11 21:08:25 kvm kernel: [  528.523775] md: export_rdev(sdi)
Dec 11 21:08:25 kvm kernel: [  528.523802] md: kicking non-fresh sdg=20
from array!
Dec 11 21:08:25 kvm kernel: [  528.523809] md: unbind<sdg>
Dec 11 21:08:25 kvm kernel: [  528.531753] md: export_rdev(sdg)
Dec 11 21:08:25 kvm kernel: [  528.531780] md: kicking non-fresh sdf=20
from array!
Dec 11 21:08:25 kvm kernel: [  528.531788] md: unbind<sdf>
Dec 11 21:08:25 kvm kernel: [  528.539749] md: export_rdev(sdf)
Dec 11 21:08:25 kvm kernel: [  528.539776] md: kicking non-fresh sdh=20
from array!
Dec 11 21:08:25 kvm kernel: [  528.539785] md: unbind<sdh>
Dec 11 21:08:25 kvm kernel: [  528.547744] md: export_rdev(sdh)
Dec 11 21:08:25 kvm kernel: [  528.547771] md: kicking non-fresh sdj=20
from array!
Dec 11 21:08:25 kvm kernel: [  528.547779] md: unbind<sdj>
Dec 11 21:08:25 kvm kernel: [  528.555755] md: export_rdev(sdj)
Dec 11 21:08:25 kvm kernel: [  528.555782] md: kicking non-fresh sde=20
from array!
Dec 11 21:08:25 kvm kernel: [  528.555790] md: unbind<sde>
Dec 11 21:08:25 kvm kernel: [  528.563758] md: export_rdev(sde)
Dec 11 21:08:25 kvm kernel: [  528.565831] md/raid10:md3: not enough=20
operational mirrors.
Dec 11 21:08:25 kvm kernel: [  528.567230] md: pers->run() failed ...

/dev/sda and /dev/sdb are the only drives not on the LSI controller. If=20
I force the assembly with 6 out of the 8 drives the RAID array comes up:

root@kvm:~# mdadm --assemble /dev/md3 /dev/sde /dev/sdf /dev/sdg=20
/dev/sdh /dev/sdi /dev/sdj --run

Then I add the extra drives:

root@kvm:~# mdadm --manage /dev/md3 --add /dev/sda
root@kvm:~# mdadm --manage /dev/md3 --add /dev/sdb

root@kvm:~# mdadm --detail /dev/md3
/dev/md3:
         Version : 1.0
   Creation Time : Thu Sep 12 18:43:56 2013
      Raid Level : raid10
      Array Size : 7814055936 (7452.06 GiB 8001.59 GB)
   Used Dev Size : 1953513984 (1863.02 GiB 2000.40 GB)
    Raid Devices : 8
   Total Devices : 8
     Persistence : Superblock is persistent

     Update Time : Fri Dec 12 08:58:19 2014
           State : active, degraded, recovering
  Active Devices : 6
Working Devices : 8
  Failed Devices : 0
   Spare Devices : 2

          Layout : near=3D2
      Chunk Size : 512K

  Rebuild Status : 76% complete

            Name : kvm.taylor.kieser.ca:3
            UUID : f0bc8469:9879a709:e4cc94a7:521bd273
          Events : 82901

     Number   Major   Minor   RaidDevice State
        0       8      128        0      active sync /dev/sdi
        8       8       96        1      active sync /dev/sdg
       11       8        0        2      spare rebuilding /dev/sda
        3       8      112        3      active sync /dev/sdh
        4       0        0        4      removed
       10       8       80        5      active sync /dev/sdf
        6       8       64        6      active sync /dev/sde
        9       8      144        7      active sync /dev/sdj

       12       8       16        -      spare   /dev/sdb

This occurs every time I restart the machine. Thoughts? I tried=20
rebuilding the initramfs but this didn't resolve the issue. I'm also=20
running bcache on this machine, but on top of the mdraid.

/etc/mdadm.conf:

# definitions of existing MD arrays
ARRAY /dev/md/0 metadata=3D1.0 UUID=3D3b174514:49f3e22e:550cf9a7:8ed93920=
=20
name=3Dlinux:0
ARRAY /dev/md/1 metadata=3D1.0 UUID=3D8e23f81d:73f9b393:addd1f7f:5ee1833a=
=20
name=3Dlinux:1
ARRAY /dev/md/2 metadata=3D1.0 UUID=3Dcc5a0495:b5262855:fb3cd40a:8b237162=
=20
name=3Dkvm.taylor.kieser.ca:2
ARRAY /dev/md/3 metadata=3D1.0 UUID=3Df0bc8469:9879a709:e4cc94a7:521bd273=
=20
name=3Dkvm.taylor.kieser.ca:3


root@kvm:~# uname -a
Linux kvm 3.17.6 #3 SMP Sun Dec 7 12:16:45 PST 2014 x86_64 x86_64 x86_64 =

GNU/Linux

root@kvm:~# mdadm -V
mdadm - v3.2.5 - 18th May 2012

root@kvm:~# cat /proc/mdstat
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]=20
[raid4] [raid10]
md127 : inactive sdk[2](S)
       1465138448 blocks super 1.0

md3 : active raid10 sdb[12](S) sda[11] sdi[0] sdj[9] sde[6] sdf[10]=20
sdh[3] sdg[8]
       7814055936 blocks super 1.0 512K chunks 2 near-copies [8/6]=20
[UU_U_UUU]
       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.....]  recovery =3D=
 76.6% (1498279040/1953513984)=20
finish=3D4710.1min speed=3D1610K/sec

md1 : active raid1 sdd5[3] sdc5[2]
       25164672 blocks super 1.0 [2/2] [UU]

md0 : active raid1 sdd1[3] sdc1[2]
       16779136 blocks super 1.0 [2/2] [UU]

md2 : active raid1 sdd6[3] sdc6[2]
       192472960 blocks super 1.0 [2/2] [UU]

unused devices: <none>

-Peter



--------------ms040104020909080007000507
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIMqzCC
BjQwggQcoAMCAQICASAwDQYJKoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA3
MTAyNDIxMDI1NVoXDTE3MTAyNDIxMDI1NVowgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
dGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWdu
aW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENs
aWVudCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMsohUWcASz7GfKrpTOM
KqANy9BV7V0igWdGxA8IU77L3aTxErQ+fcxtDYZ36Z6GH0YFn7fq5RADteP0AYzrCA+EQTfi
8q1+kA3m0nwtwXG94M5sIqsvs7lRP1aycBke/s5g9hJHryZ2acScnzczjBCAo7X1v5G3yw8M
DP2m2RCye0KfgZ4nODerZJVzhAlOD9YejvAXZqHksw56HzElVIoYSZ3q4+RJuPXXfIoyby+Y
2m1E+YzX5iCZXBx05gk6MKAW1vaw4/v2OOLy6FZH3XHHtOkzUreG//CsFnB9+uaYSlR65cdG
zTsmoIK8WH1ygoXhRBm98SD7Hf/r3FELNvUCAwEAAaOCAa0wggGpMA8GA1UdEwEB/wQFMAMB
Af8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBSuVYNv7DHKufcd+q9rMfPIHeOsuzAfBgNV
HSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jBmBggrBgEFBQcBAQRaMFgwJwYIKwYBBQUH
MAGGG2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9jYTAtBggrBgEFBQcwAoYhaHR0cDovL3d3
dy5zdGFydHNzbC5jb20vc2ZzY2EuY3J0MFsGA1UdHwRUMFIwJ6AloCOGIWh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL3Nmc2NhLmNybDAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5jb20v
c2ZzY2EuY3JsMIGABgNVHSAEeTB3MHUGCysGAQQBgbU3AQIBMGYwLgYIKwYBBQUHAgEWImh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93
d3cuc3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwDQYJKoZIhvcNAQEFBQADggIBADqp
Jw3I07QWke9plNBpxUxcffc7nUrIQpJHDci91DFG7fVhHRkMZ1J+BKg5UNUxIFJ2Z9B90Mic
c/NXcs7kPBRdn6XGO/vPc87Y6R+cWS9Nc9+fp3Enmsm94OxOwI9wn8qnr/6o3mD4noP9Jphw
UPTXwHovjavRnhUQHLfo/i2NG0XXgTHXS2Xm0kVUozXqpYpAdumMiB/vezj1QHQJDmUdPYMc
p+reg9901zkyT3fDW/ivJVv6pWtkh6Pw2ytZT7mvg7YhX3V50Nv860cV11mocUVcqBLv0gcT
+HBDYtbuvexNftwNQKD5193A7zN4vG7CTYkXxytSjKuXrpEatEiFPxWgb84nVj25SU5q/r1X
hwby6mLhkbaXslkVtwEWT3Van49rKjlK4XrUKYYWtnfzq6aSak5u0Vpxd1rY79tWhD3EdCvO
hNz/QplNa+VkIsrcp7+8ZhP1l1b2U6MaxIVteuVMD3X0vziIwr7jxYae9FZjbxlpUemqXjcC
0QaFfN7qI0JsQMALL7iGRBg7K0CoOBzECdD3fuZil5kU/LP9cr1BK31U0Uy651bFnAMMMkqh
AChIbn0ei72VnbpSsrrSdF0BAGYQ8vyHae5aCg+H75dVCV33K6FuxZrf09yTz+Vx/PkdRUYk
XmZz/OTfyJXsUOUXrym6KvI2rYpccSk5MIIGbzCCBVegAwIBAgICUcswDQYJKoZIhvcNAQEF
BQAwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJT
ZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBD
bGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQTAeFw0xNDA4MTcxMDM5MDla
Fw0xNjA4MTcxMzU1MzFaMIGOMRkwFwYDVQQNExBKSHI4SWdkNjhlbUUweVF6MQswCQYDVQQG
EwJDQTEZMBcGA1UECBMQQnJpdGlzaCBDb2x1bWJpYTESMBAGA1UEBxMJVmFuY291dmVyMRUw
EwYDVQQDEwxQZXRlciBLaWVzZXIxHjAcBgkqhkiG9w0BCQEWD3BldGVyQGtpZXNlci5jYTCC
ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAL/NmLSwzKyhFa8wVY4On4D2atW+jO4k
qzGjt32GITxEhweeR2AeQFhmBXTwwAHGnAEWU+lQSXoIoV9Hdi8GhTeFz3A5LPTLl/wa6dmv
8VCfYaREvoSxjEN4nsCtdU8P6NLUE4mqBe7ZiP9lDkqWgmd0fDEYjiOnJU3cdoLh5vDHOyu+
9mmPDVEBELFgbbdQsyiINKQN5fwElQ/5hwip/5lFCrT8SYYVS7s2JwEPtvPmpl+JyOwRJakh
VRv4Wd8Lyv/rchK4riwfMyHhuKwbbKRxs3HzSHjtsjGZ2tS1UzDEalL7ZRsHC4EvZmgBGg5E
0l1Bz7cC4JcPIy+8G14OjZkCAwEAAaOCAtUwggLRMAkGA1UdEwQCMAAwCwYDVR0PBAQDAgSw
MB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQUvDcOWQqoGGEK+KDc
6opnV1iupIkwHwYDVR0jBBgwFoAUrlWDb+wxyrn3HfqvazHzyB3jrLswGgYDVR0RBBMwEYEP
cGV0ZXJAa2llc2VyLmNhMIIBTAYDVR0gBIIBQzCCAT8wggE7BgsrBgEEAYG1NwECAzCCASow
LgYIKwYBBQUHAgEWImh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwgfcGCCsG
AQUFBwICMIHqMCcWIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MAMCAQEagb5U
aGlzIGNlcnRpZmljYXRlIHdhcyBpc3N1ZWQgYWNjb3JkaW5nIHRvIHRoZSBDbGFzcyAyIFZh
bGlkYXRpb24gcmVxdWlyZW1lbnRzIG9mIHRoZSBTdGFydENvbSBDQSBwb2xpY3ksIHJlbGlh
bmNlIG9ubHkgZm9yIHRoZSBpbnRlbmRlZCBwdXJwb3NlIGluIGNvbXBsaWFuY2Ugb2YgdGhl
IHJlbHlpbmcgcGFydHkgb2JsaWdhdGlvbnMuMDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9j
cmwuc3RhcnRzc2wuY29tL2NydHUyLWNybC5jcmwwgY4GCCsGAQUFBwEBBIGBMH8wOQYIKwYB
BQUHMAGGLWh0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9zdWIvY2xhc3MyL2NsaWVudC9jYTBC
BggrBgEFBQcwAoY2aHR0cDovL2FpYS5zdGFydHNzbC5jb20vY2VydHMvc3ViLmNsYXNzMi5j
bGllbnQuY2EuY3J0MCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cuc3RhcnRzc2wuY29tLzANBgkq
hkiG9w0BAQUFAAOCAQEAycbEJG6nvyfbv2X4npgq1ceU+y1qYmXczCBNvNRJ2yvVXc8ljjQs
KRDzpr8JhTCg4SMZh3C3AIOBGxrYCsyaxRL3Ssfh/6Ptg3ExIfVNj6CobB1piTrusORaVDYS
jEtZZRR4iYt9mDRo/mZRhh4QRManZYwCXPG4mrguqQ4NLYVdgTsHYgCTRymMbyrQ0+eIGdAO
/szcirRovADyxroMclw+TTlB7nQrovIsTVteGqe0renKR0bzdWsexQEntKpBxJLy/HTSIHeQ
HU5r7hwjk/v1aoKlimuaKbdGTJl10BYk8+pbU8JGEl1sm1cNn4MKYwhnWFRTBEPEiXP6VyNc
PTGCA9owggPWAgEBMIGTMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRk
LjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UE
AxMvU3RhcnRDb20gQ2xhc3MgMiBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0ECAlHL
MAkGBSsOAwIaBQCgggIbMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTE0MTIxMjE3MDQ1MVowIwYJKoZIhvcNAQkEMRYEFCRqeJ1TedP4H9H32HyljCAWszuQ
MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0D
BzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwIC
ASgwgaQGCSsGAQQBgjcQBDGBljCBkzCBjDELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0
Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcx
ODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDIgUHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50
IENBAgJRyzCBpgYLKoZIhvcNAQkQAgsxgZaggZMwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQK
Ew1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBT
aWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRl
IENsaWVudCBDQQICUcswDQYJKoZIhvcNAQEBBQAEggEAcRdD7TTmLBBu74Iqcgn2gqetCgFT
Ec37Zk3nnnZwdw59up5p+5zM0w/2/DzyLo5sWeWzrn1SfvZ7Fe4CuBgo1EYe7iC/AVw65mIf
KhKCtnvkBdGuoV20PngD28s/sQ4ty1vIxUy1m8IwyZVYkPzqtzEnF0QrVJw8/oug5ZnEuu7Y
hgJqzxlYv6EYkrp6A3XEJ7OmKUE0kNAOhKBWw4mwnfrlCLf2foabZdD/BRGXK+TnLnRPV8it
n6gZwEJM9yVfFtT7sKdJSypJqdovDkbuSwuqpcIhg6sofTBchzNAg4LjdzkyhqG4el/dRXG8
RNaRRSKsLnJ443kCAiSLB3J9WgAAAAAAAA==
--------------ms040104020909080007000507--
