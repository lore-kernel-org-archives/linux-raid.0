From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 04/12] imsm: FIX: imsm_get_allowed_degradation() doesn't count
	degradation for raid1
Date: Tue, 07 Feb 2012 15:03:27 +0100
Message-ID: <20120207140327.20627.55518.stgit@gklab-128-013.igk.intel.com>
References: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com, lukasz.dorau@intel.com
List-Id: linux-raid.ids

Missing case raid1 added to function.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 17034bb..19a2c84 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8771,6 +8771,7 @@ static int imsm_get_allowed_degradation(int level, int raid_disks,
 					struct imsm_dev *dev)
 {
 	switch (level) {
+	case 1:
 	case 10:{
 		int ret_val = 0;
 		struct imsm_map *map;

