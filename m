From: NeilBrown <neilb@suse.de>
Subject: Re: [BISECT] Kernel panic, RIP bitmap_create
Date: Thu, 3 May 2012 15:58:50 +1000
Message-ID: <20120503155850.2900067d@notabene.brown>
References: <CAOOwNtJhFa67EFTs5AdgSHzFseBr9xJGTsaEOyYnaYYNCeUMAQ@mail.gmail.com>
	<CAOOwNt+wjMU9+Dzrr3+d3dwML2_Q_CgT4X5OgiKvPA_bBoTYcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1P52oHVhozWl==LJ+jGUg1A"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOOwNt+wjMU9+Dzrr3+d3dwML2_Q_CgT4X5OgiKvPA_bBoTYcg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Karl Newman <siliconfiend@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/1P52oHVhozWl==LJ+jGUg1A
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 2 May 2012 22:05:44 -0700 Karl Newman <siliconfiend@gmail.com> wrot=
e:

> Hi,
>=20
> I'm attempting to use kernel 3.4-rc? but keep running into a kernel panic=
 on
> boot, with RIP pointing to bitmap_create. I tried 3.4-rc1, 3.4-rc4 and
> 3.4-rc5 and they all have the kernel panic, while 3.3.4 boots fine. I have
> my root on raid 5 with an internal bitmap, and the kernel panic occurs if=
 I
> use the built-in kernel autodetect or during the root array assembly via
> mdadm inside a dracut-generated initramfs. I bisected it down to the
> following commit:
> 61a0d80ce4ab5b4fb9ecb38f1fb19654778b71ed
>=20
> md/bitmap: discard CHUNK_BLOCK_SHIFT macro
>=20
> Be redefining ->chunkshift as the shift from sectors to chunks rather than
> bytes to chunks, we can just use "bitmap->chunkshift" which is shorter th=
an
> the macro call, and less indirect.
>=20
> Signed-off-by: NeilBrown <neilb@suse.de>
>=20
> My bisect testing including a scary commit where 2 of 3 drives had their
> UUIDs zeroed when I booted with it! Fortunately I found the mailing list
> archives with the solution and I was able to recover everything and keep
> bisecting (although I was tempted to quit and just give the range of
> commits...).
>=20
> I hope this fix can make it into the next 3.4-rc kernel.

I do too, but first I would need to know what the fix is, and I cannot see
anything in that commit what would change the behaviour of md at all.

Do you have a copy of the full stack trace provided when Linux crashed?  Th=
at
could be useful.
Also what bitmap chunk size are you using? Maybe the output of
  mdadm -X
and
  mdadm -E

of one of the devices in the array would help.

Thanks a lot for the report and going to the trouble of bisecting, it is
really appreciated.

NeilBrown

--Sig_/1P52oHVhozWl==LJ+jGUg1A
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6Iemjnsnt1WYoG5AQIkgQ/+IyBB9AzcQPd9PnFSFD6XsEtluYoExouf
97KObnoyMUaK+2YcDHIvTbAHy9+uduy4Eya/xlf6OM8ADkKdb4ttC5/XExpawvwS
FgfLuvEwSfo/F5fEVWpsVYSierZNINKsHhvgD5k06yW/vmUzQa7OmTHlbIylHiSD
ZtDaX+r3TWQ18/lEn9q+zX3vNnUFJmcp4tz/gqpmy72lZtZ31lkAZtqQ1cd0s4LP
IPqElScY66V9Ggv0Yxhx7OoUZodGTG/aCB3c4uI6KSnHGzEcwJWURAvjgAUKA7Jm
3cWZ8Ys/uZLJ5vbm1CuYuwo0//TWZGRCYAKJvU0iffqtMqIFEk2APdLDhyLCv6Oo
b8r/b1eCWm/Hgj7sAqnjXcvaoCLny4f5lhnL3YjQ+WjqYGo7MEMvP9C/4DzdmDHf
HNPGTDJHBwarOFNw/C6rp917aVlWGmHyfbBdWgGqgIMmWPxoSOGpgpqFmNMjrePl
a6xceo9QXaJg+KABFE46LXgIe0AiqRiNkkQaLkuutvdS8vrxnbTIgCGqytG+qMsC
fRJLm3vTc0+K4UUtRBRN9d2lXCO6Uh0AoIVssbTVtt7Jxer8rOcphFFyMIjZu9hD
T32pXau6huGJJQDJHmIwiGAJRFHE81109sUosnnORNU3G6Y0z4t/fwX4e2c//qTQ
8pRh7wOmrSM=
=tfSj
-----END PGP SIGNATURE-----

--Sig_/1P52oHVhozWl==LJ+jGUg1A--
