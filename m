From: mwilck@arcor.de
Subject: [PATCH 1/6] DDF: ddf_activate_spare: fix gcc -O2 uninitialized warning
Date: Fri, 16 Aug 2013 20:21:55 +0200
Message-ID: <1376677320-12816-2-git-send-email-mwilck@arcor.de>
References: <1376677320-12816-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1376677320-12816-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

The warning is spurious, but will break compilation with -O2.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index e3b3dca..95972ad 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -4779,7 +4779,7 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 	struct ddf_super *ddf = a->container->sb;
 	int global_ok = 0;
 	struct mdinfo *rv = NULL;
-	struct mdinfo *di;
+	struct mdinfo *di = NULL;
 	struct metadata_update *mu;
 	struct dl *dl;
 	int i;
-- 
1.7.3.4
