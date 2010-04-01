From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/2] imsm: delete subarray functionality
Date: Thu, 01 Apr 2010 12:41:34 -0400
Message-ID: <4BB4CCBE.90902@redhat.com>
References: <66C59AD0932712458090B447266D638CD3C7EAF4@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig90FEBBEFEF057C2891B2C53C"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66C59AD0932712458090B447266D638CD3C7EAF4@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig90FEBBEFEF057C2891B2C53C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/31/2010 04:50 PM, Hawrylewicz Czarnowski, Przemyslaw wrote:
> Patch also adds some utilities

One of which I see as being useful outside of the scope that you have
envisioned:

> diff --git a/mdstat.c b/mdstat.c
> index 4a9f370..bb6179d 100644
> --- a/mdstat.c
> +++ b/mdstat.c

This is a generic file and routines in this code should be generic, not
specific to a supertype.

> +
> +/*
> + * Finds name of the active array holding this device
> + * @param[in]  devname         name of member device
> + * @param[out] devname         name of array
> + *
> + * @return                     found (0), or
> + *                             not found, failure (1)
> + */
> +
> +int mdstat_check_active(char *devname)
> +{
> +       struct mdstat_ent *mdstat =3D mdstat_read(0, 0);
> +       struct mdstat_ent *ent;
> +       char *name;
> +
> +       if (!devname)
> +               return 1;
> +       name =3D strrchr(devname, '/');
> +       if (name++ =3D=3D NULL)
> +               return 1;
> +
> +       for (ent =3D mdstat; ent; ent =3D ent->next) {
> +               struct dev_member *m;
> +               if (ent->active) /* only containers */
> +                       continue;
> +               for (m =3D ent->members; m; m =3D m->next) {
> +                       if (!strcmp(m->name, name)) {
> +                               strcpy(devname, ent->dev);
> +                               return 0;
> +                       }
> +               }
> +       }
> +       return 1;
> +}

This in particular is useful for things other than just looking up
containers.  It is useful for finding either native or external metadata
based arrays that have a specific device in them.  I will probably snag
this for my code, but change it so that it is generic.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig90FEBBEFEF057C2891B2C53C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku0zL4ACgkQg6WylM+/8ZQepQCeJnT4wBcOhZOhsELPUQkqi15V
vkYAoJglmXgx1cTHXMNtflL/VzfKhw98
=Bkb1
-----END PGP SIGNATURE-----

--------------enig90FEBBEFEF057C2891B2C53C--
