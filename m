From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [mdadm PATCH 10/11] Enable OLCE for external IMSM metadata
Date: Wed, 24 Feb 2010 07:44:59 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D1016F65C3@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From 45520939e3eea6b4f697de6f813f9d362dc7b5bd Mon Sep 17 00:00:00 2001
From: Adam Kwolek <adam.kwolek@intel.com>
Date: Thu, 18 Feb 2010 11:10:48 +0100
Subject: [PATCH] OLCE: Workaround for mdstat problems

Changes to be committed:
	modified:   mdstat.c

Core can occur in mdmon if lines are released during configuration changes.
This should be resolved by new mdstat written by Artur Wojcik.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 mdstat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mdstat.c b/mdstat.c
index d7045a7..5883d0e 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -129,7 +129,7 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 
 	all = NULL;
 	end = &all;
-	for (; (line = conf_line(f)) ; free_line(line)) {
+	for (; (line = conf_line(f)) ; /* free_line(line)*/) {
 		struct mdstat_ent *ent;
 		char *w;
 		int devnum;
-- 
1.6.0.2

