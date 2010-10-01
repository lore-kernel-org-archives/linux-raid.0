From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: RE: [AUTOREBUILD 5/8] imsm: create mdinfo list of disks in a
 container from supertype
Date: Fri, 1 Oct 2010 13:57:22 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D171D09990@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

=46rom 904cdb060dadb748b264dc99585f44065b3e66c9 Mon Sep 17 00:00:00 200=
1
=46rom: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Tue, 28 Sep 2010 07:43:40 +0200
Subject: [AUTOREBUILD 5/8] imsm: create mdinfo list of disks in a conta=
iner from supertype

If getinfo_super is called on a container supertype we only get informa=
tion
on first disk. As a parameter it uses reference to preallocated
mdinfo structure. Amending getinfo_super to return full list of disks
would require amending all previous calls and subsequently freeing memo=
ry
allocated for mdinfo list. As an alternative a new function
getinfo_super_disks is created to obtain information about all disks
in container. Existing function sysfs_free is used to free memory
allocated by getinfo_super_disks.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
=A0mdadm.h=A0=A0=A0=A0=A0=A0 |=A0=A0=A0 2 +-
=A0super-intel.c |=A0=A0 53 +++++++++++++++++++++++++++++++++++++++++++=
++++++++++
=A02 files changed, 54 insertions(+), 1 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 56452bb..ca4b12b 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -546,7 +546,7 @@ extern struct superswitch {
=A0=A0=A0=A0=A0 =A0*=A0=A0 The device the metadata was loaded from by l=
oad_super
=A0=A0=A0=A0=A0 =A0*/
=A0=A0=A0=A0=A0 void (*getinfo_super)(struct supertype *st, struct mdin=
fo *info);
-
+=A0=A0=A0=A0 struct mdinfo *(*getinfo_super_disks)(struct supertype *s=
t);
=A0=A0=A0=A0=A0 /* Check if the given metadata is flagged as belonging =
to "this"
=A0=A0=A0=A0=A0 =A0* host.=A0 0 for 'no', 1 for 'yes', -1 for "Don't re=
cord homehost"
=A0=A0=A0=A0=A0 =A0*/
diff --git a/super-intel.c b/super-intel.c
index 38d0ae3..02480f2 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1666,6 +1666,58 @@ static void getinfo_super_imsm(struct supertype =
*st, struct mdinfo *info)
=A0=A0=A0=A0=A0 }
=A0}
=A0
+/* allocates memory and fills disk in mdinfo structure
+ * for each disk in container
+ * returns number of created elements of mdinfo list
+ * this memory must be later freed by sysfs_free */
+struct mdinfo *getinfo_super_disks_imsm(struct supertype *st)
+{
+=A0=A0=A0=A0 struct mdinfo *mddev =3D NULL;
+=A0=A0=A0=A0 struct intel_super *super =3D st->sb;
+=A0=A0=A0=A0 struct imsm_disk *disk;
+=A0=A0=A0=A0 int count =3D 0;
+=A0=A0=A0=A0 struct dl *dl;
+=A0=A0=A0=A0 if ((!super) || !st->loaded_container || !(super->disks) =
)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;
+=A0=A0=A0=A0 dl =3D super->disks;
+=A0=A0=A0=A0 mddev =3D malloc(sizeof(*mddev));
+=A0=A0=A0=A0 if (!mddev) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name ": Failed to alloc=
ate memory.\n");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 memset(mddev, 0, sizeof(*mddev));
+
+=A0=A0=A0=A0 while (dl) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct mdinfo *tmp;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 disk =3D &dl->disk;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tmp =3D malloc(sizeof(*tmp));
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!tmp) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name =
": Failed to allocate memory.\n");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (mddev)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sys=
fs_free(mddev);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memset(tmp, 0, sizeof(*tmp));
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (mddev->devs)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tmp->next =3D mddev->=
devs;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mddev->devs =3D tmp;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tmp->disk.number =3D count++;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tmp->disk.major =3D dl->major;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tmp->disk.minor =3D dl->minor;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tmp->disk.state =3D is_configured(disk)=
 ?
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
 (1 << MD_DISK_ACTIVE) : 0;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tmp->disk.state |=3D is_failed(disk) ? =
(1 << MD_DISK_FAULTY) : 0;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tmp->disk.state |=3D is_spare(disk) ? 0=
 : (1 << MD_DISK_SYNC);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tmp->disk.raid_disk =3D -1;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dl =3D dl->next;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 return mddev;
+}
+
=A0static int update_super_imsm(struct supertype *st, struct mdinfo *in=
fo,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0 char *=
update, char *devname, int verbose,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0 int uu=
id_set, char *homehost)
@@ -5580,6 +5632,7 @@ struct superswitch super_imsm =3D {
=A0=A0=A0=A0=A0 .match_home =3D match_home_imsm,
=A0=A0=A0=A0=A0 .uuid_from_super=3D uuid_from_super_imsm,
=A0=A0=A0=A0=A0 .getinfo_super=A0 =3D getinfo_super_imsm,
+=A0=A0=A0=A0 .getinfo_super_disks =3D getinfo_super_disks_imsm,
=A0=A0=A0=A0=A0 .update_super=A0=A0=A0=A0 =3D update_super_imsm,
=A0
=A0=A0=A0=A0=A0 .avail_size =3D avail_size_imsm,
--=20
1.6.4.2



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
