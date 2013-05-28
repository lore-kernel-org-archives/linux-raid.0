From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: mdadm vs zfs for home server?
Date: Tue, 28 May 2013 10:24:12 -0500
Message-ID: <20130528152412.GB1357@septictank.raw-sewage.fake>
References: <20130527180912.GA6068@septictank.raw-sewage.fake>
 <51A3DF2B.7070200@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51A3DF2B.7070200@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, May 27, 2013 at 05:33:15PM -0500, Stan Hoeppner wrote:
> The primary reason RAID6 came into use is double drive failure during
> RAID5's lengthy rebuild times causing total array loss.  RAID10 rebuilds
> are the same as a mirror rebuild.  Takes ~4-6 hours with 3TB drives.

And, based on what I've read about ZFS, since it knows about the
data, it only resyncs ("resilvers" in zfs lingo) actual data, not
the whole drive.  So depending on how full the array is, resilvering
could take even less time.

That should therefore *decrease* the chances of another disk failing
during rebuild/resilver, right?  That is, if rebuild times are
proportional to the amount of actual disk utilization (which is
assumed to be less than 100%).

> Over the ~20 years RAID10 has been in use in both soft/hardware
> solutions it has been shown that partner drive loss during rebuild
> is extremely rare.

Is that based on your experience, or have you read studies and such?
That's an honest question, not trying to start a debate, but I've
read anecdotal experience to the contrary.  One of the limitations
of doing informal internet research.  :)

> RAID10 rebuild time is constant regardless of array size.  RAID6 rebuild
> times tend to increase as the number of drives increases.  You may not
> need the application performance of RAID10, but you would surely benefit
> from the drastically lower rebuild time.  The only downside to md/RAID10
> is that it cannot be expanded.  Many hardware RAID controllers can
> expand RAID10 arrays, however.

And again, in general, my understanding is that lower rebuild times
equate to lowered chances of 2nd drive failure during the rebuild.
I don't have the math skills to predict partner drive failure (in
raid10), but intuitively, it seems like it should be fairly rare.
And in my personal case, I intend to comprise each partner (i.e.
mirror) set with drives from different manufacturers.  Again, seems
like this should give me still better statistical odds of not having
both drives in a mirror set fail at the same time.  And failing
that, that's what backups are for.  :)

