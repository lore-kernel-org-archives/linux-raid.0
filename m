From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: fix checking completion of RAID10 resync
Date: Wed, 31 Jul 2013 09:22:40 +1000
Message-ID: <20130731092240.3230bf7f@notabene.brown>
References: <20130730135925.30168.91570.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.6eI3OU5Vuq8Zouw7lBbbiT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130730135925.30168.91570.stgit@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org, lukasz.dorau@intel.com
List-Id: linux-raid.ids

--Sig_/.6eI3OU5Vuq8Zouw7lBbbiT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Jul 2013 15:59:25 +0200 Pawel Baldysiak
<pawel.baldysiak@intel.com> wrote:

> If one creates RAID10 with IMSM metadata the is_resync_complete
> function returns '1' just when initial resync reaches 50%
>=20
> IMSM version of the is_resync_complete function has been added
> that handles the case of IMSM RAID10 correctly.
>=20
>=20
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  super-intel.c |   20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 4df33f4..0371713 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -1021,6 +1021,22 @@ static int is_failed(struct imsm_disk *disk)
>  	return (disk->status & FAILED_DISK) =3D=3D FAILED_DISK;
>  }
> =20
> +/* IMSM version of is_resync_complete helper routine
> + * to determine resync completion
> + * since MaxSector is a moving target
> + */
> +static int imsm_is_resync_complete(struct mdinfo *array)
> +{
> +	if (array->array.level !=3D 10) {
> +		if (array->resync_start >=3D array->component_size)
> +			return 1;
> +	} else {
> +		if (array->resync_start >=3D 2*array->component_size)
> +			return 1;
> +	}
> +	return 0;
> +}
> +
>  /* try to determine how much space is reserved for metadata from
>   * the last get_extents() entry on the smallest active disk,
>   * otherwise fallback to the default
> @@ -7119,12 +7135,12 @@ static int imsm_set_array_state(struct active_arr=
ay *a, int consistent)
>  		handle_missing(super, dev);
> =20
>  	if (consistent =3D=3D 2 &&
> -	    (!is_resync_complete(&a->info) ||
> +	    (!imsm_is_resync_complete(&a->info) ||
>  	     map_state !=3D IMSM_T_STATE_NORMAL ||
>  	     dev->vol.migr_state))
>  		consistent =3D 0;
> =20
> -	if (is_resync_complete(&a->info)) {
> +	if (imsm_is_resync_complete(&a->info)) {
>  		/* complete intialization / resync,
>  		 * recovery and interrupted recovery is completed in
>  		 * ->set_disk


Thanks.
However the bug is not specific to intel, so should be fixed in common code.
And "2*" is not really very general.

The following patch should fix it properly.  If you can confirm that it fix=
es
the problem for you I would appreciate it.

Thanks,
NeilBrown

=46rom 71d68ff62f945254240575cd836f5f2a09ced5d2 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 31 Jul 2013 09:18:57 +1000
Subject: [PATCH] Fix is_resync_complete for RAID10

For RAID10, 'sync' numbers go up to the array size rather than the
component size.  is_resync_complete() needs to allow for this.

Reported-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/mdmon.h b/mdmon.h
index 60fda38..5a8e120 100644
--- a/mdmon.h
+++ b/mdmon.h
@@ -91,7 +91,21 @@ extern int monitor_loop_cnt;
  */
 static inline int is_resync_complete(struct mdinfo *array)
 {
-	if (array->resync_start >=3D array->component_size)
-		return 1;
-	return 0;
+	unsigned long long sync_size =3D 0;
+	int ncopies, l;
+	switch(array->array.level) {
+	case 1:
+	case 4:
+	case 5:
+	case 6:
+		sync_size =3D array->component_size;
+		break;
+	case 10:
+		l =3D array->array.layout;
+		ncopies =3D (l & 0xff) * ((l >> 8) && 0xff);
+		sync_size =3D array->component_size * array->array.raid_disks;
+		sync_size /=3D ncopies;
+		break;
+	}
+	return array->resync_start >=3D sync_size;
 }


--Sig_/.6eI3OU5Vuq8Zouw7lBbbiT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfhKwDnsnt1WYoG5AQLVZBAAw5PTeZhKp+xVPeLJ4KGmYjZtntHje7dl
jZyjX8hXTKv0Avvcjx7cY0Q3P7KmdkyaWswsFk7gXJqkpfP1sT36KKNR/3dZwVH8
lo8k+7RTC+Xrvfa/ocIZOLe158J3a5PHsotJSS85mPmPiZTB5P4LjrCGHRyC192X
Wr60ldMkZRJC0s0he+1b2Hs6QS1s8A67elw+WIpvOaSsrcth0cDLwDiroi6+G1wM
TYKYf4LWZCEEAS4n6lMopzLRmPWTvMgTOX7l/CDcwqln15jMDFhKR6YGmoTmNxkR
kWzoTn47rYKbyt1tDXO9ImhXlylvLv6ApaQ7hXtDlmxRhGuZxK8UgQXRgAgaki6v
LlFO/7yqtrAGcIoVhD86+rRpU0BgzPlIIxovH3yKtrGYIGS35ASBT228ksHX6MWp
KZelsT9V8SI1mgplGsNB8nOH+E3A+4/EgaypdjHylqgpVC/9Nq4Qewbb4HqzUKsL
/uJUhFgXPCv4He6R+AhzyQVHbIaMG26yHarlfn8j6az7oy+Z9i4BPxlAKvS4dySe
3uyMpDPNOHTC7600yy9ZZXo8eGqNWfPzPK/wE4i+I/5W9Yf+Hb0VfJnD4vGrHOtg
DSF0Th/JNhRGHz1rsilBRrAeDqAMUK25kjIQWyhsq6DUyusQ8EaA4YeM+ZRvFNju
NaAzfZl4VQk=
=00cB
-----END PGP SIGNATURE-----

--Sig_/.6eI3OU5Vuq8Zouw7lBbbiT--
