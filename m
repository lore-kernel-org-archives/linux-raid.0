From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/3] Remove race for starting container devices.
Date: Sat, 22 Oct 2011 11:49:06 +1100
Message-ID: <20111022114906.2e26e66b@notabene.brown>
References: <1319204000-6661-1-git-send-email-Jes.Sorensen@redhat.com>
	<1319204000-6661-2-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_2a5sbnObonNqN_aBM44Vkx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1319204000-6661-2-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, lukasz.dorau@intel.com, adam.kwolek@intel.com, dledford@redhat.com
List-Id: linux-raid.ids

--Sig_/_2a5sbnObonNqN_aBM44Vkx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Oct 2011 15:33:18 +0200 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> This moves the lock handling out of Incremental_container() and relies
> on the caller holding the lock. This prevents conflict with a
> follow-on mdadm comment which may try and launch the device in
> parallel.
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi Jes,

 I have applied the 7 patches you sent.

However I have question mark over part of this one:


> @@ -451,9 +456,10 @@ int Incremental(char *devname, int verbose, int runs=
top,
>  			devnum =3D fd2devnum(mdfd);
>  		close(mdfd);
>  		sysfs_free(sra);
> -		rv =3D Incremental(chosen_name, verbose, runstop,
> -				 NULL, homehost, require_homehost, autof,
> -				 freeze_reshape);
> +		rv =3D Incremental_container(st, chosen_name, homehost,
> +					   verbose, runstop, autof,
> +					   freeze_reshape);
> +		map_unlock(&map);
>  		if (rv =3D=3D 1)
>  			/* Don't fail the whole -I if a subarray didn't
>  			 * have enough devices to start yet

You have replaced a call to Incremental with a call to Incremental_containe=
r.
I feel that is significant enough that I would have liked to have seen it
discussed in the changelog comment.

You seem have have open-coded Incremental and then removed all the bits that
you don't need in this case - which is that vast majority of it.
But you didn't include the call to ->load_content().

So I have put it back in because I'm sure it must be harmless (Because it w=
as
there already) but it may not be needed.

If you have thoughts on this, please let me know.

Thanks,
NeilBrown


--Sig_/_2a5sbnObonNqN_aBM44Vkx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqITBznsnt1WYoG5AQL1Ng/+MkdwHzWA+MKGil0vX7Stlxa1HAG7lLri
P1NFlNhI8RpRQyuu8m9fFKuQMcO7oSl7Zub+xlfnFAXOJSInHJwP8+GeN/5H+lvd
iRNuVnRrKmNlerL9g7WXHUa/MXsoja+fOMlqE54vgGrL7dB1/vUkRBuUAamaEgVP
M5QSul9SkFnGcV+aWYxiSnZqiZrjKOQKjpVKGDkDNK3QeTtzfk9QKFzXGNQ2sH0f
ZQskDtEuA2p0X62Qa0dTVzQnn+ovIKvbHi4QgqgbnBq+OObqzVFOab2sGzFB5WRI
gqIdEnWDQk0ifqNlAheCucrsLL6lphmw9g56RC+Nl/UZ5F7tSfLQ6fJs/QShVGkb
kKG1HYwO9r4pFXMjC/R6KhbGZ17u8S/nYfizTY7JX9mU52XJNI9qD01Q7w+uCkf6
ykBTR5tMR5NZpFp2/DzB8N2SF78b3ScspVGT8NaE3stdvwekkWiMCDU0Pliw5VS2
nBol4EwoDXetrXTfoQxIGeMSwqlmsRTQDWGCgb6aFRZ2K0td/KMWCZrm/rmvnM0X
5tFu3fS+3cCvW801kuuuXgyZuIcAXe72MwmPy0IjYbsJ9BNOdg3IDSMr4T8m3yeJ
zjLbyh2SXtY6akd6PET/vTYxHaH50QRsVQ2W/LERsFPkwHUYfkh+unUuqkB16wcT
T/kfF3uJ5fc=
=fCZg
-----END PGP SIGNATURE-----

--Sig_/_2a5sbnObonNqN_aBM44Vkx--
