From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH 1/4] mdadm: bad block support for external metadata - initialization
Date: Mon, 28 Nov 2016 15:07:05 +0100
Message-ID: <1480342025-19508-1-git-send-email-tomasz.majchrzak@intel.com>
References: <wrfjr35vpw2j.fsf@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjr35vpw2j.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

If metadata handler provides support for bad blocks, tell md by writing
'external_bbl' to rdev state file (both on create and assemble),
followed by a list of known bad blocks written via sysfs 'bad_blocks'
file.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 mdadm.h | 13 +++++++++++++
 sysfs.c | 27 ++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/mdadm.h b/mdadm.h
index 240ab7f..4aa1d30 100755
--- a/mdadm.h
+++ b/mdadm.h
@@ -237,6 +237,17 @@ struct dlm_lksb {
 
 extern const char Name[];
 
+struct md_bb_entry {
+	unsigned long long sector;
+	int length;
+};
+
+struct md_bb {
+	int supported;
+	int count;
+	struct md_bb_entry *entries;
+};
+
 /* general information that might be extracted from a superblock */
 struct mdinfo {
 	mdu_array_info_t	array;
@@ -311,6 +322,8 @@ struct mdinfo {
 
 	/* info read from sysfs */
 	char		sysfs_array_state[20];
+
+	struct md_bb bb;
 };
 
 struct createinfo {
diff --git a/sysfs.c b/sysfs.c
index f8a9f0b..84c7348 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -52,8 +52,10 @@ void sysfs_free(struct mdinfo *sra)
 		while (sra->devs) {
 			struct mdinfo *d = sra->devs;
 			sra->devs = d->next;
+			free(d->bb.entries);
 			free(d);
 		}
+		free(sra->bb.entries);
 		free(sra);
 		sra = sra2;
 	}
@@ -261,7 +263,7 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 		dbase = base + strlen(base);
 		*dbase++ = '/';
 
-		dev = xmalloc(sizeof(*dev));
+		dev = xcalloc(1, sizeof(*dev));
 
 		/* Always get slot, major, minor */
 		strcpy(dbase, "slot");
@@ -691,6 +693,7 @@ int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume)
 	char nm[PATH_MAX];
 	char *dname;
 	int rv;
+	int i;
 
 	sprintf(dv, "%d:%d", sd->disk.major, sd->disk.minor);
 	rv = sysfs_set_str(sra, NULL, "new_dev", dv);
@@ -722,6 +725,28 @@ int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume)
 		if (resume)
 			sysfs_set_num(sra, sd, "recovery_start", sd->recovery_start);
 	}
+	if (sd->bb.supported) {
+		if (sysfs_set_str(sra, sd, "state", "external_bbl")) {
+			/*
+			 * backward compatibility - if kernel doesn't support
+			 * bad blocks for external metadata, let it continue
+			 * as long as there are none known so far
+			 */
+			if (sd->bb.count) {
+				pr_err("The kernel has no support for bad blocks in external metadata\n");
+				return -1;
+			}
+		}
+
+		for (i = 0; i < sd->bb.count; i++) {
+			char s[30];
+			const struct md_bb_entry *entry = &sd->bb.entries[i];
+
+			snprintf(s, sizeof(s) - 1, "%llu %d\n", entry->sector,
+				 entry->length);
+			rv |= sysfs_set_str(sra, sd, "bad_blocks", s);
+		}
+	}
 	return rv;
 }
 
-- 
1.8.3.1

