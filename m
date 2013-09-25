From: mwilck@arcor.de
Subject: [PATCH 4/6] tests/env-ddf-template: add helper function for checksums
Date: Wed, 25 Sep 2013 22:42:00 +0200
Message-ID: <1380141722-31454-1-git-send-email-mwilck@arcor.de>
References: <1380050242-31857-2-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1380050242-31857-2-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids


Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 tests/env-ddf-template |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tests/env-ddf-template b/tests/env-ddf-template
index cc9cc2b..c0a4b71 100644
--- a/tests/env-ddf-template
+++ b/tests/env-ddf-template
@@ -1,3 +1,7 @@
+sha1_sum() {
+    sha1sum "$1" | cut -c 1-40
+}
+
 get_rootdev() {
     local dev=$(stat -c %D /)
     local maj=$(expr $dev : '\(..\)')
-- 
1.7.3.4
