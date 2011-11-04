From: Alex <mysqlstudent@gmail.com>
Subject: Impending failure?
Date: Fri, 4 Nov 2011 09:53:54 -0400
Message-ID: <CAB1R3sh8=9imi41OTXRjf2ScoB=9WLZLHqL-WECOSyDuixVzrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I have a fedora15 system with two 80GB SATA disks using RAID1 and have
the following messages in syslog:

Nov  4 07:43:11 mail smartd[2001]: Device: /dev/sda [SAT], 2 Offline
uncorrectable sectors
Nov  4 08:13:11 mail smartd[2001]: Device: /dev/sda [SAT], 2 Currently
unreadable (pending) sectors

"smartctl --all /dev/sda" does show that errors did occur at some
point in the past, but it doesn't seem to be affecting the RAID:

# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 sda2[0] sdb2[1]
      74750908 blocks super 1.1 [2/2] [UU]
      bitmap: 1/1 pages [4KB], 65536KB chunk

md0 : active raid1 sda1[0] sdb1[1]
      511988 blocks super 1.0 [2/2] [UU]

unused devices: <none>

Perhaps the bad sectors haven't been accessed, which is why the RAID
still appears to be intact?

Do I need to verify the RAID integrity in some way? Force a rebuild?

I believe the boot sector is installed on sda, which is also the bad
disk. If I remove the disk to replace it, I'm concerned the system
will no longer boot.

Can you point me to instructions on the best way to replace a disk?

Thanks,
Alex
