From: Alex Izvorski <aizvorski@gmail.com>
Subject: Re: raid5 high cpu usage during reads - oprofile results
Date: Sat, 01 Apr 2006 22:03:04 -0800
Message-ID: <1143957785.20527.138.camel@starfire>
References: <1143240438.8573.59.camel@starfire>
	 <1143275900.8573.116.camel@starfire>
	 <Pine.LNX.4.64.0603252122210.6166@twinlark.arctic.org>
	 <1143916805.20525.30.camel@starfire>
	 <Pine.LNX.4.64.0604011414100.17019@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0604011414100.17019@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2006-04-01 at 14:28 -0800, dean gaudet wrote:
> i'm guessing there's a good reason for STRIPE_SIZE being 4KiB -- 'cause 
> otherwise it'd be cool to run with STRIPE_SIZE the same as your raid 
> chunksize... which would decrease the number of entries -- much more 
> desirable than increasing the number of buckets.

Dean - that is an interesting thought.  I can't think of a reason why
not, except that it is the same as the page size?  But offhand I don't
see any reason why that is a particularly good choice either.  Would the
code work with other sizes?  What about a variable (per array) size?
How would that interact with small reads?

Do you happen to know how many find_stripe calls there are for each
read?  I rather suspect it is several (many) times per sector, since it
uses up something on the order of several thousand clock cycles per
*sector* (reading 400k sectors per second produces 80% load of 2x 2.4GHz
cpus, of which get_active_stripe accounts for ~30% - that's 2.8k clock
cycles per sector just in that one function). I really don't see any way
a single hash lookup even in a table with ~30 entries per bucket could
do anything close to that.

Short of changing STRIPE_SIZE, it should be enough to make sure the
average bucket occupancy is considerably less than one - as long as the
occupancy is kept low the the speed of access is independent of the
number of entries.  256 stripe cache entries and 512 hash buckets works
well with a 0.5 max occupancy; we should ideally have at least 32k
buckets (or 64 pages) for 16k entries.  Yeah, ok, it's quite a bit more
memory than is used now, but considering that the box I'm running this
on has 4GB, it's not that much ;)

--Alex


