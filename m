From: NeilBrown <neilb@suse.de>
Subject: Re: unable to recover RAID 5 due to bad block
Date: Fri, 11 Nov 2011 07:09:20 +1100
Message-ID: <20111111070920.0d80e284@notabene.brown>
References: <4EBBF60F.4030606@northfolk.ca>
	<20111110172003.Horde.byVZeZk8pphOu-mzTQXxKL8@cakebox.homeunix.net>
	<4EBC00E6.3030404@northfolk.ca>
	<20111110180234.Horde.Q0tycZk8pphOvAOqm3rzJ2A@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NE2=hjpO2Gbkwv_hXklzt8U"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111110180234.Horde.Q0tycZk8pphOvAOqm3rzJ2A@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander =?ISO-8859-1?B?S/xobg==?= <alexander.kuehn@nagilum.de>
Cc: Chris Purves <chris@northfolk.ca>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, jeromepoulin@gmail.com
List-Id: linux-raid.ids

--Sig_/NE2=hjpO2Gbkwv_hXklzt8U
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Nov 2011 18:02:34 +0100 Alexander K=FChn
<alexander.kuehn@nagilum.de> wrote:

> Try --re-add.

Nope.  That doesn't make any sense at all.

NeilBrown


>=20
>=20
> Zitat von Chris Purves <chris@northfolk.ca>:
>=20
> > On 2011-11-10 12:20, Alexander K=FChn wrote:
> >> ddrescue to the rescue!
> >> Get a another new disk, then ddrescue the one with the read error =20
> >> to the new disk.
> >> Assemble the array using the new disk instead of the one with the =20
> >> read error.
> >> You will loose the blocks that can't be read of course.
> >> And in the future do run raid check/scrubbing at regular intervals. ;)
> >
> > I have tried this already.  After cloning the disk with errors, I =20
> > replaced it with the clone and tried to re-start the array using
> >
> > mdadm --assemble --force /dev/md1
> >
> > mdadm assigned the new disk as a spare and said there were only =20
> > three disks to start the array and so couldn't start it.
> >
> > After I clone the disk with the error, how precisely should I =20
> > re-start the array?
> >
> >
> > --=20
> > Chris Purves
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/NE2=hjpO2Gbkwv_hXklzt8U
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrwvcDnsnt1WYoG5AQJ6gw//YK0rHlUf2pSi6jtNgoAlaezyKAooFMyR
MjssfiCBlRLglwF1qNRFvQFqQY4l/IlFMNFm3fX90Py2Apn9m7KkFkeW5ey18+BY
Cvhalxa22OkME+Zy6RpZqvvS18P7oSbtBU5JU3bzd6b6a8abPiBfxTpr3xW1b0aW
O+DfK04Vw3lMq7scL6A/zgWc1A7a6X6PY66nmL81m4aQgYp1GDSqVgUfHz2iQxfy
yE2dvhczGU+OKI8B547KtRngN+NWaLIHSMvuFeSXleAe3oU+zVL3WUythxdBXbUh
D2qcmb/I68snFsZfFUwhStsGbAJqXyiStOqcFwLiFjO/gVKPXN2htn846JRBqDW8
Y63GO55MgwV3RDhetHpszlDG6EHbV/nN+I7Z+ebyhTxxV9dH1eiqsK4/jQA2ZW36
9yBN9tTPeuef5SVs5YItPLgazGnG5jbh8C29s9dPs7mk9fwEwakXjC+nNbWqe+Tz
D6aEdVLj1bLOQcMvKg92o8JnEjcun9GCkTDg9DBYVVn75m1aSwu99BooH+RtJ2Vv
1cuMZAI0fWcUDdQ0HEhwyGeCwMdUYm73NVwaNIsBErxT3VfUUNEt+SaWfmdo7icb
EisAqPf0kubCo2xACABgUIpmVaQvHCjwiF94j8iZvOxcrgQ4Hi3aEl6oHs2X1GRs
YfxTF7KU8ZI=
=rPkj
-----END PGP SIGNATURE-----

--Sig_/NE2=hjpO2Gbkwv_hXklzt8U--
