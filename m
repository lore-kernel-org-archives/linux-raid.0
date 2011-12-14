From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 3/3] imsm: FIX: UT '08imsm-overlap' fails
Date: Wed, 14 Dec 2011 10:21:07 -0800
Message-ID: <CABE8wwt44LbrKEGJjoUyjOt5zDP2=uO60hVPYfWpxMHi+EuQwg@mail.gmail.com>
References: <20111214150448.21483.16231.stgit@gklab-128-013.igk.intel.com>
	<20111214150720.21483.27249.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111214150720.21483.27249.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

On Wed, Dec 14, 2011 at 7:07 AM, Adam Kwolek <adam.kwolek@intel.com> wr=
ote:
> Problem was introduced by patch (2011-09-19):
> =A0 Create: Allow to create two volumes of different sizes within one=
 container
>
> To resolve problem check requested disks number not against all disks
> recorded in metadata, but against disks number set in array map struc=
ture.
>
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>
> =A0super-intel.c | =A0 24 ++++++++++++++++++++----
> =A01 files changed, 20 insertions(+), 4 deletions(-)
>
> diff --git a/super-intel.c b/super-intel.c
> index 5e1d278..3c10d29 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5318,10 +5318,26 @@ static int validate_geometry_imsm_volume(stru=
ct supertype *st, int level,
>
> =A0 =A0 =A0 =A0mpb =3D super->anchor;
>
> - =A0 =A0 =A0 if (mpb->num_raid_devs > 0 && mpb->num_disks !=3D raidd=
isks) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, Name ": the option-rom =
requires all "
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "member disks to be a m=
ember of all volumes.\n");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 /* check if currently verified volume spans the same di=
sks number
> + =A0 =A0 =A0 =A0* as all other arrays that belongs to metadata.
> + =A0 =A0 =A0 =A0* Do not allow to create volume with different disks=
 number
> + =A0 =A0 =A0 =A0* than curently is used.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 for (i =3D 0; i < mpb->num_raid_devs; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* There is any already existing array =
in metadata
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct imsm_dev *dev =3D get_imsm_dev(s=
uper, i);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct imsm_map *map =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dev)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 map =3D get_imsm_map(de=
v, MAP_0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (map) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (raiddisks !=3D map-=
>num_members) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf=
(stderr, Name ": the option-rom requires"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 " all member disks to be a member of "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 "all volumes.\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }

I'd prefer to move this check back to the other 'orom' checks in
validate_geometry_imsm_volume(), and make it dependent on the presence
of the orom.

diff --git a/super-intel.c b/super-intel.c
index 07d47b5..9885b98 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5122,12 +5122,6 @@ static int validate_geometry_imsm_volume(struct
supertype *st, int level,
 	if (!super)
 		return 0;

-	if (mpb->num_raid_devs > 0 && mpb->num_disks !=3D raiddisks) {
-		fprintf(stderr, Name ": the option-rom requires all "
-			"member disks to be a member of all volumes.\n");
-		return 0;
-	}
-
 	if (!validate_geometry_imsm_orom(super, level, layout, raiddisks,
chunk, verbose)) {
 		fprintf(stderr, Name ": RAID gemetry validation failed. "
 			"Cannot proceed with the action(s).\n");
@@ -5206,6 +5200,11 @@ static int validate_geometry_imsm_volume(struct
supertype *st, int level,
 		fprintf(stderr, Name ": The option-rom requires all member"
 			" disks to be a member of all volumes\n");
 		return 0;
+	} else if (super->orom && mpb->num_raid_devs > 0 &&
+		   mpb->num_disks !=3D raiddisks) {
+		fprintf(stderr, Name ": The option-rom requires all member"
+			" disks to be a member of all volumes\n");
+		return 0;
 	}

 	/* retrieve the largest free space block */
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
