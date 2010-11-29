From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] FIX: chunk_size cannot be read by mdstat
Date: Mon, 29 Nov 2010 10:56:50 +0100
Message-ID: <20101129095650.12551.98023.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Chunk size is not read by mdstat due to too week checking of 'check' string in mdstat.
It is the same result for 'check' and 'chunk_size' check.

Add  string length additional condition for checking.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdstat.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mdstat.c b/mdstat.c
index bb030bf..5f69e31 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -248,7 +248,8 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 				else
 					ent->resync = 0;
 			} else if (ent->percent == -1 &&
-				   (w[0] == 'r' || w[0] == 'c')) {
+				   (w[0] == 'r' ||
+				    ((w[0] == 'c') && strlen(w) < 9))) {
 				if (strncmp(w, "resync", 4)==0)
 					ent->resync = 1;
 				if (strncmp(w, "reshape", 7)==0)

