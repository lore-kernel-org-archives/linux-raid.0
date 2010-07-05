From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 10/33] update domain search to new structures, added subset
 search
Date: Mon, 5 Jul 2010 11:45:43 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC3FA@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C0B@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C0B@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:24 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 10/33] update domain search to new structures, added su=
bset search

=46rom: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.=
com>

new domain/subset model needs some changes in the interface of existing=
 domain solution. Finding domain for device needs additionally the type=
 of metadata we are looking for.
=46or subsets we need supertype with loaded superblock as argument, in =
order to get internal spare group identifier of device (if available).
Patch contains also utility stuff to make use of conf_get_domain/subset=
 easier (e.g. get_active_array_domain allows to get domain/subset pair =
for running array giving its name)

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski=
@intel.com>
---
=A0config.c=A0 |=A0=A0 29 ++++++++++++++++++++++++++---
=A0mapfile.c |=A0=A0 48 +++++++++++++++++++++++++++++++++++++++++++++++=
+
=A0mdadm.h=A0=A0 |=A0=A0=A0 4 +++-
=A0util.c=A0=A0=A0 |=A0=A0 39 ++++++++++++++++++++++++++++++---------
=A04 files changed, 107 insertions(+), 13 deletions(-)

diff --git a/config.c b/config.c
index 6c90d26..5829182 100644
--- a/config.c
+++ b/config.c
@@ -1003,6 +1003,28 @@ static struct supertype *get_supertype_by_name(c=
har *platform)
=A0=A0=A0=A0=A0 return NULL;
=A0}
=A0
+int match_platform(struct supertype *supertype, char *type) {
+=A0=A0=A0=A0 char *platform;
+=A0=A0=A0=A0 struct supertype *st;
+=A0=A0=A0=A0 int rv;
+
+=A0=A0=A0=A0 /* fix 1.x stored in super1.name */
+=A0=A0=A0=A0 platform =3D strdup(type);
+=A0=A0=A0=A0 if (!platform)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+
+=A0=A0=A0=A0 if (!strcmp(platform, "1.x")) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 platform[2] =3D '0';
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 st =3D supertype->ss->match_metadata_desc(platform);
+=A0=A0=A0=A0 rv =3D (st !=3D NULL);
+
+=A0=A0=A0=A0 free(st);
+=A0=A0=A0=A0 free(platform);
+
+=A0=A0=A0=A0 return rv;
+}
=A0/* returns domain basing on path matching and superblock type (in th=
at order).
=A0 * If st=3D=3DNULL, just match paths.
=A0 */
@@ -1024,7 +1046,8 @@ struct domain_ent *get_domain_from_devpath(char *=
devpath, char *platform)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
t =3D get_supertype_by_name(de->platform);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
f (!st)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 continue;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(st->ss->match_metadata_desc(platform)) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(match_platform(st, platform)) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 st->ss->free_super(st);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 free(st);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 return de;
@@ -1241,8 +1264,8 @@ static void domain_make_platforms(struct domain_e=
nt *de)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 f=
ree_domain_list(&domain_list);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 r=
eturn;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free(de->platform);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 de->platform =3D strd=
up(name);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free(de_new->platform=
);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 de->platform =3D name=
;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 de =3D de_new;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 de->platform =3D na=
me;
diff --git a/mapfile.c b/mapfile.c
index 0f12559..dae8e88 100644
--- a/mapfile.c
+++ b/mapfile.c
@@ -492,3 +492,51 @@ void RebuildMap(void)
=A0=A0=A0=A0=A0 map_free(map);
=A0=A0=A0=A0=A0 free_mdstat(mdstat);
=A0}
+
+/* returns device name (eg. /dev/md127) matching matching path
+ * of map_ent with given argument
+ */
+char *get_array_devname(char *array)
+{
+=A0=A0=A0=A0 struct map_ent *map =3D NULL, *me;
+=A0=A0=A0=A0 char name[PATH_MAX];
+
+=A0=A0=A0=A0 if (!array)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;
+
+=A0=A0=A0=A0 map_read(&map);
+=A0=A0=A0=A0 if (!map)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;
+=A0=A0=A0=A0 me =3D map_by_name(&map, array);
+=A0=A0=A0=A0 if (me) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 snprintf(name, sizeof(name), "/dev/md%d=
", me->devnum);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 map_free(map);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return strdup(name);
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 map_free(map);
+=A0=A0=A0=A0 return NULL;
+}
+
+/* returns device name (eg. /dev/md127) matching matching uuid
+ * of map_ent with given argument
+ */
+char *get_array_devname_by_uuid(int (*uuid)[4]) {
+=A0=A0=A0=A0 struct map_ent *map =3D NULL, *me;
+=A0=A0=A0=A0 char name[PATH_MAX];
+
+=A0=A0=A0=A0 if (!uuid)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;
+
+=A0=A0=A0=A0 map_read(&map);
+=A0=A0=A0=A0 if (!map)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;
+=A0=A0=A0=A0 me =3D map_by_uuid(&map, *uuid);
+=A0=A0=A0=A0 if (me) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 snprintf(name, sizeof(name), "/dev/md%d=
", me->devnum);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 map_free(map);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return strdup(name);
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 map_free(map);
+=A0=A0=A0=A0 return NULL;
+}
diff --git a/mdadm.h b/mdadm.h
index 0e14ba5..b6d7933 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1017,8 +1017,10 @@ extern int stat2devnum(struct stat *st);=A0 exte=
rn int fd2devnum(int fd);=A0 extern char *get_devpath_from_devname(char=
 *devname);=A0 extern char *get_array_devname(char *array);
+extern char *get_array_devname_by_uuid(int (*uuid)[4]);
=A0extern struct supertype *dev_load_supertype(char *devname); -extern =
int get_active_array_domain(char *array_name, struct domain_ent **domai=
n,
+extern int get_active_array_domain(char *array_name, int fd,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0 struct domain_ent **domain,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0 struct subset **subset);
=A0extern int is_external(char *metadata_verison);
=A0
diff --git a/util.c b/util.c
index cf08add..62544fd 100644
--- a/util.c
+++ b/util.c
@@ -1820,17 +1820,19 @@ struct supertype *dev_load_supertype(char *devn=
ame)
=A0=A0=A0=A0=A0 strcpy(devpath, "/dev/");
=A0=A0=A0=A0=A0 strcat(devpath, devname);
=A0=A0=A0=A0=A0 fd =3D open(devpath, O_RDONLY);
-=A0=A0=A0=A0 if (!fd) {
+=A0=A0=A0=A0 if (fd < 0) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free(devpath);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;
=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0 st =3D guess_super(fd);
=A0=A0=A0=A0=A0 if (!st) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free(devpath);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(fd);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;
=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0 if (st->ss->load_super(st, fd, devpath)) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free(devpath);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(fd);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;
=A0=A0=A0=A0=A0 }
=A0
@@ -1842,20 +1844,39 @@ struct supertype *dev_load_supertype(char *devn=
ame)
=A0/* Sets domain and subset appropriately to the domain/subset of firs=
t
=A0 * accessible array member. Returns !0 for failure.
=A0 */
-int get_active_array_domain(char *array_name, struct domain_ent **doma=
in,
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 struct subset **s=
ubset)
+int get_active_array_domain(char *array_name, int fd, struct domain_en=
t **domain,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0 struct subs=
et **subset)
=A0{
=A0=A0=A0=A0=A0 struct mdstat_ent *mds, *me;
=A0=A0=A0=A0=A0 struct supertype *st;
=A0=A0=A0=A0=A0 struct dev_member *dm;
-=A0=A0=A0=A0 char *name;
+=A0=A0=A0=A0 mdu_array_info_t array;
+=A0=A0=A0=A0 int md_opened =3D fd >=3D 0;
+
+=A0=A0=A0=A0 memset(&array, 0, sizeof(mdu_array_info_t));
=A0
-=A0=A0=A0=A0 if (!domain || !subset)
+=A0=A0=A0=A0 if (!domain || !subset || !array_name)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
=A0
-=A0=A0=A0=A0 name =3D strrchr(array_name, '/');
-=A0=A0=A0=A0 if (!name++)
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 name =3D array_name;
+=A0=A0=A0=A0 if (fd < 0) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fd =3D open(array_name, O_RDONLY);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (fd < 0) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name =
": error opening %s: %s\n",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 arr=
ay_name, strerror(errno));
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0 }
+
+=A0=A0=A0=A0 if (ioctl(fd, GET_ARRAY_INFO, &array)) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name ": cannot get arra=
y info for %s\n",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 array_name);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!md_opened)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(fd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
+=A0=A0=A0=A0 }
+
+=A0=A0=A0=A0 if (!md_opened)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(fd);
=A0
=A0=A0=A0=A0=A0 mds =3D mdstat_read(0, 0);
=A0=A0=A0=A0=A0 if (!mds) {
@@ -1864,7 +1885,7 @@ int get_active_array_domain(char *array_name, str=
uct domain_ent **domain,
=A0=A0=A0=A0=A0 }
=A0
=A0=A0=A0=A0=A0 for (me =3D mds; me; me =3D me->next) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!strstr(me->dev, name))
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (array.md_minor !=3D me->devnum)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* try to obtain domain/subset for fi=
rst available member */
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
