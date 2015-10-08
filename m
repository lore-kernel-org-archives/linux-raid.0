From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH RESEND] imsm: don't call abort_reshape() in imsm_manage_reshape()
Date: Thu, 08 Oct 2015 15:23:00 +1100
Message-ID: <87612i6laz.fsf@notabene.neil.brown.name>
References: <56127893.6070606@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56127893.6070606@intel.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Konrad Dabrowski <konrad.dabrowski@intel.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:

> Calling abort_reshape() in imsm_manage_reshape() is unnecessary in case
> of an error because it is handled by reshape_array(). Calling it when
> reshape completes successfully is also unnecessary and leads to a race
> condition:
> - reshape ends
> - mdadm calls abort_reshape() -> sets sync_action to idle
> - MD_RECOVERY_INTR is set and md_reap_sync_thread() does not finish the
>   reshape
>
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> Signed-off-by: Konrad Dabrowski <konrad.dabrowski@intel.com>
> ---
>  super-intel.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/super-intel.c b/super-intel.c
> index 95a72b6..e609e0c 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -10601,7 +10601,6 @@ static int imsm_manage_reshape(
>  	ret_val =3D 1;
>  abort:
>  	free(buf);
> -	abort_reshape(sra);
>=20=20
>  	return ret_val;
>  }
> --=20
> 2.1.4

Thanks for the resend.
Applied now.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWFe+kAAoJEDnsnt1WYoG5HvYP/2XeO2jZ36YIX1UnhxxsMI6/
ODoz07Z4kCRROjugTEgbl9OIkCmvkxHm4wYLQbpRa5PM7mlE4/8W4gU+TOKt1wpJ
pZ22A/3qwYe7BZXfSG3smQCpqoaZESbaacSDaNshHpAa4pMIbZG3LxY359K5V8DX
7l2UGntIqC9IrHobgdtZtGTQdnr0D5preLXheHwOVOy9ON3/6lN8zkVuotLeb6N6
m0e3tz5a2o6ocy57H6Xoqg7nZDBypO9SkkDOZnMPSXLTScl/SXeeCZAbEeFqYGZ6
36bbBGhPKa/KvlnslK1XRPp+ESGxomTGCW/hMYEy9CptDK65sRy6xvNh9SiF/LKC
44JYEgYtZHvkH5/2Vjid+mz9rhLK6AgSh2qtDOh0Po+FwLhC6MhXz/AS6Mtrvw5W
mWeoxs1GrFp7cLvcx52RA79Feh47octWv9gTMSIfuiee2WiG1v66mFVqmrnER9bu
fP/hyX/DSuzS4xaraBRV3Zg59hxbvBXEMkBnfaGfbu3jjN5BwBitOiei0yAXuZR1
OjkfrAXZ9cPusNDTd/6b8SeqT6rzt37m8/r/FvaxZJHZjN9sR5lFFIdI87oDsZ4k
VKW3XyM1Ln6rBp5NSNGjhLxpkeG39SJB1PS8sVW8/O+90hm06LL34oFqXbtVsAru
1g9rhajR9tU33TFe8Uey
=H2On
-----END PGP SIGNATURE-----
--=-=-=--
