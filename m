From: "Carl-=?ISO-8859-1?Q?Johan_W=E4gner?=" <carl-johan.wagner@agusta.se>
Subject: Re: RAID 5 with bad blocks
Date: Sat, 25 Sep 2010 20:47:07 +0200
Message-ID: <20100925000351.M29572@agusta.se>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: fafler@gmail.com
List-Id: linux-raid.ids

Similar to Lasse's RAID 5 array, I have 3 1TB drives. And the same problem as
Lasse with an array stopped working for one reason and can't recover for
another reason. And what about badblocks?

After an upgrade to Ubuntu 10.04 I had at first NO (visible) raid array at
all. After a short investigation it turned out that /dev/sdd was
"busy"-something, which I now have figured out must have been an attempt to
recover.

Unfortunately I hadn't understood all sides of running a RAID when I started
to act on the problem, so I may accidentally have destroyed my chances to
recover this in the end, but lets see...

mdadm /dev/md0 --detail (as well as with --examine) shows
0 ... active sync /dev/sdb1
1 ... active sync /dev/sdc1
2 ... faulty removed (shows only with --examine)
3 ... spare /dev/sdd1

I can't tell when /dev/sdd1 went from number 2 to 3. It's never been outside
the computer. So I began to consider the /dev/sdd1 as actually faulty. And as
so, I started to think of ways to recover. First, a complete backup, and after
that I also tried

mdadm -a /dev/md0 /dev/sdd1

and as a result the number 3 disk started to rebuild.

Here comes the interesting part; after 35% the recovering halted/exited due to
sector fault on /dev/sdb1 and consequently disabling /dev/sdb1. This leaves
the RAID5 with only one disk and very unhappy to recover the 3rd /dev/sdd1.

Now, here is the strange(?) thing. Checking the array while having it run with
only two disks (sdb1 and sdc1) I could (and still can) access all files
without any (as seen so far) errors. I haven't written anything to the disk,
except for that the timestamps may have changed. (so I took the chance and
have now made a complete backup)

My guess is that the stored information (so far 12% of disk capacity) has been
away from the bad sectors and therefor also contains correct info.

When recovering the sdd1 and coming up to the faulty sectors (for what ever
reason it wants to access those at recover) it can no longer hold the array as
clean and therefor stops with "Disk failure on sdb1, disabling the device."

This leads to a problem. I have 3 disks, where one (the first event) (disk
sdd1) fell out of sync (reason unknown). And therefor needs to (at least
claims to need) rebuild of sdd1. But it can't, since sdb1 is faulty. Even
though no data is placed on the bad sectors.

So, I have two disks that together holds enough information to rebuild the
third, but do not complete the task due to errors on sectors not in use...

...
hm...

Would it be possible to copy (with 'dd') the device (/dev/sdb) with sector
errors to a fourth disk (/dev/sde) and then remove the faulty sdb-drive and
reposition the newly copied sde to sdb's position to have this act as the
first sdb-drive, now working without any physical faults, even if the data is
incomplete in sectors; and now being possible to recover the third drive
(/dev/sdd1)?

Lasse:
> ... How do i proceed from here? On which device should i run badblocks?
Is this at all possible on a md-device? Isn't this what Neil is working on?
Or is it by any chance any meaning to run badblocks on an empty drive just to
catch bad sectors? Would mdadm by any chance use them when creation is done?

/Carl Wagner

