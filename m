From: Rik Herrin <rikherrin@yahoo.com>
Subject: Re: Linux RAID Enterprise-Level Capabilities and If It Supports Raid Level Migration and Online Capacity Expansion
Date: Thu, 29 Dec 2005 03:30:32 -0800 (PST)
Message-ID: <20051229113032.23937.qmail@web52909.mail.yahoo.com>
References: <Pine.LNX.4.58.0512221625480.13179@lajli.gau.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0512221625480.13179@lajli.gau.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Lajber Zoltan <lajbi@lajli.gau.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Lajber.  Sorry for taking so long to reply but
it's been a busy week.  Your test benchmarks look
interesting.  Do they take into consideration the
random seeks that Molle mentioned in his email?  As
Molle mentioned: "I've seen lots of MD tests, but none
that covered profiling MD's random access
performance".  Does this cover MD's random access
performance? =20

Also, have you thought of using iometer
(http://www.iometer.org) and comparing it's results
with bonnie++'s results?  Just a thought...

Thanks for your time...

--- Lajber Zoltan <lajbi@lajli.gau.hu> wrote:

> Hi,
>=20
> On Thu, 22 Dec 2005, Rik Herrin wrote:
>=20
> > 	1) OCE: Online Capacity Expansion:  From the
> latest
> > version of mdadm (v2.2), it ssems that there is
> > support for it with the -G option.  How well
> tested is
>=20
> Well, we use LVM above raid, thins is not a big
> issue.
>=20
> > 	3) Performance issues:  I'm currently thinking of
>=20
> I have some simple test with bonnie++, the sw raid
> superior to hw raid,
> except big-name storage systems.
> http://zeus.gau.hu/~lajbi/diskbenchmarks.txt
>=20
> > 	4) Would anyone recommend a certain hotswap
> > enclosure?
>=20
> We used ibm xseries and sun machines. The hotswap
> working well, but the
> number of drives very limited.
>=20
> Take a look at http://www.coraid.com : very well
> scalable, cheap storage.
>=20
> Bye,
>
-=3DLajbi=3D-----------------------------------------------------------=
-----
>  LAJBER Zoltan               Szent Istvan Egyetem,=20
> Informatika Hivatal
>  Most of the time, if you think you are in trouble,
> crank that throttle!
>=20



	=09
__________________________________________=20
Yahoo! DSL =96 Something to write home about.=20
Just $16.99/mo. or less.=20
dsl.yahoo.com=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
