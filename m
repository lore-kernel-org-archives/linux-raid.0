From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] raid6check.c add page size check and repair
Date: Thu, 23 Jan 2014 12:30:58 +1100
Message-ID: <20140123123058.72f07aa7@notabene.brown>
References: <20140118181823.GA15757@lazy.lzy>
	<52DD4ABD.5060605@itwm.fraunhofer.de>
	<20140120182223.GA4871@lazy.lzy>
	<20140120191022.GA8006@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Ru+ZzVHh37016WYbWqSTXPJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140120191022.GA8006@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Ru+ZzVHh37016WYbWqSTXPJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Jan 2014 20:10:22 +0100 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> Hi again,
>=20
> I'm polluting the mailing list now... Sorry!
>=20
> I found a couple of really stupid bugs, so this
> re-re-patch should fix them.
>=20
> Sorry for the noise.
>=20

Hi,
 I've applied that patch - it looks believable.

However:
1/ If you could try putting a description of what the patch does, and why, =
at
the top, that would help a lot.
See  http://www.ozlabs.org/~akpm/stuff/tpp.txt

2/  I'm not really happy about:
> @@ -217,26 +231,31 @@ int check_stripes(struct mdinfo *info, i
>  		block_index_for_slot[diskP] =3D data_disks;
>  		blocks[data_disks+1] =3D stripes[diskQ];
>  		block_index_for_slot[diskQ] =3D data_disks+1;
> -
> +/* Do we really need the code below? */
> +#if 0
>  		if (memcmp(p, stripes[diskP], chunk_size) !=3D 0) {
>  			printf("P(%d) wrong at %llu\n", diskP, start);
>  		}
>  		if (memcmp(q, stripes[diskQ], chunk_size) !=3D 0) {
>  			printf("Q(%d) wrong at %llu\n", diskQ, start);
>  		}
> +#endif


If you think it should be removed, then delete it completely.  It will still
exist in the git history so they is no really loss of code.
If you aren't sure, then don't delete it at all.  Ask.  Explain your thinki=
ng
and seek opinions.
In either case it should be in a separate patch.
I've left the "#if 0" etc for now but if you could push through to a
resolution and send a patch I would appreciate it.

Thanks,
NeilBrown

--Sig_/Ru+ZzVHh37016WYbWqSTXPJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUuBw0jnsnt1WYoG5AQJeyw//RHVLKwpa++pFWWT+xQsDo/PF9rXYyWON
1Kj8xxjy1ctdTkwmvtQWlQ5sRUpmn4DJCF8vNasIrx2c+sU53K2X/8py42YnnOiZ
MWVTCO0foyLQOk2qcTMYCgG/8ZYUBw6ypE59Tu8mIr00iu+mNJAN/ozsj37niC8Y
xBK0RarzANgD6rt8m+Ng6L0S6YQd8+oRIZjiFxWvsRSIvEnvcAlB7c3/lpIyOQ88
trQopvjRijs3M+oM9B7yTHvY7DcwT9z9TlbtFfFRubBDa8wtmpoKK00RroxMgo3d
1gqtsD4Z0+btiMHLhOH+c+5gw4RdshD4FKet6jn0756BIt+wYjalmwLoACDhMkgM
pVmIVWdI5Ks+WMXr3o8lAph1oJ+4B7eIyZkKfe5OnUA+batoFup8IM6YYIpXFjRW
Wpk15pMzafXTXapXjxKjbhzHjWCepF2L6urEbVaAkrHuHT7F3sOWFpZsxjpIU9nQ
T9hO8zjEDPVK+kGrBIyAj0EF/x/VExixHPmzBbXGVn9aWt8fAKog6YOzGc85Odkp
LW2zq/qHax0vh8mbf6cQ+AgrZnYMQ48A93oktJD0YuLJYDcB7jfyqo2+/wAQ0g2K
w1xsXE8X+dJJfblGpWRhR4y7ui8ST9RsT+BECvhF6zkGZl5VTtjprEA4SPlSjHEC
NiYTLzQfaE0=
=IREM
-----END PGP SIGNATURE-----

--Sig_/Ru+ZzVHh37016WYbWqSTXPJ--
