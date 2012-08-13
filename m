From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 2/2 v3]raid5: create multiple threads to handle stripes
Date: Mon, 13 Aug 2012 14:21:16 +1000
Message-ID: <20120813142116.24cb6ab5@notabene.brown>
References: <20120809085808.GB30111@kernel.org>
	<201208111645321254409@gmail.com>
	<CANejiEVNPv6qVJ1nsvt21VMF8Py=3L8sABh9wab9eCQfdRAGeA@mail.gmail.com>
	<201208130906432967842@gmail.com>
	<20120813021324.GB447@kernel.org>
	<CANejiEUoguBD8PRAAuj=ATk+gd0RAqCTNjV12odSChejX-+R6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/p94NWsB.=xEdM0Z3OL6ZG=d"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANejiEUoguBD8PRAAuj=ATk+gd0RAqCTNjV12odSChejX-+R6Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Jianpeng Ma <majianpeng@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@gmail.com>
List-Id: linux-raid.ids

--Sig_/p94NWsB.=xEdM0Z3OL6ZG=d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Aug 2012 10:20:01 +0800 Shaohua Li <shli@kernel.org> wrote:


> >> >> 1:print cpulist of auxth, you maybe lost print the '\n'.
> >> >> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> >> index 7c8151a..3700cdc 100644
> >> >> --- a/drivers/md/raid5.c
> >> >> +++ b/drivers/md/raid5.c
> >> >> @@ -4911,9 +4911,13 @@ struct raid5_auxth_sysfs {
> >> >>  static ssize_t raid5_show_thread_cpulist(struct mddev *mddev,
> >> >>         struct raid5_auxth *thread, char *page)
> >> >>  {
> >> >> +       int n;
> >> >>         if (!mddev->private)
> >> >>                 return 0;
> >> >> -       return cpulist_scnprintf(page, PAGE_SIZE, &thread->work_mas=
k);
> >> >> +       n =3D cpulist_scnprintf(page, PAGE_SIZE - 2, &thread->work_=
mask);
> >> >> +       page[n++] =3D '\n';
> >> >> +       page[n] =3D 0;
> >> >> +       return n;
> >> >>  }
> >> >>
> >> >>  static ssize_t
> >> >
> >> >some sysfs entries print out '\n', some not, I don't mind add it
> >> I search kernel code found places which like this print out '\n';
> >> Can you tell rule which use or not?
> >> Thanks!
> >
> > I'm not aware any rule about this

I can provide a rule if it helps:
  sysfs files must *always* end with '\n' unless they are empty.

NeilBrown

--Sig_/p94NWsB.=xEdM0Z3OL6ZG=d
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCiAvDnsnt1WYoG5AQIJSw//flSqf3ScW1yB/pMx0Bd3qQlCa+Mg0d9U
cGWZHPZoEQY5SvdyrZm7yyTm2WN2pIdIUC6Vwc8F5DITmzoO6pJ2iNjiQdm7d9+n
6omcKGG2ERlB7HRxMICtwU7WuDwiwPy4MV++XV5pm1/jMo+27o2DjdwPR57jVczb
PQH51yourBckW6yQQKvf6YEIWe7AWraC5w9udw8sarGWsY5fU8D2hNr+E+JbhJhB
fM+VjprnkIe8BaBBUCHfW/LH3aEuGWBJ12/TBne/XVpUCBHLoG77YeleRtkMuGOn
o/mw+EsRT4FW0imzAFcgPMvXzTupslBtYEXtq1gZD3rK5pV4JwdGGMQcUx+R0GPb
a84+gbt0KGNRqV/HlcV7LXNt+fRHxgOF2F1S3ghKk7BM/SEkGgUSoVL/XJ+Vy9Wp
kbHQQEKnWGWXJtwzLG83HFu13PMtcL+1jtFGBrxBdQ5Qqgrtw7I2yp8PH3M6RV5P
Zz7NZ6Bf2Y05vdTGygzXKd6Hoem51flR5YQprvvd8jYqoBjyedpsb7TWBAzEcbhE
nu3SC1Urk7ZadbNcfSyhO1VOPO2lYrmK4BltDvz/xpZOtUbhJR3jDScUfmL9RecU
/QhpzovOck0+qIcEkgxKdBTILNBfP8EipXAuoTFuTra29o/pKugnux3ad5PpL/2E
w2o6o16opeY=
=02mL
-----END PGP SIGNATURE-----

--Sig_/p94NWsB.=xEdM0Z3OL6ZG=d--
