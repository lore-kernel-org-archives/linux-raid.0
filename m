From: Christian <cjs703@gmail.com>
Subject: Re: RAID6 array won't start
Date: Fri, 11 Feb 2011 19:57:52 -0500
Message-ID: <AANLkTikY5AvGBTS_P88z_WzPVBqbmRfS0qxOo98vcb1Y@mail.gmail.com>
References: <AANLkTimLfJHc2waPkvjUXn=mewc37qkCd-r0GG4k=e-D@mail.gmail.com>
	<AANLkTi=dtMbuszU3x_hGduN-y5ATbgD0tgby_2mj4YsH@mail.gmail.com>
	<20110212074904.41e113ed@notabene.brown>
	<AANLkTikmCmutS_96PNYR0RKAv07cG5Vje0kyzzQ7U9rd@mail.gmail.com>
	<20110212083224.6b1c2cee@notabene.brown>
	<AANLkTi=Y7zf9v6dobfWj-z97FSfkVk2FpWT9Yi4MMKMr@mail.gmail.com>
	<AANLkTi=em0Wkj48SOECZqSuyJ01AwDnDdE76aQPzWiTp@mail.gmail.com>
	<20110212115235.5e38c3db@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110212115235.5e38c3db@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

# mdadm -V
mdadm - v3.1.4 - 31st August 2010

On Fri, Feb 11, 2011 at 7:52 PM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 11 Feb 2011 17:36:08 -0500 Christian <cjs703@gmail.com> wrote=
:
>
>> Here it is again, there were a few other messages in there at the be=
ginning.
>>
>> [70745.855861] md: md1 stopped.
>> [70745.859303] md: bind<sdm1>
>> [70745.859576] md: bind<sdr1>
>> [70745.859720] md: bind<sds1>
>> [70745.860265] md: bind<sdq1>
>> [70745.860428] md: bind<sdk1>
>> [70745.860680] md: bind<sdf1>
>> [70745.860839] md: bind<sdg1>
>> [70745.860986] md: bind<sdl1>
>> [70745.861169] md: bind<sde1>
>> [70745.861359] md: bind<sdt1>
>> [70745.861407] md: kicking non-fresh sds1 from array!
>> [70745.861411] md: unbind<sds1>
>> [70745.870570] md: export_rdev(sds1)
>> [70745.870598] md: kicking non-fresh sdm1 from array!
>
> That shouldn't happen when you use -f ....
>
> Could be that you hit the mdadm bug fixed by commit =A067a8c82d606
> which is in mdadm-2.6
> What version of mdadm are you running???
>
> (I note you have got your data back by other means - good!)
>
> NeilBrown
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
