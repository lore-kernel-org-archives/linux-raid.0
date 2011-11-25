From: Przemyslaw Czarnowski
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH] imsm: fix: does not allow to use invalid chunk size
Date: Fri, 25 Nov 2011 13:12:04 +0100
Message-ID: <20111125121204.662.4111.stgit@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Only least significant bit of chunk size provided by user has been used
in test with OROM capabilities. This way user could pass value which is
not a power of 2.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 platform-intel.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/platform-intel.h b/platform-intel.h
index 6c094d7..99450ba 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -124,11 +124,13 @@ static inline int imsm_orom_has_raid5(const struct imsm_orom *orom)
 static inline int imsm_orom_has_chunk(const struct imsm_orom *orom, int chunk)
 {
 	int fs = ffs(chunk);
+	int orom_chunk_bit;
 
 	if (!fs)
 		return 0;
 	fs--; /* bit num to bit index */
-	return !!(orom->sss & (1 << (fs - 1)));
+	orom_chunk_bit = (orom->sss & (1 << (fs - 1)));
+	return orom_chunk_bit && 1 << orom_chunk_bit == chunk;
 }
 
 

