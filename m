From: Jes.Sorensen@redhat.com
Subject: [PATCH 2/2] super-intel.c: Fix resource leak from opendir()
Date: Fri,  4 May 2012 15:41:22 +0200
Message-ID: <1336138882-31869-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1336138882-31869-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1336138882-31869-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Use closedir() on dirp from opendir() to avoid resource leaking.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super-intel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index ca15703..e2ed95a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5686,6 +5686,7 @@ get_devices(const char *hba_path)
 			free(dv);
 		}
 	}
+	closedir(dir);
 	return devlist;
 }
 
-- 
1.7.7.6

