From: "Ian Brown" <ianbrn@gmail.com>
Subject: Stopping and starting a RAID1 :Invalid argument
Date: Sun, 8 Oct 2006 12:05:02 +0200
Message-ID: <d0383f90610080305x4d06d307yfc497f39761f073c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I am trying to understand and practice RAID1 functionality: for that
purpose I created two partitions on the same device (yes,
I know that it is recommended that the partitions are
better to be on differrent devices when using RAID1, but this
is for testing purposes only ).
My device is a 64 K USB Disk On Key. (on /dev/sdb)

Than I ran:
dd if=/dev/zero of=/dev/sdb bs=1M count=64

then I created 2 primary partitions for RAID1 with fdisk:
/dev/sdb1 and /dev/sdb2.

fdisk -l /dev/sdb shows :

Disk /dev/sdb: 65 MB, 65470464 bytes
3 heads, 42 sectors/track, 1014 cylinders
Units = cylinders of 126 * 512 = 64512 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1         256       16107   fd  Linux raid autodetect
/dev/sdb2             257         513       16191   fd  Linux raid autodetect

Both Partitions are of type  Linux raid autodetect ("fd").
The partitions are equal in size (256 cylinders each)
Then I created a RAID1 by running:

mdadm --create /dev/md0 --level=raid1 --raid-devices=2 /dev/sdb1 /dev/sdb2

I got : mdadm: array /dev/md0 started

cat /proc/mdstat shows:

Personalities : [raid1]
md0 : active raid1 sdb2[1] sdb1[0]
      16000 blocks [2/2] [UU]
      [==>..................]  resync = 12.5% (2112/16000)
finish=0.7min speed=301K/sec
unused devices: <none>

I created ext3 fs on /dev/md0 and /dev/sdb1 and /dev/sdb2.

I found out that I can mount /dev/md0 , but I cannot
mount /dev/sdb1 or /dev/sdb2.

when I try : mount /dev/sdb1 /mnt/sdb1/
I get mount: /dev/sdb1 already mounted or /mnt/sdb1/ busy


I found out that if I stop the RAID (and unmount /dev/md0),
I am able to mount /dev/sdb1 and /dev/sdb2. I also found
out that a file I created (on the path where /mnt/md0
was mounted) was mirrored to /dev/sdb1 and /dev/sdb2, as it should
in RAID1.

The problem is that I cannot run again the RAID
after stopping it.

I stopped it by:
mdadm --stop /dev/md0
cat /proc/mdstat
Personalities : [raid1]
unused devices: <none>

I tried to run it again by:
mdadm --run /dev/md0
mdadm: failed to run array /dev/md0: Invalid argument

Why is it so ?

what is the way to stop and than run again a RAID ?
Am I doing something wrong ? any idea?

Regards,

Ian
