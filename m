From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: freezing RAID 1+0 with single disk failure
Date: Sat, 16 Oct 2004 15:13:08 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410161913.i9GJDDN03151@www.watkins-home.com>
References: <20041016054606.27308.qmail@s1.pbasehk.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041016054606.27308.qmail@s1.pbasehk.com>
To: dchiu@hkasatkd.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have never setup a RAID1+0, but what you have done is what I would have
done.  A single disk failure on each RAID1 should not cause the RAID0 to
fail.  My guess... a bug.  :(

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of dchiu@hkasatkd.org
Sent: Saturday, October 16, 2004 1:46 AM
To: linux-raid@vger.kernel.org
Subject: freezing RAID 1+0 with single disk failure

Hello,

A few days ago my server experienced a single disk failure in a 8 disks RAID
1+0 configuration. Kernel is 2.6.8.1 w/smp, it's a P4 HT machine with 2GB
RAM,
filesystem is ext3. 

When the disk failure happens, my webserver stop serving pages, "top" show
that
load average is around 300, iowait is ~100%, I can still telnet into my box
but
I can't umount the mounted RAID10 volumn, I can't kill the running apache, I
can't even shutdown the machine successfully. Finally, I have to switch of
the
power to shut it off.

I found the following at my /var/log/messages:
============================================================================
===
Oct 14 23:20:34 s1 kernel: scsi5: ERROR on channel 0, id 0, lun 0, CDB: 0x28
00
08 87 4b a1 00 00 70 00 
Oct 14 23:20:34 s1 kernel: Current sdf: sense = 70  3
Oct 14 23:20:34 s1 kernel: ASC=11 ASCQ= 4
Oct 14 23:20:34 s1 kernel: Raw sense data:0x70 0x00 0x03 0x00 0x00 0x00 0x00
0x06 0x00 0x00 0x00 0x00 0x11 0x04 
Oct 14 23:20:34 s1 kernel: end_request: I/O error, dev sdf, sector 143084449
Oct 14 23:20:39 s1 kernel: scsi5: ERROR on channel 0, id 0, lun 0, CDB: 0x28
00
08 87 4b a2 00 00 6f 00 
Oct 14 23:20:39 s1 kernel: Current sdf: sense = 70  3
Oct 14 23:20:39 s1 kernel: ASC=11 ASCQ= 4
Oct 14 23:20:39 s1 kernel: Raw sense data:0x70 0x00 0x03 0x00 0x00 0x00 0x00
0x06 0x00 0x00 0x00 0x00 0x11 0x04 
Oct 14 23:20:39 s1 kernel: end_request: I/O error, dev sdf, sector 143084450
Oct 14 23:20:43 s1 kernel: scsi5: ERROR on channel 0, id 0, lun 0, CDB: 0x28
00
08 87 4b a3 00 00 6e 00 
Oct 14 23:20:43 s1 kernel: Current sdf: sense = 70  3
Oct 14 23:20:43 s1 kernel: ASC=11 ASCQ= 4
Oct 14 23:20:43 s1 kernel: Raw sense data:0x70 0x00 0x03 0x00 0x00 0x00 0x00
0x06 0x00 0x00 0x00 0x00 0x11 0x04 

.......

Oct 14 23:23:14 s1 kernel: end_request: I/O error, dev sdf, sector 143084484
Oct 14 23:23:19 s1 kernel: scsi5: ERROR on channel 0, id 0, lun 0, CDB: 0x28
00
08 87 4b c5 00 00 4c 00 
Oct 14 23:23:19 s1 kernel: Current sdf: sense = 70  3
Oct 14 23:23:19 s1 kernel: ASC=11 ASCQ= 4
Oct 14 23:23:19 s1 kernel: Raw sense data:0x70 0x00 0x03 0x00 0x00 0x00 0x00
0x06 0x00 0x00 0x00 0x00 0x11 0x04 
Oct 14 23:23:19 s1 kernel: end_request: I/O error, dev sdf, sector 143084485
Oct 14 23:23:19 s1 kernel: raid1: Disk failure on sdf1, disabling device. 
Oct 14 23:23:19 s1 kernel: ^IOperation continuing on 1 devices
Oct 14 23:23:19 s1 kernel: raid1: sdf1: rescheduling sector 138570184
Oct 14 23:23:19 s1 kernel: raid1: sde1: redirecting sector 138570184 to
another
mirror
Oct 14 23:23:19 s1 kernel: ata5(0): WARNING: zero len r/w req
Oct 14 23:23:19 s1 kernel: raid1: sde1: rescheduling sector 138570184
Oct 14 23:23:19 s1 kernel: raid1: sde1: redirecting sector 138570184 to
another
mirror
============================================================================
===

then I can't do anything on the freezing RAID1+0 volumn. Shouldn't the
kernel
kick the bad disk off and keep the RAID running?

My raidtab is as follow:

raiddev             /dev/md1
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/hda2
    raid-disk     0
    device          /dev/hdc2
    raid-disk     1
raiddev             /dev/md0
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/hda1
    raid-disk     0
    device          /dev/hdc1
    raid-disk     1

raiddev             /dev/md2
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/sda1
    raid-disk     0
    device          /dev/sdb1
    raid-disk     1

raiddev             /dev/md3
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/sdc1
    raid-disk     0
    device          /dev/sdd1
    raid-disk     1

raiddev             /dev/md4
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/sde1
    raid-disk     0
    device          /dev/sdf1
    raid-disk     1

raiddev             /dev/md5
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/hda4
    raid-disk     0
    device          /dev/hdc4
    raid-disk     1

raiddev             /dev/md6
raid-level                  0
nr-raid-disks               4
chunk-size                  512k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/md5
    raid-disk     0
    device          /dev/md2
    raid-disk     1
    device          /dev/md3
    raid-disk     2
    device          /dev/md4
    raid-disk     3

more /proc/mdstat (after replaced with the demaged disk and finished
resync):

Personalities : [raid0] [raid1]
md6 : active raid0 md4[3] md3[2] md2[1] md5[0]
      967753728 blocks 512k chunks

md1 : active raid1 hdc2[0] hda2[1]
      2048192 blocks [2/2] [UU]

md5 : active raid1 hdc4[1] hda4[0]
      241938816 blocks [2/2] [UU]

md2 : active raid1 sdb1[1] sda1[0]
      241938816 blocks [2/2] [UU]

md3 : active raid1 sdd1[1] sdc1[0]
      241938816 blocks [2/2] [UU]

md4 : active raid1 sdf1[1] sde1[0]
      241938816 blocks [2/2] [UU]

md0 : active raid1 hdc1[0] hda1[1]
      104320 blocks [2/2] [UU]

Thanks for reading.


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

