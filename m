From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Reset bad flag on map update
Date: Thu, 8 Mar 2012 09:26:30 +1100
Message-ID: <20120308092630.6c992e26@notabene.brown>
References: <3F8F31A3BFD1664EAB894D1BD6AF32B915714B17@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jpSlNSmCjgTB5r1eXQw+y/q"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F8F31A3BFD1664EAB894D1BD6AF32B915714B17@IRSMSX102.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>
List-Id: linux-raid.ids

--Sig_/jpSlNSmCjgTB5r1eXQw+y/q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 7 Mar 2012 12:51:30 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> Map file may miss an entry if bad flag is not cleared on update.
>=20
> This happens for example when an old entry exists in map that
> has no mdstat counterpart and we create a new array with the same devnum.
> Newly created array will not appear in map if update doesnt clear bad fla=
g.
>=20
> Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
> ---
>  mapfile.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/mapfile.c b/mapfile.c
> index 0bfecd0..9e2c893 100644
> --- a/mapfile.c
> +++ b/mapfile.c
> @@ -246,6 +246,7 @@ int map_update(struct map_ent **mpp, int devnum, char=
 *metadata,
>  			memcpy(mp->uuid, uuid, 16);
>  			free(mp->path);
>  			mp->path =3D path ? strdup(path) : NULL;
> +			mp->bad =3D 0;
>  			break;
>  		}
>  	if (!mp)

applied, thanks.

NeilBrown

--Sig_/jpSlNSmCjgTB5r1eXQw+y/q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT1fgljnsnt1WYoG5AQI2Ig//Rv3IWm5gob8QZdEqpgrhctHsKsc2zEXg
RV4pe9IvaaNwvahEDWsal3VdBEUzQ74VmT9E7G7ez5afxDcH/v4uYCG6zaJgwlZj
7+G4e6ddOfH9iPdEOC6YWs89IZU42coZ/djI6mGmqWyUd5jMqZI7EZqFdW/8jss4
sHgSQvY219vBw0KnpOz8Kr/sj7xl/i3hdBGA6z4VacG5W2OXzbatN1zb9grDQ1Kj
WmuR6YhU23RfMkUwdgbMUXcy44nADYpdw0uIZL6rnEIxaWUKTtLOFbxBTv2IGSD+
RwV2YLlim94AGSekhwSDnZOISpsmeWAhOfk7nC0mTa2BPRf8x7wvJjZyJEckR8jx
oH3QvCsZzp/LrUA+86F6DepW/9dpjiOwjwGotnLxuYsEpmZjxJsjdx5GABtp1RVZ
ENbpUelzW93WrQ591N3dJxGx0A/kv2atBzawYqP3v03+vYFAxtIn878UJ/03wOJ+
eZ3HtcYSGSjlMNhKhVJZp5PtIQiReWx3c+ndE9ONGq4SzJXbU02DW7mPEvAlsJxp
+ojXxBLFUU35OVgiPN9ndD/Jwl2y1syXdqr0aJARLf0caOqP/NiB5Qzgcc1qSdj7
9BzyI8aF4MkdE0lvLfV1hudWFAUg2vvFQH8SXverDCJZfVtN11k+iekO8kX4qPva
tD/l2lbKVYo=
=/FOU
-----END PGP SIGNATURE-----

--Sig_/jpSlNSmCjgTB5r1eXQw+y/q--
