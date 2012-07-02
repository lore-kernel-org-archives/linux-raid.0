From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 0/3 v3] MD: improve raid1/10 write performance for fast
 storage
Date: Mon, 2 Jul 2012 15:36:45 +0800
Message-ID: <20120702073645.GA785@kernel.org>
References: <20120613091143.508417333@kernel.org>
 <20120628190352.4dc1dd76@notabene.brown>
 <CANejiEWfR1S+F5GT7Bxhi2ig8ef7ZziAbVebM_DT3-_3hftYUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANejiEWfR1S+F5GT7Bxhi2ig8ef7ZziAbVebM_DT3-_3hftYUw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

On Fri, Jun 29, 2012 at 02:10:30PM +0800, Shaohua Li wrote:
> 2012/6/28 NeilBrown <neilb@suse.de>:
> > On Wed, 13 Jun 2012 17:11:43 +0800 Shaohua Li <shli@kernel.org> wro=
te:
> >
> >> In raid1/10, all write requests are dispatched in a single thread.=
 In fast
> >> storage, the thread is a bottleneck, because it dispatches request=
 too slow.
> >> Also the thread migrates freely, which makes request completion cp=
u not match
> >> with submission cpu even driver/block layer has such capability. T=
his will
> >> cause bad cache issue. Both these are not a big deal for slow stor=
age.
> >>
> >> Switching the dispatching to percpu/perthread based dramatically i=
ncreases
> >> performance. =A0The more raid disk number is, the more performance=
 boosts. In a
> >> 4-disk raid10 setup, this can double the throughput.
> >>
> >> percpu/perthread based dispatch doesn't harm slow storage. This is=
 the way how
> >> raw device is accessed, and there is correct block plug set which =
can help do
> >> request merge and reduce lock contention.
> >>
> >> V2->V3:
> >> rebase to latest tree and fix cpuhotplug issue
> >>
> >> V1->V2:
> >> 1. droped direct dispatch patches. That has better performance imp=
orvement, but
> >> is hopelessly made correct.
> >> 2. Add a MD specific workqueue to do percpu dispatch.
> >
> >
> > Hi.
> >
> > I still don't like the per-cpu allocations and the extra work queue=
s.
> >
> > The following patch demonstrates how I would like to address this i=
ssue. =A0It
> > should submit requests from the same thread that initially made the=
 request -
> > at least in most cases.
> >
> > It leverages the plugging code and pushed everything out on the unp=
lug,
> > unless that comes from a scheduler call (which should be uncommon).=
 =A0In that
> > case it falls back on passing all the requests to the md thread.
> >
> > Obviously if we proceed with this I'll split this up into neat revi=
ewable
> > patches. =A0However before that it would help to know if it really =
helps as I
> > think it should.
> >
> > So would you be able to test it on your SSD hardware and see how it=
 compares
> > the current code, and to you code? =A0Thanks.
> >
> > I have only tested it lightly myself so there could still be bugs, =
but
> > hopefully not obvious ones.
> >
> > A simple "time mkfs" test on very modest hardware show as 25% reduc=
tion in
> > total time (168s -> 127s). =A0I guess that's a 33% increase in spee=
d?
> > However sequential writes with 'dd' seem a little slower (14MB/s ->=
 13.6MB/s)
> >
> > There are some hacks in there that need to be cleaned up, but I thi=
nk the
> > general structure looks good.
>=20
> Thought I consider this approach before, and schedule from the unplug
> callback is an issue. Maybe I overlooked it at that time, the from_sc=
hedule
> check looks promising.

I tried raid1/raid10 performance with this patch (with similar change f=
or
raid10, and add plug in the raid1/10 unplug function for dispatching), =
the
result is ok. The from_schedule check does the trick, there isn't race =
I
mentioned before. And I double checked the rate unplug is called from s=
chedule,
which is very very low.

Now the only problem is if extra bitmap flush could be an overhead. Our=
 card
hasn't such overhead, so not sure.

Thanks,
Shaohua
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
