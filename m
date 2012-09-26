From: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
Subject: [PATCH 3/6] Fix return code for --detail-platform
Date: Wed, 26 Sep 2012 13:42:58 +0200
Message-ID: <20120926114257.328.56556.stgit@gklab-128-174.igk.intel.com>
References: <20120926114202.328.71156.stgit@gklab-128-174.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120926114202.328.71156.stgit@gklab-128-174.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

Variable 'err' is initially set to 1, so changing its value with
'|=' won't set it to 0 even if the operation is successful.

Signed-off-by: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
---
 Detail.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Detail.c b/Detail.c
index 57faf3c..96d1ff6 100644
--- a/Detail.c
+++ b/Detail.c
@@ -640,6 +640,7 @@ int Detail_Platform(struct superswitch *ss, int scan, int verbose, int export, c
 	if (!scan)
 		return err;
 
+	err = 0;
 	for (i = 0; superlist[i]; i++) {
 		struct superswitch *meta = superlist[i];
 

