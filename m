From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH] md: Track raid5/6 statistics
Date: Fri, 02 Oct 2009 13:51:28 -0400
Message-ID: <4AC63DA0.3050406@tmr.com>
References: <20090312205754.GH8732@clouds> <e9c3a7c20903141007h5fea439co70e4ea9ea4a10ec1@mail.gmail.com> <20090506200502.GK25233@clouds> <e9c3a7c20905070930n5b7bd3dcy3e837d17865d4540@mail.gmail.com> <20090511133602.GB30561@clouds> <4A0AC6C3.6020702@tmr.com> <20091002170121.GB22539@clouds>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091002170121.GB22539@clouds>
Sender: linux-raid-owner@vger.kernel.org
To: Jody McIntyre <scjody@sun.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Jody McIntyre wrote:
> I finally got around to looking at the load average code and thinking how
> it could be applied to tracking stripe cache usage, and unfortunately I
> don't have any great ideas.
>
> What's useful to know is:
>
> 1. The current stripe_cache_active value, which can be sampled by a script
> during heavy IO/resync/etc.  This is already available.
>
> 2. How often (relative to the amount of IO) we've had to block waiting for
> a free stripe recently.  The "recently" part is hard to define and and not
> implemented by current the current patch - it just reports the number of
> events since the array was started, but we can collect statistics from
> before and after a run and compare.
>
> 3. We've had a few customers using write-intent bitmaps lately, and our
> "bit delayed" counter (the number of stripes currently on bitmap_list) has
> been useful in assessing the impact of bitmaps / changes to bitmap chunk
> size.  But it's not really a great measure of anything so I'm open to
> suggestions.  I think "average amount of time an IO is delayed due to
> bitmaps" would be nice and probably not too hard to implement, but I'm
> worried about the performance impact of this.
>
> Also, there's still the open question of where we report these values other
> than /proc/mdstat and I'm really open to suggestions.  If nobody has any
> ideas, we'll just continue to patch raid5.c ourselves to extend
> /proc/mdstat.
>   

I would think in /sys would be a better place, anything which changes 
/proc/mdstat is likely to break some script, and therefore be less 
useful (and adoptable to mainline), where another file in /sys would be 
really unlikely to cause an issue. People tend to look at what is in 
known files, but ignore files which were not known at the time of script 
creation. It tends to a messy tree of files, but rarely breaks existing 
code.

-- 
Bill Davidsen <davidsen@tmr.com>
  Unintended results are the well-earned reward for incompetence.

