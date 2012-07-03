From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 0/3 v3] MD: improve raid1/10 write performance for fast
 storage
Date: Tue, 3 Jul 2012 16:58:58 +0800
Message-ID: <20120703085858.GA829@kernel.org>
References: <20120613091143.508417333@kernel.org>
 <20120628190352.4dc1dd76@notabene.brown>
 <CANejiEWfR1S+F5GT7Bxhi2ig8ef7ZziAbVebM_DT3-_3hftYUw@mail.gmail.com>
 <20120702073645.GA785@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120702073645.GA785@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

On Mon, Jul 02, 2012 at 03:36:45PM +0800, Shaohua Li wrote:
> On Fri, Jun 29, 2012 at 02:10:30PM +0800, Shaohua Li wrote:
> > 2012/6/28 NeilBrown <neilb@suse.de>:
> > > On Wed, 13 Jun 2012 17:11:43 +0800 Shaohua Li <shli@kernel.org> w=
rote:
> > >
> > >> In raid1/10, all write requests are dispatched in a single threa=
d. In fast
> > >> storage, the thread is a bottleneck, because it dispatches reque=
st too slow.
> > >> Also the thread migrates freely, which makes request completion =
cpu not match
> > >> with submission cpu even driver/block layer has such capability.=
 This will
> > >> cause bad cache issue. Both these are not a big deal for slow st=
orage.
> > >>
> > >> Switching the dispatching to percpu/perthread based dramatically=
 increases
> > >> performance. =A0The more raid disk number is, the more performan=
ce boosts. In a
> > >> 4-disk raid10 setup, this can double the throughput.
> > >>
> > >> percpu/perthread based dispatch doesn't harm slow storage. This =
is the way how
> > >> raw device is accessed, and there is correct block plug set whic=
h can help do
> > >> request merge and reduce lock contention.
> > >>
> > >> V2->V3:
> > >> rebase to latest tree and fix cpuhotplug issue
> > >>
> > >> V1->V2:
> > >> 1. droped direct dispatch patches. That has better performance i=
mporvement, but
> > >> is hopelessly made correct.
> > >> 2. Add a MD specific workqueue to do percpu dispatch.
> > >
> > >
> > > Hi.
> > >
> > > I still don't like the per-cpu allocations and the extra work que=
ues.
> > >
> > > The following patch demonstrates how I would like to address this=
 issue. =A0It
> > > should submit requests from the same thread that initially made t=
he request -
> > > at least in most cases.
> > >
> > > It leverages the plugging code and pushed everything out on the u=
nplug,
> > > unless that comes from a scheduler call (which should be uncommon=
). =A0In that
> > > case it falls back on passing all the requests to the md thread.
> > >
> > > Obviously if we proceed with this I'll split this up into neat re=
viewable
> > > patches. =A0However before that it would help to know if it reall=
y helps as I
> > > think it should.
> > >
> > > So would you be able to test it on your SSD hardware and see how =
it compares
> > > the current code, and to you code? =A0Thanks.
> > >
> > > I have only tested it lightly myself so there could still be bugs=
, but
> > > hopefully not obvious ones.
> > >
> > > A simple "time mkfs" test on very modest hardware show as 25% red=
uction in
> > > total time (168s -> 127s). =A0I guess that's a 33% increase in sp=
eed?
> > > However sequential writes with 'dd' seem a little slower (14MB/s =
-> 13.6MB/s)
> > >
> > > There are some hacks in there that need to be cleaned up, but I t=
hink the
> > > general structure looks good.
> >=20
> > Thought I consider this approach before, and schedule from the unpl=
ug
> > callback is an issue. Maybe I overlooked it at that time, the from_=
schedule
> > check looks promising.
>=20
> I tried raid1/raid10 performance with this patch (with similar change=
 for
> raid10, and add plug in the raid1/10 unplug function for dispatching)=
, the
> result is ok. The from_schedule check does the trick, there isn't rac=
e I
> mentioned before. And I double checked the rate unplug is called from=
 schedule,
> which is very very low.
>=20
> Now the only problem is if extra bitmap flush could be an overhead. O=
ur card
> hasn't such overhead, so not sure.

Looks you merged the patch to your tree, great! The raid1_unplug() stil=
l lacks
blk_start_plug/blk_finish_plug. Will you add a similar patch for raid10=
?

Thanks,
Shaohua
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
