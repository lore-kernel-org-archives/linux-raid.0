From: Neil Brown <neilb@suse.de>
Subject: Re: Problem re-shaping RAID6
Date: Thu, 17 Jun 2010 15:47:08 +1000
Message-ID: <20100617154708.227cd303@notabene.brown>
References: <AANLkTikv3JPbto1F2YYmRx0HNP7cgFh3gj6dHekCt1SE@mail.gmail.com>
	<20100614091518.2492a9db@notabene.brown>
	<20100614124723.84152dz5al8096f4@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100614124723.84152dz5al8096f4@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: Nagilum <nagilum@nagilum.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 14 Jun 2010 12:47:23 +0200
Nagilum <nagilum@nagilum.org> wrote:

>=20
> ----- Message from neilb@suse.de ---------
>      Date: Mon, 14 Jun 2010 09:15:18 +1000
>      From: Neil Brown <neilb@suse.de>
>   Subject: Re: Problem re-shaping RAID6
>        To: J=C3=A9r=C3=B4me Poulin <jeromepoulin@gmail.com>
>        Cc: linux-raid <linux-raid@vger.kernel.org>
>=20
>=20
> > Thanks.
> > I fixed this bug a slightly different way
> >
> > -               blocks =3D ochunk/512 * nchunk/512 * odata * ndata =
/ a;
> > +               blocks =3D (ochunk/512) * (nchunk/512) * odata * nd=
ata / a;
> >
> >
> > See
> > http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff;h=3D200871adf9e=
15d5ad985f28c349fd89c386ef48a
>=20
> Those static numbers always make my nose wrinkle.
> Don't we have the blocksize somewhere already? I'm also concerned wha=
t =20
> happens when true 4k sectors are used..
>=20

A sector will always be 512 bytes to Linux, even when we have drives th=
at can
only do IO in multiples of 8 sectors.  Changing that would cause way to=
 many
headaches.

Yes,  I could possibly use a define for '512'.  Some times that is
appropriate, but I thing 512 is so clearly "bytes_per_sector" it would =
just
add an unnecessary level of indirection.
It is a question of taste really - no right answers.

Thanks,
NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
