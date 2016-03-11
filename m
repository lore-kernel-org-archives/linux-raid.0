From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH 2/2] super-intel: Simplify for() loop in ahci_enumerate_ports
Date: Fri, 11 Mar 2016 16:47:16 +0100
Message-ID: <1457711236-16990-2-git-send-email-pawel.baldysiak@intel.com>
References: <1457711236-16990-1-git-send-email-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457711236-16990-1-git-send-email-pawel.baldysiak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@redhat.com, artur.paszkiewicz@intel.com, Pawel Baldysiak <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

This patch simplifies for() loop used in
ahci_enumerate_ports(). It makes it more readable.
Similar thing was done in b913501
({platform,super}-intel: Fix two resource leaks).

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 super-intel.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/super-intel.c b/super-intel.c
index 8a80c5b..1bc3688 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1624,7 +1624,10 @@ static int ahci_enumerate_ports(const char *hba_path, int port_count, int host_b
 	 * this hba
 	 */
 	dir = opendir("/sys/dev/block");
-	for (ent = dir ? readdir(dir) : NULL; ent; ent = readdir(dir)) {
+	if (!dir)
+		return 1;
+
+	for (ent = readdir(dir); ent; ent = readdir(dir)) {
 		int fd;
 		char model[64];
 		char vendor[64];
-- 
2.5.0

