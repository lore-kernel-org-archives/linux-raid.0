From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm raid1 read performance
Date: Thu, 5 May 2011 09:45:38 +1000
Message-ID: <20110505094538.0cef02cc@notabene.brown>
References: <BANLkTim8Ehn0fANtibg7X1cMVvOgt7CNMA@mail.gmail.com>
	<20110504105822.21e23bc3@notabene.brown>
	<BANLkTimzqu1C+_Z2t5m1bjduXFeRwbgssQ@mail.gmail.com>
	<4DC0F2B6.9050708@fnarfbargle.com>
	<BANLkTinbFZf=kV=3eUe2S6XNAOst_McX4w@mail.gmail.com>
	<BANLkTikQTKPuY+Mg8h9ZOkJPoEQ-jGTeLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikQTKPuY+Mg8h9ZOkJPoEQ-jGTeLg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Liam Kurmos <quantum.leaf@gmail.com>
Cc: Roberto Spadim <roberto@spadim.com.br>, Brad Campbell <lists2009@fnarfbargle.com>, Drew <drew.kay@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 5 May 2011 00:08:59 +0100 Liam Kurmos <quantum.leaf@gmail.com> wrote:

> Thanks to all who replied on this.
> 
> I somewhat naively assumed that having 2 disks with the same data
> would mean a similar read speed to raid0 should be the norm (and i
> think this is a very popular miss-conception).
> I was neglecting the seek time to skip alternate blocks which i guess
> must the flaw.
> 
> In theory though if i was reading a larger file, couldn't one disk
> start reading at the beginning to a buffer and one start reading from
> half way ( assuming 2 disks) and hence get close to 2x single d

isk
> speed?

If you write your program to read from both the beginning and the middle
then you might get double-speed.  The kernel doesn't know you are going to do
this so the best it can do is read-ahead is large amounts.

raid1 could notice large reads and send some to one disk and some to another,
but the size for each device must be large enough that the time to seek over
must be much less than the time to read, which is probably many megabytes on
todays hardware - and raid1 has no way to know what that size is.

Certainly it is possible that the read_balance code in md/raid1 could be
improved.  As yet no-one has improved it and provided convincing performance
numbers.

> 
> as a separate question, what should be the theoretical performance of raid5?

x(N-1)

So a 4 drive RAID5 should read at 3 time the speed of a single drive.

> 
> in my tests i read 1GB and throw away the data.
> dd if=/dev/md0 of=/dev/null bs=1M count=1000
> 
> With 4 fairly fast hdd's i get

Which apparently do 140MB/s:

> 
> raid0: ~540MB/s

I would expect 4*140 == 560, so this is a good result.

> raid10: 220MB/s

Assuming the default 'n2' layout, I would expect 2*140 or 280, so this is a
little slow.  Try "--layout=f2" and see what you get (should be more like
RAID0).

> raid5: ~165MB/s

I would expect 3*140 or 420, so this is very slow.  I wonder if read-ahead is
set badly.
Can you:
   blockdev --getra /dev/md0
multiply the number it gives you by 8 and give it back with
   blockdev --setra NUMBER /dev/md0


> raid1: ~140MB/s  (single disk speed)

as expected.

> 
> for 4 disks raid0 seems like suicide, but for my system drive the
> speed advantage is so great im tempted to try it anyway and try and
> use rsync to keep constant back up.

If you have somewhere to rsync to, then you have more disks so RAID10 might
be an answer... but I suspect you cannot move disks around that freely :-)

NeilBrown



> 
> cheers for you responses,
> 
> Liam
