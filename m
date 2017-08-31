From: NeilBrown <neilb@suse.com>
Subject: Re: report a bug that panic when grow size for external bitmap
Date: Thu, 31 Aug 2017 10:27:21 +1000
Message-ID: <87r2vsfuom.fsf@notabene.neil.brown.name>
References: <ad8c69c7-f1e0-b6ab-dc87-a81aa7bca391@suse.com> <87y3q3gq8g.fsf@notabene.neil.brown.name> <6eaf97d4-bd8c-e33c-a9c7-37d0fe2086ce@suse.com> <87mv6jgj8z.fsf@notabene.neil.brown.name> <ba801ebe-9c0c-d911-2b18-936495fe0ed3@suse.com> <87k21mhcqw.fsf@notabene.neil.brown.name> <73429dce-a22d-149e-656a-13af228c093f@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73429dce-a22d-149e-656a-13af228c093f@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 30 2017, Zhilong Liu wrote:

> On 08/29/2017 06:47 PM, NeilBrown wrote:

>> Thanks.  I see what I missed. Please try this patch instead.
>
> Hi, Neil;
>      I have tested the following patch, I still got the call-trace after=
=20
> I built with it.
> If you need other infos, I would append.


Thanks for testing.
I looked more completely and I think it is easiest just to disable the
functionality rather than try to fix it.
Resizing the file in the kernel is extra complexity that I don't
want to get in to.
We could adjust the bitmap chunk size so that the file doesn't
need to grow, but it started getting more complicated than I really
wanted to deal with.
If there is anyone actually using file-backed bitmaps who wants to
be able to resize the array without removing the bitmap first, then
we can look at the problem again.  For now I've sent a patch which
just returns an error instead of crashing when someone tries to resize
an array with a file-backed bitmap.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmnV+sACgkQOeye3VZi
gbnoKhAAwmAKA5s0V2+N46johePJvgd2fMn/j+NNIEx9o+8TSAPoJeUh5XgQXZgB
nEml5MTFtD0k9zCS0winNRbySY1lHcjy1zRtXuYMqetKQuLh+zn5QDSRGnOvarQt
0uscuRf5yR2JOz56F3cW8u2qGpCtA/NBpPPzMiPni2Yj8AxYnn+NjZtsY8Ye9JF9
CJieVISJeHEla16BIydIR7XYj26fhxTzOTxsPLgjiAy/5ZWzrzuAjDIVC40ALyry
Dq1+JRS86934+cMUcP0uVHBBucWaODonMRsTNSS2J+e9V/Kl1I/cJOdPuisoKeqE
0Ni0KaO/b0HHtlHYV71mPMTJXSC+z657rSZg2qIhsR03P2Gw/n7l5Vh1MF/uv565
Ey8FQUqd2+smaBg/3qbJdUzwTxheXqRsyxqX6yFEIMm3iMzeW7J43cmaSFx1h+3x
XsAyGJQ41MhtLIueXMGNQIOhSXyT8FNGjiVW5qECAQKDzs2RMrcNaK6bhO0yiIOt
ekTITxqrP5ARUfg87yrKfErcU0QZ3W8jenv4mEmw+GznAjyhpzcqbmSnvOSPAHCb
6gcNqET+p5ieQgvvSAyd9Mz0ucXVbg1nJPvMa/U/xP6S0Iuce2+rVkOI4ffRqjzY
koY1Y5ZcdE7YVNwIvAMFYXHIrsoFZ+HJFoVl9nnuhcOgIMZXEcI=
=7cJ5
-----END PGP SIGNATURE-----
--=-=-=--
