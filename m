From: NeilBrown <neilb@suse.de>
Subject: Re: Breaks LSI RAID on C600 chipset
Date: Wed, 13 May 2015 10:35:57 +1000
Message-ID: <20150513103557.1df6036d@notabene.brown>
References: <CAGRSmLtoCz+wff+F=xnnusc5_bUYxWYT5V5iTncTnRfgRnTqtg@mail.gmail.com>
	<21791.17074.357416.218211@quad.stoffel.home>
	<CAGRSmLu5kEXA34mmHb5Q9+Fjmh5NFtRw2hrOrCDiOS4NR=5fvQ@mail.gmail.com>
	<21792.11560.92731.222551@quad.stoffel.home>
	<CAGRSmLt+1KJJHmMgoUHG0Dq0qg+38q5PRWnMNCRFg6qTa9s7gQ@mail.gmail.com>
	<21795.3296.846489.199118@quad.stoffel.home>
	<CAGRSmLtrp6Rh3pALL2Rr62jRRZQKFg-3SaV_AxubaHNhkeb0UA@mail.gmail.com>
	<20150410105001.171d6683@notabene.brown>
	<CAGRSmLvoj-UhV+8hSESQ+RRyzMHZ68QuBdRZzVU0PWEztZWeOw@mail.gmail.com>
	<CAGRSmLsxN_oGm9LQmDJSUVcTvVP7DzSAeWG+aaR+Td-OFc=c=A@mail.gmail.com>
	<CAGRSmLvdP8y1=KzG0j7Q9oc9HDGDgNGkSnhNLRUU1YXmLq3KDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/w98taIPE5j8lOL0hgwshx4n"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLvdP8y1=KzG0j7Q9oc9HDGDgNGkSnhNLRUU1YXmLq3KDg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David F." <df7729@gmail.com>
Cc: John Stoffel <john@stoffel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/w98taIPE5j8lOL0hgwshx4n
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 11 May 2015 09:31:26 -0700 "David F." <df7729@gmail.com> wrote:

> any progress or more information needed on this?
>=20
> On Mon, Apr 20, 2015 at 10:39 PM, David F. <df7729@gmail.com> wrote:
> > If you need access to the system, a network kvm is available - or if
> > you have a C600 based system, you should see the same problem there.
> >
> > On Fri, Apr 10, 2015 at 1:07 PM, David F. <df7729@gmail.com> wrote:
> >> Okay, and to confirm, this is happening on other C600 based systems.
> >> Boot to Linux with MDADM raid support and the raid is gone after
> >> reboot.
> >>
> >> On Thu, Apr 9, 2015 at 5:50 PM, NeilBrown <neilb@suse.de> wrote:
> >>> On Thu, 9 Apr 2015 14:13:05 -0700 "David F." <df7729@gmail.com> wrote:
> >>>
> >>>> Hello,
> >>>>
> >>>> I built a new system, installed new drives (no partitioning, just raw
> >>>> new drives), configured RAID 1, boot to linux, created reports
> >>>> attached.  Rebooted and the system doesn't see any configured raid
> >>>> drives (just the two raw drives).
> >>>
> >>> Thanks.  I might take a look, but I would greatly prefer it if you ke=
pt the
> >>> linux-raid list on the Cc.....
> >>>
> >>> NeilBrown
> >>>

I must confess that I haven't even looked at it.
But I just saw and email on linux-raid from Martin Wilck:

 Subject: [PATCH] DDF: _write_super_to_disk: fix anchor header type

which very likely fixes your problem.  I've applied it and pushed out to
   git://neil.brown.name/mdadm/

NeilBrown

--Sig_/w98taIPE5j8lOL0hgwshx4n
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVVKcbTnsnt1WYoG5AQLIGhAAgg+l6UZ+/HwBSzplgZUzp4fCaRSHZlqU
d1Yg32HDAkSjUnQ3m9gSrewXd0yhVoCt6g2KwX6uJFvuJ7VyNCSHU5MzF7xeMvWg
raMeC2CUPtQWJBSBLoDpQWy0A0cYD1r+FDk366EAvvtaEWTEGh+AC9GLFUf0rRDF
46jm2L68aMh6wZvus35dB7Gwn4VFMhT7nVRZEm+KKJxSBhFEt+Uo4EIwIrRTJO7A
g8URY26ICldGkQyQYOa/QI0ldNilz/bhVmE5EzP0WVM/R7RqxsB4elVFhp1wWspz
odr5/PQtE7SQMjdfZ8WGzAsB0CHFCt7pT41LyROpU4cZfLBCiLc0dzmX2JN4MXHU
Pdw2PJcZZU0G54jFZMgjfnr0vLwmr6Os10pAC/I2YCb8ut0kM1rlmdBvCcR3BdCY
JBg49rLJUO+9tW1VWTgaDiAKDK48R8fHGlz5TmyhlNbHbG8YdWMkOxevI+biZBLl
7wWcRAgEDPA067jJUwEA0XP6Roj+JcPSdLYl/nBFLvSbKwtNbL/XJ6EpWD/R4tB2
TnBsLIWN29WkVE+wScECuXE+zto10cBbvKCP4Tb2QVpDRD8TFdinDIygOuoAkXhX
3EEvgnwmrmkC4zjifF8dfibkjQFD2bh2LlF53c/Oc79JZD05bX7fgXEgbCT51GI/
1/GJLYF9B7Y=
=vqwn
-----END PGP SIGNATURE-----

--Sig_/w98taIPE5j8lOL0hgwshx4n--
