From: mwilck@arcor.de
Subject: [PATCH 2/3] tests/env-ddf-template: fix container name
Date: Tue, 24 Sep 2013 21:17:21 +0200
Message-ID: <1380050242-31857-1-git-send-email-mwilck@arcor.de>
References: <1380048798-31699-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1380048798-31699-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

/dev/md/ddf0 works also with assembly. /dev/md/ddf doesn't.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 tests/env-ddf-template |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tests/env-ddf-template b/tests/env-ddf-template
index a607c10..cc9cc2b 100644
--- a/tests/env-ddf-template
+++ b/tests/env-ddf-template
@@ -98,7 +98,7 @@ ddf_check() {
     esac
 }
 
-container=/dev/md/ddf
+container=/dev/md/ddf0
 member0=/dev/md/vol0
 member1=/dev/md/vol1
 member2=/dev/md/vol2
-- 
1.7.3.4
