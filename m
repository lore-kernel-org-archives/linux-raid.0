From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Don't use whole disks for raid arrays [was: Questions about software
 RAID]
Date: Tue, 19 Apr 2005 16:08:14 +0400
Message-ID: <4264F4AE.4060400@tls.msk.ru>
References: <1113853825.1483.34.camel@debian>	 <426414A5.3020706@dgreaves.com> <1113865936.1483.73.camel@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1113865936.1483.73.camel@debian>
Sender: linux-raid-owner@vger.kernel.org
To: tmp <skrald@amossen.dk>
Cc: David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A followup about one single question.

tmp wrote:
[]
> Is it correct that I can use whole disks (/dev/hdb) only if I make a
> partitionable array and thus creates the partitions UPON the raid
> mechanism?

Just don't use whole disks for md arrays.  *Especially* if you want
to create partitions inside the array.  Instead, create a single
partition (/dev/hdb1) - you will waste the first sector on the disk,
but will be much safer.  The reason is trivial:

Linux raid subsystem is designed to leave almost the whole underlying
device from its very beginning to almost the end for the data, it
stores its superblock (metadata information) at the *end* of the
device (this way, you can mount eg a single component of your
raid1 array without md layer at all, for recovery purposes).

Whenever you will use the whole disk, /dev/hdb, for the raid arrays,
or not, kernel will still look at the partition table in the disk.
This table is at the very beginning of it.  If md array is at the
whole disk, very beginning of the disk is the same as the very
beginning of the array.  So, kernel may recognize something written
to the start of the array as a partition table, and "activate"
all the /dev/hdbN devices.

This is especially the case when you create partitions *inside* the
array (md1p1 etc) -- the same partition table (now valid one) will
be seen in /dev/hdb itself *and* in /dev/md1.

Now, when kernel recognized and activated partitions this way,
the partitions physically will reside somewhere inside the array.
For one, it is unsafe to access the partitions, obviously, and
the kernel will not warn/deny your accesses.

But it is worse.  Suppose you're assembling your arrays by searching
all devices for a superblocks.  The device you want is /dev/hdb,
but kernel recognized partitions on it, and now the superblock is
at the end of both /dev/hdb and the last partition on it, say,
/dev/hdb4 -- you're lucky if your raid assembly tools will pick
up the right one...  (Ok ok, the same applies to normal partitions
as well: it's always ambiguous choice if your last partition is a
part of a raid array, what to chooce: the last partition or the
whole disk)

Also suppose you will later want to boot from this drive, eg
because your real boot drive failed - you will have to actually
move your data off by a single sector to free the room for real
partition table...

To summarize: don't leave the kernel with more than one choice.
It's trivial to avoid the whole issue, with some more yet unknown
to me possible bad sides, by just creating a single partition on
the drive and be done with it, once and forever.

/mjt
