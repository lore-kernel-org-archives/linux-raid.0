From: dean gaudet <dean@arctic.org>
Subject: Re: raid5 high cpu usage during reads - oprofile results
Date: Sat, 1 Apr 2006 23:13:49 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0604012242550.17019@twinlark.arctic.org>
References: <1143240438.8573.59.camel@starfire>  <1143275900.8573.116.camel@starfire>
  <Pine.LNX.4.64.0603252122210.6166@twinlark.arctic.org>
 <1143916805.20525.30.camel@starfire>  <Pine.LNX.4.64.0604011414100.17019@twinlark.arctic.org>
 <1143957785.20527.138.camel@starfire>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1143957785.20527.138.camel@starfire>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Izvorski <aizvorski@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 1 Apr 2006, Alex Izvorski wrote:

> On Sat, 2006-04-01 at 14:28 -0800, dean gaudet wrote:
> > i'm guessing there's a good reason for STRIPE_SIZE being 4KiB -- 'cause 
> > otherwise it'd be cool to run with STRIPE_SIZE the same as your raid 
> > chunksize... which would decrease the number of entries -- much more 
> > desirable than increasing the number of buckets.
> 
> Dean - that is an interesting thought.  I can't think of a reason why
> not, except that it is the same as the page size?  But offhand I don't
> see any reason why that is a particularly good choice either.  Would the
> code work with other sizes?  What about a variable (per array) size?
> How would that interact with small reads?

i don't understand the code well enough...


> Do you happen to know how many find_stripe calls there are for each
> read?  I rather suspect it is several (many) times per sector, since it
> uses up something on the order of several thousand clock cycles per
> *sector* (reading 400k sectors per second produces 80% load of 2x 2.4GHz
> cpus, of which get_active_stripe accounts for ~30% - that's 2.8k clock
> cycles per sector just in that one function). I really don't see any way
> a single hash lookup even in a table with ~30 entries per bucket could
> do anything close to that.

well the lists are all struct stripe_heads... which on i386 seem to be 
0x30 + 0x6c*(devs - 1) bytes each.  that's pretty big.  they're allocated 
in a slab, so they're relatively well packed into pages... but still, 
unless i've messed up somewhere that's 480 bytes for a 5 disk raid5.  so 
that's only 8 per page... so a chain of length 30 touches at least 4 
pages.  if you're hitting all 512 buckets, chains of length 30, then 
you're looking at somewhere on the order of 2048 pages...

that causes a lot of thrashing in the TLBs... and isn't so great on the 
cache either.

it's even worse on x86_64 ... it looks like 0xf8 + 0xb0*(devs - 1) bytes 
per stripe_head ... (i'm pulling these numbers from the call setup for 
kmem_cache_create in the disassembly of raid5.ko from kernels on my 
boxes).

oh btw you might get a small improvement by moving the "sector" field of 
struct stripe_head close to the hash field... right now the sector field 
is at 0x28 (x86_64) and so it's probably on a different cache line from 
the "hash" field at offset 0 about half the time (64 byte cache line).  if 
you move sector to right after the "hash" field it'll more likely be on 
the same cache line...

but still, i think the tlb is the problem.

oh you can probably ask oprofile to tell you if you're seeing cache miss 
or tlb miss stalls there (not sure on the syntax).


> Short of changing STRIPE_SIZE, it should be enough to make sure the
> average bucket occupancy is considerably less than one - as long as the
> occupancy is kept low the the speed of access is independent of the
> number of entries.  256 stripe cache entries and 512 hash buckets works
> well with a 0.5 max occupancy; we should ideally have at least 32k
> buckets (or 64 pages) for 16k entries.  Yeah, ok, it's quite a bit more
> memory than is used now, but considering that the box I'm running this
> on has 4GB, it's not that much ;)


i still don't understand all the code well enough... but if i assume 
there's a good reason for STRIPE_SIZE == PAGE_SIZE then it seems like you 
need to improve the cache locality of the hash chaining... a linked list 
of struct stripe_heads doesn't have very good locality because they're 
such large structures.

one possibility is a linked list of:

	struct stripe_hash_entry {
		struct hlist_node	hash;
		sector_t		sector;
		struct stripe_head *	sh;
	};

but that's still 32 bytes on x86_64 ...

you can get it down to 16 bytes by getting rid of chaining and using open 
addressing...

eh ... this still isn't that hot... really there's too much pressure 
because there's a hash table entry per 4KiB of disk i/o...

anyhow i'm only eyeballing code here, i could easily have missed some 
critical details.

-dean
