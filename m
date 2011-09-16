From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 07/14] FIX: Memory leak during Assembly
Date: Fri, 16 Sep 2011 13:54:40 +0200
Message-ID: <20110916115440.5201.42062.stgit@gklab-128-013.igk.intel.com>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

For fdlist pointer allocated in assemble_container_content() function,
free() is never called. This patch fixes this memory leak.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 25cfec1..66d2ee4 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1584,6 +1584,7 @@ int assemble_container_content(struct supertype *st, int mdfd,
 				if (fdlist[spare] >= 0)
 					close(fdlist[spare]);
 			}
+			free(fdlist);
 			if (err) {
 				fprintf(stderr, Name ": Failed to restore critical"
 					" section for reshape - sorry.\n");

