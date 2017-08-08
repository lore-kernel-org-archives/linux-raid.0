From: NeilBrown <neilb@suse.com>
Subject: Re: [MD] Crash with 4.12+ kernel and high disk load -- bisected to 4ad23a976413: MD: use per-cpu counter for writes_pending
Date: Tue, 08 Aug 2017 17:01:28 +1000
Message-ID: <87k22esfuf.fsf@notabene.neil.brown.name>
References: <ee7921d2-d3ff-2381-1f05-2c07b8001d08@unsolicited.net> <c2df7906-67b2-b33f-0e82-49e6ef53f5f1@unsolicited.net> <20170807112025.GA3094@light.dominikbrodowski.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170807112025.GA3094@light.dominikbrodowski.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>, Shaohua Li <shli@fb.com>
Cc: David R <david@unsolicited.net>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 07 2017, Dominik Brodowski wrote:

> Neil, Shaohua,
>
> following up on David R's bug message: I have observed something similar
> on v4.12.[345] and v4.13-rc4, but not on v4.11. This is a RAID1 (on bare
> metal partitions, /dev/sdaX and /dev/sdbY linked together). In case it
> matters: Further upwards are cryptsetup, a DM volume group, then logical
> volumes, and then filesystems (ext4, but also happened with xfs).
>
> In a tedious bisect (the bug wasn't as quickly reproducible as I would li=
ke,
> but happened when I repeatedly created large lvs and filled them with some
> content, while compiling kernels in parallel), I was able to track this
> down to:
>
>
> commit 4ad23a976413aa57fe5ba7a25953dc35ccca5b71
> Author: NeilBrown <neilb@suse.com>
> Date:   Wed Mar 15 14:05:14 2017 +1100
>
>     MD: use per-cpu counter for writes_pending
>=20=20=20=20=20
>     The 'writes_pending' counter is used to determine when the
>     array is stable so that it can be marked in the superblock
>     as "Clean".  Consequently it needs to be updated frequently
>     but only checked for zero occasionally.  Recent changes to
>     raid5 cause the count to be updated even more often - once
>     per 4K rather than once per bio.  This provided
>     justification for making the updates more efficient.
>
>     ...

Thanks for the report... and for bisecting and for re-sending...

I believe I have found the problem, and have sent a patch separately.

If mddev->safemode =3D=3D 1 and mddev->in_sync !=3D 0, md_check_recovery()
causes the thread that calls it to spin.
Prior to the patch you found, that couldn't happen.  Now it can,
so it needs to be handled more carefully.

While I was examining the code, I found another bug - so that is a win!

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmJYcoACgkQOeye3VZi
gbkV1A//SbJoywhtTl3vMc2zwA258abAefSgT1sCGzAMEG4xyCBAltnux/4pfq1l
UqJPU+fPhUy1fjc4Nel4MmO47huvgmQcXlPi9An79yre90fNsiruZenRQvewpD5d
GhY1oQ0Pespoxw/5peEB6x98+EO03yCZJdr/Vxozk7s6S1vyMFX9z58OUC222g2D
qv+04kO6Zn8QS0z7McSJewwO7r4ldVeaooL5HZPY5JLnJqA7tg/nNImZBhf/zC23
HIlfsKhXqODhel68FNpKOakvi+d5/BFsVGipXys9zWn+haZracs1AKR/aWKbKNE9
Bc1pxSSUaNoj8CQbzt1Mry3iVLB6zEVQOkccWrkjlVPpdfyN2Rf956YhFNxTGrBu
NWYafufqRzoxGgNr8poYKgdUfqukihcAxYtJP04eRQRsuVOqwWTAIv0L2sASc9Tc
9klRXU2ApTO4+uAxwWro+g2IDPQovaDg4Ia9mpk+pltdrxdrNeetMnFUW0quHC8Y
KD0exS642Upb7K5pg8O9LTW4GmkD0PKI/yCWuL9u54ztghNE4NCck1aO9FWbUQOs
MKi87Ukjiu+BO1tpXraDd9sRERdJoDFvqFQI38Qa1JHFmAng2tuLnwK8MCoGVQB1
7rLLmJiF1TCuGd4Fj7MGHdtH1gLgeTkLuqyzwyjjZNjdEIIBtJk=
=J93t
-----END PGP SIGNATURE-----
--=-=-=--
