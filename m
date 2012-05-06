From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] super-intel.c: Don't try to close negative fd
Date: Mon, 7 May 2012 09:10:33 +1000
Message-ID: <20120507091033.3d797914@notabene.brown>
References: <1336138882-31869-1-git-send-email-Jes.Sorensen@redhat.com>
	<CAA9_cmcnWHeu-x9L5os9gZzmhtMxvAWVnLf3uSfey+aVktaKoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0rkomZQ2wlKylege/4yghXm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmcnWHeu-x9L5os9gZzmhtMxvAWVnLf3uSfey+aVktaKoA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jes.Sorensen@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/0rkomZQ2wlKylege/4yghXm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 4 May 2012 11:00:15 -0700 Dan Williams <dan.j.williams@intel.com>
wrote:

> On Fri, May 4, 2012 at 6:41 AM,  <Jes.Sorensen@redhat.com> wrote:
> > From: Jes Sorensen <Jes.Sorensen@redhat.com>
> >
> > This should be harmless, but lets be consistent and not try to close a
> > negative file descripter.
> >
> > Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> > ---
>=20
> Patch 1 and 2, Acked-by: Dan Williams <dan.j.williams@intel.com>

Thanks to you both.
Patches applied.

NeilBrown

--Sig_/0rkomZQ2wlKylege/4yghXm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6cE6Tnsnt1WYoG5AQIFUg/+OW/jW4XusLXan3AjFKcGX8hssIy0aa7Y
HKFkd0qhg81yBHqimXfrEvvPYZiK8OICxAOy/+1cuNz7s52/czVkD/fmWJ0uyEQy
oSnVIuKojgn2FLuDufLGzkt5N07mihDhjkqM43HVEWLQDO40R285kNVISLzEfMAJ
a1c+uhXQ5CISNrAFoxFqWer+4pAjzJr3eAcN+6eeTaRqXd/kgON1HDtzKG1Hb2zf
UUmRWHuWV0a6ju6Nxp9HilTGmRDaoWg6t59NSpU8kpz54iQ7wZswUCFuuvcIuL8i
qmNWN7NOPXNnCP65S3OyF2dvuOg/gpfPySejdjAyAwKfBRi80vCQugPRaJoo5IZz
c/CKo6OQInpYbO2L2xtW/KjWxUOhF5f5d3emacPyVO41+dQHXpqf67EG+it7pv4A
NMzMMEr2tAHFqnLQUSUkMSYGh7GLyPxAqwpFw2WmuL02NV6jUmivoENdOkq/NK2v
B1bEtJmcmRhox+MxrfdUKjctuBA10gD3+QdBroaAndYtljb6/IJhEQALt9g8/wFy
03hXzCf0w/iGikCwWwUIZ8KacGyNUeXzeFL5pKlyfFyhZEWxwtqofa2zXT3Ken9F
tjO9BPH8aSjZ4mG3CL9Uy0dwJERu3mMGhL7a3hB9RH0ZRSbJJVJpg273i/1Q06C3
nGmGoD3Xy1g=
=fY6q
-----END PGP SIGNATURE-----

--Sig_/0rkomZQ2wlKylege/4yghXm--
