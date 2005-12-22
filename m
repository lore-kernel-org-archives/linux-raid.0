From: ross@lug.udel.edu (Ross Vandegrift)
Subject: Re: Linux RAID Enterprise-Level Capabilities and If It Supports Raid Level Migration and Online Capacity Expansion
Date: Thu, 22 Dec 2005 10:06:31 -0500
Message-ID: <20051222150631.GC31400@lug.udel.edu>
References: <20051222100703.23157.qmail@web52909.mail.yahoo.com> <62b0912f0512220431l4d1ec130q137b737c1956ddd9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <62b0912f0512220431l4d1ec130q137b737c1956ddd9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: Rik Herrin <rikherrin@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Dec 22, 2005 at 12:31:25PM +0000, Molle Bestefich wrote:
> Since you say "we", I assume you're part of a very large corporation
> and thus intend to RAID a whole bunch of disks.  Go with RAID6 + a
> couple of spares for that.  If you intend to use really many disks,
> make multiple arrays.  (Not sure whether you can share spares across
> arrays, but I think you can.)

A recent foray through mdadm's code verifies this.  If it noticies a
failure and there is a spare, it attempts to migrate the spare to the
array that needs it.  Very cool feature!

> I've seen lots of MD tests, but none that covered profiling MD's
> random access performance.  So I suppose that most hardware solutions
> will do a lot better than MD here since they have been profiled with
> this in mind.

Well, it depends on the RAID level, disk, configuration, and how
you're using it.  In general, RAID 0+1 has better seek properties
because reads can be done independantly from many disks.  RAID5 is
always going to be slow because n-1 disks need to all simultaneously
read their stripe, and this can cause spindle contention.

Of course, you lose more space to overhead as RAID 0+1 arrays grow...

-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
