From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 05/13] Assemble: fix assembly in the delta_disks >
	max_degraded case
Date: Thu, 18 Nov 2010 10:22:01 +0100
Message-ID: <20101118092201.29508.16243.stgit@gklab-170-111.igk.intel.com>
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

Incremental assembly works on such an array because the kernel sees the
disk as in-sync and that the array is reshaping.  Teach Assemble() the
same assumptions.

This is only needed on kernels that do not initialize ->recovery_offset
when activating spares for reshape.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Assemble.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index afd4e60..409f0d7 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -804,7 +804,9 @@ int Assemble(struct supertype *st, char *mddev,
 		    devices[most_recent].i.events) {
 			devices[j].uptodate = 1;
 			if (i < content->array.raid_disks) {
-				if (devices[j].i.recovery_start == MaxSector) {
+				if (devices[j].i.recovery_start == MaxSector ||
+				    (content->reshape_active &&
+				     j >= content->array.raid_disks - content->delta_disks)) {
 					okcnt++;
 					avail[i]=1;
 				} else

