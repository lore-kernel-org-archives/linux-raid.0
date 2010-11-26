From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 05/53] Assemble: fix assembly in the delta_disks >
	max_degraded case
Date: Fri, 26 Nov 2010 09:04:30 +0100
Message-ID: <20101126080430.5221.30017.stgit@gklab-170-024.igk.intel.com>
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

