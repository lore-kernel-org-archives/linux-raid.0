From: NeilBrown <neilb@suse.de>
Subject: Re: Boot option raid=parttitionable and autodetection
Date: Thu, 11 Sep 2014 10:02:11 +1000
Message-ID: <20140911100211.6984024a@notabene.brown>
References: <CAEp_DRBuccHOzkrJe8UKP1bKLdk_GM1TB8rqB_7_9w-fgdUZ0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/WU+QBQuTi.rLz2k1cMnuT3c"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEp_DRBuccHOzkrJe8UKP1bKLdk_GM1TB8rqB_7_9w-fgdUZ0g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bostjan Skufca <bostjan@a2o.si>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WU+QBQuTi.rLz2k1cMnuT3c
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Sep 2014 01:31:13 +0200 Bostjan Skufca <bostjan@a2o.si> wrote:

> Hi all,
>=20
> does kernel boot time parameter raid=3Dpartitionable ofer any additional
> feature over not using it at all?
>=20
> Besides changing autodetected device names from /dev/mdX to /dev/md_dX
> I currently can not see any other difference, save lilo being unable
> to work with them.

You have identified the one singular thing which that parameter does.  It
does nothing else.

>=20
> Normal raid devices can be partitioned without hassle,

This was not true when that parameter was added.  It is true now.
So best to ignore that parameter.

>                                                        unfortunately
> in-kernel autodetection of nested raid arrays does not work (talking
> about raid0 over raid1 here, not raid10), but that is more or less
> understandable.

I discourage use of in-kernel autodetection.  Use mdadm from an initrd
instead.

>=20
>=20
> Another quick question:
> What is the status of in-kernel autodetection vs initramfs based one?

initramfs based is preferred at least by me.

> As I could gather from various sites it seems initramfs is preferable,
> but what does that mean for in-kernel detection? Is it slowly being
> phased out?

Not it isn't being phase out, but it is not being enhanced at all.  Some new
features only work with v1.x metadata and that cannot be used with in-kernel
autodetection.

NeilBrown

>=20
> Tnx for info,
> b.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/WU+QBQuTi.rLz2k1cMnuT3c
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBDmgznsnt1WYoG5AQJxgQ//WhZ1rPR7jtcm4wi4+Pn3kZv/X9ImOvoW
EijXJOKzDq+lF5XwkGmX+n9ItfWuPLzzTzD9nGLltK2OK0yg+gIeT+peDaSpWZUH
rAZ2w0sDwF9nFe/KjsAV8pI9KPsjwKgHlyfiAd/h0CZaA/gwCyIGhsssXehk1Jkl
XfILdu6tu83PG7pUMiHglFwoeucMqH3xHZhH3Y6sHgA9xjcHUuL3qdzdtR+Qga2k
8kFxXxbBRA/cwp46uSNKKGRgbGlr6xSpFoaG2rOlGR6NR4dzWmOkY8gj/VFfWY/r
3bOak5eoQOLtE9+b245o5lzeEtG9elurEKUUFUNnYpt/NJv9+0NYe1PrwiUByIK3
q8PHGBOj3NQEdi6ZDRdUy+aOsbMIr5MpFdAxGKudTLWK3nK7DZ9Om6GJZGsDUBko
+uV0Nq+BXqPP1PnskaSJeiJ4/RSZsDMprPtvdM4c7Ok0NqEPZ+bcA59p1PzFi+0e
HaQkab7HHLg2w88bYA7aobYmbE+p62ID85LQudNaDDW5RULJyPs8g2lEhREn/v5F
zWoY9lMBAXG8j3b/p1ZFld9iz9tuIoK8v5rBfRasbCltFV4Ocj1a1YN3JQ8EQm7a
WPtqKqs/RFs5z8lHWKFAUx80aExtR11sSIACQOqfwFdtVu6KpCT6h6N7Zg7yBTyP
Z7lRbySmg2g=
=OfuI
-----END PGP SIGNATURE-----

--Sig_/WU+QBQuTi.rLz2k1cMnuT3c--
