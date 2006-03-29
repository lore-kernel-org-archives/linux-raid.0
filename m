From: "JaniD++" <djani22@dynamicweb.hu>
Subject: (X)FS corruption on 2 SATA disk RAID 1
Date: Wed, 29 Mar 2006 12:09:55 +0200
Message-ID: <001301c65318$ee4249c0$1600a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Hello, list,

I think, this is generally hardware error, but looks like software problem
too.
At this point there is no dirty data in memory!

Cheers,
Janos

[root@dy-xeon-1 /]# cmp -b /dev/sda1 /dev/sdb1
/dev/sda1 /dev/sdb1 differ: byte 68881481729, line 308395510 is 301 M-A  74
<
[root@dy-xeon-1 /]# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [faulty]
md10 : active raid1 sdb1[1] sda1[0]
      136729088 blocks [2/2] [UU]
      bitmap: 0/131 pages [0KB], 512KB chunk

unused devices: <none>

[root@dy-xeon-1 /]# mount
192.168.0.1://NFS/ROOT-BASE/ on / type nfs
(rw,hard,rsize=8192,wsize=8192,timeo=
5,retrans=0,actimeo=1)
none on /proc type proc (rw,noexec,nosuid,nodev)
none on /dev/pts type devpts (rw,gid=5,mode=620)
none on /dev/shm type tmpfs (rw)
none on /sys type sysfs (rw)
/dev/ram0 on /mnt/fast type ext2 (rw)
none on /dev/cpuset type cpuset (rw)
/dev/md10 on /mnt/1 type xfs (ro)
[root@dy-xeon-1 /]#

cut from log:

Mar 29 08:14:45 dy-xeon-1 kernel: scsi1 : ata_piix
Mar 29 08:14:45 dy-xeon-1 kernel:   Vendor: ATA       Model: WDC
WD2000JD-19H  Rev: 08.0
Mar 29 08:14:45 dy-xeon-1 kernel:   Type:   Direct-Access
ANSI SCSI revision: 05
Mar 29 08:14:45 dy-xeon-1 kernel:   Vendor: ATA       Model: WDC
WD2000JD-19H  Rev: 08.0
Mar 29 08:14:45 dy-xeon-1 kernel:   Type:   Direct-Access
ANSI SCSI revision: 05
Mar 29 08:14:45 dy-xeon-1 kernel: SCSI device sda: 390721968 512-byte hdwr
sectors (200050 MB)
Mar 29 08:14:45 dy-xeon-1 kernel: SCSI device sda: drive cache: write back
Mar 29 08:14:45 dy-xeon-1 kernel: SCSI device sda: 390721968 512-byte hdwr
sectors (200050 MB)
Mar 29 08:14:45 dy-xeon-1 kernel: SCSI device sda: drive cache: write back
Mar 29 08:14:45 dy-xeon-1 kernel:  sda: sda1 sda2
Mar 29 08:14:45 dy-xeon-1 kernel: sd 0:0:0:0: Attached scsi disk sda
Mar 29 08:14:45 dy-xeon-1 kernel: SCSI device sdb: 390721968 512-byte hdwr
sectors (200050 MB)
Mar 29 08:14:45 dy-xeon-1 kernel: SCSI device sdb: drive cache: write back
Mar 29 08:14:45 dy-xeon-1 kernel: SCSI device sdb: 390721968 512-byte hdwr
sectors (200050 MB)
Mar 29 08:14:45 dy-xeon-1 kernel: SCSI device sdb: drive cache: write back
Mar 29 08:14:45 dy-xeon-1 kernel:  sdb: sdb1 sdb2
Mar 29 08:14:45 dy-xeon-1 kernel: sd 1:0:0:0: Attached scsi disk sdb
Mar 29 08:14:45 dy-xeon-1 kernel: sd 0:0:0:0: Attached scsi generic sg0 type
0
Mar 29 08:14:45 dy-xeon-1 kernel: sd 1:0:0:0: Attached scsi generic sg1 type
0

Smart logs:
sda:
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED
WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000b   200   200   051    Pre-fail
s       -       0
  3 Spin_Up_Time            0x0007   130   124   021    Pre-fail
s       -       6025
  4 Start_Stop_Count        0x0032   100   100   040    Old_age
ys       -       97
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
s       -       0
  7 Seek_Error_Rate         0x000b   200   200   051    Pre-fail
s       -       0
  9 Power_On_Hours          0x0032   089   089   000    Old_age
ys       -       8047
 10 Spin_Retry_Count        0x0013   100   253   051    Pre-fail
s       -       0
 11 Calibration_Retry_Count 0x0013   100   253   051    Pre-fail
s       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
ys       -       97
194 Temperature_Celsius     0x0022   120   111   000    Old_age
ys       -       30
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
ys       -       0
197 Current_Pending_Sector  0x0012   200   200   000    Old_age
ys       -       0
198 Offline_Uncorrectable   0x0012   200   200   000    Old_age
ys       -       0
199 UDMA_CRC_Error_Count    0x000a   200   253   000    Old_age
ys       -       0
200 Multi_Zone_Error_Rate   0x0009   200   200   051    Pre-fail  Offline
-       0

SMART Error Log Version: 1
No Errors Logged

sdb:
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED
WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000b   200   200   051    Pre-fail
s       -       0
  3 Spin_Up_Time            0x0007   127   120   021    Pre-fail
s       -       6175
  4 Start_Stop_Count        0x0032   100   100   040    Old_age
ys       -       94
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
s       -       0
  7 Seek_Error_Rate         0x000b   200   200   051    Pre-fail
s       -       0
  9 Power_On_Hours          0x0032   089   089   000    Old_age
ys       -       8065
 10 Spin_Retry_Count        0x0013   100   253   051    Pre-fail
s       -       0
 11 Calibration_Retry_Count 0x0013   100   253   051    Pre-fail
s       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
ys       -       94
194 Temperature_Celsius     0x0022   117   109   000    Old_age
ys       -       33
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
ys       -       0
197 Current_Pending_Sector  0x0012   200   200   000    Old_age
ys       -       0
198 Offline_Uncorrectable   0x0012   200   200   000    Old_age
ys       -       0
199 UDMA_CRC_Error_Count    0x000a   200   253   000    Old_age
ys       -       1
200 Multi_Zone_Error_Rate   0x0009   200   200   051    Pre-fail
ine      -       0

SMART Error Log Version: 1
No Errors Logged

