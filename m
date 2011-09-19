From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: RE: [PATCH 5/9] imsm: fix reserved sectors for spares
Date: Mon, 19 Sep 2011 12:57:48 +0000
Message-ID: <3F8F31A3BFD1664EAB894D1BD6AF32B9024C2A@IRSMSX102.ger.corp.intel.com>
References: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
	<20110826021424.28015.2342.stgit@localhost6.localdomain6>
	<CABE8wwv08oPwU4maaBULCoy993v=uhGny0_gTWFdYHDsoYLvEg@mail.gmail.com>
	<20110830122036.357e63f0@notabene.brown>
 <CABE8wwv3Uk1pY_D5aAh49+aaoKi9cwwqv6YoqSHGgjw30iQbOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABE8wwv3Uk1pY_D5aAh49+aaoKi9cwwqv6YoqSHGgjw30iQbOg@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>
List-Id: linux-raid.ids

The patch below makes a better decision as to the size of required rese=
rvation.

> -----Original Message-----
> From: Williams, Dan J [mailto:dan.j.williams@intel.com]
> Sent: Tuesday, September 06, 2011 10:43 PM
> To: NeilBrown
> Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Labun, Marcin;
> Ciechanowski, Ed
> Subject: Re: [PATCH 5/9] imsm: fix reserved sectors for spares
>=20
> On Mon, Aug 29, 2011 at 7:20 PM, NeilBrown <neilb@suse.de> wrote:
> >> Anna rightly points out that this could probably be safely made
> >> bigger. =A0As it stands this applies to too broad an array of disk=
s.
> =A0I
> >> think a happy medium (until we can nail down the forward
> compatibility
> >> of older oroms, v8 in this case) is to detect the case where the
> disk
> >> is being activated for rebuild and if it is at least as large as o=
ne
> >> of the existing members truncate the reserved region to the same
> size
> >> as the other member. =A0That way we are at least compatible with
> >> whatever agent created the array in the first instance.
> >>
> >
> > I think you are saying that I can go ahead and apply this patch, bu=
t
> that it
> > might get improved upon in the future .... I hope that is right ?
>=20
> Yes, this may have corrected things too far in the other direction,
> but is less surprising than what we had before.

=46rom bf5c919219d9947a0eba1ce2b450c8f663291f48 Mon Sep 17 00:00:00 200=
1
=46rom: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Mon, 19 Sep 2011 13:41:46 +0200
Subject: [PATCH] Calculate reservation for a spare based on active disk=
s in container

New function to calculate minimum reservation to expect from a spare
is introduced.

The required amount of space at the end of the disk depends on what we
plan to do with the spare and what array we want to use it in.
=46or creating new subarray in an empty container the full reservation =
of
MPB_SECTOR_COUNT + IMSM_RESERVED_SECTORS is required.

=46or recovery or OLCE on a volume using new metadata format at least
MPB_SECTOR_CNT + NUM_BLOCKS_DIRTY_STRIPE_REGION is required.
The additional space for migration optimization included in
IMSM_RESERVED_SECTORS is not necessary and is not reserved by some orom=
s.

MPB_SECTOR_CNT alone is not sufficient as it does not include the
reservation at the end of subarray.

However if the real reservation on active disks is smaller than this
(when the array uses old metadata format) we should use the real value.
This will allow OLCE and recovery to start on the spare even if the vol=
ume
doesn't have the reservation we normally use for new volumes.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 super-intel.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++=
+++++--
 1 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index f1c924f..8dad03c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -88,6 +88,7 @@
=20
 #define MPB_SECTOR_CNT 2210
 #define IMSM_RESERVED_SECTORS 4096
+#define NUM_BLOCKS_DIRTY_STRIPE_REGION 2056
 #define SECT_PER_MB_SHIFT 11
=20
 /* Disk configuration info. */
@@ -827,6 +828,8 @@ static int count_memberships(struct dl *dl, struct =
intel_super *super)
 	return memberships;
 }
=20
+static __u32 imsm_min_reserved_sectors(struct intel_super *super);
+
 static struct extent *get_extents(struct intel_super *super, struct dl=
 *dl)
 {
 	/* find a list of used extents on the given physical device */
@@ -840,7 +843,7 @@ static struct extent *get_extents(struct intel_supe=
r *super, struct dl *dl)
 	 * IMSM_RESERVED_SECTORS region
 	 */
 	if (dl->index =3D=3D -1)
-		reservation =3D MPB_SECTOR_CNT;
+		reservation =3D imsm_min_reserved_sectors(super);
 	else
 		reservation =3D MPB_SECTOR_CNT + IMSM_RESERVED_SECTORS;
=20
@@ -933,6 +936,51 @@ static int is_failed(struct imsm_disk *disk)
 	return (disk->status & FAILED_DISK) =3D=3D FAILED_DISK;
 }
=20
+/* try to determine how much space is reserved for metadata from
+ * the last get_extents() entry on the smallest active disk,
+ * otherwise fallback to the default
+ */
+static __u32 imsm_min_reserved_sectors(struct intel_super *super)
+{
+	struct extent *e;
+	int i;
+	__u32 min_active, remainder;
+	__u32 rv =3D MPB_SECTOR_CNT + IMSM_RESERVED_SECTORS;
+	struct dl *dl, *dl_min =3D NULL;
+
+	if (!super)
+		return rv;
+
+	min_active =3D 0;
+	for (dl =3D super->disks; dl; dl =3D dl->next) {
+		if (dl->index < 0)
+			continue;
+		if (dl->disk.total_blocks < min_active || min_active =3D=3D 0) {
+			dl_min =3D dl;
+			min_active =3D dl->disk.total_blocks;
+		}
+	}
+	if (!dl_min)
+		return rv;
+
+	/* find last lba used by subarrays on the smallest active disk */
+	e =3D get_extents(super, dl_min);
+	if (!e)
+		return rv;
+	for (i =3D 0; e[i].size; i++)
+		continue;
+
+	remainder =3D min_active - e[i].start;
+	free(e);
+
+	/* to give priority to recovery we should not require full
+	   IMSM_RESERVED_SECTORS from the spare */
+	rv =3D MPB_SECTOR_CNT + NUM_BLOCKS_DIRTY_STRIPE_REGION;
+
+	/* if real reservation is smaller use that value */
+	return  (remainder < rv) ? remainder : rv;
+}
+
 /* Return minimum size of a spare that can be used in this array*/
 static unsigned long long min_acceptable_spare_size_imsm(struct supert=
ype *st)
 {
@@ -941,6 +989,7 @@ static unsigned long long min_acceptable_spare_size=
_imsm(struct supertype *st)
 	struct extent *e;
 	int i;
 	unsigned long long rv =3D 0;
+	__u32 reservation;
=20
 	if (!super)
 		return rv;
@@ -958,9 +1007,12 @@ static unsigned long long min_acceptable_spare_si=
ze_imsm(struct supertype *st)
 		continue;
 	if (i > 0)
 		rv =3D e[i-1].start + e[i-1].size;
+	reservation =3D __le32_to_cpu(dl->disk.total_blocks) - e[i].start;
 	free(e);
+
 	/* add the amount of space needed for metadata */
-	rv =3D rv + MPB_SECTOR_CNT + IMSM_RESERVED_SECTORS;
+	rv =3D rv + imsm_min_reserved_sectors(super);
+
 	return rv * 512;
 }
=20
--=20
1.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
