From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 05/11] md/raid5: add scribble region for buffer lists
Date: Fri, 5 Jun 2009 12:19:07 -0700
Message-ID: <e9c3a7c20906051219x122f443dtc7836f0c16ae9f27@mail.gmail.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519005951.4104.27062.stgit@dwillia2-linux.ch.intel.com>
	 <18983.26015.413162.445846@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18983.26015.413162.445846@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, maan@systemlinux.org, linux-kernel@vger.kernel.org, yur@emcraft.com, hpa@zytor.com
List-Id: linux-raid.ids

On Wed, Jun 3, 2009 at 11:11 PM, Neil Brown<neilb@suse.de> wrote:
> On Monday May 18, dan.j.williams@intel.com wrote:
>> Hang some memory off of each stripe_head which can be used for stori=
ng
>> the buffer lists used in parity calculations. =A0Include space for d=
ma
>> address conversions and pass that to async_tx via the
>> async_submit_ctl.scribble pointer.
>>
>> [ Impact: move memory pressure from stack to heap ]
>
> I've finally had a look at this and I cannot say that I like it.
>
> We don't really need one scribble-buffer per stripe_head.
> And in fact, that isn't even enough because you find you need a mutex
> to avoid multiple-use.

The mutex is probably not necessary, just need to audit the
stripe_operations state machine to make sure threads don't overlap in
raid_run_ops()...  but the point is mute when we move to per-cpu
resources.

> We really want one scribble-buffer per thread, or per CPU, or
> something like that.

One of the design goals was to prevent the occurrence of the
softlockup watchdog events which seem to trigger on large raid6
resyncs.  A per-cpu scheme would still require preempt_disable() while
the calculation is active, so perhaps we just need a call to
cond_resched() in raid5d to appease the scheduler.

> You could possibly handle it a bit like ->spare_page, though we cope
> with that being NULL some times, and you might not be able to do that
> with scribble-buffer.
> How do the async-raid6 patches cope with possible multiple users of
> ->spare_page now that the computations are async and so possible in
> parallel?

Currently the code just takes a spare page lock.

>
> Maybe a little mempool would be best?.... though given that in most
> cases, the stack solution is really quite adequate it would be good t=
o
> make sure the replacement isn't too heavy-weight....
>
> I'm not sure what would be best, but I really don't like the current
> proposal.
>

I'll take a look at a per-cpu implementation.

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
