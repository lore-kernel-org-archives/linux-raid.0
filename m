From: Jody McIntyre <scjody@sun.com>
Subject: Re: [PATCH] md: Track raid5/6 statistics
Date: Fri, 02 Oct 2009 13:01:22 -0400
Message-ID: <20091002170121.GB22539@clouds>
References: <20090312205754.GH8732@clouds>
 <e9c3a7c20903141007h5fea439co70e4ea9ea4a10ec1@mail.gmail.com>
 <20090506200502.GK25233@clouds>
 <e9c3a7c20905070930n5b7bd3dcy3e837d17865d4540@mail.gmail.com>
 <20090511133602.GB30561@clouds> <4A0AC6C3.6020702@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
In-reply-to: <4A0AC6C3.6020702@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

I finally got around to looking at the load average code and thinking how
it could be applied to tracking stripe cache usage, and unfortunately I
don't have any great ideas.

What's useful to know is:

1. The current stripe_cache_active value, which can be sampled by a script
during heavy IO/resync/etc.  This is already available.

2. How often (relative to the amount of IO) we've had to block waiting for
a free stripe recently.  The "recently" part is hard to define and and not
implemented by current the current patch - it just reports the number of
events since the array was started, but we can collect statistics from
before and after a run and compare.

3. We've had a few customers using write-intent bitmaps lately, and our
"bit delayed" counter (the number of stripes currently on bitmap_list) has
been useful in assessing the impact of bitmaps / changes to bitmap chunk
size.  But it's not really a great measure of anything so I'm open to
suggestions.  I think "average amount of time an IO is delayed due to
bitmaps" would be nice and probably not too hard to implement, but I'm
worried about the performance impact of this.

Also, there's still the open question of where we report these values other
than /proc/mdstat and I'm really open to suggestions.  If nobody has any
ideas, we'll just continue to patch raid5.c ourselves to extend
/proc/mdstat.

Cheers,
Jody
