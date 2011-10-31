From: Jes.Sorensen@redhat.com
Subject: [PATCH 05/11] partition_try_spare() use closedir() to release DIR * returned by opendir()
Date: Mon, 31 Oct 2011 15:02:33 +0100
Message-ID: <1320069759-13361-6-git-send-email-Jes.Sorensen@redhat.com>
References: <1320069759-13361-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320069759-13361-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Incremental.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 7e345c5..cc50a79 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1199,6 +1199,8 @@ static int partition_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 			close(fd);
 	}
 
+	closedir(dir);
+
 	if (!chosen)
 		return 1;
 
-- 
1.7.6.4

