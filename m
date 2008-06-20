From: Jon Buckingham <jbuckingham@blueyonder.co.uk>
Subject: Re: mdadm: making a spare actie
Date: Fri, 20 Jun 2008 23:18:16 +0100
Message-ID: <485C2CA8.7050506@blueyonder.co.uk>
References: <485A259B.9040106@blueyonder.co.uk>	<18522.18111.182249.694308@notabene.brown>	<485ADC8D.2010708@blueyonder.co.uk> <18522.64213.285243.770425@notabene.brown>
Reply-To: jbuckingham@blueyonder.co.uk
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms000104090902020608020005"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18522.64213.285243.770425@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Jon Buckingham <jon.buckingham@hp.com>
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms000104090902020608020005
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Neil
> 
> What would be interesting to see is the --examine output and the dmesg
> just as the recovery after the add has completed.  i.e. just before
> the reboot.
> 
> The dmesg you have included is after the reboot.  It confirms that
> sdb5 is non-refresh, presumably the event count is behind for some
> reason (as can be seen from the --examine output you send in the first
> email).  However it doesn't contain any hint as to why.
> 
> NeilBrown
> 
> 

OK, after the resync completed, the disk is marked as faulty.
Also, there are bundles of errors reported by dmesg,
and the other partition on the drive which was ok is
unreadable.
So your earlier thought that there were IO errors was correct.

I will now try some system rebuilding!

FYI, the various outputs are appended.

Thanks for your help

Jon B


nas:~ # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sda5[0] sdb5[4](F) sdd5[3] sdc5[2]
       733142016 blocks level 5, 64k chunk, algorithm 2 [4/3] [U_UU]

unused devices: <none>

nas:~ # mdadm -E /dev/sda5
/dev/sda5:
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

     Update Time : Fri Jun 20 13:05:54 2008
           State : clean
  Active Devices : 3
Working Devices : 3
  Failed Devices : 1
   Spare Devices : 0
        Checksum : f11d55f5 - correct
          Events : 0.3796224

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     0       8        5        0      active sync   /dev/sda5

    0     0       8        5        0      active sync   /dev/sda5
    1     1       0        0        1      faulty removed
    2     2       8       37        2      active sync   /dev/sdc5
    3     3       8       53        3      active sync   /dev/sdd5

mdadm -E /dev/sdb5
mdadm: No md superblock detected on /dev/sdb5.


ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata4.00: BMDMA stat 0x24
ata4.00: cmd 35/00:30:9a:e7:63/00:02:1b:00:00/e0 tag 0 cdb 0x0 data 286720 out
          res 61/04:01:e3:e8:63/04:00:1b:00:00/e0 Emask 0x1 (device error)
ata4.00: failed to set xfermode (err_mask=0x1)
ata4: failed to recover some devices, retrying in 5 secs
Marking TSC unstable due to: cpufreq changes.
Time: acpi_pm clocksource has been installed.
Clocksource tsc unstable (delta = -163018120 ns)
ata4: soft resetting link
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: failed to set xfermode (err_mask=0x1)
ata4: limiting SATA link speed to 1.5 Gbps
ata4.00: limiting speed to UDMA/133:PIO3
ata4: failed to recover some devices, retrying in 5 secs
ata4: hard resetting link
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata4.00: failed to set xfermode (err_mask=0x1)
ata4.00: disabled
ata4: EH complete
sd 3:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdb, sector 459532186
raid5: Disk failure on sdb5, disabling device. Operation continuing on 3 devices
sd 3:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdb, sector 459532746
sd 3:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdb, sector 459533570
sd 3:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdb, sector 883198
Buffer I/O error on device sdb2, logical block 98351
lost page write due to I/O error on sdb2
sd 3:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdb, sector 1049150
Buffer I/O error on device sdb2, logical block 119095
lost page write due to I/O error on sdb2
Aborting journal on device sdb2.
journal commit I/O error
ext3_abort called.
EXT3-fs error (device sdb2): ext3_journal_start_sb: Detected aborted journal
Remounting filesystem read-only
sd 3:0:0:0: [sdb] READ CAPACITY failed
sd 3:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
sd 3:0:0:0: [sdb] Sense not available.
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 00 00 00
sd 3:0:0:0: [sdb] Asking for cache data failed
sd 3:0:0:0: [sdb] Assuming drive cache: write through
md: md0: recovery done.
RAID5 conf printout:
  --- rd:4 wd:3
  disk 0, o:1, dev:sda5
  disk 1, o:0, dev:sdb5
  disk 2, o:1, dev:sdc5
  disk 3, o:1, dev:sdd5
RAID5 conf printout:
  --- rd:4 wd:3
  disk 0, o:1, dev:sda5
  disk 2, o:1, dev:sdc5
  disk 3, o:1, dev:sdd5
Buffer I/O error on device sdb2, logical block 98350
lost page write due to I/O error on sdb2
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:17:31:4c:c2:28:00:09:5b:25:14:ee:08:00 SRC=212.13.194.96 DST=192.168.1.11 LEN=76 TOS=0x00 PREC=0x00 TTL=53 ID=0 DF PROTO=UDP SPT=123 DPT=123 LEN=56
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:17:31:4c:c2:28:00:09:5b:25:14:ee:08:00 SRC=212.13.194.96 DST=192.168.1.11 LEN=76 TOS=0x00 PREC=0x00 TTL=53 ID=0 DF PROTO=UDP SPT=123 DPT=123 LEN=56
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:17:31:4c:c2:28:00:09:5b:25:14:ee:08:00 SRC=212.13.194.96 DST=192.168.1.11 LEN=76 TOS=0x00 PREC=0x00 TTL=53 ID=0 DF PROTO=UDP SPT=123 DPT=123 LEN=56
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:17:31:4c:c2:28:00:09:5b:25:14:ee:08:00 SRC=212.13.194.96 DST=192.168.1.11 LEN=76 TOS=0x00 PREC=0x00 TTL=53 ID=0 DF PROTO=UDP SPT=123 DPT=123 LEN=56
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=00:17:31:4c:c2:28:00:09:5b:25:14:ee:08:00 SRC=212.13.194.96 DST=192.168.1.11 LEN=76 TOS=0x00 PREC=0x00 TTL=53 ID=0 DF PROTO=UDP SPT=123 DPT=123 LEN=56
SFW2-INext-ACC-TCP IN=eth0 OUT= MAC=00:17:31:4c:c2:28:00:40:ca:3b:a6:05:08:00 SRC=192.168.1.12 DST=192.168.1.11 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=11827 DF PROTO=TCP SPT=27999 DPT=22 WINDOW=5840 RES=0x00 SYN URGP=0 OPT (020405B40402080A004B8D400000000001030306)
Buffer I/O error on device sdb5, logical block 488761344
Buffer I/O error on device sdb5, logical block 488761345
Buffer I/O error on device sdb5, logical block 488761346
Buffer I/O error on device sdb5, logical block 488761347
Buffer I/O error on device sdb5, logical block 488761348
Buffer I/O error on device sdb5, logical block 488761349
Buffer I/O error on device sdb5, logical block 488761350
Buffer I/O error on device sdb5, logical block 488761351
Buffer I/O error on device sdb5, logical block 488761344
Buffer I/O error on device sdb5, logical block 488761345
nas:~ # ll /var
ls: cannot access /var/adm: Input/output error
ls: cannot access /var/X11R6: Input/output error
total 52
d?????????  ? ?     ?         ?                ? adm
drwxr-xr-x  8 root  root   4096 2007-11-21 23:42 cache
drwxrwxr-x  3 games games  4096 2007-10-28 23:23 games
drwxr-xr-x 20 root  root   4096 2007-11-01 23:09 lib
drwxrwxr-t  5 root  uucp   4096 2008-06-20 10:03 lock
drwxr-xr-x  8 root  root   4096 2008-06-20 10:02 log
drwx------  2 root  root  16384 2007-10-28 23:09 lost+found
lrwxrwxrwx  1 root  root     10 2007-10-28 23:09 mail -> spool/mail
drwxr-xr-x  2 root  root   4096 2007-09-21 23:04 opt
drwxr-xr-x 10 root  root   4096 2008-06-20 10:03 run
drwxr-xr-x  9 root  root   4096 2007-11-01 23:09 spool
drwxrwxrwt  4 root  root   4096 2008-06-20 00:03 tmp
d?????????  ? ?     ?         ?                ? X11R6
nas:~ #

--------------ms000104090902020608020005
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
MDgwNjIwMjIxODE2WjAjBgkqhkiG9w0BCQQxFgQUf7WzyLJl+MPIoGwjrVTjX9UQrn0wUgYJ
KoZIhvcNAQkPMUUwQzAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgYUGCSsGAQQBgjcQBDF4MHYwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhA/tp1SdARusHi2hoSW40yu
MIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBD
b25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFp
bCBJc3N1aW5nIENBAhA/tp1SdARusHi2hoSW40yuMA0GCSqGSIb3DQEBAQUABIIBACEx4SDN
m4qU0pYV8JjkzcIJBLjJGKgE9p1OfMkaNAvCyNIqtr5yB5kdA/eDoVMXwxts0lwaZ6wIMvfJ
2xNRA+C4Bv3SW/LUxvcwzQjCqz/idYyCNbNqVLd9n0XZXpFSO+ckGVS/0f+NCAFQcYAEaWSl
CnHsqBwE+4i2oa/fW/FnBD6o1K9fcjnM4j5hBG6+T3Uv6JToPsXOSjjvBP16ugb8HZoIF8aE
Pm6cSIFJAyDsMqB5jn8h9rsIyKLugn55q1AzSZsCb463huuErKrhzA0eCU1PpNV6Y7cSF6NR
dKpsrKlfYhf8YHJAxKKkdRr4b3mNG1zEECYy79xkLrhH9UUAAAAAAAA=
--------------ms000104090902020608020005--

