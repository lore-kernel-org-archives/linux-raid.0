From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH 5/9] raid5: log recovery
Date: Wed, 5 Aug 2015 14:39:09 -0700
Message-ID: <20150805213909.GA3197719@devbig257.prn2.facebook.com>
References: <cover.1438215986.git.shli@fb.com>
 <5683d4e81fe802c46350732560bbdd0a70212413.1438215986.git.shli@fb.com>
 <20150805140525.0e0774ae@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150805140525.0e0774ae@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Wed, Aug 05, 2015 at 02:05:25PM +1000, NeilBrown wrote:
> On Wed, 29 Jul 2015 17:38:45 -0700 Shaohua Li <shli@fb.com> wrote:
> 
> > This is the log recovery support. The process is quite straightforward.
> > We scan the log and read all valid meta/data/parity into memory. If a
> > stripe's data/parity checksum is correct, the stripe will be recoveried.
> > Otherwise, it's discarded and we don't scan the log further. The reclaim
> > process guarantees stripe which starts to be flushed raid disks has
> > completed data/parity and has correct checksum. To recovery a stripe, we
> > just copy its data/parity to corresponding raid disks.
> > 
> > The trick thing is superblock update after recovery. we can't let
> > superblock point to last valid meta block. The log might look like:
> > | meta 1| meta 2| meta 3|
> > meta 1 is valid, meta 2 is invalid. meta 3 could be valid. If superblock
> > points to meta 1, we write a new valid meta 2n.  If crash happens again,
> > new recovery will start from meta 1. Since meta 2n is valid, recovery
> > will think meta 3 is valid, which is wrong.  The solution is we create a
> > new meta in meta2 with its seq == meta 1's seq + 2 and let superblock
> > points to meta2.  recovery will not think meta 3 is a valid meta,
> > because its seq is wrong
> 
> I like the idea of using a slightly larger 'seq' to avoid collisions -
> except that I would probably feel safer with a much larger seq. May add
> 1024 or something (at least 10).

ok 
> > 
> > TODO:
> > -recovery should run the stripe cache state machine in case of disk
> > breakage.
> 
> Why?
> 
> when you write to the log, you write all of the blocks that need
> updating, whether they are destined for a failed device or not.
> 
> When you recover, you then have all the blocks that you might want to
> write.  So write all the ones for which you have working devices, and
> ignore the rest.
> 
> Did I miss something?
> 
> Not that I object, but if it works....

I mean the case of disk is broken. For example, log has a stripe with
data for disk 1, 2, 4. In recovery, disk 2 is broken. Just write 1, 4
isn't good. If we run the state machine, we can read disk 3 and have an
eventually consistent stripe.

Thanks,
Shaohua
