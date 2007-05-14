From: Neil Brown <neilb@suse.de>
Subject: Re: /proc/mdstat showing a device missing from array
Date: Tue, 15 May 2007 09:35:09 +1000
Message-ID: <17992.61997.544536.744615@notabene.brown>
References: <1179081234.46475a12d46ba@mail.2inches.com>
	<17991.46650.304434.640289@notabene.brown>
	<1179171731.4648bb938d688@mail.2inches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from evoltech@2inches.com on Monday May 14
Sender: linux-raid-owner@vger.kernel.org
To: evoltech@2inches.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 14, evoltech@2inches.com wrote:
> Quoting Neil Brown <neilb@suse.de>:
> 
> > 
> > A raid5 is always created with one missing device and one spare.  This
> > is because recovery onto a spare is faster than resync of a brand new
> > array.
> 
> This is unclear to me.  Do you mean that is how mdadm implements raid5 creation
>  or do you mean that is how raid5 is designed?  I havn't read about this in any
> raid5 documentation or mdadm documentation.  Can you point me in the right
> direction?

In the OPTIONS section of mdadm.8, under "For create, build, or
grow:", it says:
       -f, --force
              Insist that mdadm accept the geometry and layout specified with‐
              out  question.   Normally  mdadm  will  not allow creation of an
              array with only one device, and will try to create a raid5 array
              with  one  missing  drive (as this makes the initial resync work
              faster).  With --force, mdadm will not try to be so clever.

This is a feature specific to the md implementation of raid5, not
necessarily general to all raid5 implementations.
When md/raid5 performs a "sync", it assumes that most parity blocks
are correct.  So it simply reads all drives in parallel and check that
the parity block is correct.  When it finds one that isn't (which
should not happen often) it will write the correct data.  This
requires a backward seek and breaks the streaming flow of data off the
drives.

For a new array, it is likely that most if not all parity blocks are
wrong.  The above algorithm will cause every parity block to be first
read, and then written, producing lots of seeks and much slower
throughput.

If you create a new array degraded and add a spare, it will recover
the spare by reading all the good drives in parallel, computing the
missing drive, and writing that purely sequentially.  That goes much
faster.

e.g. on my test machine with 5 SATA drives, I get 42Meg/sec recovery
speed, but only around 30Meg/sec resync on a new array.

> > 
> > This bug was fixed in mdadm-2.5.2
> 
> The recovery of the array has started, thanks!

Excellent.  I have since realised that there is a kernel bug as
well.  I will get that fixed in the next release so that the old mdadm
will also work properly.

NeilBrown
