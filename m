From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] kill-subarray: fix, IMSM cannot kill-subarray with
 unsupported metadata
Date: Mon, 31 Oct 2011 11:31:51 +1100
Message-ID: <20111031113151.64f566b1@notabene.brown>
References: <F9123E44003394499FDD2B17C60621D4043755@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bSD9IuSD1dQafakHiki/2Ud"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F9123E44003394499FDD2B17C60621D4043755@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/bSD9IuSD1dQafakHiki/2Ud
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Oct 2011 14:46:57 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> Hi Neil,
> Please review modified patch in response for your comments.
> I have introduced two flags, one for activation blocking, second for cont=
ainer wide reshapes
> Blocking:
> - some arrays in container are blocked, the others can be activated and r=
eshaped,
> - some arrays are blocked, others can be activated but container wide res=
haped is blocked for all.
>=20
> Thanks,
> Marcin Labun

Thanks.  This looks mostly OK.
I have applied it -  with a number of formatting improvements and the remov=
al
for a debugging printf :-)

However this bit looks wrong:

> +/*
> + * helper routine to check metadata reshape avalability
> + * 1. Do not "grow" arrays with volume activation blocked
> + * 2. do not reshape containers with container reshape blocked
> + *
> + * IN:
> + *	subarray - array name or NULL for container wide reshape
> + *	content - md device info from container_content
> + * OUT:
> + *	0 - block reshape
> + */
> +static int check_reshape(char *subarray, struct mdinfo *content)
> +{
> +	char *ep;
> +	unsigned int idx;
> +	printf("subarray: %s\n", subarray);
> +
> +=09
> +	if (!subarray) {
> +		if (content->array.state & (1<<MD_SB_BLOCK_CONTAINER_RESHAPE))
> +			return 0;
> +	}
> +	else {
> +		/* do not "grow" arrays with volume activation blocked */
> +		idx =3D strtoul(subarray, &ep, 10);
> +		if ((*ep =3D=3D '\0') && (content->container_member =3D=3D (int) idx) =
&&
> +		    (content->array.state & (1<<MD_SB_BLOCK_VOLUME)))
> +			return 0;
> +	}
> +	 =20
> +	return 1;
> +}

Grow.c shouldn't be doing a 'strtoul' here.  The subarray string belongs to
the metadata handler, mdadm core code shouldn't interpret it at all.

What exactly is the point of that bit of code?

Thanks,
NeilBrown


--Sig_/bSD9IuSD1dQafakHiki/2Ud
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTq3sfDnsnt1WYoG5AQJuAA//Rn4BKOPkwE6gjK39jJK0do4ajrV5my/f
MjsknhrR5qNM0VM9+4IHZJAFWMU3Hz59T9MAkVmSe72z4oJYwa8HOwvrKteFANtm
TtTuvtxp1ODx1iRU7+7hRMpvXcaJtIE1nTy687u6/dD1XeV2SNTwmCnn02YCVdOs
wM2N46WfsuI17hd0Tt8K33AY93WnRWD+YvclLv7Sg+uOsIbcVy+2tqw0YSHyrNyV
Wg49ITVl3+0WnSeItRjrIj+J7KjK1PBJsLOv8R5LFH6g9bnQ8H4860lGy4VpYY0B
woj3Y5LogShZukI/pR/aSdyQTcPYvodT/W4TCt2wvl90OadBZA/0s4hkQ+qmZtpJ
Pd3uk3wgUeYSikGB8nk/bKqnNuhCISO3ajO4VIqXy4NH1GGrRB6ZaaBmz/+wRiWj
Z3bH0fLYAuXC+mhwRDJmuFya680rb2iEaismC9RgkcGWmRbacpFBggpSwS5w79qU
C5Os+3xg61WYRCfntrinzVnjk6aQJkHHqw6ZoQshJOHT+2h3Ir7sUcgzLQqMoEHO
UdHB6Kj6dJwqItKjnjdfb7dQRgWlwaAy6Sa9nEzi1zA2d0hUGY2AfqmKA1H7UhR2
Vu6ZLrq35C9/Z8JbeblKyz3YXr7JlvxQu32+qx7isRUay7cTgrBZzkX99hVxz/g1
71lDusXNfgA=
=T/SN
-----END PGP SIGNATURE-----

--Sig_/bSD9IuSD1dQafakHiki/2Ud--
