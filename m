From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH RESEND] imsm: don't call abort_reshape() in
 imsm_manage_reshape()
Date: Mon, 5 Oct 2015 15:18:11 +0200
Message-ID: <56127893.6070606@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Konrad Dabrowski <konrad.dabrowski@intel.com>
List-Id: linux-raid.ids

Calling abort_reshape() in imsm_manage_reshape() is unnecessary in case
of an error because it is handled by reshape_array(). Calling it when
reshape completes successfully is also unnecessary and leads to a race
condition:
- reshape ends
- mdadm calls abort_reshape() -> sets sync_action to idle
- MD_RECOVERY_INTR is set and md_reap_sync_thread() does not finish the
  reshape

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Signed-off-by: Konrad Dabrowski <konrad.dabrowski@intel.com>
---
 super-intel.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/super-intel.c b/super-intel.c
index 95a72b6..e609e0c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -10601,7 +10601,6 @@ static int imsm_manage_reshape(
 	ret_val = 1;
 abort:
 	free(buf);
-	abort_reshape(sra);
 
 	return ret_val;
 }
-- 
2.1.4

