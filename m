From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: Re: Benchmarks comparing 3ware 7410 RAID5 to Linux md
Date: Mon, 8 Sep 2003 18:50:46 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0309081833450.14706@twinlark.arctic.org>
References: <20030908225852.GN2743@vitelus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030908225852.GN2743@vitelus.com>
To: Aaron Lehmann <aaronl@vitelus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 8 Sep 2003, Aaron Lehmann wrote:

> * Can software raid 5 reliably deal with drive failures? If not, I
> don't think I'll even run the test. I've heard about some bad
> experiences with software raid, but I don't want to dismiss the option
> because of hearsay.

in my experience linux sw raid5 or raid1 have no problem dealing with
single drive failures.

there are a class of multiple drive failures for which it's at least
theoretically possible to recover, but which sw raid5 doesn't not
presently recover.  and given that we don't have the source code to
3ware's raid5 stuff it's hard to say if they cover this class either (this
is generally true of hw raid, 3ware or otherwise).  the specific type of
failures i'm referring to are those for which every stripe has at least
N-1 working copies, but there are no set of N-1 disks for which you can
read every stripe.

it's easier to explain with a picture:

good raid5:

	// disk 0, 1, 2, 3 resp.
	{ D, D, D, P }	// stripe 0
	{ D, D, P, D }	// stripe 1
	{ D, P, D, D }	// stripe 2
	{ P, D, D, D }  // stripe 3
	...

where D/P are data/parity respectively.

bad disk type 1:

	// disk 0, 1, 2, 3 resp.
	{ X, D, D, P }	// stripe 0
	{ X, D, P, D }	// stripe 1
	{ X, P, D, D }	// stripe 2
	{ X, D, D, D }	// stripe 3
	...

where "X" means we can't read this chunk.  this is the type of failure
which sw raid5 handles fine -- it goes into a degraded mode using disks 1,
2, and 3.

bad disks type 2:

	// disk 0, 1, 2, 3 resp.
	{ D, X, D, P }	// stripe 0
	{ D, D, P, D }	// stripe 1
	{ X, P, D, D }	// stripe 2
	{ P, D, D, D }	// stripe 3
	...

this is a type of failure which sw raid5 does not presently handle
(although i'd love for someone to tell me i'm wrong :).

but it's easy to see that you *can* recover from this situation.  in this
case to recover all of stripe 0 you'd reconstruct from disks 0, 2 and 3;
and to recover all of stripe 2 you'd reconstruct from disks 1, 2, and 3.

as to whether hw raids are any better is up for debate... if you've got
the source you can always look at it and prove it either way.  (or a
vendor can step forward and claim they support this type of failure.)

there are similar failure modes for raid1 as well, and i believe sw
raid1 also believes a disk is either "all good" or "all bad" with no
in-betweens.


> * Is it possible to boot off a software array with LILO or GRUB?

LILO can do raid1 fine, and i don't know anything about GRUB.

-dean
