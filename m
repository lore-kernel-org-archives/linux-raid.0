From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 0/3] md: retry bailed bio
Date: Thu, 28 Sep 2017 12:47:41 +1000
Message-ID: <87ing35yk2.fsf@notabene.neil.brown.name>
References: <cover.1506015297.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1506015297.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 21 2017, Shaohua Li wrote:

> From: Shaohua Li <shli@fb.com>
>
> With cc27b0c78c79(md: fix deadlock between mddev_suspend() and
> md_write_start()), pers->make_request could bail out without handling the=
 bio.
> If that happens, we should retry. There are two call sites we don't do the
> retry and cause problems. This set fixes the issues.

All look good to me, thanks.
Reviewed-by: NeilBrown <neilb@suse.com>

NeilBrown

>
> Thanks,
> Shaohua
>
> Shaohua Li (3):
>   md: separate request handling
>   md: fix a race condition for flush request handling
>   dm-raid: fix a race condition in request handling
>
>  drivers/md/dm-raid.c |  2 +-
>  drivers/md/md.c      | 72 +++++++++++++++++++++++++++++++---------------=
------
>  drivers/md/md.h      |  1 +
>  3 files changed, 45 insertions(+), 30 deletions(-)
>
> --=20
> 2.11.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnMYs4ACgkQOeye3VZi
gbl0ExAAi1cvLxCFELTBMCJp9dA5g2+fV3X4/m0vONYZj+3pHPKPTgyeW26bkZRC
U1jBZX/tB6zpOR+DwApl0ex8jX7JZAszMxZL3yUz8cA299mWrCFZWd0wTCR6TnCk
HDaNomrrM4Q/bO0O0o0MqZdboFpmSZeBjwB/S0U6Zod8t8eQ9TojTBL7lSvibXUS
LtXN/wJu2Tj15gpaK3gyizveszWMweQYju2kjzwMXCu5osOyH7HWXUBHrpgWdvwu
vkFd1WmNY60XlIeYEcP2hlugTjPBft1NIIqFKWsvryWQJKwdvui+tm/kpNi3XS+y
TVwqLmRNcM+HrtGWuInRIddulGGJY8Xj6A0NvCVKJQ+8JU2+wnRUtkGlaZCWMcG1
swSEDZenJC2t8mTXeWT/cDZRDU/i3A4lvXPt6ONiS39pAvqFTQox4LnzYmFmjeBu
OaOWPBNPGNV0ieXltil/oQ6ZFbUMmz2JcJUVTyXe7f8UXuaufe3SoEAzDIQET8oU
fdcyh9keuSpRtQz3TSH93aVHmdufrdVX3eXHgBTs9YMA6apIlsWV9dS98YTmw9D1
OMwXGhc5hWetSb2HYoedNzshhqs2WV3AFhJNG4vBkxXjhnrLDLkW2ZNOBMVIH75v
Z04ZhYQGpSMwbFvsrnep5TOeqIC1Trt/SjFnbs22QH43wWIWiIo=
=j3HX
-----END PGP SIGNATURE-----
--=-=-=--
