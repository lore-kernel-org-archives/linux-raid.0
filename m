From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: MD bug or me being stupid?
Date: Fri, 22 Apr 2005 12:45:55 +0200
Message-ID: <62b0912f0504220345349335f9@mail.gmail.com>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just upgraded a MD RAID 5 box to 2.6.11 from 2.4.something.

Found out one disk was failing completely, got a replacement from Maxtor.  Neat.
Replaced disk, rebooted..
Added the new disk to the array with 'raidhotadd'.
MD started syncing.

A couple of minutes into the process, it started *seriously* spamming
the console with messages:

==========================
Apr 22 01:47:00 linux kernel: ..<6>md: syncing RAID array md1
Apr 22 01:47:00 linux kernel: md: minimum _guaranteed_ reconstruction
speed: 1000 KB/sec/disc.
Apr 22 01:47:00 linux kernel: md: using maximum available idle IO bandwith (but
not more than 200000 KB/sec) for reconstruction.
Apr 22 01:47:00 linux kernel: md: using 128k window, over a total of
199141632 blocks.
Apr 22 01:47:00 linux kernel: md: md1: sync done.
Apr 22 01:47:00 linux kernel: ..<6>md: syncing RAID array md1
Apr 22 01:47:01 linux kernel: md: minimum _guaranteed_ reconstruction
speed: 1000 KB/sec/disc.
Apr 22 01:47:01 linux kernel: md: using maximum available idle IO bandwith (but
not more than 200000 KB/sec) for reconstruction.
Apr 22 01:47:01 linux kernel: md: using 128k window, over a total of
199141632 blocks.
Apr 22 01:47:01 linux kernel: md: md1: sync done.
==========================

Thought it had probably gone haywire and decided to start trashing my
data, so pulled the plug and rebooted.  When examining the log
afterwards, I can see that the above messages repeat themselves.
cat /var/log/messages | grep md | grep 'Apr 22 01:47:01' | grep 'sync done'
tells me that the messages were repeated 12 times per second.  The
/var/log/messages file grew to 600kB before I pulled the plug.

Noticed something strange during next boot: Linux failed to recognize
one of the disks.  Booted into Maxtor PowerMax and it said various
weird things (seemed different each time) about the disk too.  So
decided to switch ATA cables on this disk, which made wonders - both
PowerMax and Linux talks to the disk fine now.

Now, when I boot the machine, the 6 disks in the array have these
event counters, according to mdadm:

sda1:  0.19704  (completely new, "blank" disk)
sdb1:  0.19704
sdc1:  0.144      (but why?)
sdd1:  0.19704
sde1:  0.19704  (this disk had the bad cable)
sdf1:  0.19704

My questions now are (and yes, I know I had faulty hardware, but
that's incidentally also the reason I use MD at all):

1. What's with the infinitely repeated md1: sync done messages?

2. Wouldn't the mentioned event counters cause MD to think that the
totally blank disk /dev/sda1 has valid data, and that the disk with
valid data (/dev/sdc1) does not next time it syncs?

3. How do I proceed from here, if I want to rescue my data?


Best regards, many thanks for MD and all that :-).
