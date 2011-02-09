From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/4] FIX: array after migration should be unfrozen
Date: Wed, 09 Feb 2011 14:47:54 +0100
Message-ID: <20110209134754.4559.28494.stgit@gklab-128-013.igk.intel.com>
References: <20110209134737.4559.34527.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110209134737.4559.34527.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

After level migration array is left frozen.
When process is not externally forked reshape_array() should
unfreeze array before exit (this is not container operation).

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index e3d3cb8..402da5e 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2095,6 +2095,7 @@ started:
 out:
 	if (forked)
 		return 0;
+	unfreeze(st);
 	exit(0);
 
 release:

