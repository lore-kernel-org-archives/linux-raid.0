From: mwilck@arcor.de
Subject: [PATCH 2/3] DDF test: make sure mdmon isn't started by systemd
Date: Sat, 14 Sep 2013 22:47:11 +0200
Message-ID: <1379191632-32719-2-git-send-email-mwilck@arcor.de>
References: <1379191632-32719-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1379191632-32719-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

For testing we usually want the locally built mdmon, not the
one systemd prefers.
---
 tests/env-ddf-template |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tests/env-ddf-template b/tests/env-ddf-template
index aa57fab..a607c10 100644
--- a/tests/env-ddf-template
+++ b/tests/env-ddf-template
@@ -104,3 +104,6 @@ member1=/dev/md/vol1
 member2=/dev/md/vol2
 member3=/dev/md/vol3
 member4=/dev/md/vol4
+
+# We don't want systemd to start system mdmon; start our own
+export MDADM_NO_SYSTEMCTL=1
-- 
1.7.3.4
