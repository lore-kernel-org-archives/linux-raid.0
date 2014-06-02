From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] Grow: Do not fork via systemd if freeze_reshape is
 set
Date: Mon, 2 Jun 2014 12:42:26 +1000
Message-ID: <20140602124226.31b4c3da@notabene.brown>
References: <84A53BEA6EAC69439B7E311E9B17A76F07918D3F@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cyu_fPgWKb.RWpNkqytc49L"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84A53BEA6EAC69439B7E311E9B17A76F07918D3F@IRSMSX105.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

--Sig_/cyu_fPgWKb.RWpNkqytc49L
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 30 May 2014 14:40:11 +0000 "Baldysiak, Pawel"
<pawel.baldysiak@intel.com> wrote:

> Mdadm should not run 'grow-continue' unit file for container if
> '--freeze-reshape' argument is passed. Otherwise it will be ignored,
> and reshape will start anyway.
>=20
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
> Grow.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index 158a709..487111e 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -3472,7 +3472,7 @@ int reshape_container(char *container, char *devnam=
e,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 =C2=A0*/
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 ping_monitor(container);
>=20
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 if (!forked && !check_env("MDADM_NO_SYSTEMCTL"))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (!forked && !freeze_reshape && !check_env("MDADM_NO_SYSTEMCTL"))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (continue_via_systemd(container))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>=20

Applied - thanks.

NeilBrown

--Sig_/cyu_fPgWKb.RWpNkqytc49L
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU4vkkjnsnt1WYoG5AQLLLRAAm1QYn0WtrixQdtL7X5dkxxKBOXMW0EWq
cRTfBXvSyEss/efKBitlk8staX3j8Dop+cMUwJ3E53cgArwZq5S+d+Tt7tsAsGbj
eizSktgaaqaiLobf0ivWUA/3WX1lLxsBzHF/od1WZELwHHrh73sNUMLiWlvXBVPc
RyxxTw2XtYUz5WfOgKX2N6ddZFOew6bvKwLahGKP35gKgQjFnBKgZc32ljeHqaVw
vQwIXzSz8Yxr9s1w8H3sgh1XrwgMOdlEPfcYCbh1TUfD9Wg1t3UUofakCrChQx4F
li6Dqm7mqVuJ7iScIK3s+j+VPiuQwcg2whGiTOEYXvbD6R2DQ9yWeJbIhg1xkBT7
sCXXdG7q01PE/IF3/R9BPK9qCVedZNmHtTHXXfrHAbLS8NQWuYdpiDzDFivhr3bJ
n74JCfh83moYj1KScMgbEz7jdVXirxYOqsgxiLuOojqV2YGXC1OTHAzv4wLtRP3L
o7p+FTz3163S5EBo5q/FwrfNGtM4xbbr5QO/bh6RDaw12QsmlZvvrI81ZmOeClJ2
nP6asEf44rUxfvv+W8bOIVyGje/85+RAPS9PFEPrCBKMk+vAXz4rnfdFW81MuC/W
VVrny58yHE/if15X4MO56YtyjNVfKtnDMZORCWdp2SSVsXA1UOMmFCipsBxnfyY7
4wXxkfCrbTI=
=6a2E
-----END PGP SIGNATURE-----

--Sig_/cyu_fPgWKb.RWpNkqytc49L--
