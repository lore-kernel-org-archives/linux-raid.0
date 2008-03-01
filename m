From: Michael Guntsche <mike@it-loops.com>
Subject: Strange RAID-5 rebuild problem
Date: Sat, 1 Mar 2008 22:09:46 +0100
Message-ID: <656D8E57-804D-4A63-B9CA-D3C899616F61@it-loops.com>
Mime-Version: 1.0 (Apple Message framework v753)
Content-Type: multipart/signed; micalg=sha1; boundary=Apple-Mail-2-612803222; protocol="application/pkcs7-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Apple-Mail-2-612803222
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed

Hello list,

The first version of this mail got send to linux-kernel by mistake,  
now sending it to the correct list.
--------------------------------------------------------------------

Ok, after going through benchmarking for the last few days, I now  
started acutally deploying the system.

I created a RAID-5 with a 1.0 superblock and let the RAID resync.
I had to reboot the computer for another update and did not think  
about thw rebuilding process since it should continue just fine after  
a restart. After a reboot I noticed that the RAID was in the  
following state.

/dev/md1:
         Version : 01.00.03
   Creation Time : Sat Mar  1 21:42:18 2008
      Raid Level : raid5
      Array Size : 1464982272 (1397.12 GiB 1500.14 GB)
   Used Dev Size : 976654848 (465.71 GiB 500.05 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 1
     Persistence : Superblock is persistent

     Update Time : Sat Mar  1 21:50:19 2008
           State : clean, degraded
  Active Devices : 3
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 256K

            Name : gibson:1  (local to host gibson)
            UUID : 80b0698e:d7c76d22:e231f03e:d25feba2
          Events : 32

     Number   Major   Minor   RaidDevice State
        0       8        2        0      active sync   /dev/sda2
        1       8       18        1      active sync   /dev/sdb2
        2       8       34        2      active sync   /dev/sdc2
        4       8       50        3      spare rebuilding   /dev/sdd2

mdadm -E /dev/sdd2:

/dev/sdd2:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x2
      Array UUID : 80b0698e:d7c76d22:e231f03e:d25feba2
            Name : gibson:1  (local to host gibson)
   Creation Time : Sat Mar  1 21:42:18 2008
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 976655336 (465.71 GiB 500.05 GB)
      Array Size : 2929964544 (1397.12 GiB 1500.14 GB)
   Used Dev Size : 976654848 (465.71 GiB 500.05 GB)
    Super Offset : 976655592 sectors
Recovery Offset : 973312 sectors
           State : clean
     Device UUID : 5d6d28dd:c1d4d59d:3617c511:267c47f6

     Update Time : Sat Mar  1 21:55:44 2008
        Checksum : a1ca2174 - correct
          Events : 52

          Layout : left-symmetric
      Chunk Size : 256K

     Array Slot : 4 (0, 1, 2, failed, 3)
    Array State : uuuU 1 failed




/proc/mdstat showed now progress bar though. Ok, since he seems stuck  
I thought, why not just mark sdd2 as failed.
I was able to mark it as failed but looking at the detail again I saw  
"spare rebuilding" and I could not remove it.
Next I tried a fail/remove which also did not work. I stopped the  
array started it again, and THEN it removed the disk.
I tried this several times, the same result every time.

Just for kicks I created the RAID with a 0.90 superblock and tried  
the same thing. Lo and behold after stopping the array and starting  
it again the progress bar showed up and everything started rebuilding  
where it stopped earlier.

Is this "normal" or is this a superblock 1.0 related problem?

Current kernel is 2.6.24.2, mdadm is v2.6.4 from debian unstable.

I do not need the RAID right now so I could run some tests on it if  
someone wants me too.

Kind regards,
Michael
--Apple-Mail-2-612803222
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
AW8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDgwMzAxMjEwOTQ2
WjAjBgkqhkiG9w0BCQQxFgQUGXqTF2DZXOeDATXAUnSLxn3iEKMwgYUGCSsGAQQBgjcQBDF4MHYw
YjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAq
BgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhAXeGafW9tpYlIyv1f3
vGU1MIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBD
b25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJ
c3N1aW5nIENBAhAXeGafW9tpYlIyv1f3vGU1MA0GCSqGSIb3DQEBAQUABIIBAFs72EZJw2tZj23O
POwZw2o+xlB/Khf5s3Xdb+zL67hI9JmsBrTkbTbhYRPQd/F/u3kXPtu44spMV31mlaQouzN3XBXb
BrhpuRwG+R8SnvpKwSWtWn8ny9GkYsaAZmqj9ZE04w0K6Pxhvd+rhgh3WWKz0l7Qh0IlD6Zk543Y
bYVPQG17RcMsEQpFXWCMhufCeYpR6ntU9c4ZA71JQjizBiF6acEnDMw3QKrbgWWOvgukAcAvR9WE
zkdsHdWgEYJE5oMarJjBjBmjz0+IlOkV7xTRtCG1J1pEhjRuD4ClHuYSjv91xsT4gnMdnWxkCtut
H9cDFIQScf9SMSjVuTDNVLwAAAAAAAA=

--Apple-Mail-2-612803222--
