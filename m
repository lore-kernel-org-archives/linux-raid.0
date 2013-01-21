From: Jes.Sorensen@redhat.com
Subject: [PATCH 3/3] execl() only returns in case of error
Date: Mon, 21 Jan 2013 14:22:58 +0100
Message-ID: <1358774578-2183-4-git-send-email-Jes.Sorensen@redhat.com>
References: <1358774578-2183-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1358774578-2183-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, harald@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

In case exec fails, fall through and print warning rather than just
calling exit(1) silently.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 util.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/util.c b/util.c
index 500b2bd..68fd27e 100644
--- a/util.c
+++ b/util.c
@@ -1705,7 +1705,6 @@ int start_mdmon(int devnum)
 					}
 				}
 		}
-		exit(1);
 	case -1: pr_err("cannot run mdmon. "
 			 "Array remains readonly\n");
 		return -1;
-- 
1.7.11.7

