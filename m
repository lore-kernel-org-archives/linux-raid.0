From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Fwd: mismatches in raid1, clarification please
Date: Tue, 11 Jun 2013 17:09:40 +0100
Message-ID: <20130611160940.GB22861@cthulhu.home.robinhill.me.uk>
References: <CAHOfOo1Ex+JsJ3NDzyKxAkabBMY4up0apftMK=mVwS4rw_E+Bg@mail.gmail.com>
 <CAHOfOo0gjhXV701kwHcLS4-VYvxCnpLZp76P7hc_-e_g6vi-BA@mail.gmail.com>
 <20130611151724.GA22861@cthulhu.home.robinhill.me.uk>
 <CAHOfOo0g9ACH2V_L-_SPXoT7Zd1srJu3av339sjipZDAa9RwxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3lcZGd9BuhuYXNfi"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHOfOo0g9ACH2V_L-_SPXoT7Zd1srJu3av339sjipZDAa9RwxA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Brooks <arb@sat.dundee.ac.uk>
Cc: Linux-RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Jun 11, 2013 at 04:39:56PM +0100, Andrew Brooks wrote:

> On 11 June 2013 16:17, Robin Hill <robin@robinhill.me.uk> wrote:
> >> If there has been no read error then how does it know which block is g=
ood?
> >>
> > It doesn't. I'm not sure what the algorithm is to pick which disk to use
> > as the reference value
>=20
> I wonder if someone on this list will know or whether I should ask on
> the kernel list.
>=20
Neil will know, and others may well be able to make more sense of the
kernel code than I can.

> > but one disk is picked and that data is then written to the other mirro=
rs.
> > It's not ideal
>=20
> No kidding, it potentially catastrophic ;-)
>=20
> The manual says "It is conceivable for a similar situation to occur on
> non-swap files, though it is less likely."
> but doesn't elaborate on the possible causes.
>=20
My understanding is that the in-memory data is not locked, so can be
modified in-between writes to the separate devices. You therefore get
different data written to the devices. Normally this will be rewritten
to any devices which were written before the change but, if the data is
then deleted, this doesn't happen. This is pretty common for swap
data, and other applications could also manage data/memory in the same
way and trigger the same situation. It's not important though as the
data written to disk is no longer referenced within the filesystem.

> Also "Thus the mismatch_cnt value can not be interpreted very reliably on=
 RAID1"
> but if you see it on a non-swap partition then surely it's a very
> serious problem?
>=20
It shouldn't be, no. If the data was written correctly to disk then the
mismatches should be irrelevant. If the data was mangled between the CPU
and the disk surface then it's a different matter. There's no way for
the md subsystem to know what the hardware layout is and which data
would be more accurate though, so the repair process merely ensures that
the array is in sync. The added complexity to try to deal with what
should be exceedingly rare circumstances would seem not to be felt to be
worth it.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--3lcZGd9BuhuYXNfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iEYEARECAAYFAlG3S8MACgkQShxCyD40xBJuvwCgjEFhkl287xxuvUy0ByL3AQzQ
AiMAnAw1br8rsOPp9PqPukBwxm3OPpzb
=Em7h
-----END PGP SIGNATURE-----

--3lcZGd9BuhuYXNfi--
