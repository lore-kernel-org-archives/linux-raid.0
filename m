From: Petr Vorel <pvorel@suse.cz>
Subject: [RESENT PATCH 1/1] Makefile: install mdadm_env.sh to /usr/lib/mdadm
Date: Mon, 24 Feb 2020 14:36:25 +0100
Message-ID: <20200224133625.16050-1-pvorel@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: colyli <colyli@suse.coly>, NeilBrown <neilb@suse.com>, Petr Vorel <pvorel@suse.cz>, Coly Li <colyli@suse.de>
List-Id: linux-raid.ids

From: colyli <colyli@suse.coly>

Current Makefile installs mdadm_env.sh to /usr/libexec/mdadm but calls it
from /usr/lib/mdadm. This patch changes the installation directory to
/usr/lib/mdadm to make things working.

Fixes: f93b797 ("Move mdadm_env.sh out of /usr/lib/systemd")

Reviewed-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Coly Li <colyli@suse.de>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index a33319a..0f2fffd 100644
--- a/Makefile
+++ b/Makefile
@@ -91,7 +91,7 @@ MDMON_DIR = $(RUN_DIR)
 # place for autoreplace cookies
 FAILED_SLOTS_DIR = $(RUN_DIR)/failed-slots
 SYSTEMD_DIR=/lib/systemd/system
-LIB_DIR=/usr/libexec/mdadm
+LIB_DIR=/usr/lib/mdadm
 
 COROSYNC:=$(shell [ -d /usr/include/corosync ] || echo -DNO_COROSYNC)
 DLM:=$(shell [ -f /usr/include/libdlm.h ] || echo -DNO_DLM)
-- 
2.25.1
