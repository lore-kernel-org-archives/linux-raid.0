From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: [patch 0/3 v3] MD: improve raid1/10 write performance for fast storage
Date: Fri, 29 Jun 2012 00:02:30 -0300
Message-ID: <CABYL=Tqy4wiX6SBwuy2thLRDeMiys3r=Ebqp+Co3_pWoR_7WBQ@mail.gmail.com>
References: <20120613091143.508417333@kernel.org>
	<20120628190352.4dc1dd76@notabene.brown>
	<4FED04F1.8010902@hardwarefreak.com>
	<20120629125256.31de1c2b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120629125256.31de1c2b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: stan@hardwarefreak.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

kkk 1024 cores
i will mark this email and go back when i get one 1024cores cpu maybe
just some 2 years? 10 years?

2012/6/28 NeilBrown <neilb@suse.de>
>
> On Thu, 28 Jun 2012 20:29:21 -0500 Stan Hoeppner <stan@hardwarefreak.=
com>
> wrote:
>
> > On 6/28/2012 4:03 AM, NeilBrown wrote:
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
> >
> >
> > > I still don't like the per-cpu allocations and the extra work que=
ues.
> >
> > Why don't you like this method Neil? =A0Complexity? =A0The performa=
nce seems
> > to be there.
> >
>
> Not an easy question to answer. =A0It just doesn't "taste" nice.
> I certainly like the performance and if this is the only way to get t=
hat
> performance then we'll probably go that way. =A0But I'm not convinced=
 it is the
> only way and I want to explore other options first.
> I guess it feels a bit heavy handed. =A0On machines with 1024 cores, =
per-cpu
> allocations and per-cpu threads are not as cheap as they are one 2-co=
re
> machines. =A0And I'm hoping for a 1024-core phone soon :-)
>
> NeilBrown
>



--
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
