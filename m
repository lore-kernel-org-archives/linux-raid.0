From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 6/6] Add help message and man entry for --write-journal
Date: Fri, 28 Aug 2015 16:27:06 -0700
Message-ID: <1440804426-1461372-7-git-send-email-songliubraving@fb.com>
References: <1440804426-1461372-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1440804426-1461372-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, dan.j.williams@intel.com, neilb@suse.de, hch@infradead.org, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Signed-off-by: Shaohua Li <shli@fb.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 ReadMe.c   | 1 +
 mdadm.8.in | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/ReadMe.c b/ReadMe.c
index 10921e3..fb5a671 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -376,6 +376,7 @@ char Help_create[] =
 "  --name=       -N   : Textual name for array - max 32 characters\n"
 "  --bitmap-chunk=    : bitmap chunksize in Kilobytes.\n"
 "  --delay=      -d   : bitmap update delay in seconds.\n"
+"  --write-journal=   : Specify journal device for RAID-4/5/6 array\n"
 "\n"
 ;
 
diff --git a/mdadm.8.in b/mdadm.8.in
index bf3e131..2844039 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -990,6 +990,12 @@ Only works when the array is for clustered environment. It specifies
 the maximum number of nodes in the cluster that will use this device
 simultaneously. If not specified, this defaults to 4.
 
+.TP
+.BR \-\-write-journal
+Specify journal device for the RAID-4/5/6 array. The journal device
+should be a SSD with reasonable lifetime.
+
+
 .SH For assemble:
 
 .TP
-- 
1.8.1

