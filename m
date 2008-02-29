From: Michael Guntsche <mike@it-loops.com>
Subject: Severe slowdown with LVM on RAID, alignment problem?
Date: Fri, 29 Feb 2008 01:05:55 +0100
Message-ID: <6774F74A-902B-4F37-8816-26D6293AF060@it-loops.com>
Mime-Version: 1.0 (Apple Message framework v753)
Content-Type: multipart/signed; micalg=sha1; boundary=Apple-Mail-1-450572866; protocol="application/pkcs7-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Apple-Mail-1-450572866
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed

Hello list,

I know the subject about lvm on raid and the very popular alignment  
question have been beaten to death by now.
But whatever I try I cannot seem to work it out, so please bear with  
me and my lengthy description.

Currently I am testing a SATA RAID-5 for deployment in my little home  
server. I am interested in space mostly but still do not want to give  
up all the speed.
So for testing purposes I created a 10GB partition on every disk and  
created a RAID-5 across them.

mdadm --detail /dev/md0
/dev/md0:
         Version : 01.00.03
   Creation Time : Thu Feb 28 18:56:07 2008
      Raid Level : raid5
      Array Size : 29326080 (27.97 GiB 30.03 GB)
   Used Dev Size : 19550720 (9.32 GiB 10.01 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Fri Feb 29 00:40:44 2008
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 256K

            Name : gibson:0  (local to host gibson)
            UUID : 46cb01e4:ea969e20:535d91a1:234004ed
          Events : 8

     Number   Major   Minor   RaidDevice State
        0       8       33        0      active sync   /dev/sdc1
        1       8       49        1      active sync   /dev/sdd1
        2       8       65        2      active sync   /dev/sde1
        4       8       81        3      active sync   /dev/sdf1

I set the Cunk Size to 256K as you can see and also used Superblock  
1.0, apart from that I changed nothing. I let the RAID resync and  
then I started testing.

First one was a simple XFS FS sans LVM. I called mkfs.xfs without any  
parameters and got the following.

  mkfs.xfs /dev/md0
meta-data=/dev/md0               isize=256    agcount=16,  
agsize=458240 blks
          =                       sectsz=4096  attr=2
data     =                       bsize=4096   blocks=7331520, imaxpct=25
          =                       sunit=64     swidth=192 blks
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=3579, version=2
          =                       sectsz=4096  sunit=1 blks, lazy- 
count=1
realtime =none                   extsz=786432 blocks=0, rtextents=0

Running a quick bonnie benchmark on this one, I got the following  
results.

Version  1.03c      ------Sequential Output------ --Sequential Input-  
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- -- 
Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec % 
CP  /sec %CP
xfs              1G           31359  20 24135  19           79587  29  
154.8   1

Well this is not the fastest machine, so I did not think much about  
the results, in my opinion the look ok, but please correct me if I am  
totally wrong.

Next I created VG-LV on the raid, formatted it with XFS and ran bonny  
again.

!! No special switches where used for vgcreate or lvcreate !!


Version  1.03c      ------Sequential Output------ --Sequential Input-  
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- -- 
Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec % 
CP  /sec %CP
xfs              1G           31359  20 24135  19           79587  29  
154.8   1
lvm-nal          1G           28917  21 15344  19           33645  26  
136.3   1

We lost a little bit on writing, but what happened to reading? I lost  
more than half of the performance here.

So I had a look at mkfs.xfs again and saw that sunit and swidth where  
0. Looking at the values I got the first time I called mkfs.xfs on  
the /dev/md0 device I came up with

mkfs.xfs -dsunit=512,swidth=1536 /dev/mapper/lamo-gabo -f
meta-data=/dev/mapper/lamo-gabo  isize=256    agcount=4,  
agsize=655360 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=2621440, imaxpct=25
          =                       sunit=64     swidth=192 blks
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=2560, version=2
          =                       sectsz=512   sunit=64 blks, lazy- 
count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Result:

Version  1.03c      ------Sequential Output------ --Sequential Input-  
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- -- 
Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec % 
CP  /sec %CP
xfs              1G           31359  20 24135  19           79587  29  
154.8   1
lvm-nal          1G           28917  21 15344  19           33645  26  
136.3   1
xfsopt-lvm-nal   1G           29503  22 15369  19           36604  30  
135.0   1

Ok, some improvement but still not really satisfying.

Reading through the archives I also found hints to improve  
performance by aligning the VG to the stripe/chunk size. Although  
only talking about writing I tried that.

I came up with.... The LVM header is 64K my chunksize 256, so  
256-64=192. I called pvcreate --metadatasize 192k and recreated the  
VG-LV combo, formatted it again with plain mkfs.xfs (no sunit or  
swidth) and ran bonnie again.

Version  1.03c      ------Sequential Output------ --Sequential Input-  
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- -- 
Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec % 
CP  /sec %CP
xfs              1G           31359  20 24135  19           79587  29  
154.8   1
lvm-nal          1G           28917  21 15344  19           33645  26  
136.3   1
xfsopt-lvm-nal   1G           29503  22 15369  19           36604  30  
135.0   1
lvm-al           1G           29561  21 15857  20           35242  28  
130.6   1

A little bit better but not really that much.

Finally I reformatted it with the sunit, and swidth values from above.

Version  1.03c      ------Sequential Output------ --Sequential Input-  
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- -- 
Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec % 
CP  /sec %CP
xfs              1G           31359  20 24135  19           79587  29  
154.8   1
lvm-nal          1G           28917  21 15344  19           33645  26  
136.3   1
xfsopt-lvm-nal   1G           29503  22 15369  19           36604  30  
135.0   1
lvm-al           1G           29561  21 15857  20           35242  28  
130.6   1
xfsopt-lvm-al    1G           30948  22 15404  19           33715  26  
118.4   1

Nope still not doing great here.

Ok, this is where I am at now.
Do I really loose that much reading speed just by using lvm on RAID?  
I would have understood some decrease in writing speed but why is  
reading affected that much?

Once again, sorry for the long E-Mail, but this is really bugging me  
right now.

Kind regards,
Michael 
  
--Apple-Mail-1-450572866
Content-Transfer-Encoding: base64
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Disposition: attachment;
	filename=smime.p7s

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGIzCCAtww
ggJFoAMCAQICEBd4Zp9b22liUjK/V/e8ZTUwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA3MTAzMTE2MDMwMVoXDTA4MTAzMDE2MDMw
MVowQzEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEgMB4GCSqGSIb3DQEJARYRbWlr
ZUBpdC1sb29wcy5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC/D9ePLG2ZNk/Z
NXTRfUq7Rs+3k5M/nqmZ8riQYRnt8sCTj6o/fPS4qjaDf9jRfgbxViROiShFWMoBNJkKg91doJFk
FYdive8ujFfKpPR6FVGu8rN/sHUZM/gowZUcqDyIMAJVr7iiWhQYxP3U4hmprJsmUaGkjBU37Bcw
vJnEZ4gDCgYiZLiHUACDDfsl2xl5r6XvtXV9TsjWA3eQSeju68nQFP0PjFU+UtYfr3z1nFMJpuzE
xStjCEZ+EkYBOHK+RmBaOLEfF2Rq8175oaX5ScotY61s7wjADYesS//bvdcZ11jf/R+UCE90p8iC
Y1TjqqRv+zMc+VpyfG1dt9ELAgMBAAGjLjAsMBwGA1UdEQQVMBOBEW1pa2VAaXQtbG9vcHMuY29t
MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQEFBQADgYEAgVh3S3v4j1ydxqgc/DWXcO5RRnyfLTjU
bJwYwTdaQVuykeXrT+2ITDIpOpVEqZ7xV/N9aKMM/izyQ8oMvw/J13TUm1N77kNCp5jYy1S+Ntuz
bCdOdFVA5tFVn/nMfmK1Is6NjK+0GmryYPEpn8vaP9ZGy57wCpKZrwmytgm3oPQwggM/MIICqKAD
AgECAgENMA0GCSqGSIb3DQEBBQUAMIHRMQswCQYDVQQGEwJaQTEVMBMGA1UECBMMV2VzdGVybiBD
YXBlMRIwEAYDVQQHEwlDYXBlIFRvd24xGjAYBgNVBAoTEVRoYXd0ZSBDb25zdWx0aW5nMSgwJgYD
VQQLEx9DZXJ0aWZpY2F0aW9uIFNlcnZpY2VzIERpdmlzaW9uMSQwIgYDVQQDExtUaGF3dGUgUGVy
c29uYWwgRnJlZW1haWwgQ0ExKzApBgkqhkiG9w0BCQEWHHBlcnNvbmFsLWZyZWVtYWlsQHRoYXd0
ZS5jb20wHhcNMDMwNzE3MDAwMDAwWhcNMTMwNzE2MjM1OTU5WjBiMQswCQYDVQQGEwJaQTElMCMG
A1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNv
bmFsIEZyZWVtYWlsIElzc3VpbmcgQ0EwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMSmPFVz
VftOucqZWh5owHUEcJ3f6f+jHuy9zfVb8hp2vX8MOmHyv1HOAdTlUAow1wJjWiyJFXCO3cnwK4Va
qj9xVsuvPAsH5/EfkTYkKhPPK9Xzgnc9A74r/rsYPge/QIACZNenprufZdHFKlSFD0gEf6e20Txh
BEAeZBlyYLf7AgMBAAGjgZQwgZEwEgYDVR0TAQH/BAgwBgEB/wIBADBDBgNVHR8EPDA6MDigNqA0
hjJodHRwOi8vY3JsLnRoYXd0ZS5jb20vVGhhd3RlUGVyc29uYWxGcmVlbWFpbENBLmNybDALBgNV
HQ8EBAMCAQYwKQYDVR0RBCIwIKQeMBwxGjAYBgNVBAMTEVByaXZhdGVMYWJlbDItMTM4MA0GCSqG
SIb3DQEBBQUAA4GBAEiM0VCD6gsuzA2jZqxnD3+vrL7CF6FDlpSdf0whuPg2H6otnzYvwPQcUCCT
cDz9reFhYsPZOhl+hLGZGwDFGguCdJ4lUJRix9sncVcljd2pnDmOjCBPZV+V2vf3h9bGCE6u9uo0
5RAaWzVNd+NWIXiC3CEZNd4ksdMdRv9dX2VPMYIDEDCCAwwCAQEwdjBiMQswCQYDVQQGEwJaQTEl
MCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBl
cnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECEBd4Zp9b22liUjK/V/e8ZTUwCQYFKw4DAhoFAKCC
AW8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDgwMjI5MDAwNTU2
WjAjBgkqhkiG9w0BCQQxFgQU8WIMMEIXZwriHAIT3sPD3NKdjd4wgYUGCSsGAQQBgjcQBDF4MHYw
YjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAq
BgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhAXeGafW9tpYlIyv1f3
vGU1MIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBD
b25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJ
c3N1aW5nIENBAhAXeGafW9tpYlIyv1f3vGU1MA0GCSqGSIb3DQEBAQUABIIBACq2TDUF3/ANYPwu
srOFmpOjCY5bPs88JLx+hBy/Rd10pI+Pj4R9gCvkQ7yfzcu1QliIcNw8pZBrsqAcLPNMXU6iqI1N
/i5+Tsr/B5ag6f8O/aCLm9mhrTKlfmGeKWUfYxFYXXe3Aainq9L9y29RxuTargKIwJf3HJYytZBM
Z0oO+SgHHShNiYDQMgcTdfZoq2aeVMRIoyNkBWQHWE30mr5CrXeEWdSOxIH26Fto4Frp1eYfb/l1
0e+uwtvT0myOPEW2+rMog2Vakc5mEeQ9KyZXpa7jTxaYyJfW3k/Eiylm0RCubwzI6LVoNj8A2jsK
5G6fkd1qHTJZC0pzc0ob4OcAAAAAAAA=

--Apple-Mail-1-450572866--
