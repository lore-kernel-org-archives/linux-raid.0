From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/3] MD: hold mddev lock for .quiesce in md_do_sync
Date: Wed, 03 Aug 2016 09:47:58 +1000
Message-ID: <87y44epwb5.fsf@notabene.neil.brown.name>
References: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org, linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 31 2016, shli@kernel.org wrote:

> From: Shaohua Li <shli@fb.com>
>
> .quiesce is called with mddev lock hold at most places. There are few
> exceptions. Calling .quesce without the lock hold could create races. For
> example, the .quesce of raid1 can't be recursively. The purpose of the pa=
tches
> is to fix a race in raid5-cache. The raid5-cache .quesce will write md
> superblock and should be called with mddev lock hold.
>
> Cc: NeilBrown <neilb@suse.com>
> Signed-off-by: Shaohua Li <shli@fb.com>

Acked-by: NeilBrown <neilb@suse.com>

This should be safe but I'm not sure I really like it.
The raid1 quiesce could be changed so that it can be called recursively.
The raid5-cache situation would be harder to get right and maybe this is
the best solution... It's just that 'quiesce' should be a fairly
light-weight operation, just waiting for pending requests to flush.  It
shouldn't really *need* a lock.

NeilBrown


> ---
>  drivers/md/md.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 2c3ab6f..0550445 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7945,8 +7945,10 @@ void md_do_sync(struct md_thread *thread)
>  		 * region.
>  		 */
>  		if (mddev->bitmap) {
> +			mddev_lock_nointr(mddev);
>  			mddev->pers->quiesce(mddev, 1);
>  			mddev->pers->quiesce(mddev, 0);
> +			mddev_unlock(mddev);
>  		}
>  	}
>=20=20
> --=20
> 2.7.4

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXoTEuAAoJEDnsnt1WYoG5tAEQAKzErRnvdep0yqGcNRGt7DXx
+MLyOLiCXiEtDrdFHIIan5YNOzai7r23IPd1k9nwh9V7W6a7/fGPL89/MxpeMK8z
tCsnE7v81pWq/mbBrfARak9x5TanRqX1qC1SdXv5HmdLnxYaCnkHwGuu42WvQFBI
bwHK3mdS9DubMAAy4tgQkPsWJcfSXevUOvp35wLv1nYmyu1aXqowpUnZ6OL0txTA
s0d3+A84HgO9TTuUuRAAuObYedod8gsb+WL7PDn22UiTxyuYW9kC/33RunAW4ZXi
SPJnQ97Tl3c/QAGPTellKMY3ul+7d86VKcq4W5o16TsNbhGzVpxASudR6f/kp/Im
H4pmCWr+GRfWPlzXvZjClNkbcxZir2VtfZvSJAk1BdCUJXUFXx7Wc51MGacQtsXv
rhxzXQ/3NHQWEDBnbgTav945CNhBNfvEnIUkoq+q2+nqBNaK6SEbUUA5j3XhC+Eb
eXsVCFaSdkRy3qxX8z7xVGxA3y2K2FOwwRoR2uKQFHHE2GA2Q1s6Po5feHQdpcd9
WunzzqsB6vKhKcNSaK+bINaqAAIko3eGVTEiuR98wOfqGwfWLmTLolb6xKpoRq1w
ysjf/09N+5whV28tvn05hSGLuvvq44X1Z1Fmjcvy0lMXvzvo/wWIa5sXmla8PR2h
Ni+zJt/AiCX7CJw2kMCA
=wPmX
-----END PGP SIGNATURE-----
--=-=-=--
