From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 1/2] add sysfs_array_state to struct mdinfo
Date: Mon, 14 Dec 2015 17:43:42 -0800
Message-ID: <1450143823-1145846-2-git-send-email-songliubraving@fb.com>
References: <1450143823-1145846-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1450143823-1145846-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, dan.j.williams@intel.com, shli@fb.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Add sysfs_array_state to struct mdinfo, and add GET_ARRAY_STATE to
options of sysfs_read.

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 mdadm.h | 4 ++++
 sysfs.c | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/mdadm.h b/mdadm.h
index 840a359..21fe789 100755
--- a/mdadm.h
+++ b/mdadm.h
@@ -305,6 +305,9 @@ struct mdinfo {
 	#define	DS_REMOVE	1024
 	#define	DS_UNBLOCK	2048
 	int prev_state, curr_state, next_state;
+
+	/* info read from sysfs */
+	char		sysfs_array_state[20];
 };
 
 struct createinfo {
@@ -588,6 +591,7 @@ enum sysfs_read_flags {
 	GET_SIZE	= (1 << 22),
 	GET_STATE	= (1 << 23),
 	GET_ERROR	= (1 << 24),
+	GET_ARRAY_STATE = (1 << 25),
 };
 
 /* If fd >= 0, get the array it is open on,
diff --git a/sysfs.c b/sysfs.c
index f1fd610..2600343 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -230,6 +230,13 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 			goto abort;
 	}
 
+	if (options & GET_ARRAY_STATE) {
+		strcpy(base, "array_state");
+		if (load_sys(fname, sra->sysfs_array_state))
+			goto abort;
+	} else
+		sra->sysfs_array_state[0] = 0;
+
 	if (! (options & GET_DEVS))
 		return sra;
 
-- 
2.4.6

