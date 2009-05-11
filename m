From: Jody McIntyre <scjody@sun.com>
Subject: Re: [PATCH] md: Track raid5/6 statistics
Date: Mon, 11 May 2009 09:36:03 -0400
Message-ID: <20090511133602.GB30561@clouds>
References: <20090312205754.GH8732@clouds>
 <e9c3a7c20903141007h5fea439co70e4ea9ea4a10ec1@mail.gmail.com>
 <20090506200502.GK25233@clouds>
 <e9c3a7c20905070930n5b7bd3dcy3e837d17865d4540@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
In-reply-to: <e9c3a7c20905070930n5b7bd3dcy3e837d17865d4540@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Thu, May 07, 2009 at 09:30:33AM -0700, Dan Williams wrote:

> It would be nice if the kernel could auto-tune stripe_cache_size, but
> I think modifying it in a reactive fashion may do more harm than good.
>  The times when we want write-out to be faster are usually the times
> when the system has too much dirty memory lying around so there is no
> room to increase the cache.  If we are under utilizing the stripe
> cache then there is a good chance the memory could be put to better
> use in the page cache, but then we are putting ourselves in a
> compromised state when a write burst appears.

Yes - it's really too bad that we have this tunable, but I can't think
of a good way to get rid of it.  In some customer issues I've seen,
performance really suffers when the array is out of stripes - enough to
make single IOs take _minutes_ in the worst cases.  This is especially
easy to reproduce during a resync or rebuild, for obvious reasons.

On a related note, there seems to be some confusion surrounding how much
memory is used by the stripe cache.  I've seen users who believed the
value was in kilobytes of memory, whereas the truth is a bit more
complicated.  We could add a stripe_cache_kb entry (writeable even) to
make this clearer, and/or improve Documentation/md.txt.  Also, we
helpfully print the amount allocated when the array is first run():

		printk(KERN_INFO "raid5: allocated %dkB for %s\n",
			memory, mdname(mddev));

but we don't ever provide an update when it changes.  I don't think we
want to printk() every time someone changes the sysfs tunable though -
perhaps we should get rid of the message in run()?

> In the end I agree that having some kind of out_of_stripes
> notification would be useful.  However, I think it would make more
> sense to implement it as a "stripe_cache_active load average".  Then
> for a given workload the operator can see if there are spikes or
> sustained cache saturation.  What do you think?

That makes sense.  It would be a more meaningful number than our current
statistic, which is "at some point since you started the array, we had
to wait for a stripe N times."

I'll come up with a patch when I get the chance.

Cheers,
Jody
