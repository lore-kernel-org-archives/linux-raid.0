From: Jes.Sorensen@redhat.com
Subject: [PATCH 11/12] fd2devname(): Don't dereference NULL pointer
Date: Wed,  2 Nov 2011 15:42:16 +0100
Message-ID: <1320244937-9739-12-git-send-email-Jes.Sorensen@redhat.com>
References: <1320244937-9739-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320244937-9739-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super-intel.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index b583b35..f776be9 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2868,8 +2868,10 @@ static void fd2devname(int fd, char *name)
 	
 	dname[rv] = '\0';
 	nm = strrchr(dname, '/');
-	nm++;
-	snprintf(name, MAX_RAID_SERIAL_LEN, "/dev/%s", nm);
+	if (nm) {
+		nm++;
+		snprintf(name, MAX_RAID_SERIAL_LEN, "/dev/%s", nm);
+	}
 }
 
 extern int scsi_get_serial(int fd, void *buf, size_t buf_len);
-- 
1.7.6.4

