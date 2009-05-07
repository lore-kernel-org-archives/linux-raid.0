From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] md: Track raid5/6 statistics
Date: Thu, 7 May 2009 09:30:33 -0700
Message-ID: <e9c3a7c20905070930n5b7bd3dcy3e837d17865d4540@mail.gmail.com>
References: <20090312205754.GH8732@clouds>
	 <e9c3a7c20903141007h5fea439co70e4ea9ea4a10ec1@mail.gmail.com>
	 <20090506200502.GK25233@clouds>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090506200502.GK25233@clouds>
Sender: linux-raid-owner@vger.kernel.org
To: Jody McIntyre <scjody@sun.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Wed, May 6, 2009 at 1:05 PM, Jody McIntyre <scjody@sun.com> wrote:
> 2. The out_of_stripes tracking is useful - we've found several cases
> where stripe_cache_size was set too low and performance suffered as a
> result. =A0Monitoring stripe_cache_active during IO is difficult so i=
t's
> far better to have a counter like this.
>
> So if we can solve the second problem somehow - maybe just introduce =
a
> read-only counter under /sys/block/md*/md/out_of_stripes - the need f=
or
> the rest of the patch goes away IMO.

It would be nice if the kernel could auto-tune stripe_cache_size, but
I think modifying it in a reactive fashion may do more harm than good.
 The times when we want write-out to be faster are usually the times
when the system has too much dirty memory lying around so there is no
room to increase the cache.  If we are under utilizing the stripe
cache then there is a good chance the memory could be put to better
use in the page cache, but then we are putting ourselves in a
compromised state when a write burst appears.

In the end I agree that having some kind of out_of_stripes
notification would be useful.  However, I think it would make more
sense to implement it as a "stripe_cache_active load average".  Then
for a given workload the operator can see if there are spikes or
sustained cache saturation.  What do you think?

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
