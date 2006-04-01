From: Alex Izvorski <aizvorski@gmail.com>
Subject: Re: raid5 high cpu usage during reads - oprofile results
Date: Sat, 01 Apr 2006 10:40:05 -0800
Message-ID: <1143916805.20525.30.camel@starfire>
References: <1143240438.8573.59.camel@starfire>
	 <1143275900.8573.116.camel@starfire>
	 <Pine.LNX.4.64.0603252122210.6166@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0603252122210.6166@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2006-03-25 at 21:38 -0800, dean gaudet wrote:
> On Sat, 25 Mar 2006, Alex Izvorski wrote:
> 
> >  http://linuxraid.pastebin.com/621363 - oprofile annotated assembly
> 
> it looks to me like a lot of time is spent in __find_stripe() ... i wonder 
> if the hash is working properly.
> 
> in raid5.c you could try changing
> 
> #define stripe_hash(conf, sect) (&((conf)->stripe_hashtbl[((sect) >> STRIPE_SHIFT) & HASH_MASK]))
> 
> to
> 
> #define stripe_hash(conf, sect) (&((conf)->stripe_hashtbl[(((sect) >> STRIPE_SHIFT) ^ ((sect) >> (2*STRIPE_SHIFT))) & HASH_MASK]))
> 
> or maybe try using jhash_1word((sect) >> STRIPE_SHIFT, 0) ...
> 
> -dean

Dean - I think I see what you mean, you're looking at this line in the
assembly?

65830 16.8830 :     c1f:       cmp    %rcx,0x28(%rax)

I looked at the hash stuff, I think the problem is not that the hash
function is poor, but rather that the number of entries in all buckets
gets to be pretty high.  I haven't actually run this with extra
debugging statements yet, but as far as I can tell from reading the
code, the hash-related defines will get the following values:

NR_HASH = 512
HASH_MASK = 0x1ff
STRIPE_SHIFT = 3

With this, every successive stripe will go to a different bucket, so for
a sequential access this is a good hash function (actually, to break it
you'd need to read 4k every 2M, which is not a common access pattern).
The problem is that there are too few buckets?  Since with 16k entries
in the stripe cache and 512 buckets we'd have 32 elements per bucket.
Would redefining HASH_PAGES to 16 or so help?  For that matter, is the
code even expected to work with HASH_PAGES > 1?   Perhaps someone who is
more familiar with the code can comment on this.

Regards,
--Alex


