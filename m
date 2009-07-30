From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: question about bitmaps and dirty percentile
Date: Thu, 30 Jul 2009 13:25:01 -0500
Message-ID: <cccedfc60907301125i2187907od5819e464de2d25a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a 3-disk raid1 configured with bitmaps.

Most of the time it only has 1 disk (disk A)
Periodically (weekly or less frequenly) I re-add a second disk (disk
B), which then re-synchronizes, and when it's done I --fail and
--remove it.
Even less frequently (monthly or less frequently) I do the same thing
with a third disk (disk C).

Before adding the disks, I will issue an --examine.
When I added disk B today, it said this:

Events : 14580
Bitmap : 283645 bits (chunks), 11781 dirty (4.2%)

I'm curious why *any* of the bitmap chunks are dirty - when the disks
are removed the device has typically been quiescent for quite some
time. Is there a way to force a "flush" or whatever to get each disk
as up-to-date as possible, prior to a --fail and --remove?


While /dev/nbd0 was syncing, I also --re-add'ed /dev/sdf1, which (as
expected) waited until /dev/nbd0 was done.
Then, due to a logic bug in a script, /dev/sdf1 was removed (the
script was waiting with mdadm --wait /dev/md12 which returned when
/dev/nbd0 was done, even though /dev/sdf1 had not yet started!!).

Then things got weird.

I saw this, which just *can't* be right:

md12 : active raid1 nbd0[2](W) sde[0]
      72612988 blocks super 1.1 [3/1] [U__]
      [======================================>]  recovery =192.7%
(69979200/36306494) finish=13228593199978.6min speed=11620K/sec
      bitmap: 139/139 pages [556KB], 256KB chunk

and of course the percentile kept growing, and the finish minutes are crazy.

I had to --fail and --remove /dev/nbd0, and re-add it, which
unfortunately started the recovery over.

I haven't even gotten to my questions about dirty percentages and so
on, which I will save for later.

In summary:

3-disk raid1, using bitmaps, with 2 missing disks.
re-add disk B. recovery begins.
re-add disk C. recovery continues on to disk B, will wait for disk C.
recovery completes on disk B, mdadm --wait returns (unexpectedly)
--fail, --remove disk C (which was never recovered on-to)
/proc/mdstat crazy, disk I/O still high (WTF is it *doing*, then?)
--fail --remove disk B, --re-add disk B, recovery starts over.



-- 
Jon
