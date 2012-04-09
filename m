From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/4] Imsm OROM compatibility/boot support fixes
Date: Tue, 10 Apr 2012 09:22:58 +1000
Message-ID: <20120410092258.66ed98ad@notabene.brown>
References: <20120405152553.19851.48052.stgit@linux.site>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bX1QZVjUU_Ck3Xiy1wqQD1q"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120405152553.19851.48052.stgit@linux.site>
Sender: linux-raid-owner@vger.kernel.org
To: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

--Sig_/bX1QZVjUU_Ck3Xiy1wqQD1q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 05 Apr 2012 17:28:12 +0200 Przemyslaw Czarnowski
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:

> This series of patches contain fixes regarding OROM and mdadm compatibili=
ty
> connected with handling of recovery/degraded states and missing disks.
> OROM behaves little differently when it marks disk as missing (see descri=
ption
> of patches for details)
> Last one in the series does not allow to modify metadata (in particular d=
oes
> not finish migration) on disks when array is set to read only by kernel
> (eg. during restart of system, when root partition lies on raid device).
>=20
> ---
>=20
> Przemyslaw Czarnowski (4):
>       imsm: monitor: do not finish migration if there are no failed disks
>       imsm: clean up missing disks if there are any left after migration
>       imsm: avoid double change of serial number of missing device
>       imsm: monitor: do not finish recovery, when raid goes to read-only
>=20
>=20
>  monitor.c     |    1 +
>  super-intel.c |   33 ++++++++++++++++++++++++---------
>  2 files changed, 25 insertions(+), 9 deletions(-)
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Given Dan's comments, I won't apply these just now.=20

NeilBrown

--Sig_/bX1QZVjUU_Ck3Xiy1wqQD1q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4NvUjnsnt1WYoG5AQKt6A/9H0yzchQSh5722HVlF6Wf0JN5fYfRc4l9
bMPmP4r6MIGfWBH3FfUYPvhhWwFp1ZwHaAn+6cMo23mZsMlOwCT+pI1af1VLQDqt
vAtZJnX+kJyMSsaBiZVQ6zy4KzLnUAlgoNl2HFXATvOfiOywyLAJ+bBzQdhCKjeT
WhafCGzHJGF8peTqtB4UVM73FHzM334xq70W+neo7YtSkcJQGUeYZZOPhUFbYjyG
gRlRS0TZmX1MjknaJILchCvaIm6gCoCW1Hjw7h0dVQWoKkajoAoZ+9noi4rbV6/i
W2SpK+hXIrsH59cDoZ9ce7+sLSs49yLEuAiSseWJFN68w78GE6LijAQrTD4lkpwc
51fSjkRE9/NhFDm44q9M1VYtFUW8oayVRwqBnB32MRC80JkwmUUiDAHb8vs0aEW0
6PM7nO1rMETEoJRusTX3Pcqm6Gq9ZB9yDKvjH52MP1H1ChqjdmMFkMCRqNx+uzBW
YDflWbSuZisrRG23TDo7VBNbC80Xu/kz+JOKo1mKSTi0e54CDHOAoXBqGwSskpZz
hMcD0h9m9m4a8nLugvOpAzEVGxxdgdG8WweSQ9VQbfFaPmWwy3IM14sxucewHwmb
YxKRrjrfJfcm4U5R3lum4rjJ/LpF5Yjb7O3nraMdSr2H0c/I+6aSR8QG+azqw/TZ
2brTbxhh1Tk=
=FCyb
-----END PGP SIGNATURE-----

--Sig_/bX1QZVjUU_Ck3Xiy1wqQD1q--
