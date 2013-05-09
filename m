From: NeilBrown <neilb@suse.de>
Subject: Re: 0.90 vs 1.X - Differing behavior for device # during
 fail/remove/add operation
Date: Fri, 10 May 2013 07:29:06 +1000
Message-ID: <20130510072906.6d457c29@notabene.brown>
References: <CAFfJ-R58bqNKL+Q1Htp=KDzARi1GLamW9B7idFjnL+h6tYArkw@mail.gmail.com>
	<CAFfJ-R6Fgz+Mye2FX5D-+uaM0jgUe2j4nnE1ACyCwwk=9X-KPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2BKdMHBgjqU+6Gqd.yEZoQb"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFfJ-R6Fgz+Mye2FX5D-+uaM0jgUe2j4nnE1ACyCwwk=9X-KPQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dusty Mabe <dustymabe@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/2BKdMHBgjqU+6Gqd.yEZoQb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 9 May 2013 11:30:26 -0400 Dusty Mabe <dustymabe@gmail.com> wrote:

> On Wed, May 8, 2013 at 1:39 PM, Dusty Mabe <dustymabe@gmail.com> wrote:
> > CentOS 6.3
> > 2.6.32-279.19.1
> > mdadm-3.2.3-9.el6.x86_64
> >
> >
> > I have noticed that the device number printed in the mdstat file gets
> > changed if you fail->remove->add a member device of a 1.X metadata
> > array, but for a 0.90 metadata array the device will go back to the
> > original value once recovery has finished.
> >
> >
> > Is this by design? I know 1.X version of metadata use dev_roles rather
> > than this_disk and the mdp_disk_t structure so maybe it is by design?
> >
>=20
> Hey guys.. Sorry to be a pain. Has anyone seen this before? Is it by
> design or a known issue?
>=20
It is an unfortunate consequence of incoherent design.
I've occasionally wondered if I should "fix" it.

NeilBrown

--Sig_/2BKdMHBgjqU+6Gqd.yEZoQb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUYwVIjnsnt1WYoG5AQInWQ//VeNjwKfk8q1NHuo+GjaFOUJZP8Vb76Ki
wmkSWxb582DXFI3F1b1xrCiVPOsvXTCkE/AM3AvFxtEEtRdAy0YEUZ9nzgZKdeEm
PurtmI2HHSqlbx0reJGOGzJoypNYHyZeqkdmoATHN0j+IoySyI0elEEAzOKul6sT
XGAZllnpzuPBrNJxdL9Mk9NzmpUazQsWAUbIRDlw+tAkiLe4SxyoB/21zdgJuiss
HQvfXgwQyIYZ+1QjQvQ8AsVZhevmWrSXDdmZBUUWwphSRhEA4g6qT1DIzmk5VFHs
2nDeAKJo2WUKALsBdV5sXEge8VGQB37DlP8WP4LgUn2crhg7cfRsXy1SSrjlFbH/
77Rh6OFwPGqDd4u5WwDE0M4fPiMGTM7S9vnGaBUcs4er5C7AjajHRMaWyMZM68UD
D096SSKgTN9MHTF2mn7a50Mkfe2nz1p43XBudutTVAlHMn3AH9XiOm1LQ9hDInOS
e0wK5/AU/RmlhDt3sE04x+ZZFVMfwDakSvjb3qirK3mOgvTAx/Xgwv85c2LCZXfP
QAMIY4biK8sgx9IcFhkWQmHr17VV5xB1yyp0NHj2U1oerTwe+gkWNkkXJ8wlDqQ2
xTuPkx2SaxLFv/O4GRelaMZPmDJq+qgquBgVa72BvOjZA+4JPNruQTiOimeK5zhE
JwKaL9x/b8s=
=NWNP
-----END PGP SIGNATURE-----

--Sig_/2BKdMHBgjqU+6Gqd.yEZoQb--
