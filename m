From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm PATCH 09/12] Detail: export MD_UUID from mapfile
Date: Tue, 13 Oct 2009 19:11:01 -0700
Message-ID: <20091014021101.31570.15793.stgit@dwillia2-linux.ch.intel.com>
References: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, krzysztof.wojcik@intel.com, ed.ciechanowski@intel.com, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

The load_super() from an mdadm --detail call may race against an mdmon
update.  When this happens the load_super sees an inconsistent metadata
block and returns an error.  The fallback path to use the map file
contents lacks uuid reporting, so provide __fname_from_uuid for
generically printing a uuid.

Reported-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Detail.c |    5 +++++
 mdadm.h  |    1 +
 util.c   |   12 ++++++++----
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/Detail.c b/Detail.c
index 001012a..1598a42 100644
--- a/Detail.c
+++ b/Detail.c
@@ -194,7 +194,12 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
 				st->ss->export_detail_super(st);
 		} else {
 			struct map_ent *mp, *map = NULL;
+			char nbuf[64];
 			mp = map_by_devnum(&map, fd2devnum(fd));
+			if (mp) {
+				__fname_from_uuid(mp->uuid, 0, nbuf, ':');
+				printf("MD_UUID=%s\n", nbuf+5);
+			}
 			if (mp && mp->path &&
 			    strncmp(mp->path, "/dev/md/", 8) == 0)
 				printf("MD_DEVNAME=%s\n", mp->path+8);
diff --git a/mdadm.h b/mdadm.h
index 04b87b8..8212a2c 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -810,6 +810,7 @@ extern void uuid_from_super(int uuid[4], mdp_super_t *super);
 extern const int uuid_match_any[4];
 extern int same_uuid(int a[4], int b[4], int swapuuid);
 extern void copy_uuid(void *a, int b[4], int swapuuid);
+extern char *__fname_from_uuid(int id[4], int swap, char *buf, char sep);
 extern char *fname_from_uuid(struct supertype *st,
 			     struct mdinfo *info, char *buf, char sep);
 extern unsigned long calc_csum(void *super, int bytes);
diff --git a/util.c b/util.c
index 4ccb1bb..98aedd0 100644
--- a/util.c
+++ b/util.c
@@ -269,17 +269,15 @@ void copy_uuid(void *a, int b[4], int swapuuid)
 		memcpy(a, b, 16);
 }
 
-char *fname_from_uuid(struct supertype *st, struct mdinfo *info, char *buf, char sep)
+char *__fname_from_uuid(int id[4], int swap, char *buf, char sep)
 {
 	int i, j;
-	int id;
 	char uuid[16];
 	char *c = buf;
 	strcpy(c, "UUID-");
 	c += strlen(c);
-	copy_uuid(uuid, info->uuid, st->ss->swapuuid);
+	copy_uuid(uuid, id, swap);
 	for (i = 0; i < 4; i++) {
-		id = uuid[i];
 		if (i)
 			*c++ = sep;
 		for (j = 3; j >= 0; j--) {
@@ -288,6 +286,12 @@ char *fname_from_uuid(struct supertype *st, struct mdinfo *info, char *buf, char
 		}
 	}
 	return buf;
+
+}
+
+char *fname_from_uuid(struct supertype *st, struct mdinfo *info, char *buf, char sep)
+{
+	return __fname_from_uuid(info->uuid, st->ss->swapuuid, buf, sep);
 }
 
 #ifndef MDASSEMBLE

