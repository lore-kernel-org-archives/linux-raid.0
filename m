From: Milo <search.lists@gmail.com>
Subject: raid5 in degraded mode; trying to revive
Date: Tue, 6 Dec 2005 00:15:57 -0800
Message-ID: <dc164f000512060015v2e211817gefb9005fd9b26f08@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, I have been trying to figure out how to fix my raid system,
SUSE 9.3, linux 2.6.11.4-21.9-default. A hard reset put my raid in
unstable state, almost same errors as
http://sumo.genetics.ucla.edu/pipermail/nelsonlab-dev/2004-August/000150.html
except, sda1 seems to be the problem.
md: kicking non-fresh sda1 from array!

I did
mdadm -A -f /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1
and then /proc/mdstat shows the 2 disk raid active, but I could not
mount it, mounting /dev/md0 hangs.  Later I tried
mdadm --assemble /dev/md0 --force /dev/sda1 /dev/sdb1 /dev/sdc1
same thing.

If the raid is ok in degraded (missing 1 drive) mode, shouldn't I be
able to mount it?

Also, another strange effect before I had the guts to run any real
commands was that I could only run one mdadm command; all commands
after the first would hang. Because of this I could not reboot, I have
been doing soft resets and booting a livecd ever since this problem
occured.

The next potential step after mdadm -A -f is mdadm -a /dev/md0
/dev/sda1. Since I really don't know what I'm doing, I thought I'd
ask for help and I kind of value this personal data, I don't really
want to risk losing it. I'm considering paying to get some help in
debugging this remotely ... also I'm kicking myself now for not
monitoring the raid.

Here is my /etc/raidtab :

raiddev /dev/md0
   raid-level 5
   nr-raid-disks 3
   nr-spare-disks 0
   persistent-superblock 1
   parity-algorithm left-symmetric
   chunk-size 128
   device /dev/sda1
   raid-disk 0
   device /dev/sdb1
   raid-disk 1
   device /dev/sdc1
   raid-disk 2

Thanks for any advice!!

--
Milan Andric
