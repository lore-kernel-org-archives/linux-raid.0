From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 08/13] fix a get_linux_version() comparison typo
Date: Thu, 18 Nov 2010 10:22:25 +0100
Message-ID: <20101118092225.29508.60604.stgit@gklab-170-111.igk.intel.com>
References: <20101118080359.29508.50648.stgit@gklab-170-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101118080359.29508.50648.stgit@gklab-170-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Dan Williams <dan.j.williams@intel.com>

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 mdadm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mdadm.c b/mdadm.c
index 08e8ea4..e3361ed 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1484,7 +1484,7 @@ int main(int argc, char *argv[])
 			break;
 		}
 		if (delay == 0) {
-			if (get_linux_version() > 20616)
+			if (get_linux_version() > 2006016)
 				/* mdstat responds to poll */
 				delay = 1000;
 			else

