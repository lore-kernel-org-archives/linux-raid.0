From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Linux RAID Enterprise-Level Capabilities and If It Supports Raid Level Migration and Online Capacity Expansion
Date: Thu, 22 Dec 2005 15:20:10 +0000
Message-ID: <62b0912f0512220720i30d86919we67901d35e4e81c@mail.gmail.com>
References: <20051222100703.23157.qmail@web52909.mail.yahoo.com>
	 <62b0912f0512220431l4d1ec130q137b737c1956ddd9@mail.gmail.com>
	 <20051222150631.GC31400@lug.udel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051222150631.GC31400@lug.udel.edu>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Ross Vandegrift <ross@lug.udel.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ross Vandegrift wrote:
> Molle Bestefich wrote:
> > Since you say "we", I assume you're part of a very large corporation
> > and thus intend to RAID a whole bunch of disks.  Go with RAID6 + a
> > couple of spares for that.  If you intend to use really many disks,
> > make multiple arrays.  (Not sure whether you can share spares across
> > arrays, but I think you can.)
>
> A recent foray through mdadm's code verifies this.  If it noticies a
> failure and there is a spare, it attempts to migrate the spare to the
> array that needs it.  Very cool feature!

Super =)

> > I've seen lots of MD tests, but none that covered profiling MD's
> > random access performance.  So I suppose that most hardware solutions
> > will do a lot better than MD here since they have been profiled with
> > this in mind.
>
> Well, it depends on the RAID level, disk, configuration, and how
> you're using it.

Still a shame for MD that noone has done these tests.

Also a shame that noone has setup up a test farm with:
 * A test box that regularly profiles MD, for seek time, throughput
and CPU usage with various personalities.
 * Another test box, exactly the same hardware as the first one,
suited for plugging in new hardware RAID adapters (while retaining
disks and other hardware) to test hardware RAID solutions with
consistent results even when new products come out.

> In general, RAID 0+1 has better seek properties
> because reads can be done independantly from many disks.  RAID5 is
> always going to be slow because n-1 disks need to all simultaneously
> read their stripe, and this can cause spindle contention.

Why would you need to send all of the disks in a RAID5 to the same
stripe if only fx. one block in the stripe was requested?  Doesn't
make much sense to me..

> Of course, you lose more space to overhead as RAID 0+1 arrays grow...

Of course.  It seems to me that RAID 1+0 has the exact same
performance properties as RAID 0+1 if things are done properly in
whatever RAID hardware/software used..
