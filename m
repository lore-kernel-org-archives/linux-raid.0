From: =?ISO-8859-1?Q?Jaime_Pe=F1alba?= <jpenalba@corenetworks.es>
Subject: Re: Multipath problems with 2.6.8.1
Date: Thu, 09 Sep 2004 18:05:35 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41407F4F.3060703@corenetworks.es>
References: <S265098AbUIIOeH/20040909143407Z+1912@vger.kernel.org> <41407793.3060105@corenetworks.es>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms010500080606010007000800"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41407793.3060105@corenetworks.es>
To: linux-raid@vger.kernel.org
Cc: neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms010500080606010007000800
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Here is some different behavior,
superblock is writed for both paths, and the superblock for the second 
path persists on both.

1) create md
apache2:~# mdadm --create /dev/md0 -v --force --level multipath 
--raid-devices=1 /dev/sdb1 --spare-devices=1 /dev/sdd1
mdadm: array /dev/md0 started.

md: bind<sdb1>
md: bind<sdd1>
multipath: array md0 active with 1 out of 1 IO paths
MULTIPATH conf printout:
 --- wd:1 rd:1
 disk0, o:1, dev:sdb1
MULTIPATH conf printout:
 --- wd:1 rd:1
 disk0, o:1, dev:sdb1


apache2:~# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Thu Sep  9 17:57:32 2004
     Raid Level : multipath
     Array Size : 10485632 (10.00 GiB 10.74 GB)
   Raid Devices : 1
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Sep  9 17:57:32 2004
          State : clean
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1


    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       49       -1      spare   /dev/sdd1
           UUID : 2a8d2bd1:54255df5:5b4b62b5:136a6e34
         Events : 0.42

----------------------------------

apache2:~# cat /proc/mdstat
Personalities : [multipath]
md0 : active multipath sdd1[1] sdb1[0]
      10485632 blocks [1/1] [U]
     
unused devices: <none>

----------------------------------

apache2:~# mdadm -E /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 2a8d2bd1:54255df5:5b4b62b5:136a6e34
  Creation Time : Thu Sep  9 17:57:32 2004
     Raid Level : multipath
    Device Size : 10485632 (10.00 GiB 10.74 GB)
   Raid Devices : 1
  Total Devices : 2
Preferred Minor : 0

    Update Time : Thu Sep  9 17:57:32 2004
          State : dirty
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 19b4a54c - correct
         Events : 0.42


      Number   Major   Minor   RaidDevice State
this     1       8       49        1      spare   /dev/sdd1
   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       49        1      spare   /dev/sdd1

----------------------------------

apache2:~# mdadm -E /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 2a8d2bd1:54255df5:5b4b62b5:136a6e34
  Creation Time : Thu Sep  9 17:57:32 2004
     Raid Level : multipath
    Device Size : 10485632 (10.00 GiB 10.74 GB)
   Raid Devices : 1
  Total Devices : 2
Preferred Minor : 0

    Update Time : Thu Sep  9 17:57:32 2004
          State : dirty
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 19b4a54c - correct
         Events : 0.42


      Number   Major   Minor   RaidDevice State
this     1       8       49        1      spare   /dev/sdd1
   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       49        1      spare   /dev/sdd1



2) stop md
mdadm -S /dev/md0


3) start md again
apache2:~# mdadm --assemble /dev/md0 
--uuid=2a8d2bd1:54255df5:5b4b62b5:136a6e34 /dev/sdb1 /dev/sdd1
mdadm: failed to add /dev/sdb1 to /dev/md0: Device or resource busy
mdadm: /dev/md0 has been started with 1 drive.

---------------

md: bind<sdd1>
md: export_rdev(sdb1)
multipath: array md0 active with 1 out of 1 IO paths

---------------

apache2:~# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Thu Sep  9 17:57:32 2004
     Raid Level : multipath
     Array Size : 10485632 (10.00 GiB 10.74 GB)
   Raid Devices : 1
  Total Devices : 1
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Sep  9 18:00:28 2004
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/sdd1
           UUID : 2a8d2bd1:54255df5:5b4b62b5:136a6e34
         Events : 0.43


Jaime.


Jaime Peñalba wrote:

> Hi,
>
> Im having some troubles with multipath on a 2.6.8.1 linux kernel.
>
> Im using 2 QLogic 2344 connected to the SAN, i think that my problem 
> is related to superblocks, because when i create a new multipath 
> device, it writes the superblock for both disks and really is the same 
> disk trought two paths. I have else tried to disable persistent 
> superblock, but mdadm doesnt support multipath with the build mode.
>
> Im doing it like this
>
> 1) Start the md
> apache1:~/soft/mdadm-1.7.0# mdadm --create /dev/md0 --force --level 
> multipath --raid-devices=1 /dev/sdb1 --spare-devices=1 /dev/sdd1
> mdadm: array /dev/md0 started.
>
> apache1:~/soft/mdadm-1.7.0# cat /proc/mdstat
> Personalities : [multipath]
> md0 : active multipath sdd1[1] sdb1[0]
>      4882304 blocks [1/1] [U]
>     unused devices: <none>
>
> This is ok and runs fine, But superblock is only at /dev/sdd1, so no 
> remount would be possible, or i think so...
>
> apache1:~/soft/mdadm-1.7.0# mdadm -E /dev/sdb1
> mdadm: No super block found on /dev/sdb1 (Expected magic a92b4efc, got 
> 00000000)
>
> apache1:~/soft/mdadm-1.7.0# mdadm -E /dev/sdd1
> /dev/sdd1:
>          Magic : a92b4efc
>        Version : 00.90.00
>           UUID : af3395fd:fac2b820:2ca7083c:612864e0
>  Creation Time : Thu Sep  9 17:20:43 2004
>     Raid Level : multipath
>    Device Size : 4882304 (4.66 GiB 5.00 GB)
>   Raid Devices : 1
>  Total Devices : 2
> Preferred Minor : 0
>
>    Update Time : Thu Sep  9 17:20:43 2004
>          State : dirty
> Active Devices : 1
> Working Devices : 2
> Failed Devices : 0
>  Spare Devices : 1
>       Checksum : 63bc7489 - correct
>         Events : 0.36
>
>
>      Number   Major   Minor   RaidDevice State
> this     1       8       49        1      spare   /dev/sdd1
>   0     0       8       17        0      active sync   /dev/sdb1
>   1     1       8       49        1      spare   /dev/sdd1
>
>
>
> 2) Stop the md
> apache1:~/soft/mdadm-1.7.0# mdadm -S /dev/md0
>
>
> 3) Start the md again
> apache1:~/soft/mdadm-1.7.0# mdadm --assemble /dev/md0 
> --uuid=af3395fd:fac2b820:2ca7083c:612864e0 /dev/sdb1 /dev/sdd1
> mdadm: no RAID superblock on /dev/sdb1
> mdadm: /dev/sdb1 has wrong uuid.
> mdadm: /dev/md0 has been started with 1 drive.
>
>
> apache1:~/soft/mdadm-1.7.0# cat /proc/mdstat
> Personalities : [multipath]
> md0 : active multipath sdd1[0]
>      4882304 blocks [1/1] [U]
>     unused devices: <none>
>
> Now things arent working very well....
>
> apache1:~/soft/mdadm-1.7.0# mdadm --detail /dev/md0
> /dev/md0:
>        Version : 00.90.01
>  Creation Time : Thu Sep  9 17:20:43 2004
>     Raid Level : multipath
>     Array Size : 4882304 (4.66 GiB 5.00 GB)
>   Raid Devices : 1
>  Total Devices : 1
> Preferred Minor : 0
>    Persistence : Superblock is persistent
>
>    Update Time : Thu Sep  9 17:26:21 2004
>          State : clean
> Active Devices : 1
> Working Devices : 1
> Failed Devices : 0
>  Spare Devices : 0
>
>
>    Number   Major   Minor   RaidDevice State
>       0       8       49        0      active sync   /dev/sdd1
>           UUID : af3395fd:fac2b820:2ca7083c:612864e0
>         Events : 0.37
>
>
> I would appreciate very much any help with this.
>
> Thanks,
> Jaime.



--------------ms010500080606010007000800
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIILmDCC
BcgwggSwoAMCAQICAQEwDQYJKoZIhvcNAQEFBQAwfDELMAkGA1UEBhMCRVMxFTATBgNVBAoT
DENvcmVuZXR3b3JrczERMA8GA1UECxMIU2VjdXJpdHkxGDAWBgNVBAMTD0NvcmVuZXR3b3Jr
cyBDQTEpMCcGCSqGSIb3DQEJARYaY2EtbWFuYWdlckBjb3JlbmV0d29ya3MuZXMwHhcNMDMx
MDI0MTA1OTA4WhcNMDQxMDIzMTA1OTA4WjBbMQswCQYDVQQGEwJFUzEVMBMGA1UEChMMQ29y
ZW5ldHdvcmtzMREwDwYDVQQLEwhJbnRlcm5ldDEWMBQGA1UEAxMNSmFpbWUgUGVuYWxiYTEK
MAgGA1UEBRMBMTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMRMgduDEd6vUZrV
7Vqn2lZWgeIU4QLu1eRC1ISgnfuOduKtUFwJoxK8KV1TL5lcV1kjBp4AEIqAZpgT4XQqtI0a
IPPk8vrWV8VBin7Kh7q/xRPxkuq6BvGLvcYgEiTqzH/r03U63/EmAtTxxO13NlVpIEF+YZfo
dMmRQ2LriG32oSvIG7luWA9r90QYxrmfJW50I3hzqUIRCO/dG2RCr3Mek1dKZAKIaL4574UB
npMhjykK9Wx45JbAi+nkhoUZOqICATK3s3QLX4rl87aD7BrqmXnBDDtd2rNLxHiL6HM02qDE
pt2VmIhoGZWgaCqIelvwb7Mv/5ueFsOmOhh5aeUCAwEAAaOCAnQwggJwMAkGA1UdEwQCMAAw
EQYJYIZIAYb4QgEBBAQDAgSwMAsGA1UdDwQEAwIF4DApBgNVHSUEIjAgBggrBgEFBQcDAgYI
KwYBBQUHAwQGCisGAQQBgjcUAgIwPgYJYIZIAYb4QgENBDEWL1JlZ2lzdHJhdGlvbiBBdXRo
b3JpdHkgT3BlcmF0b3Igb2YgQ29yZW5ldHdvcmtzMB0GA1UdDgQWBBT3lNJ22whTSizfNoGL
O+vVOLrRrTCBpwYDVR0jBIGfMIGcgBRnCmpg3xGD9jfmLU4VxzzHW5HcGaGBgKR+MHwxCzAJ
BgNVBAYTAkVTMRUwEwYDVQQKEwxDb3JlbmV0d29ya3MxETAPBgNVBAsTCFNlY3VyaXR5MRgw
FgYDVQQDEw9Db3JlbmV0d29ya3MgQ0ExKTAnBgkqhkiG9w0BCQEWGmNhLW1hbmFnZXJAY29y
ZW5ldHdvcmtzLmVzggEAMCMGA1UdEQQcMBqBGGpwZW5hbGJhQGNvcmVuZXR3b3Jrcy5lczAl
BgNVHRIEHjAcgRpjYS1tYW5hZ2VyQGNvcmVuZXR3b3Jrcy5lczA/BglghkgBhvhCAQQEMhYw
aHR0cHM6Ly9zcGFya3kuY29yZW5ldHdvcmtzLmVzL3B1Yi9jcmwvY2FjcmwuY3JsMD8GCWCG
SAGG+EIBAwQyFjBodHRwczovL3NwYXJreS5jb3JlbmV0d29ya3MuZXMvcHViL2NybC9jYWNy
bC5jcmwwQQYDVR0fBDowODA2oDSgMoYwaHR0cHM6Ly9zcGFya3kuY29yZW5ldHdvcmtzLmVz
L3B1Yi9jcmwvY2FjcmwuY3JsMA0GCSqGSIb3DQEBBQUAA4IBAQCAf1jvjA87zFIDnPoKITfF
2HUZGEQV4Dk/NOenLq0YfOjd94hniHNMz8a7zjBoONsX9FsKcsOlOUQFQKYChRRmNKliYENB
QbyHDxW87CYZhhZUFzDLz/Emi2cFZa+E2rZWsU+Fe99ee9Ui9zMdzi7gOBkbQ1CNxO5r35CN
qSlfCW8Zr4lNAs4zqBUWzgn7kPYP/iFzYTPhEB2MPzDYv766tN7PyCWivDMn14eScLc3vJzE
Iax0TsUQbVbAxcgB7r1lkE9sG2UaIn1yDAORCM3aoAO/XHobrtABjw+37OHAJRdARzlXMV68
R6i8XdboKBJltUW5g9VpSvDmp5ySCCF+MIIFyDCCBLCgAwIBAgIBATANBgkqhkiG9w0BAQUF
ADB8MQswCQYDVQQGEwJFUzEVMBMGA1UEChMMQ29yZW5ldHdvcmtzMREwDwYDVQQLEwhTZWN1
cml0eTEYMBYGA1UEAxMPQ29yZW5ldHdvcmtzIENBMSkwJwYJKoZIhvcNAQkBFhpjYS1tYW5h
Z2VyQGNvcmVuZXR3b3Jrcy5lczAeFw0wMzEwMjQxMDU5MDhaFw0wNDEwMjMxMDU5MDhaMFsx
CzAJBgNVBAYTAkVTMRUwEwYDVQQKEwxDb3JlbmV0d29ya3MxETAPBgNVBAsTCEludGVybmV0
MRYwFAYDVQQDEw1KYWltZSBQZW5hbGJhMQowCAYDVQQFEwExMIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEAxEyB24MR3q9RmtXtWqfaVlaB4hThAu7V5ELUhKCd+4524q1QXAmj
ErwpXVMvmVxXWSMGngAQioBmmBPhdCq0jRog8+Ty+tZXxUGKfsqHur/FE/GS6roG8Yu9xiAS
JOrMf+vTdTrf8SYC1PHE7Xc2VWkgQX5hl+h0yZFDYuuIbfahK8gbuW5YD2v3RBjGuZ8lbnQj
eHOpQhEI790bZEKvcx6TV0pkAohovjnvhQGekyGPKQr1bHjklsCL6eSGhRk6ogIBMrezdAtf
iuXztoPsGuqZecEMO13as0vEeIvoczTaoMSm3ZWYiGgZlaBoKoh6W/Bvsy//m54Ww6Y6GHlp
5QIDAQABo4ICdDCCAnAwCQYDVR0TBAIwADARBglghkgBhvhCAQEEBAMCBLAwCwYDVR0PBAQD
AgXgMCkGA1UdJQQiMCAGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAjA+BglghkgB
hvhCAQ0EMRYvUmVnaXN0cmF0aW9uIEF1dGhvcml0eSBPcGVyYXRvciBvZiBDb3JlbmV0d29y
a3MwHQYDVR0OBBYEFPeU0nbbCFNKLN82gYs769U4utGtMIGnBgNVHSMEgZ8wgZyAFGcKamDf
EYP2N+YtThXHPMdbkdwZoYGApH4wfDELMAkGA1UEBhMCRVMxFTATBgNVBAoTDENvcmVuZXR3
b3JrczERMA8GA1UECxMIU2VjdXJpdHkxGDAWBgNVBAMTD0NvcmVuZXR3b3JrcyBDQTEpMCcG
CSqGSIb3DQEJARYaY2EtbWFuYWdlckBjb3JlbmV0d29ya3MuZXOCAQAwIwYDVR0RBBwwGoEY
anBlbmFsYmFAY29yZW5ldHdvcmtzLmVzMCUGA1UdEgQeMByBGmNhLW1hbmFnZXJAY29yZW5l
dHdvcmtzLmVzMD8GCWCGSAGG+EIBBAQyFjBodHRwczovL3NwYXJreS5jb3JlbmV0d29ya3Mu
ZXMvcHViL2NybC9jYWNybC5jcmwwPwYJYIZIAYb4QgEDBDIWMGh0dHBzOi8vc3Bhcmt5LmNv
cmVuZXR3b3Jrcy5lcy9wdWIvY3JsL2NhY3JsLmNybDBBBgNVHR8EOjA4MDagNKAyhjBodHRw
czovL3NwYXJreS5jb3JlbmV0d29ya3MuZXMvcHViL2NybC9jYWNybC5jcmwwDQYJKoZIhvcN
AQEFBQADggEBAIB/WO+MDzvMUgOc+gohN8XYdRkYRBXgOT8056curRh86N33iGeIc0zPxrvO
MGg42xf0Wwpyw6U5RAVApgKFFGY0qWJgQ0FBvIcPFbzsJhmGFlQXMMvP8SaLZwVlr4Tatlax
T4V731571SL3Mx3OLuA4GRtDUI3E7mvfkI2pKV8JbxmviU0CzjOoFRbOCfuQ9g/+IXNhM+EQ
HYw/MNi/vrq03s/IJaK8MyfXh5Jwtze8nMQhrHROxRBtVsDFyAHuvWWQT2wbZRoifXIMA5EI
zdqgA79cehuu0AGPD7fs4cAlF0BHOVcxXrxHqLxd1ugoEmW1RbmD1WlK8OannJIIIX4xggOK
MIIDhgIBATCBgTB8MQswCQYDVQQGEwJFUzEVMBMGA1UEChMMQ29yZW5ldHdvcmtzMREwDwYD
VQQLEwhTZWN1cml0eTEYMBYGA1UEAxMPQ29yZW5ldHdvcmtzIENBMSkwJwYJKoZIhvcNAQkB
FhpjYS1tYW5hZ2VyQGNvcmVuZXR3b3Jrcy5lcwIBATAJBgUrDgMCGgUAoIIB3TAYBgkqhkiG
9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0wNDA5MDkxNjA1MzVaMCMGCSqG
SIb3DQEJBDEWBBQhEo+/wiu2HrP47/AI8pXv7VfC9jBSBgkqhkiG9w0BCQ8xRTBDMAoGCCqG
SIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG
9w0DAgIBKDCBkgYJKwYBBAGCNxAEMYGEMIGBMHwxCzAJBgNVBAYTAkVTMRUwEwYDVQQKEwxD
b3JlbmV0d29ya3MxETAPBgNVBAsTCFNlY3VyaXR5MRgwFgYDVQQDEw9Db3JlbmV0d29ya3Mg
Q0ExKTAnBgkqhkiG9w0BCQEWGmNhLW1hbmFnZXJAY29yZW5ldHdvcmtzLmVzAgEBMIGUBgsq
hkiG9w0BCRACCzGBhKCBgTB8MQswCQYDVQQGEwJFUzEVMBMGA1UEChMMQ29yZW5ldHdvcmtz
MREwDwYDVQQLEwhTZWN1cml0eTEYMBYGA1UEAxMPQ29yZW5ldHdvcmtzIENBMSkwJwYJKoZI
hvcNAQkBFhpjYS1tYW5hZ2VyQGNvcmVuZXR3b3Jrcy5lcwIBATANBgkqhkiG9w0BAQEFAASC
AQCGzpSrKW62apgi07o9DV9YfEVuZLe1VyIXrTWmb1pJjgDUCdf+9zFcA0GgQVqYwk4sIPrr
9DOvFnvZmmBDV1WKL73i0RP6zHlRt48/FxdTE7IEXiYMTCrwTRxm7SEbhQivrOwJTTf+sYWM
8kf5eviGaTl/TrZKHWS0c/wFqr3qc6chNgkjCjb9saB1o7VgRwjSBnbwwpzjXa5Lb2jM2tkm
Lawye10Gbt0yU/Um5Y8UAcXOJ7R06F0dfC98P2WnZm15sWP6EkElDHVW+EyWrildEXdKkgaI
m+LfFbY8X14qcXGj73Se4H9IdgLX32FPZyhVz1gQmr0FDqHqK77BYq4PAAAAAAAA
--------------ms010500080606010007000800--
