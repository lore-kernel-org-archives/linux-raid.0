From: "NeilBrown" <neilb@suse.de>
Subject: Re: >16TB RAID0
Date: Fri, 17 Jul 2009 13:59:19 +1000 (EST)
Message-ID: <88b4380a1bcd5fd15556fd1d4454565a.squirrel@neil.brown.name>
References: <150c16850907162036w44a13b3dn6d6039a8960ed141@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <150c16850907162036w44a13b3dn6d6039a8960ed141@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, July 17, 2009 1:36 pm, Justin Maggard wrote:
> Has anybody here tried using a >16TB RAID0?  When I recently got my
> hands on some 2TB drives, I decided to check out the current status of
> large EXT4 filesystems on 32-bit systems.  I created a ~17TB RAID0,
> and immediately had problems.  Andreas Dilger advised me to try out
> his llverdev utility (kindly hosted by Val Aurora at
> http://valhenson.livejournal.com/38933.html) to verify that the
> underlying device is functioning properly.  Running "llverdev -p -v
> /dev/md0" on a >16TB array resulted in a runaway process, with
> llverdev and pdflush each eating up 100% of the CPU time on my two
> cores, but not advancing the write offset.  The process did not appear
> to be interruptable after more than 30 minutes, and I had to do a hard
> shutdown.  A RAID0 just under 16TB ran through llverdev without a
> hitch.
>
> I'm in the process of running a RAID5 array through the same test now,
> but it's already past the point where the RAID0 failed; so if it does
> fail, it'll likely be due to a different cause.  Does anyone have any
> ideas?  Has this never been done before?  I'm running debian on a
> 2.6.30.1 kernel.

I'm not 100% sure, but a quick look at the code suggests that
16TB is the upper limit for normal read/write operations on
a block device like /dev/md0 on a 32bit host.  This is because it uses
the page cache, and that uses 4K pages with a 32bit index, hence
16TB.

A filesystem using a 16TB device would not be limited in the same way
as it caches individual files, not the whole device (individual files
would still be limited to 16TB).
I think if you access the block device with O_DIRECT you might be
able to bypass the 16TB barrier.  Try hacking the program
to add O_DIRECT to the open mode.

However this doesn't explain why it seems to work for RAID5.  If I
am right, RAID5 should fail in the same way as RAID0.
But I would certainly expect RAID0 to work if anything does.

Confused.
NeilBrown

