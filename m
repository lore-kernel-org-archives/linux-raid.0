From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 8/8] Manual update for --continue option
Date: Mon, 3 Oct 2011 10:09:48 +1100
Message-ID: <20111003100948.1bd85b1c@notabene.brown>
References: <20110927115845.4890.49289.stgit@gklab-128-013.igk.intel.com>
	<20110927120539.4890.87894.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=2hjXgWeV0copRh7X1YA7FF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110927120539.4890.87894.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/=2hjXgWeV0copRh7X1YA7FF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Sep 2011 14:05:39 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> Patch adds to mdadm man the following information:
>=20
>  --continue
>    This option is complementary pair to assembly --freeze-reshape option.
>    It is needed when --grow operation is interrupted and it is not restar=
ted
>    automatically due to --freeze-reshape usage during array assembly.
>    Option --continue has to be used together with -G , ( --grow ) command
>    and device that it should be executed on.  All parameters required for
>    reshape continuation will be read from array metadata.  If initial
>    --grow command had required --backup-file=3D option to be set,
>    continuation option will require to  have  exactly the same backup
>    file pointed to also.
>=20
>    Any other parameter passed together with --continue option will be ign=
ored.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  mdadm.8.in |   27 +++++++++++++++++++++++++++
>  1 files changed, 27 insertions(+), 0 deletions(-)
>=20
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 3e2f99e..6b0af55 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -734,6 +734,33 @@ The file must be stored on a separate device, not on=
 the RAID array
>  being reshaped.
> =20
>  .TP
> +.BR \-\-continue
> +This option is complementary pair to assembly
> +.B \-\-freeze-reshape
> +option. It is needed when
> +.B \-\-grow
> +operation is interrupted and it is not restarted automatically due to
> +.B \-\-freeze-reshape
> +usage during array assembly. Option
> +.BR \-\-continue
> +has to be used together with
> +.BR \-G
> +, (
> +.BR \-\-grow
> +) command and device that it should be executed on.
> +All parameters required for reshape continuation will be read from array=
 metadata.
> +If initial
> +.BR \-\-grow
> +command had required
> +.BR \-\-backup\-file=3D
> +option to be set, continuation option will require to have exactly the s=
ame
> +backup file pointed to also.
> +.IP
> +Any other parameter passed together with
> +.BR \-\-continue
> +option will be ignored.
> +
> +.TP
>  .BR \-N ", " \-\-name=3D
>  Set a
>  .B name


Thanks.
Both man-page updates added (with some minor fixes).

NeilBrown


--Sig_/=2hjXgWeV0copRh7X1YA7FF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOiO88G5fc6gV+Wb0RAu/4AJ9v3g5SF1LbujDeMMcG+v5KfYVGHACfc2TL
xjdbVm7gUR9flTI+WvRH6no=
=Ol0+
-----END PGP SIGNATURE-----

--Sig_/=2hjXgWeV0copRh7X1YA7FF--
