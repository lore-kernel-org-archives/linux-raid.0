From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 08/53] fix a get_linux_version() comparison typo
Date: Fri, 26 Nov 2010 09:04:52 +0100
Message-ID: <20101126080452.5221.53227.stgit@gklab-170-024.igk.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
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

