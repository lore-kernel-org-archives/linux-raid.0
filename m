From: "Fairbanks, David" <David.Fairbanks@stratus.com>
Subject: Linux Software RAID /sysfs repair issue
Date: Tue, 13 May 2008 15:42:14 -0400
Message-ID: <EEEB1FA7BB798343BD171137F3E7FA53069EF4@EXNA.corp.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: mingo@redhat.com, neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
Cc: "Fairbanks, David" <David.Fairbanks@stratus.com>
List-Id: linux-raid.ids

Hello Linux SW RAID maintainers;

I am a software engineer at Stratus Technologies in Maynard, MA.
I am running into an issue using the /sysfs "repair" functionality.
kernel version: 2.6.18-87.el5 (RHEL5, update 2)

I have a 2 member RAID level 1 set consisting of 2 SAS drives on an
Adaptec aic94xx HBA. I built the raid set using the following command:

mdadm -C /dev/md7 -size=5000000 -b internal -n2 -l1 /dev/sdb /dev/sde

I inject a medium error onto one of the disks using sg_write_long:

sg_write_long -lba=2000 -xfer_len=580 /dev/sdb

I then execute:

echo repair > /sys/block/md7/md/sync_action

I have done some testing and I have found that if the lba is on a 4K
byte aligned boundary (e.g. -lba=2000), the repair succeeds as expected.
However, if the lba is "not" on a 4K byte aligned boundary (e.g.
-lba=2001), the medium error is detected, but the disk gets removed from
the raid set. The medium error is not repaired. The following messages
appear in /var/log/messages:

May 12 13:46:24 leeloo kernel: md: syncing RAID array md7
May 12 13:46:24 leeloo kernel: md: minimum _guaranteed_ reconstruction
speed: 1000 KB/sec/disc.
May 12 13:46:24 leeloo kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for reconstruction.
May 12 13:46:24 leeloo kernel: md: using 128k window, over a total of
5000000 blocks.
May 12 13:46:33 leeloo kernel: sd 0:0:1:0: SCSI error: return code =
x08000002
May 12 13:46:33 leeloo kernel: sdh: Current: sense key: Medium Error
May 12 13:46:33 leeloo kernel:     Add. Sense: Unrecovered read error
May 12 13:46:33 leeloo kernel:
May 12 13:46:33 leeloo kernel: Info fld=0x7d1
May 12 13:46:33 leeloo kernel: end_request: I/O error, dev sdh, sector
2001
May 12 13:46:39 leeloo kernel: sd 0:0:1:0: SCSI error: return code =
0x00050000
May 12 13:46:39 leeloo kernel: end_request: I/O error, dev sdh, sector
1920
May 12 13:46:39 leeloo kernel: raid1: Disk failure on sdh, disabling
device.
May 12 13:46:39 leeloo kernel:  Operation continuing on 1 devices
May 12 13:46:39 leeloo kernel: md: md7: sync done

I originally thought this was a low level driver issue. However, this is
also reproducible on parallel scsi and Fibre Channel configurations. I
have also tried this on the latest kernel with the same results. I can
provide any other info necessary.

Because this appears to be a 4K byte alignment (cache block size) issue,
I am not sure if this is an issue in the block layer (?).

Thanks;

Dave

