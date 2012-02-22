From: Jes.Sorensen@redhat.com
Subject: [PATCH] Print error message if failing to write super for 1.x metadata
Date: Wed, 22 Feb 2012 12:01:56 +0100
Message-ID: <1329908516-17822-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: meyering@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

In addition remove attempt to print an error message if
write_init_super() fails, as this is handled in the various
write_init_super() functions. This avoids a segfault on error.

Reported by Jim Meyering in
https://bugzilla.redhat.com/show_bug.cgi?id=795461

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Create.c |    3 ---
 super1.c |   20 ++++++++++++++++----
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/Create.c b/Create.c
index 90ff3ed..e5c6b05 100644
--- a/Create.c
+++ b/Create.c
@@ -924,9 +924,6 @@ int Create(struct supertype *st, char *mddev,
 			}
 
 			if (st->ss->write_init_super(st)) {
-				fprintf(stderr,
-					Name ": Failed to write metadata to %s\n",
-					dv->devname);
 				st->ss->free_super(st);
 				goto abort_locked;
 			}
diff --git a/super1.c b/super1.c
index a18952a..1db4de6 100644
--- a/super1.c
+++ b/super1.c
@@ -1106,13 +1106,16 @@ static int write_init_super1(struct supertype *st)
 		}
 		free(refst);
 
-		if (!get_dev_size(di->fd, NULL, &dsize))
-			return 1;
+		if (!get_dev_size(di->fd, NULL, &dsize)) {
+			rv = 1;
+			goto error_out;
+		}
 		dsize >>= 9;
 
 		if (dsize < 24) {
 			close(di->fd);
-			return 2;
+			rv = 2;
+			goto error_out;
 		}
 
 
@@ -1176,7 +1179,11 @@ static int write_init_super1(struct supertype *st)
 			sb->data_size = __cpu_to_le64(dsize - reserved);
 			break;
 		default:
-			return -EINVAL;
+			fprintf(stderr,	Name ": Failed to write invalid "
+				"metadata format 1.%i to %s\n",
+				st->minor_version, di->devname);
+			rv = -EINVAL;
+			goto out;
 		}
 
 
@@ -1192,6 +1199,11 @@ static int write_init_super1(struct supertype *st)
 		close(di->fd);
 		di->fd = -1;
 	}
+error_out:
+	if (rv)
+		fprintf(stderr,	Name ": Failed to write metadata to %s\n",
+			di->devname);
+out:
 	return rv;
 }
 #endif
-- 
1.7.7.6

