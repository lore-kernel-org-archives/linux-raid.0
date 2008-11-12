From: Doug Ledford <dledford@redhat.com>
Subject: Re: Fedora 9 install using md RAID
Date: Wed, 12 Nov 2008 13:30:48 -0500
Message-ID: <1226514649.4765.108.camel@firewall.xsintricity.com>
References: <491A5165.5080004@sauce.co.nz>
	 <1226505384.4765.70.camel@firewall.xsintricity.com>
	 <72dbd3150811121026k21ee2c01g12dcfe263e3ca383@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rUBkglcZIA5zyxL3jvXA"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dbd3150811121026k21ee2c01g12dcfe263e3ca383@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: Richard Scobie <richard@sauce.co.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-rUBkglcZIA5zyxL3jvXA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-12 at 10:26 -0800, David Rees wrote:
> On Wed, Nov 12, 2008 at 7:56 AM, Doug Ledford <dledford@redhat.com> wrote=
:
> > On Wed, 2008-11-12 at 16:45 +1300, Richard Scobie wrote:
> >> Slightly off topic, but I was wondering if anyone knew how I could do =
an
> >> install of Fedora 9 WITHOUT it using dm RAID.
> >>
> >> I have done a number of md RAID installs of Fedora 9, but this
> >> particular machine has a Silicon Image controller that the Redhat
> >> installer obviously recognises and automatically proceeds to install
> >> using dmraid and I would prefer to use md.
> >
> > At the boot prompt, pass the nodmraid option.  There are a number of
> > options available, you can get the entire list by installing anaconda,
> > then running anaconda --help on a working system.  Any options the
> > kernel doesn't know just get passed on to anaconda.
>=20
> Is nodmraid enough? For some reason on a recent system I installed F10
> Preview on I seemed to have to specify both nodmraid and nompath to
> get multipath from taking over...
>=20
> It would be a lot easier if you could choose which you wanted during
> install time instead of having to figure out boot parameters.

That's a valid point.  Feel free to file an RFE against Anaconda in
Fedora's bugzilla (bugzilla.redhat.com).

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-rUBkglcZIA5zyxL3jvXA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkbINgACgkQTzP9PM7pjw/T2gCfQR+GGZQajuW5Muy6tGTWJXQB
36EAn3DLsutjC6fM32ME370Ihat/hGr7
=Gncg
-----END PGP SIGNATURE-----

--=-rUBkglcZIA5zyxL3jvXA--

