From: NeilBrown <neilb@suse.de>
Subject: Re: raid10 make_request failure during iozone benchmark upon btrfs
Date: Tue, 3 Jul 2012 11:39:43 +1000
Message-ID: <20120703113943.3e4c43ad@notabene.brown>
References: <4FF108A8.6090606@gmail.com>
	<20120702125227.179c4343@notabene.brown>
	<4FF10E71.2090501@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/96t85mSo+EDkHf/x6cNaAtl"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FF10E71.2090501@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kerin Millar <kerframil@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/96t85mSo+EDkHf/x6cNaAtl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 02 Jul 2012 03:58:57 +0100 Kerin Millar <kerframil@gmail.com> wrote:

> Hi Neil,
>=20
> On 02/07/2012 03:52, NeilBrown wrote:
> > On Mon, 02 Jul 2012 03:34:16 +0100 Kerin Millar<kerframil@gmail.com>  w=
rote:
> >
> >> >  Hello,
> >> >
> >> >  I'm running a 4-way RAID-10 array with the f2 layout scheme on a 3.=
5-rc5
> > I thought I fixed this in 3.5-rc2.
> > Maybe there is another bug....
> >
> > Could you please double check that you are running a kernel with
> >
> > commit aba336bd1d46d6b0404b06f6915ed76150739057
> > Author: NeilBrown<neilb@suse.de>
> > Date:   Thu May 31 15:39:11 2012 +1000
> >
> >      md: raid1/raid10: fix problem with merge_bvec_fn
> >
> > in it?
>=20
> I am indeed. I searched the list beforehand and noticed the patch in
> question. Not sure which -rc it landed in but I checked my source tree
> and it's definitely in there.
>=20
> Cheers,
>=20
> --Kerin

Thanks.
Looking at it again I see that it is definitely a different bug, that patch
wouldn't affect it.

But I cannot see what could possibly be causing the problem.
You have a 256K chunk size, so requests should be limited to 512 sectors
aligned at a 512-sector boundary.
However all the requests that a causing errors are 512 sectors long, but
aligned on a 256-sector boundary (which is not also 512-sector).  This is
wrong.

It could be that btrfs is submitting bad requests, but I think it always us=
es
bio_add_page, and bio_add_page appears to do the right thing.
It could be that dm-linear is causing problem, but it seems to correctly af=
ter
the underlying device for alignment, and reports that alignment to
bio_add_page.
It could be that md/raid10 is the problem but I cannot find any fault in
raid10_mergeable_bvec - performs much the same tests that the
raid01 make_request function does.

So it is a mystery.

Is this failure repeatable?

If so, could you please insert
   WARN_ON_ONCE(1);
in drivers/md/raid10.c where it prints out the message: just after the
"bad_map:" label.

Also, in raid10_mergeable_bvec, insert=20
   WARN_ON_ONCE(max < 0);
just before
		if (max < 0)
			/* bio_add cannot handle a negative return */
			max =3D 0;

and then see if either of those generate a warning, and post the full stack
trace  if they do.

Thanks,
NeilBrown

--Sig_/96t85mSo+EDkHf/x6cNaAtl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/JNXznsnt1WYoG5AQLQOQ/+LSmmQrVeZFmQeQjqjTd9IY/jKmsjcU/T
3RRdj12WBX1Ew6kCq7VopScHEpKTjU+dVCB/kHkhMZlt/v9Mnhkt/jvXkelwSg5R
p2PbaQayp0Rg+AoHupHZDgQWStKIZ3wZFOhcA/x4vg9cRvGIhCRYh75cCXNNxtX6
9UJIfpzXGKfe6j+cs5v/wwGz7bNAltr5clY+wY2kowVGcZAmrfpoQLUakBCK4bGO
WyL/CzfYlmuzmXmYnZnkXqN+pz3ZaYviLk+IHPQtxDTsQnqralp4a7Lsss/BdN1d
UlJ+bFh8TGnUaYcCKpFTg/0DVVS8wFDDI8HUKTlTUvZq+1woIoEtD9k0s1LVnCt9
hnK9VZnYpNi2BRl3j6WKsKhqT3H3hAfVIeI2vlqAJ5gCrXh/gzjP7YY5tpOjoBS9
GWe/izIhNHHEeDnPTSVfvB5fD6twPuIJxYXzaxaVjoftQAysYiDOrafcq30orYwP
Agmxo5tFvP52+WfUNTxolMeeksByhKvDyTENQ5ujB3u9XH1LKciPcFqDP4nCS7gN
tSChqpRqyYVmky7MIDjyXsaFHyMd8vwUMOMOVT6pJQlP7YL8tEXzwg0bc5iVaNze
T4HLjir9JgwzXrh2ZO6mN1hEbvMlJQ7xRZlKVnGc17vsqDtv/Pk7gXiBrEcPY9T8
ZMBTEuw1IsI=
=KgOD
-----END PGP SIGNATURE-----

--Sig_/96t85mSo+EDkHf/x6cNaAtl--
