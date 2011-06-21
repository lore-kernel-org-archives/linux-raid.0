From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 4/4] .gitignore: ignore mdadm.8 file
Date: Wed, 22 Jun 2011 01:19:05 +0900
Message-ID: <1308673145-8151-4-git-send-email-namhyung@gmail.com>
References: <1308673145-8151-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308673145-8151-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mdadm.8 is auto-generated from mdadm.8.in, so ignore it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 .gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index 2503bd8..7200741 100644
--- a/.gitignore
+++ b/.gitignore
@@ -2,6 +2,7 @@
 /*.man
 /*-stamp
 /mdadm
+/mdadm.8
 /mdadm.udeb
 /mdmon
 /swap_super
-- 
1.7.5.2

