From: Jason Lunz <lunz@falooley.org>
Subject: Re: recovery of hosed raid5 array
Date: Sun, 12 Oct 2003 14:04:19 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031012180419.GA23827@orr.falooley.org>
References: <slrnbog9og.t0c.lunz@orr.homenet> <no.Yo.24973.N.nN.0310111457280@business.com> <slrnboirt8.me8.lunz@orr.homenet> <Pine.LNX.4.58.0310121034090.7866@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0310121034090.7866@twinlark.arctic.org>
To: dean gaudet <dean-list-linux-raid@arctic.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 12, 2003 at 10:39AM -0700, dean gaudet wrote:
> querying SMART shouldn't cause this to happen -- but i've seen it occur

That's true, in theory. Fact is, asking a broken drive to do SMART stuff
may be the straw that breaks the camel's back. Immediately upon using
smartctl -a, /dev/hde started making repetetive clicking sounds every
half second or so, and the ide driver spammed syslog spectacularly. It's
only worked sporadically since (no more than a few minutes at a time),
even when power-cycled.

> with a promise controller and maxtor disks.  i used to query the SMART

oddly enough, it _is_ a maxtor disk on a promise controller (PDC20626, I
believe).

> i've since switched from promise to 3ware, and now i can't use smartctl to
> query the data.  (mind you a kind engineer from 3ware sent me the code i
> need to query SMART from the drives, i've just never had the chance to
> merge it into smartctl).

I've heard noises about 3ware support in very recent releases of
smartmontools, iirc.

> mdadm can do it for you ... you need to know exactly which disk was in
> which position in the raid.  then you recreate the raid using "missing" in
> the slot where /dev/hde belonged.  then you'll have a degraded array, so
> md won't try rebuilding it.  then you can copy off the data.

seriously? Did you read the whole thread? mdadm will do the right thing
even though /dev/hdg was 3% into a resync when /dev/hde died? That would
be lovely.

> you need to know the exact numberings, and the exact commands you used
> to create the array in the first place.

How might I go about figuring this out? I got a 120G drive yesterday
that's large enough to capture raw images of all the raid disks, so I
can try different combinations of commands. What I can't do is look at
the logs, because the non-raid portion of the now-dead /dev/hde held the
root, /usr, and /var partitions.

Jason
