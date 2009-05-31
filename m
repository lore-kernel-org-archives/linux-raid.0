From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Awful RAID5 random read performance
Date: Sun, 31 May 2009 10:41:54 -0500
Message-ID: <20090531154159405.TTOI3923@cdptpa-omta04.mail.rr.com>
References: <4A227832.1090808@anonymous.org.uk>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A227832.1090808@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > I happen to be the friend Maurice was talking about. I let the raid
> layer keep
> > its default chunk size of 64K. The smaller size (below like 2MB) tests
> in
> > iozone are very very slow. I recently tried disabling readahead,
> Acoustic
> > Management, and played with the io scheduler and all any of it has done
> is
> > make the sequential access slower and has barely touched the smaller
> sized
> > random access test results. Even with the 64K iozone test random
> read/write is
> > only in the 7 and 11MB/s range.
> >
> > It just seems too low to me.
> 
> I don't think so; can you try a similar test on single drives not using
> md RAID-5?
> 
> The killer is seeks, which is what random I/O uses lots of; with a 10ms
> seek time you're only going to get ~100 seeks/second and if you're only
> reading 512 bytes after each seek you're only going to get ~500
> kbytes/second. Bigger block sizes will show higher throughput, but
> you'll still only get ~100 seeks/second.
> 
> Clearly when you're doing this over 4 drives you can have ~400
> seeks/second but that's still limiting you to ~400 reads/second for
> smallish block sizes.

	John is perfectly correct, although of course a 10ms seek is a
fairly slow one.  The point is, it is drive dependent, and there may not be
much one can do about it at the software layer.  That said, you might try a
different scheduler, as the seek order can make a difference.  Drives with
larger caches may help some, although the increase in performance with
larger cache sizes diminishes rapidly beyond a certain point.  As one would
infer from John's post, increasing the number of drives in the array will
help a lot, since increasing the number of drives raises the limit on the
number of seeks / second.

	What file system are you using?  It can make a difference, and
surely has a bigger impact than most tweaks to the RAID subsystem.

	The biggest question in my mind, however, is why is random access a
big issue for you?  Are you running a very large relational database with
tens of thousands of tiny files?  For most systems, high volume accesses
consist mostly of large sequential I/O.  The majority of random I/O is of
rather short duration, meaning even with comparatively poor performance, it
doesn't take long to get the job done.  Fifty to eighty Megabits per second
is nothing at which to sneeze for random access of small files.  A few years
ago, many drives would have been barely able to manage that on a sustained
basis for sequential I/O.


