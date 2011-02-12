From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 array won't start
Date: Sat, 12 Feb 2011 12:03:25 +1100
Message-ID: <20110212120325.07d55a2c@notabene.brown>
References: <AANLkTimLfJHc2waPkvjUXn=mewc37qkCd-r0GG4k=e-D@mail.gmail.com>
	<AANLkTi=dtMbuszU3x_hGduN-y5ATbgD0tgby_2mj4YsH@mail.gmail.com>
	<20110212074904.41e113ed@notabene.brown>
	<AANLkTikmCmutS_96PNYR0RKAv07cG5Vje0kyzzQ7U9rd@mail.gmail.com>
	<20110212083224.6b1c2cee@notabene.brown>
	<AANLkTi=Y7zf9v6dobfWj-z97FSfkVk2FpWT9Yi4MMKMr@mail.gmail.com>
	<AANLkTi=em0Wkj48SOECZqSuyJ01AwDnDdE76aQPzWiTp@mail.gmail.com>
	<20110212115235.5e38c3db@notabene.brown>
	<AANLkTikY5AvGBTS_P88z_WzPVBqbmRfS0qxOo98vcb1Y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikY5AvGBTS_P88z_WzPVBqbmRfS0qxOo98vcb1Y@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christian <cjs703@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 11 Feb 2011 19:57:52 -0500 Christian <cjs703@gmail.com> wrote:

> # mdadm -V
> mdadm - v3.1.4 - 31st August 2010

So either I didn't fix it like I thought, or I subsequently broke it.

Could you send me the combined --examine output that you saved?
That might help me reproduce the exact problem, then add it to the
mdadm test suite.  Then fix it.

Thanks,
NeilBrown


>=20
> On Fri, Feb 11, 2011 at 7:52 PM, NeilBrown <neilb@suse.de> wrote:
> > On Fri, 11 Feb 2011 17:36:08 -0500 Christian <cjs703@gmail.com> wro=
te:
> >
> >> Here it is again, there were a few other messages in there at the =
beginning.
> >>
> >> [70745.855861] md: md1 stopped.
> >> [70745.859303] md: bind<sdm1>
> >> [70745.859576] md: bind<sdr1>
> >> [70745.859720] md: bind<sds1>
> >> [70745.860265] md: bind<sdq1>
> >> [70745.860428] md: bind<sdk1>
> >> [70745.860680] md: bind<sdf1>
> >> [70745.860839] md: bind<sdg1>
> >> [70745.860986] md: bind<sdl1>
> >> [70745.861169] md: bind<sde1>
> >> [70745.861359] md: bind<sdt1>
> >> [70745.861407] md: kicking non-fresh sds1 from array!
> >> [70745.861411] md: unbind<sds1>
> >> [70745.870570] md: export_rdev(sds1)
> >> [70745.870598] md: kicking non-fresh sdm1 from array!
> >
> > That shouldn't happen when you use -f ....
> >
> > Could be that you hit the mdadm bug fixed by commit =A067a8c82d606
> > which is in mdadm-2.6
> > What version of mdadm are you running???
> >
> > (I note you have got your data back by other means - good!)
> >
> > NeilBrown
> >

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
