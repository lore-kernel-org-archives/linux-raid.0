From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Wed, 23 May 2012 23:55:05 -0300
Message-ID: <CABYL=Tqam2mhg51ByJ9zLk3Ni_FEAdfxTjrqUfmMWJoZw=_-9A@mail.gmail.com>
References: <4FAAE8F1.8000600@pocock.com.au>
	<CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com>
	<4FABC7C6.4030107@turmel.org>
	<4FAC2FF2.5060305@hardwarefreak.com>
	<4FAC40BC.1060300@hesbynett.no>
	<CABYL=ToORULrdhBVQk0K8zQqFYkOomY-wgG7PpnJnzP9u7iBnA@mail.gmail.com>
	<4FACBB68.2080304@hesbynett.no>
	<4FACCAC8.4020206@pocock.com.au>
	<4FAD9283.7020809@hardwarefreak.com>
	<CAGqmV7oJg8vwKPJEYJhPANzaN-xxVW6Lw2gLTEKmMfG=pqCHuA@mail.gmail.com>
	<4FBA8EA9.40203@hardwarefreak.com>
	<20120522093404.3ffaae42@notabene.brown>
	<4FBB33D6.4010101@hardwarefreak.com>
	<20120524121020.3349c402@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120524121020.3349c402@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: stan@hardwarefreak.com, CoolCold <coolthecold@gmail.com>, Daniel Pocock <daniel@pocock.com.au>, David Brown <david.brown@hesbynett.no>, Phil Turmel <philip@turmel.org>, Marcus Sorensen <shadowsor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

nice, so...
write is single thread and read multi thread
any performace test / results?

2012/5/23 NeilBrown <neilb@suse.de>
>
> On Tue, 22 May 2012 01:36:06 -0500 Stan Hoeppner <stan@hardwarefreak.=
com>
> wrote:
>
> > On 5/21/2012 6:34 PM, NeilBrown wrote:
> > > On Mon, 21 May 2012 13:51:21 -0500 Stan Hoeppner <stan@hardwarefr=
eak.com>
> > > wrote:
> > >
> > >> On 5/21/2012 10:20 AM, CoolCold wrote:
> > >>> On Sat, May 12, 2012 at 2:28 AM, Stan Hoeppner <stan@hardwarefr=
eak.com> wrote:
> > >>>> On 5/11/2012 3:16 AM, Daniel Pocock wrote:
> > >>>>
> > >>> [snip]
> > >>>> That's the one scenario where I abhor using md raid, as I ment=
ioned. =A0At
> > >>>> least, a boot raid 1 pair. =A0Using layered md raid 1 + 0, or =
1 + linear
> > >>>> is a great solution for many workloads. =A0Ask me why I say ra=
id 1 + 0
> > >>>> instead of raid 10.
> > >>> So, I'm asking - why?
> > >>
> > >> Neil pointed out quite some time ago that the md RAID 1/5/6/10 c=
ode runs
> > >> as a single kernel thread. =A0Thus when running heavy IO workloa=
ds across
> > >> many rust disks or a few SSDs, the md thread becomes CPU bound, =
as it
> > >> can only execute on a single core, just as with any other single=
 thread.
> > >
> > > This is not the complete truth.
> >
> > Yes, I should have stipulated only writes are limited to a single t=
hread.
> >
> > > For RAID1 and RAID10, successful IO requests do not involved the =
kernel
> > > thread, so the fact that there is only one should be irrelevant.
> > > Failed requests are retried using the thread and it is also invol=
ved it
> > > resync/recovery so those processes may be limited by the single t=
hread.
> > >
> > > RAID5/6 does not use the thread for read requests on a non-degrad=
ed array.
> > > However all write requests go through the single thread so there =
could be
> > > issues there.
> >
> > Thanks for clarifying this. =A0In your previous response to this is=
sue
> > (quoted and linked below) you included RAID 1/10 with RAID 5/6 WRT
> > writes going through a single thread.
> >
> > > Have you =A0actually measured md/raid10 being slower than raid0 o=
ver raid1?
> >
> > I personally have not, as I don't have access to the storage hardwa=
re
> > necessary to sink a sufficiently large write stream to peak a core =
with
> > the md thread.
> >
> > > I have a vague memory from when this came up before that there wa=
s some extra
> > > issue that I was missing, but I cannot recall it just now....
> >
> > We're recalling the same thread, which was many months ago. =A0Here=
's your
> > post: =A0http://marc.info/?l=3Dlinux-raid&m=3D132616899005148&w=3D2
> >
> > And here's the relevant section upon which I was basing my recent
> > statements:
> >
> > "I think you must be misremembering. =A0Neither RAID0 or Linear hav=
e any
> > threads involved. =A0They just redirect the request to the appropri=
ate
> > devices. =A0Multiple threads can submit multiple requests down thro=
ugh
> > RAID0 and Linear concurrently.
> >
> > RAID1, RAID10, and RAID5/6 are different. =A0For reads they normall=
y are
> > have no contention with other requests, but for writes things do ge=
t
> > single-threaded at some point."
> >
>
> That's right - I keep forgetting about the single-threading caused by=
 needing
> to sync with bitmap updates.
>
> So reads a fully parallel. =A0Writes are - for now - serialised to a =
single
> processor for handling.
>
> Thanks,
> NeilBrown




--
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
