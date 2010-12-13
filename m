From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 04/16] FIX: prepare for new spares management
Date: Mon, 13 Dec 2010 15:45:22 +0100
Message-ID: <20101213144522.4384.80703.stgit@gklab-170-024.igk.intel.com>
References: <20101213143604.4384.55544.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101213143604.4384.55544.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When grow uses new spares management from auto-rebuild
Disks list is not guaranteed to be in order.

Signed-off-by: Krzysztof Wojcik <krzysztof.wolcik@intel.com>
---

 super-intel.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 0a27836..bee28bc 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7499,6 +7499,9 @@ static int imsm_reshape_array_manage_new_slots(struct intel_super *super,
 		int fd2;
 		int rv;
 
+		if (dl->index < 0)
+			continue;
+
 		dprintf("\tLooking at device %s (index = %i).\n",
 			dl->devname,
 			dl->index);

