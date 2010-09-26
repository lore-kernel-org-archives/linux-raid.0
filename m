From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Accidental grow before add
Date: Sun, 26 Sep 2010 22:22:32 +0100
Message-ID: <20100926212232.GB5719@cthulhu.home.robinhill.me.uk>
References: <AANLkTi=PydpqTR1x=KTfW16en3U3+KxoLV85iWpWtRC9@mail.gmail.com>
 <AANLkTi=3MEirXZs_Qv7nO7fvAKxvErnkvAiEe8fdxQA=@mail.gmail.com>
 <AANLkTimPPD6TfoX7GVbaNgQo1CPpjc7LLG-nWDz7=En=@mail.gmail.com>
 <alpine.DEB.1.10.1009261159120.28005@uplift.swm.pp.se>
 <AANLkTikOr3LdZ_uy5Vnj=wu0k7Ag8A+LXRYwxf69YNOv@mail.gmail.com>
 <20100926103818.GA5719@cthulhu.home.robinhill.me.uk>
 <AANLkTi=iUUT_qZdg7gtxfroT+Y-c92SKQbhtUGhWwE=e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=iUUT_qZdg7gtxfroT+Y-c92SKQbhtUGhWwE=e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun Sep 26, 2010 at 03:34:17PM -0400, Mike Hartman wrote:

> >> At any rate, that doesn't help me with my most immediate issue: does a
> >> drive failing during a reshape corrupt the array? Or am I safe to
> >> resume the reshape? Is there any way to restore my safety net a bit
> >> before resuming the reshape, or will I just have to hope nothing else
> >> goes wrong between now and the time the new hot spare is finally
> >> incorporated?
> >>
> > Failure of a device during the reshape certainly shouldn't corrupt the
> > array (I don't see how it would anyway, unless there's a screw-up in the
> > code).
>=20
> I guess I was thinking that the reshape was restriping all the data
> under the assumption of 7 (or 8) drives, and one failing might change
> the restriping requirements in midstream and leave it in an
> unrecoverable in-between state. Very glad to hear that's not the case.
>=20
I've not looked at the code, so I can't be certain.  I'm pretty sure
I've had this happen to me during a reshape though, without any issues.

> > I don't think there's any way to "restore your safety net"
> > though (short of imaging all the drives as backups), but it's probably
> > worth while doing a read test of all member devices before you continue.
>=20
> Can you recommend a good way to perform such a read test? Would I just
> dd the entire contents of each disk to /dev/null or is there a more
> efficient way of doing it?
>=20
That's what I'd do anyway.  You could also try running a full SMART
test - that should pick up anything.  I'd still go with dd though, as
I'm more confident of what that's actually doing.

Good luck,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAkyfuZUACgkQShxCyD40xBJ0RQCg1xtdhwqNqocHgRghfjHe+hkv
zWMAn30vV1vg4HDx+szyIsgf+ox3F3RA
=vE0R
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--
