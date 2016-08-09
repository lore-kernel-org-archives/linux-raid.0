From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH] Incremental: don't try to load_container() for a subarray
Date: Tue,  9 Aug 2016 10:05:51 +0200
Message-ID: <20160809080551.2226-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

mdadm -IRs would exit with a non-zero status because of this.

Reported-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 Incremental.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Incremental.c b/Incremental.c
index ba97b00..cc01d41 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1347,8 +1347,12 @@ restart:
 
 		if (devnm && strcmp(devnm, me->devnm) != 0)
 			continue;
-		if (devnm && me->metadata[0] == '/') {
+		if (me->metadata[0] == '/') {
 			char *sl;
+
+			if (!devnm)
+				continue;
+
 			/* member array, need to work on container */
 			strncpy(container, me->metadata+1, 32);
 			container[31] = 0;
-- 
2.9.2

