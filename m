From: Jes.Sorensen@redhat.com
Subject: [PATCH 10/12] Manage_ro(): Check pointer rather than dereferencing it
Date: Wed,  2 Nov 2011 15:42:15 +0100
Message-ID: <1320244937-9739-11-git-send-email-Jes.Sorensen@redhat.com>
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
 Manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Manage.c b/Manage.c
index d5110a7..d9775de 100644
--- a/Manage.c
+++ b/Manage.c
@@ -86,7 +86,7 @@ int Manage_ro(char *devname, int fd, int readonly)
 			sysfs_set_str(mdi, NULL, "metadata_version", vers);
 
 			cp = strchr(vers+10, '/');
-			if (*cp)
+			if (cp)
 				*cp = 0;
 			ping_monitor(vers+10);
 			if (mdi->array.level <= 0)
-- 
1.7.6.4

