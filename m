From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH v2 04/11] async_xor: permit callers to pass in a 'dma/page scribble' region
Date: Wed, 20 May 2009 21:09:28 +0200
Message-ID: <20090520190928.GL11504@skl-net.de>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com> <20090519005946.4104.28803.stgit@dwillia2-linux.ch.intel.com> <20090520080818.GT6403@skl-net.de> <e9c3a7c20905201135y46022829s9b68d7ee81a5d3dc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zH41lVBEV8cLJnCl"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e9c3a7c20905201135y46022829s9b68d7ee81a5d3dc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--zH41lVBEV8cLJnCl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11:35, Dan Williams wrote:

> > Don't we need to fall back to sync xor if src_cnt exceeds
> > what the device can handle, i.e. if it is larger than
> > chan->device->max_xor? async_xor_val() further down has a check for
> > this condition.
>=20
> No, we don't need this check for async_xor().  The asynchronous path
> of async_xor_val() has the constraint that it must be able to validate
> an xor block without writing to that block i.e. it is a read-only
> operation.  The synchronous path recalculates the xor with the
> destination as a source and then does a memcmp() to validate that the
> new result is zero.
>=20
> To support more than ->max_xor sources for async_xor_val() we would
> need an engine that supported hardware continuation of validate
> operations (i.e. an engine with an internal buffer for the
> intermediate xor result) otherwise we will need to store an
> intermediate xor result in system memory which is no better than the
> synchronous path.
>=20
> For async_xor() we are always allowed to write the destination, so we
> can reuse it as a source to continue the calculation of the xor
> result.

I see. Thanks for this detailed explanation!

BTW: So far I've only glanced at patches 7-11 of your series. I will
review these patches this evening and tomorrow, so I'll send another
batch of comments/questions/sign-offs by Friday.

Robinson^WAndre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--zH41lVBEV8cLJnCl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKFFVoWto1QDEAkw8RAohHAKCQaRe2u+7Nlh+8bBdk+4odNdWylgCdGHj7
wla1oy5r6h8Ui5KVPFQm5rw=
=CmPj
-----END PGP SIGNATURE-----

--zH41lVBEV8cLJnCl--
