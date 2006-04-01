From: dean gaudet <dean@arctic.org>
Subject: Re: raid5 high cpu usage during reads - oprofile results
Date: Sat, 1 Apr 2006 14:28:14 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0604011414100.17019@twinlark.arctic.org>
References: <1143240438.8573.59.camel@starfire>  <1143275900.8573.116.camel@starfire>
  <Pine.LNX.4.64.0603252122210.6166@twinlark.arctic.org> <1143916805.20525.30.camel@starfire>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1143916805.20525.30.camel@starfire>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Izvorski <aizvorski@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 1 Apr 2006, Alex Izvorski wrote:

> Dean - I think I see what you mean, you're looking at this line in the
> assembly?
> 
> 65830 16.8830 :     c1f:       cmp    %rcx,0x28(%rax)

yup that's the one... that's probably a fair number of cache (or tlb) 
misses going on right there.


> I looked at the hash stuff, I think the problem is not that the hash
> function is poor, but rather that the number of entries in all buckets
> gets to be pretty high.

yeah... your analysis seems more likely.

i suppose increasing the number of buckets is the only option.  it looks 
to me like you'd just need to change NR_HASH and the kzalloc in run() in 
order to increase the number of buckets.

i'm guessing there's a good reason for STRIPE_SIZE being 4KiB -- 'cause 
otherwise it'd be cool to run with STRIPE_SIZE the same as your raid 
chunksize... which would decrease the number of entries -- much more 
desirable than increasing the number of buckets.

-dean
