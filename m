From: Kanoa Withington <kanoa@cfht.hawaii.edu>
Subject: Re: Benchmarks comparing 3ware 7410 RAID5 to Linux md
Date: Mon, 8 Sep 2003 16:24:44 -1000 (HST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.55.0309081600180.1237@umi.cfht.hawaii.edu>
References: <20030908225852.GN2743@vitelus.com>
 <Pine.LNX.4.53.0309081833450.14706@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.53.0309081833450.14706@twinlark.arctic.org>
To: dean gaudet <dean-list-linux-raid@arctic.org>
Cc: Aaron Lehmann <aaronl@vitelus.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dean is exactly right.

3ware cards cannot recover from scenario 2 either _if_ one drive has
already been kicked out of the array. The only advantage they have is
that they will not kick out a disk for a read error, they will find
the unreadable data from parity and rewrite it to the bad disk which
will usually map out the bad block automatically and therefore
"repair" the sector.

Software RAID would kick out the disk with the read error and then you
would loose data because the array can no longer be reconstructed due
to the other bad sector/disk.

In other words, neither can recover from scenario 2 but you will be
less likely to find yourself in that position with a 3ware array. The
chances of finding yourself in scenario 2 with a large RAID 5 volume
are actually frighteningly high since large disks tend to develop
latent read errors over time.

Keep in mind RAID doesn't care about the filesystem so every block in
the array, not just the utilized ones, needs to be readable for any
degraded RAID 5 to rebuild onto a new disk.

Since 3ware cards can repair read errors they also let you "verify"
volumes which means scanning the whole thing correcting any newfound
errors. This greatly reduces the odds that in the event of a real disk
failure you would find yourself in the dreaded "scenario 2".

That said, the Linux software raid is a wonderful thing as far as
software RAID goes, and software RAID 5 can be much faster and less
expensive than a 3ware RAID 5.

-Kanoa



On Mon, 8 Sep 2003, dean gaudet wrote:

> On Mon, 8 Sep 2003, Aaron Lehmann wrote:
>
> > * Can software raid 5 reliably deal with drive failures? If not, I
> > don't think I'll even run the test. I've heard about some bad
> > experiences with software raid, but I don't want to dismiss the option
> > because of hearsay.
>
> in my experience linux sw raid5 or raid1 have no problem dealing with
> single drive failures.
>
> there are a class of multiple drive failures for which it's at least
> theoretically possible to recover, but which sw raid5 doesn't not
> presently recover.  and given that we don't have the source code to
> 3ware's raid5 stuff it's hard to say if they cover this class either (this
> is generally true of hw raid, 3ware or otherwise).  the specific type of
> failures i'm referring to are those for which every stripe has at least
> N-1 working copies, but there are no set of N-1 disks for which you can
> read every stripe.
>
> it's easier to explain with a picture:
>
> good raid5:
>
> 	// disk 0, 1, 2, 3 resp.
> 	{ D, D, D, P }	// stripe 0
> 	{ D, D, P, D }	// stripe 1
> 	{ D, P, D, D }	// stripe 2
> 	{ P, D, D, D }  // stripe 3
> 	...
>
> where D/P are data/parity respectively.
>
> bad disk type 1:
>
> 	// disk 0, 1, 2, 3 resp.
> 	{ X, D, D, P }	// stripe 0
> 	{ X, D, P, D }	// stripe 1
> 	{ X, P, D, D }	// stripe 2
> 	{ X, D, D, D }	// stripe 3
> 	...
>
> where "X" means we can't read this chunk.  this is the type of failure
> which sw raid5 handles fine -- it goes into a degraded mode using disks 1,
> 2, and 3.
>
> bad disks type 2:
>
> 	// disk 0, 1, 2, 3 resp.
> 	{ D, X, D, P }	// stripe 0
> 	{ D, D, P, D }	// stripe 1
> 	{ X, P, D, D }	// stripe 2
> 	{ P, D, D, D }	// stripe 3
> 	...
>
> this is a type of failure which sw raid5 does not presently handle
> (although i'd love for someone to tell me i'm wrong :).
>
> but it's easy to see that you *can* recover from this situation.  in this
> case to recover all of stripe 0 you'd reconstruct from disks 0, 2 and 3;
> and to recover all of stripe 2 you'd reconstruct from disks 1, 2, and 3.
>
> as to whether hw raids are any better is up for debate... if you've got
> the source you can always look at it and prove it either way.  (or a
> vendor can step forward and claim they support this type of failure.)
>
> there are similar failure modes for raid1 as well, and i believe sw
> raid1 also believes a disk is either "all good" or "all bad" with no
> in-betweens.
>
>
> > * Is it possible to boot off a software array with LILO or GRUB?
>
> LILO can do raid1 fine, and i don't know anything about GRUB.
>
> -dean
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
