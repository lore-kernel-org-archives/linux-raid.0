From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 09/21] imsm: FIX: Do not verify unused parameters
Date: Wed, 08 Jun 2011 18:10:46 +0200
Message-ID: <20110608161046.24327.33033.stgit@gklab-128-013.igk.intel.com>
References: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Parameters that are not used by imsm_manage_reshape() should not cause
failure of this function.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 0d46132..437975f 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8689,7 +8689,7 @@ static int imsm_manage_reshape(
 	unsigned long long start_buf_shift; /* [bytes] */
 	int degraded = 0;
 
-	if (!fds || !offsets || !destfd || !destoffsets || !sra)
+	if (!fds || !offsets || !sra)
 		goto abort;
 
 	/* Find volume during the reshape */

