From: Mogens Kjaer <mk@crc.dk>
Subject: multiple [01] requests for sector xxx and crash
Date: Sat, 13 Mar 2004 12:07:41 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4052EB7D.9070207@crc.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I hope someone can help.

I've had _two_ machines crashing (freezing) within a month.

Both run redhat 9 with latest patches.

One or two days before the crash, I see the following starting
to occur in the /var/log/messages:

Feb  2 08:24:46 mail kernel: raid5: multiple 0 requests for sector 9306120
Feb  2 08:24:50 mail kernel: raid5: multiple 1 requests for sector 9306120
Feb  2 10:24:51 mail kernel: raid5: multiple 0 requests for sector 260046944
Feb  2 10:24:51 mail kernel: raid5: multiple 1 requests for sector 260046944
Feb  2 10:39:53 mail kernel: raid5: multiple 1 requests for sector 260046944
Feb  2 12:35:15 mail kernel: raid5: multiple 0 requests for sector 61997112
Feb  2 13:26:08 mail kernel: raid5: multiple 0 requests for sector 9306120
Feb  2 13:26:08 mail kernel: raid5: multiple 1 requests for sector 9306120
Feb  2 13:56:37 mail kernel: raid5: multiple 0 requests for sector 255460304
Feb  2 13:56:38 mail kernel: raid5: multiple 1 requests for sector 255460304
Feb  2 15:04:55 mail kernel: raid5: multiple 0 requests for sector 260046944
Feb  2 15:04:55 mail kernel: raid5: multiple 1 requests for sector 260046944
Feb  2 15:10:28 mail kernel: raid5: multiple 1 requests for sector 61997120
Feb  2 16:24:03 mail kernel: raid5: multiple 1 requests for sector 57147392
Feb  2 19:19:57 mail kernel: raid5: multiple 0 requests for sector 260046944
Feb  2 19:19:58 mail kernel: raid5: multiple 1 requests for sector 260046944
Feb  2 20:07:54 mail kernel: raid5: multiple 0 requests for sector 100663320
Feb  2 20:37:04 mail kernel: raid5: multiple 0 requests for sector 94896128
Feb  2 20:37:04 mail kernel: raid5: multiple 1 requests for sector 94896128

so thats why I suspect the software raid code.

This machine has 3 146G disks in raid1/5, and
one spare disk.

/proc/mdstat:

Personalities : [raid1] [raid5]
read_ahead 1024 sectors
md0 : active raid1 sdd1[2] sdb1[1] sda1[0]
       208704 blocks [2/2] [UU]

md1 : active raid1 sdd2[2] sdb2[1] sda2[0]
       3148672 blocks [2/2] [UU]

md2 : active raid5 sdd3[3] sdc3[2] sdb3[1] sda3[0]
       280028800 blocks level 5, 64k chunk, algorithm 0 [3/3] [UUU]

md0 is /boot, md1 is swap, and md2 is /

/etc/raidtab has:

raiddev             /dev/md2
raid-level                  5
nr-raid-disks               3
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              1
     device          /dev/sda3
     raid-disk     0
     device          /dev/sdb3
     raid-disk     1
     device          /dev/sdc3
     raid-disk     2
     device          /dev/sdd3
     spare-disk     0
raiddev             /dev/md0
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              1
     device          /dev/sda1
     raid-disk     0
     device          /dev/sdb1
     raid-disk     1
     device          /dev/sdd1
     spare-disk     0
raiddev             /dev/md1
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              1
     device          /dev/sda2
     raid-disk     0
     device          /dev/sdb2
     raid-disk     1
     device          /dev/sdd2
     spare-disk     0

This machine has 1.5G RAM.

The disks are connected to the built-in adaptec
scsi controller, /proc/scsi/scsi lists:
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: COMPAQ   Model: BD14686225       Rev: HPB6
   Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 01 Lun: 00
   Vendor: COMPAQ   Model: BD14686225       Rev: HPB6
   Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 02 Lun: 00
   Vendor: COMPAQ   Model: BD14686225       Rev: HPB6
   Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 03 Lun: 00
   Vendor: COMPAQ   Model: BD14686225       Rev: HPB6
   Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 15 Lun: 00
   Vendor: COMPAQ   Model: PROLIANT 4L6I    Rev: 1.86
   Type:   Processor                        ANSI SCSI revision: 02


The other machine has 4.5G RAM, 8 146G disks (no spare),
set up with two partitions per disk, one
small and one big. The eight big partitions are
raid5 for /, two of the small partitions are raid 1
for /boot, and the 6 small partitions are raid 5
for swap.

Both machines are HP/Compaq Proliant ML370,
two cpu's, running RH9 kernel:

Linux version 2.4.20-30.9smp (bhcompile@porky.devel.redhat.com) (gcc 
version 3.2.2 20030222 (Red Hat Linux 3.2.2-5)) #1 SMP Wed Feb 4 
20:36:46 EST 2004

The big machine runs the bigmem smp kernel.

Can anyone please come with some suggestions?

Both are production machines (the small is the mail server
in the DMZ, the large one is Samba server for all our
Windows users), so it doesn't leave much room for
playing with the setup :-(

Machine no. one didn't have anything on the console
when it was frozen (except for the "multiple requests.." stuff),
and the only thing I could do
was to switch it off and on again.

Machine no. two did an automatic reboot 20 minutes after
the crash because of some watchdog (ASR) in the BIOS,
so I couldn't see anything on the console.

Mogens
-- 
Mogens Kjaer, Carlsberg A/S, Computer Department
Gamle Carlsberg Vej 10, DK-2500 Valby, Denmark
Phone: +45 33 27 53 25, Fax: +45 33 27 47 08
Email: mk@crc.dk Homepage: http://www.crc.dk

