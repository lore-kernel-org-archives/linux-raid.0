From: Jan Hejl <jh@excello.cz>
Subject: Corrupted Cisco NSS4000 raid
Date: Sat, 17 Jan 2015 16:23:59 +0100
Message-ID: <54BA7E8F.1090601@excello.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms060509040902010502030208"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms060509040902010502030208
Content-Type: multipart/mixed;
 boundary="------------090204080200010705070807"

This is a multi-part message in MIME format.
--------------090204080200010705070807
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: quoted-printable

Hello everyone,

right after finish rebuilding faulty, but still usable, RAID array on=20
Cisco NSS4000 NAS box, array stopped working completly.
I took all 4 drives (1TB each) out and connected to my linux machine to=20
take a look what happened. You can find raid-status (mdadm --examine=20
/dev/sd[bcde]) attached.

After reading this page=20
https://raid.wiki.kernel.org/index.php/RAID_Recovery I'm considering to=20
try recreate array, as soon as dd ends with image backup of these=20
drives, but before I screw something I would to ask you RAID wizards for =

help. Was anyone solving similiar issue?

Thanks for help
Jan

--------------090204080200010705070807
Content-Type: text/plain; charset=UTF-8;
 name="raid-status"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="raid-status"

/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : c5e32635:d1ed305c:c7804bbe:d0dd962d
           Name : 0
  Creation Time : Mon Feb 11 16:58:03 2013
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953524896 (931.51 GiB 1000.20 GB)
     Array Size : 2930287296 (2794.54 GiB 3000.61 GB)
  Used Dev Size : 1953524864 (931.51 GiB 1000.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : bbd560dd:768ade9f:dd15ef88:53d2dd62

    Update Time : Wed Jan 14 17:24:39 2015
       Checksum : 1e255442 - correct
         Events : 1190

         Layout : left-symmetric
     Chunk Size : 32K

   Device Role : Active device 3
   Array State : A..A ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : c5e32635:d1ed305c:c7804bbe:d0dd962d
           Name : 0
  Creation Time : Mon Feb 11 16:58:03 2013
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953524896 (931.51 GiB 1000.20 GB)
     Array Size : 2930287296 (2794.54 GiB 3000.61 GB)
  Used Dev Size : 1953524864 (931.51 GiB 1000.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 0c7f1826:b250a6da:fcdeef79:bb3845ad

    Update Time : Wed Jan 14 17:24:39 2015
       Checksum : dd0cf356 - correct
         Events : 1190

         Layout : left-symmetric
     Chunk Size : 32K

   Device Role : spare
   Array State : A..A ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : c5e32635:d1ed305c:c7804bbe:d0dd962d
           Name : 0
  Creation Time : Mon Feb 11 16:58:03 2013
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953524896 (931.51 GiB 1000.20 GB)
     Array Size : 2930287296 (2794.54 GiB 3000.61 GB)
  Used Dev Size : 1953524864 (931.51 GiB 1000.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : ba398ff8:329c83c3:4e9a58be:5e3ea83e

    Update Time : Wed Jan 14 17:24:39 2015
       Checksum : 6e2cba76 - correct
         Events : 1190

         Layout : left-symmetric
     Chunk Size : 32K

   Device Role : Active device 0
   Array State : A..A ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : c5e32635:d1ed305c:c7804bbe:d0dd962d
           Name : 0
  Creation Time : Mon Feb 11 16:58:03 2013
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953524896 (931.51 GiB 1000.20 GB)
     Array Size : 2930287296 (2794.54 GiB 3000.61 GB)
  Used Dev Size : 1953524864 (931.51 GiB 1000.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 358b8c70:0307f5df:5aeabe91:ba88e079

    Update Time : Wed Jan 14 16:57:26 2015
       Checksum : 113d0d6d - correct
         Events : 1186

         Layout : left-symmetric
     Chunk Size : 32K

   Device Role : Active device 1
   Array State : AA.A ('A' =3D=3D active, '.' =3D=3D missing)

--------------090204080200010705070807--

--------------ms060509040902010502030208
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: Elektronicky podpis S/MIME

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIINPzCC
BkIwggUqoAMCAQICEDirAC//rpa3Vv85Wvtd5xswDQYJKoZIhvcNAQEFBQAwgcoxCzAJBgNV
BAYTAlVTMRcwFQYDVQQKEw5WZXJpU2lnbiwgSW5jLjEfMB0GA1UECxMWVmVyaVNpZ24gVHJ1
c3QgTmV0d29yazE6MDgGA1UECxMxKGMpIDE5OTkgVmVyaVNpZ24sIEluYy4gLSBGb3IgYXV0
aG9yaXplZCB1c2Ugb25seTFFMEMGA1UEAxM8VmVyaVNpZ24gQ2xhc3MgMSBQdWJsaWMgUHJp
bWFyeSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eSAtIEczMB4XDTExMDkwMTAwMDAwMFoXDTIx
MDgzMTIzNTk1OVowgaYxCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3Jh
dGlvbjEfMB0GA1UECxMWU3ltYW50ZWMgVHJ1c3QgTmV0d29yazEeMBwGA1UECxMVUGVyc29u
YSBOb3QgVmFsaWRhdGVkMTcwNQYDVQQDEy5TeW1hbnRlYyBDbGFzcyAxIEluZGl2aWR1YWwg
U3Vic2NyaWJlciBDQSAtIEc0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxuwn
/R1j9DsdisHTHMjIgoa2uEqGkqqBXHLKMA0vnkEiVzAhJZCao/SsKsaIF4ZhchN2LuwDyyeb
jyCAN+DkitpVplAP/LlcI2mJQqG6H6/vDvmkyQrx+DeyxtmSSq5937hEH5u6P4wG/tgjT0hR
I2pghKjuJy9g35byGiqMPI8AzE/L+iCOvDX24fCatgXz/B0/xhR7DtryBeTTgwKmxWlwtKnk
VunbHVz0pjbia7UeKi3cvrvuOgSwMAitX2hsxr0GloiE5+apZC28ODC7iCbDZ2ZmtLR3+cCh
xw5y72bi5bnK4POFdzWY3tQcsP5mceI4y258T0BV65fZqBge7QIDAQABo4ICRDCCAkAwOAYI
KwYBBQUHAQEELDAqMCgGCCsGAQUFBzABhhxodHRwOi8vcGtpLW9jc3AudmVyaXNpZ24uY29t
MBIGA1UdEwEB/wQIMAYBAf8CAQAwbAYDVR0gBGUwYzBhBgtghkgBhvhFAQcXATBSMCYGCCsG
AQUFBwIBFhpodHRwOi8vd3d3LnN5bWF1dGguY29tL2NwczAoBggrBgEFBQcCAjAcGhpodHRw
Oi8vd3d3LnN5bWF1dGguY29tL3JwYTA0BgNVHR8ELTArMCmgJ6AlhiNodHRwOi8vY3JsLnZl
cmlzaWduLmNvbS9wY2ExLWczLmNybDAOBgNVHQ8BAf8EBAMCAQYwKQYDVR0RBCIwIKQeMBwx
GjAYBgNVBAMTEVZlcmlTaWduTVBLSS0yLTk3MB0GA1UdDgQWBBSt+cOTci21uShh5KTXYNXE
Cl4aATCB8QYDVR0jBIHpMIHmoYHQpIHNMIHKMQswCQYDVQQGEwJVUzEXMBUGA1UEChMOVmVy
aVNpZ24sIEluYy4xHzAdBgNVBAsTFlZlcmlTaWduIFRydXN0IE5ldHdvcmsxOjA4BgNVBAsT
MShjKSAxOTk5IFZlcmlTaWduLCBJbmMuIC0gRm9yIGF1dGhvcml6ZWQgdXNlIG9ubHkxRTBD
BgNVBAMTPFZlcmlTaWduIENsYXNzIDEgUHVibGljIFByaW1hcnkgQ2VydGlmaWNhdGlvbiBB
dXRob3JpdHkgLSBHM4IRAItbdVaEVIULAM+vOEjOsaQwDQYJKoZIhvcNAQEFBQADggEBANaP
wdqbiPKzbE0fWC+6AVFddMFG6MO4e5/WQPHv/zK6iWvADjRDn6SZ5qTwXUgzYoWFYf4jiCKM
YJsrnGVJlMSiOCRIpVylUEto6WIip5PomSJuPVu7EEIOH0x1RzRWCY/4vYw881y70pZwVHBi
Te/REL6dSCxe7IZrB4LwPeElJygs4BZ2HrP95WKW0oo9Xyuu+1zCE7dlY8s0dkOf1oeZq26t
lcEAP0Yngf813iMOQ9wUXzL5yinvwlIw9ZnduYH4OiUgjYJo8rkhhXRmBOGGORYy8i3WKqjJ
3tkAAk/jGCDFpYFWtpXe04Kt+HslvmR8LqC6cCz4+XXidE0HbYQwggb1MIIF3aADAgECAhAE
lT3Qzv8VewCwlJdEY+ItMA0GCSqGSIb3DQEBBQUAMIGmMQswCQYDVQQGEwJVUzEdMBsGA1UE
ChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlN5bWFudGVjIFRydXN0IE5ldHdv
cmsxHjAcBgNVBAsTFVBlcnNvbmEgTm90IFZhbGlkYXRlZDE3MDUGA1UEAxMuU3ltYW50ZWMg
Q2xhc3MgMSBJbmRpdmlkdWFsIFN1YnNjcmliZXIgQ0EgLSBHNDAeFw0xNDA3MzEwMDAwMDBa
Fw0xNTA4MDEyMzU5NTlaMIG/MS4wLAYDVQQDDCVQZXJzb25hIE5vdCBWYWxpZGF0ZWQgLSAx
NDA2Nzk5NjU0MDQ2MRwwGgYJKoZIhvcNAQkBFg1qaEBleGNlbGxvLmN6MQ8wDQYDVQQLDAZT
L01JTUUxHjAcBgNVBAsMFVBlcnNvbmEgTm90IFZhbGlkYXRlZDEfMB0GA1UECwwWU3ltYW50
ZWMgVHJ1c3QgTmV0d29yazEdMBsGA1UECgwUU3ltYW50ZWMgQ29ycG9yYXRpb24wggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC7LZjJJsMZwyIRXuJbru8HLP/FfADg5r/cZ1FR
r0jha7bfpO6SFG2S5kiGKuomWj4107pTqAcKSmYPKRwyv1o7qDMDFhEqDhf4Q/qDTL2ohFdp
UZA6ELviNLZe8zvs9MylYGGzEI7QZX+r+o2Hcr289hTRJ1ymC3mQlNln3nlfRzlRLXBwoWqM
Mq6cAhdtnXr5sv+Qrz81AfwP7DBi5flSMU5Ni1sJWcSrH3rVJ3Qo03pRi0mo5f+jY9eplrG5
JgfCyZ5rlTl+pk2dsrqH1/km3+FilpsUcyHDrrIuZdGvfsY7vipCDRkYO1i0nvkAqXg2s0vm
XSDPiLAW9czL49k/AgMBAAGjggMCMIIC/jAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIF
oDAgBgNVHSUBAf8EFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIwHQYDVR0OBBYEFO1MnjgkRFYa
Bqe5hpWGXzi/amBxMBgGA1UdEQQRMA+BDWpoQGV4Y2VsbG8uY3owHwYDVR0jBBgwFoAUrfnD
k3IttbkoYeSk12DVxApeGgEwggErBggrBgEFBQcBAQSCAR0wggEZMIIBFQYIKwYBBQUHMAKG
ggEHbGRhcDovL2RpcmVjdG9yeS52ZXJpc2lnbi5jb20vQ04lMjAlM0QlMjBTeW1hbnRlYyUy
MENsYXNzJTIwMSUyMEluZGl2aWR1YWwlMjBTdWJzY3JpYmVyJTIwQ0ElMjAtJTIwRzQlMkMl
MjBPVSUyMCUzRCUyMFBlcnNvbmElMjBOb3QlMjBWYWxpZGF0ZWQlMkMlMjBPVSUyMCUzRCUy
MFN5bWFudGVjJTIwVHJ1c3QlMjBOZXR3b3JrJTJDJTIwTyUyMCUzRCUyMFN5bWFudGVjJTIw
Q29ycG9yYXRpb24lMkMlMjBDJTIwJTNEJTIwVVM/Y0FDZXJ0aWZpY2F0ZTtiaW5hcnkwXQYD
VR0fBFYwVDBSoFCgToZMaHR0cDovL3BraS1jcmwuc3ltYXV0aC5jb20vY2FfNTYxYzEwMzY5
MGM5N2E2OTI0N2EwZWYwNzFhYzgxYWYvTGF0ZXN0Q1JMLmNybDBsBgNVHSAEZTBjMGEGC2CG
SAGG+EUBBxcBMFIwJgYIKwYBBQUHAgEWGmh0dHA6Ly93d3cuc3ltYXV0aC5jb20vY3BzMCgG
CCsGAQUFBwICMBwaGmh0dHA6Ly93d3cuc3ltYXV0aC5jb20vcnBhMCsGCmCGSAGG+EUBEAME
HTAbBhJghkgBhvhFARABAgIEAYbHzm8WBTEwOTIyMDkGCmCGSAGG+EUBEAUEKzApAgEAFiRh
SFIwY0hNNkx5OXdhMmt0Y21FdWMzbHRZWFYwYUM1amIyMD0wDQYJKoZIhvcNAQEFBQADggEB
ABWSa56+iTI1lgEgVfIxrNlrKNGGmPhquhqnPOH5iDxV5QteQdAma7kjt9NplIsVtuMd1QmK
jSzipJ2xvdMUmOMMukzETWZqeqTNcCGL7lQsT+11UGAb+69MtZd1FWTVRlx6Hf4j9heyVrh2
Fc3BaCztV8aOXpuNi3JrbV0BO0iRMsMz2qinm0Ta4QZk5BnPPKOryREQyWSPqmYGG0qyfcam
i0OvJTwmVzxqlhFiaTmRMuIFxFRrZHMgg1X73TgI1nxcaSYk3pIAyKSGUrbM3LCV72zO/ivT
EE1WOe0FSVAR2S+RLiOIgf20R9kE5i1io87FeqduDegaEzaysl5GO3sxggRSMIIETgIBATCB
uzCBpjELMAkGA1UEBhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMR8wHQYD
VQQLExZTeW1hbnRlYyBUcnVzdCBOZXR3b3JrMR4wHAYDVQQLExVQZXJzb25hIE5vdCBWYWxp
ZGF0ZWQxNzA1BgNVBAMTLlN5bWFudGVjIENsYXNzIDEgSW5kaXZpZHVhbCBTdWJzY3JpYmVy
IENBIC0gRzQCEASVPdDO/xV7ALCUl0Rj4i0wCQYFKw4DAhoFAKCCAmswGAYJKoZIhvcNAQkD
MQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwMTE3MTUyMzU5WjAjBgkqhkiG9w0B
CQQxFgQUPMiU8kdi5p0XInCeHgl+alR6Bm4wbAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQME
ASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0D
AgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBzAYJKwYBBAGCNxAEMYG+MIG7MIGmMQsw
CQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlN5
bWFudGVjIFRydXN0IE5ldHdvcmsxHjAcBgNVBAsTFVBlcnNvbmEgTm90IFZhbGlkYXRlZDE3
MDUGA1UEAxMuU3ltYW50ZWMgQ2xhc3MgMSBJbmRpdmlkdWFsIFN1YnNjcmliZXIgQ0EgLSBH
NAIQBJU90M7/FXsAsJSXRGPiLTCBzgYLKoZIhvcNAQkQAgsxgb6ggbswgaYxCzAJBgNVBAYT
AlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEfMB0GA1UECxMWU3ltYW50ZWMg
VHJ1c3QgTmV0d29yazEeMBwGA1UECxMVUGVyc29uYSBOb3QgVmFsaWRhdGVkMTcwNQYDVQQD
Ey5TeW1hbnRlYyBDbGFzcyAxIEluZGl2aWR1YWwgU3Vic2NyaWJlciBDQSAtIEc0AhAElT3Q
zv8VewCwlJdEY+ItMA0GCSqGSIb3DQEBAQUABIIBADEEzm5AqFo4miz6MXvWhjoq6V7yPZsU
cqzMhqyi/yy3ceRb4NsRaUnyeQ95QKi1nWnK8vb7BOEDMQrcqCBN+647NIWrPfbT66Km78/O
us0VsqJY7WTchHoJTaxbLeHmN4xRuamvEIhvq1oP5mzCfF+7K9q7RB16001/XzaXFbZhiVt4
duCQRqP476nILfFiTDZBxRbS1PO/EyjvabHKQCSDJbbssHeu+ikg10qhVMXFAxvpa8VRVMss
OEYl11i1DEqYnLvdgMJbj8/TGY9nXKwB/U3/Wz2cquucoFw1QS+QWQO5n7QYAUYnVSbRkXhR
OOsS9y5ijV+CCwfMnlmaqMoAAAAAAAA=
--------------ms060509040902010502030208--
