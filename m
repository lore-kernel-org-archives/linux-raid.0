From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/3] Don't tell sysfs to launch the container as we are
 doing it ourselves
Date: Fri, 23 Dec 2011 10:48:43 +1100
Message-ID: <20111223104843.6ef30cba@notabene.brown>
References: <1319204000-6661-1-git-send-email-Jes.Sorensen@redhat.com>
	<1319204000-6661-3-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4ZkHTKY1/72whOFjZUPj_ry"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1319204000-6661-3-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, lukasz.dorau@intel.com, adam.kwolek@intel.com, dledford@redhat.com
List-Id: linux-raid.ids

--Sig_/4ZkHTKY1/72whOFjZUPj_ry
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Oct 2011 15:33:19 +0200 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  Incremental.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>=20
> diff --git a/Incremental.c b/Incremental.c
> index 1a9a97b..cff7663 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -446,7 +446,6 @@ int Incremental(char *devname, int verbose, int runst=
op,
>  	if (info.array.level =3D=3D LEVEL_CONTAINER) {
>  		int devnum =3D devnum; /* defined and used iff ->external */
>  		/* Try to assemble within the container */
> -		sysfs_uevent(&info, "change");
>  		if (verbose >=3D 0)
>  			fprintf(stderr, Name
>  				": container %s now has %d devices\n",

Hi Jes,
 I've had to revert this patch as it causes a regression.

Without the 'change' event the container device doesn't get created in /dev.

I'm not sure udev should be running "--incremental" on containers anyway, b=
ut
if it does it shouldn't cause problems should it?  If it does we should fix
those problems.

Thanks,
NeilBrown


--Sig_/4ZkHTKY1/72whOFjZUPj_ry
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTvPB2znsnt1WYoG5AQIOYQ//caAWNe7Bo4c6R4E1E3781TKUhal5eSgR
oTIDWMBeprY1RIeRMFAF0TU6fATESU0rWfdpb50SgXht8QnxfVuC6AOrSC9ygxkv
DZvVgD8bD90/ilya0wGHaIVSPmKJb2nZvjx4JUO60FbzNdOyck4TcaqJ4VhrZdKe
bjL1I3gy9hWKqI+iku5PgGKmUb5fk5VOGhONL1RsgNh5YHt5H3TxMFiVSKQcgea1
/gV9l4di/8v59Esga4ZvUTrK0hD6sLvlPwz7qB9+03YKoD8zLXpRec3I4xplWGX1
gfum5ktZox2SGqz/2z8AyAX+cBNjE+DOYG16v2b0qb9JPHZ+k7t9+RIen/WfRgLt
CFXkJVvxKxLSg0EQR4QX/AHUl6o38lfXoqlsBkWhx4yi3qoQm66YV/REXFhDDj1/
FWr+qh5hNrEy055EX34pqpSgBw4haDCuh07Zbi/EAwNCbZmutdfqv5x/kVFH8T9k
ln78FtWsWnarbc4P5Crqurj8YNYXsuJty/EcbMYxUnuhjUMF8yZ+iAYg1zkZXE4O
1RMO77dDVouY+IAc2L2nCPbnYLols7P2MmIl37Ol6moO2oIhQz4iEorFEC4hfKZQ
59uAChQw9z7KCkeTQGldA9/uMrSn+8CGWBKbzIlPlkfkVGXzrauF2cLKCppN4jtZ
Dj4R9qbJ/Pw=
=Mz/L
-----END PGP SIGNATURE-----

--Sig_/4ZkHTKY1/72whOFjZUPj_ry--
