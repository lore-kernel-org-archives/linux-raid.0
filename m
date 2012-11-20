From: NeilBrown <neilb@suse.de>
Subject: Re: Where can i download mdadm 3.3
Date: Wed, 21 Nov 2012 08:25:00 +1100
Message-ID: <20121121082500.411ea21b@notabene.brown>
References: <CAGmni9ozPTrqeg+RLBu=J8NEqqK95nwf0ymK7qA7DgpZNRHX=A@mail.gmail.com>
 <20121120122622.34f9bacd@notabene.brown>
 <CAGmni9oWcBYNyfKW4YQUPORRgz+hPM1tQ_jzWrOiNyZV2UmPEA@mail.gmail.com>
 <CAGmni9rkwQO4iHjg+tHSiPQm7Hx_y86cgBUfyio=HrR1Sp9TDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/her7qFwnSBsgFuL2IL=yHU1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGmni9rkwQO4iHjg+tHSiPQm7Hx_y86cgBUfyio=HrR1Sp9TDg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Salatiel Filho <salatiel.filho@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/her7qFwnSBsgFuL2IL=yHU1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Nov 2012 14:00:35 -0300 Salatiel Filho <salatiel.filho@gmail.com>
wrote:

> []'s
> Salatiel
>=20
>=20
> On Tue, Nov 20, 2012 at 8:02 AM, Salatiel Filho
> <salatiel.filho@gmail.com> wrote:
> > Thanks Neil !
> > []'s
> > Salatiel
> >
> >
> > On Mon, Nov 19, 2012 at 10:26 PM, NeilBrown <neilb@suse.de> wrote:
> >> On Sun, 18 Nov 2012 10:42:22 -0300 Salatiel Filho <salatiel.filho@gmai=
l.com>
> >> wrote:
> >>
> >>> Hi guys, i will be building a few arrays very soon and i'd like to
> >>> test the badblock feature and the replaceable feature, but i haven`t
> >>> found where i can download the source of mdadm 1.3. Where can i get it
> >>> ?
> >>>
> >> You can't.  3.3 doesn't exist yet.
> >>
> >> However
> >>   git clone git://neil.brown.name/mdadm
> >>   cd mdadm
> >>   make
> >>
> >> will get you code that supports bad blocks and replaceable devices.
> >>
> >> Alternately you can get a tar file at
> >>
> >>    http://git.neil.brown.name/git?p=3Dmdadm.git;a=3Dsnapshot;h=3Dmaster
> >>
> >> NeilBrown
>=20
> Forgot to send a copy to the list:
>=20
>=20
> Now the question, how do i enable badblock list ?
> # mdadm -A /dev/md1 /dev/sd[bcd]2 --update=3Dbbl  ?

Yes, I think that is right - does it work?

>=20
> I actually created also a new array
> # mdadm -C -n4 -l5 -e 1.2 /dev/md2 /dev/sd[bcde]3 ,
> but how do i verify if badblock support was enabled ?

mdadm -E /dev/sdb3

should show

   Bad Block Log : 512 entries available at offset xxx sectors

NeilBrown

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/her7qFwnSBsgFuL2IL=yHU1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKv1LDnsnt1WYoG5AQI+0A//fYGK6k4i5lql2LrX2KT7VKfT8YuKPixC
mn5+dF1LwWyerI1XZhdzclgFH6VnGMHr2grhNBbodeL9q4yQlSl5vqT0d/Na/mdL
3MyuKgZbDQQ4uejeHUL9WLcPiIgBlae82tz1VyazAO4HckevUGu8I+BKr1/QBc10
HzuS+6M+uJprboG8NO/i2O7A8BFIhIgGGNKYolKhGdVWnCeOKIPWUD9BwHEAAy3X
mWQwytddRhO4SeF2Nfgz1H42jUMlV1Ar3HqF0/zr5dm33WIk8lyA6X3m57Smk2ll
pJJFFSKzKgBqTGbDdb4nF+b4+d9Cy0gIOVPtVQiCnW7RJ31aVwHlqex6C2VfwFzO
BZn+OxUPylYgHVGpUOE1uPezXWwdiagLXNySijFvO3GkAKpRMNRmU1ntvqgYTTpV
ZNUpz/9h5vuKrFOZpmd6YH+2xEbgANODM+leAlLrS2CgMl6H3FgOCHGnJZl/PIBC
IKOy6gA+LP5sKPxXaad6Lc188qS8gk+TlTZ9vWKa6CCTry49ULQDOol/DaKUFkPt
LVBZe57w1xuFxMThg+LsmtDPnSjnEmUpkgc5hQ+u2xXhgxJadbd9t6Vn8m8seB2p
gytG8YzYSSriHAb/s7px7KADi4bCPAQOFSaERViCurmzGH0dJ9f8ipKHPtFJw5Xb
PsC57zsOVzM=
=gA8O
-----END PGP SIGNATURE-----

--Sig_/her7qFwnSBsgFuL2IL=yHU1--
