From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] Create.c: check if freesize is equal 0
Date: Fri, 16 Nov 2012 17:24:36 +0100
Message-ID: <20121116162436.11415.87524.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

"freesize" can be equal 0 after rounding to the chunk's size.
Creating should be aborted in such case.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 Create.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Create.c b/Create.c
index afcf1a5..f5b7194 100644
--- a/Create.c
+++ b/Create.c
@@ -399,6 +399,11 @@ int Create(struct supertype *st, char *mddev,
 		if (s->chunk && s->chunk != UnSet) {
 			/* round to chunk size */
 			freesize = freesize & ~(s->chunk-1);
+			if (!freesize) {
+				pr_err("no free space left on %s\n", dname);
+				fail = 1;
+				continue;
+			}
 			if (do_default_chunk) {
 				/* default chunk was just set */
 				if (c->verbose > 0)

