From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH 02/13] async_tx: don't use src_list argument of async_xor() for dma addresses
Date: Thu, 26 Mar 2009 11:39:12 +0100
Message-ID: <20090326103912.GP17185@skl-net.de>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com> <20090318192026.20375.3053.stgit@dwillia2-linux.ch.intel.com> <20090319201008.GC10491@skl-net.de> <e9c3a7c20903251011w3f6b3f58u7c0352ae39bb1c7c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+sObS8/rhx1YpqEF"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e9c3a7c20903251011w3f6b3f58u7c0352ae39bb1c7c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de, maciej.sosnowski@intel.com, Yuri Tikhonov <yur@emcraft.com>, Ilya Yanok <yanok@emcraft.com>
List-Id: linux-raid.ids


--+sObS8/rhx1YpqEF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10:11, Dan Williams wrote:
> On Thu, Mar 19, 2009 at 1:10 PM, Andre Noll <maan@systemlinux.org> wrote:
> > On 12:20, Dan Williams wrote:
> >
> >> Using src_list argument of async_xor() as a storage for dma addresses
> >> implies sizeof(dma_addr_t) <=3D sizeof(struct page *) restriction whic=
h is
> >> not always true (e.g. ppc440spe).
> >
> > This message does not tell what the patch is going to do about that.
> > It would also be nice to mention (either in the log message or as a
> > comment) why allocating the dma_src arrays on the stack is not going
> > to be a problem.
> >
>=20
> True, and taking into account your other comment about the number of
> parameters I think this is a good opportunity to solve this problem
> rather than kick it down the road.  So I will prepare a rework to make
> this memory caller provided.  This gives us the flexibility to use a
> kmalloc'd buffer hanging off the stripe_head as Neil suggested in
> another thread.

Glad you agree. I'm looking forward to seeing the reworked patch set.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--+sObS8/rhx1YpqEF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJy1tQWto1QDEAkw8RAh77AKCZjEr0A4Sjog2N583P4DDO6X0tiACgmiiV
8YWg4iVYkIFoN1ejRsQQieQ=
=VWTU
-----END PGP SIGNATURE-----

--+sObS8/rhx1YpqEF--
