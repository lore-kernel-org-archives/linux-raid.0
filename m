From: Lukas Kubin <kubin@opf.slu.cz>
Subject: Re: Array of disks attached to multiple controllers
Date: Tue, 14 Sep 2004 16:07:43 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4146FB2F.9080103@opf.slu.cz>
References: <200409141357.i8EDvg332052@watkins-home.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms030700030709030705010906"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200409141357.i8EDvg332052@watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms030700030709030705010906
Content-Type: multipart/mixed;
 boundary="------------080606010201010702060305"

This is a multi-part message in MIME format.
--------------080606010201010702060305
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Ok, the output follows:

=====

/dev/md0:
         Version : 00.90.00
   Creation Time : Tue Sep 14 16:02:42 2004
      Raid Level : raid5
      Array Size : 782929792 (746.66 GiB 801.72 GB)
     Device Size : 195360896 (186.31 GiB 200.05 GB)
    Raid Devices : 16
   Total Devices : 17
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Tue Sep 14 16:02:42 2004
           State : dirty, recovering
  Active Devices : 16
Working Devices : 17
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 128K

  Rebuild Status : 0% complete

     Number   Major   Minor   RaidDevice State
        0       8       16        0      active sync   /dev/sdb
        1       8       32        1      active sync   /dev/sdc
        2       8       48        2      active sync   /dev/sdd
        3       8       64        3      active sync   /dev/sde
        4       8       80        4      active sync   /dev/sdf
        5       8       96        5      active sync   /dev/sdg
        6       8      112        6      active sync   /dev/sdh
        7       8      128        7      active sync   /dev/sdi
        8       8      144        8      active sync   /dev/sdj
        9       8      160        9      active sync   /dev/sdk
       10       8      176       10      active sync   /dev/sdl
       11       8      192       11      active sync   /dev/sdm
       12       8      208       12      active sync   /dev/sdn
       13       8      224       13      active sync   /dev/sdo
       14       8      240       14      active sync   /dev/sdp
       15      65        0       15      active sync   /dev/sdq
       16      65       16       16      spare   /dev/sdr
            UUID : c18d1ba9:d7d4f338:6d83a4e1:023cbbdb
          Events : 0.1

=====

All the disks are SATA 200GB, the first controller (for drives sd{a..f}) 
is 3ware 8xxx, the second is 3ware 9000 ATA Raid controller. The first 
controller uses 3w-xxxx kernel module, the second one 3x-9xxx on linux 
2.4.27.

Thank you for any help.

lukas

Guy wrote:
> Give us more info.
> Output from mdadm -D /dev/md?
> 
> Guy
> 
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Lukas Kubin
> Sent: Tuesday, September 14, 2004 9:22 AM
> To: linux-raid@vger.kernel.org
> Subject: Array of disks attached to multiple controllers
> 
> I'm having troubles creating Raid-5 array consisted of 16 (+1 spare) 
> disks attached to two 3ware (not same version) SATA controllers.
> 
> Mkraid creates the array without problems, however the array's total 
> size only equals the sum of space on drives attached to the first of 2 
> controllers. Ie, sd{b..f} are on scsi0 and sd{g..r} on scsi1. The space 
> of created array is close to the sum of drives attechted to scsi0 only.
> 
> Is it possible to combine drives on 2 controllers into one array? If 
> not, what solution should I use to have one filesystem containing whole 
> the drivespace on Raid-5?
> 
> Thank you.
> 
> lukas
> 

-- 
Lukas Kubin

phone: +420596398275
email: kubin@opf.slu.cz

Information centre
The School of Business Administration in Karvina
Silesian University in Opava
Czech Republic
http://www.opf.slu.cz

--------------080606010201010702060305
Content-Type: text/x-vcard; charset=utf-8;
 name="kubin.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kubin.vcf"

begin:vcard
fn:Lukas Kubin
n:Kubin;Lukas
org:The School of Business Administration in Karvina;Information centre
adr:;;Univerzitni namesti 1934/3;Karvina;;73340;Czech Republic
email;internet:kubin@opf.slu.cz
title:Network administrator
tel;work:+420596398275
x-mozilla-html:FALSE
url:http://www.opf.slu.cz
version:2.1
end:vcard


--------------080606010201010702060305--

--------------ms030700030709030705010906
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGbDCC
AzIwggIaoAMCAQICAgDmMA0GCSqGSIb3DQEBBAUAMDIxCzAJBgNVBAYTAkNaMQ8wDQYDVQQK
EwZDRVNORVQxEjAQBgNVBAMTCUNFU05FVCBDQTAeFw0wMzExMTkxNDM4NTdaFw0wNDExMTgx
NDM4NTdaMEUxDzANBgNVBAoTBkNFU05FVDEcMBoGA1UEChMTU2lsZXNpYW4gVW5pdmVyc2l0
eTEUMBIGA1UEAxMLbHVrYXMga3ViaW4wgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAL7l
zAuBktAjhaVuPR0S2kwnO/xt1fp9D2GdLpxu2NcqUsuyEC00k3VHEijgFzcNt7+QviV1y5nq
P3nmCqk+eNp20Z3qrYZKGh0YTho/qPESyjFZ4P2NmV7W+SewXZ0IEtxD/DaOMQo8kww1ho5y
zaxVgSRItwefSBEMmFYdqrxpAgMBAAGjgcIwgb8wHQYDVR0OBBYEFNBqBwZMDvExebpgW4m8
MCWtsegvMB8GA1UdIwQYMBaAFPhWGtmaeJVttIiEVTUvqgbz1yBaMDUGA1UdHwQuMCwwKqAo
oCaGJGh0dHA6Ly93d3cuY2VzbmV0LmN6L3BraS9jcmwvY2NhLmNybDAOBgNVHQ8BAf8EBAMC
BPAwGwYDVR0RBBQwEoEQa3ViaW5Ab3BmLnNsdS5jejAZBgNVHSAEEjAQMA4GDCsGAQQBvnkB
AgIBATANBgkqhkiG9w0BAQQFAAOCAQEAuI/sMxZZa78h5+Mzo3IhgSxrVMl5Hbm2YgLWLHAx
QG1NxG0W9bkggMmRWrW8Xotr8VPA4IySqBiVwOlVMdZ5GNcUiSCrrFU6zfxAXD6dAJuEHGfb
Vz/dQntptJ9Dz/URteoMleNZjn2gPaLELEax2gaF+2cvbpW521CFJrxxMc2LdScRDBCFapWO
GNbxqSflLqbT8TsrbmS1V6zUicXf2eUurKA36/psbtFdG03vVaD3+V+RMgHr6X5k1NUfDfSI
pmX7irFEn7tMrxq630NTJUrEm1w4ivK/+f+6+F0ozeaamYS/Gm7LUFSgA15ZDtGCKySWQp2V
B+gwUKfc+8R+WjCCAzIwggIaoAMCAQICAgDmMA0GCSqGSIb3DQEBBAUAMDIxCzAJBgNVBAYT
AkNaMQ8wDQYDVQQKEwZDRVNORVQxEjAQBgNVBAMTCUNFU05FVCBDQTAeFw0wMzExMTkxNDM4
NTdaFw0wNDExMTgxNDM4NTdaMEUxDzANBgNVBAoTBkNFU05FVDEcMBoGA1UEChMTU2lsZXNp
YW4gVW5pdmVyc2l0eTEUMBIGA1UEAxMLbHVrYXMga3ViaW4wgZ8wDQYJKoZIhvcNAQEBBQAD
gY0AMIGJAoGBAL7lzAuBktAjhaVuPR0S2kwnO/xt1fp9D2GdLpxu2NcqUsuyEC00k3VHEijg
FzcNt7+QviV1y5nqP3nmCqk+eNp20Z3qrYZKGh0YTho/qPESyjFZ4P2NmV7W+SewXZ0IEtxD
/DaOMQo8kww1ho5yzaxVgSRItwefSBEMmFYdqrxpAgMBAAGjgcIwgb8wHQYDVR0OBBYEFNBq
BwZMDvExebpgW4m8MCWtsegvMB8GA1UdIwQYMBaAFPhWGtmaeJVttIiEVTUvqgbz1yBaMDUG
A1UdHwQuMCwwKqAooCaGJGh0dHA6Ly93d3cuY2VzbmV0LmN6L3BraS9jcmwvY2NhLmNybDAO
BgNVHQ8BAf8EBAMCBPAwGwYDVR0RBBQwEoEQa3ViaW5Ab3BmLnNsdS5jejAZBgNVHSAEEjAQ
MA4GDCsGAQQBvnkBAgIBATANBgkqhkiG9w0BAQQFAAOCAQEAuI/sMxZZa78h5+Mzo3IhgSxr
VMl5Hbm2YgLWLHAxQG1NxG0W9bkggMmRWrW8Xotr8VPA4IySqBiVwOlVMdZ5GNcUiSCrrFU6
zfxAXD6dAJuEHGfbVz/dQntptJ9Dz/URteoMleNZjn2gPaLELEax2gaF+2cvbpW521CFJrxx
Mc2LdScRDBCFapWOGNbxqSflLqbT8TsrbmS1V6zUicXf2eUurKA36/psbtFdG03vVaD3+V+R
MgHr6X5k1NUfDfSIpmX7irFEn7tMrxq630NTJUrEm1w4ivK/+f+6+F0ozeaamYS/Gm7LUFSg
A15ZDtGCKySWQp2VB+gwUKfc+8R+WjGCAicwggIjAgEBMDgwMjELMAkGA1UEBhMCQ1oxDzAN
BgNVBAoTBkNFU05FVDESMBAGA1UEAxMJQ0VTTkVUIENBAgIA5jAJBgUrDgMCGgUAoIIBRTAY
BgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0wNDA5MTQxNDA3NDNa
MCMGCSqGSIb3DQEJBDEWBBRVAD4G73cbJIcd1NEVbfZ5jfUkuTBHBgkrBgEEAYI3EAQxOjA4
MDIxCzAJBgNVBAYTAkNaMQ8wDQYDVQQKEwZDRVNORVQxEjAQBgNVBAMTCUNFU05FVCBDQQIC
AOYwSQYLKoZIhvcNAQkQAgsxOqA4MDIxCzAJBgNVBAYTAkNaMQ8wDQYDVQQKEwZDRVNORVQx
EjAQBgNVBAMTCUNFU05FVCBDQQICAOYwUgYJKoZIhvcNAQkPMUUwQzAKBggqhkiG9w0DBzAO
BggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgw
DQYJKoZIhvcNAQEBBQAEgYByLIA0z5unrVhJtHLJG0Y3dln3+3LqKCZ0RbPkLSrCFwb7fFFw
h3ShCpwMissbYaVOUqhPzdfmvMEcb8cDmWxWrXa0BMPQJdQh6Eyj5uxNMdnDoOrnelwTwL4i
b+kQMVKeZrxM0c8qY67QveGDgpWxp0oBwGOq63rzqLdeYAoVMAAAAAAAAA==
--------------ms030700030709030705010906--
