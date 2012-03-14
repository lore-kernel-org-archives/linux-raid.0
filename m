From: NeilBrown <neilb@suse.de>
Subject: Re: Question about handle_failed_sync()
Date: Wed, 14 Mar 2012 18:28:27 +1100
Message-ID: <20120314182827.4738c70c@notabene.brown>
References: <201203141516404211761@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5.IhW7mvp+QnbFfx4Ae=6uQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203141516404211761@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/5.IhW7mvp+QnbFfx4Ae=6uQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Mar 2012 15:16:45 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

>  In function handle_failed_sync():
> >>/* During recovery devices cannot be removed, so locking and
> >>	 * refcounting of rdevs is not needed
> >>	 */
> >>	for (i =3D 0; i < conf->raid_disks; i++) {
> >>		struct md_rdev *rdev =3D conf->disks[i].rdev;
> >>		if (rdev
> >>		    && !test_bit(Faulty, &rdev->flags)
> >>		    && !test_bit(In_sync, &rdev->flags)
> >>		    && !rdev_set_badblocks(rdev, sh->sector,
> >>					   STRIPE_SECTORS, 0))
> >>			abort =3D 1;
>=20
> I have two questions:
> 1:if raid have two or more spare disks, it wil set bad block on all spare=
 disk. Is it worth it?

This is not looking at spare disks exactly.  Rather it is looking at
devices that are being recovered - they were spares by now they are member =
of
the array that are being recovered.
So there will only be 2 in RAID6 and never more.

And yes, it is worth it.


> 2:If raid have two or more spare disks,I can remove spare disks which not=
 working for recovery.Then you shold add locking=20
>    and refconting.

I'm not iterating through the list of disks (mddev->disks) here - just
through the list of devices that are active members of the array
(conf->disks).
You cannot remove those while recovery is happening.

Thanks,
NeilBrown



>  			=09
> --------------
> majianpeng
> 2012-03-14
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/5.IhW7mvp+QnbFfx4Ae=6uQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT2BImznsnt1WYoG5AQK8fw/+OJBWO4lETcQg/gAXN+OSAtFCYKPIZizc
Amr1jKw/jTzttfLjwk/Gn9NwLUw8LyRsOUR7mWELRz9KalgQTbZKs7sdsdRlUJXh
zGOa8kmDWwKzHdgPyywruuZNQceOZSJxPGrNy1XtrLYH1VRVQLJijv6S3/VIqyw/
SZhXLI1ZShrix4Ob58T/blhO+tvbfQJARLmN1tDU2Xxq2O2MiuESnRuz+Xf3Rj2/
V1i1S8tb2n+oWJiVJp/66Gc7A3RuiDpQtnuXZES8EUowUc9zUdUsG/r2HjVfGx50
Aub8SG47V1z3MBxPW5tycuItKqm/DvOKwOFdz40IVpTD3QeS3HP6o/tqsDhihThH
lHUBslvFkoOYqsfHCyQScu+ja07pC7NKjAjaq6ZS4ZfpKvsKwrDI2rTKxZSWPsW1
zPPVplivVR0UlLRROkHc/CbHR/4Zhjh07k0h+wtKQx6pSWIPpI6TGL3ZWMOwlA+r
KOhKYPnMWbPxFO2I9qe2jJlTYmarRu21cwwWi5yoezde/5LivFrvH/A+sLv1FDuI
Jy2WtM0SdBbysr+elG2aKkmahevL9DlFQgjvHE2v5/r5oEyvkTvdUNAxg0GATUIR
Szd/4EK7FCL0U9G0pxD2lsD3aRYChSa6NTwg0gfmkZuEns/JSy4KulurDB73pdUf
01JVcYAN6mg=
=0XZB
-----END PGP SIGNATURE-----

--Sig_/5.IhW7mvp+QnbFfx4Ae=6uQ--
