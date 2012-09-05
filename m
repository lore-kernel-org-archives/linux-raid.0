From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] DM RAID: Fix for ineffective "sync" directive
Date: Wed, 5 Sep 2012 11:44:26 +1000
Message-ID: <20120905114426.1ce3c898@notabene.brown>
References: <1345735914.25206.8.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5d0GCftSKxFKgc7OO_2U4z8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1345735914.25206.8.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/5d0GCftSKxFKgc7OO_2U4z8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Aug 2012 10:31:54 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> Neil,
>=20
> There are two ways I see to fix the problem of the "sync" table argument
> not causing the array to re-sync.  We could set mddev->events to
> UINT_MAX and force an mddev/bitmap event mismatch - causing the bitmap
> code to set BITMAP_STALE itself.  Otherwise, we can do as I have below
> and set BITMAP_STALE ourselves.  The real difference is whether this is
> done before or after md_run().  The first solution can be done before
> md_run(); the second cannot because the bitmap is allocated during
> md_run().  Either solution works and correctly sets the bitmap to stale
> before bitmap_load() is called.  So, rather than having to think about
> issues that come with setting events to UINT_MAX, I chose to set the
> bitmap stale after md_run().

I'm not at all sure this is the right way to look at the issue.

The only reason that we have 'sync' and 'nosync' table args is because
originally we weren't storing any metadata on disk.  The 'in-sync?' state of
the array is important metadata, so it needed to be given to md via a table
option.

If you have a bitmap, then you are storing this information in metadata, so
including it as a table option is redundant and - as you noticed - ignored.

If you want to assert that the data in the bitmap is incorrect, then I think
the best approach is to change it so that it is correct.
i.e. if you want to assert that an array is not in-sync and should be fully
'synced', then the right thing to do is to write lots of '1's to the bitmap
before trying to assemble the array.

However I'm not violently against the patch - though I would be against
fiddling with event_count. It does seem unpleasantly asymmetric though.
The 'sync' option says 'assume all bits in the bitmap are set', but the
'nosync' option doesn't say 'assume all bits in the bitmap are clear'.

Is simply writing to the bitmap when you want to force some behaviour an
option, or do you really really want "sync" to mean "please ignore the
bitmap"?  (or maybe an "ignorebitmap" option is what we want??).

NeilBrown



>=20
>  brassow
>=20
> DM RAID: Fix for "sync" directive ineffectiveness
>=20
> There are two table arguments that can be given to a DM RAID target that
> control whether the array is forced to (re)synchronize or skip initializa=
tion:
> "sync" and "nosync".  When "sync" is given, we set mddev->recovery_cp to 0
> in order to cause the device to resynchronize.  This is insufficient if t=
here
> is a bitmap in use, because the array will simply look at the bitmap and =
see
> that there is no recovery necessary.
>=20
> Once md_run() is called and creates the bitmap, we set the bitmap as stal=
e.
> When the bitmap is loaded during the resume phase, a full resync will
> result.
>=20
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
>=20
> Index: linux-upstream/drivers/md/dm-raid.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/dm-raid.c
> +++ linux-upstream/drivers/md/dm-raid.c
> @@ -1123,6 +1123,10 @@ static int raid_ctr(struct dm_target *ti
>  		ret =3D -EINVAL;
>  		goto size_mismatch;
>  	}
> +
> +	if (rs->print_flags & DMPF_SYNC)
> +		set_bit(BITMAP_STALE, &(rs->md.bitmap->flags));
> +
>  	rs->callbacks.congested_fn =3D raid_is_congested;
>  	dm_table_add_target_callbacks(ti->table, &rs->callbacks);
> =20
>=20


--Sig_/5d0GCftSKxFKgc7OO_2U4z8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUEauejnsnt1WYoG5AQJIvRAAnqCTsB2MJAYRN69jwuHqmLQg7D7Kx9UJ
96tD8mkhvqZ9dDI5rLnGabbFmLlpaZ/44Hp7ZUBwBnurdCuF3Q8GEHEAs0JYxCc2
xuf+PnAgJhsoQF4iWnjiwPR81svyBrbICvE3qxNzmAbQwAdAmgF+0RFgV+tzQytN
g0m2soYzm0EeFhjXbx6h/U1eTY2BqD68DvjTRsg907eJqliafhOwNIhYF1drG5Lz
MFHgQhJYxHPxPo0yu/a+9gbg35N3d7QuRINmQJFrn4jBPa1I1foc2nCxhDAEkNC3
1VphOr1qD/l9aSyIShert1Z1Z0vvNtOsRKYOUPfmDQathkozW7Xg0I7NZrS+jTtS
PqvQ9zjEpr++3Z2CDklwUI4og7Bpx/9dUmF1w+d/5PGzMZvpck50mM3ha1XCTgPU
Sxx/DSi5ElJM22GHGNYG0M4RmvgQympfjkzDs4E/P2fL/L1kAe0vq5t7InMlDyD+
DZi1pa9Jxds5/Ky6wVPylzfckiAJUTGrcY5RILiMXR3g+kQp2GJ+qjGio1m8zfIl
e+yXI6U/nbD4skpscu+eJ3G/hWqOP0I4LjHBwpBdK/cZc+i/pMej/AhbteAhthVw
Nhx0IEemOMD6K4QgmKoWWakN8f+250WJX/4jLLPd3LZQVIFu563jUXa3Vscp5YY5
21a1QzZmocY=
=M45K
-----END PGP SIGNATURE-----

--Sig_/5d0GCftSKxFKgc7OO_2U4z8--
