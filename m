From: Przemyslaw Czarnowski
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 4/4] imsm: monitor: do not finish recovery,
 when raid goes to read-only
Date: Thu, 05 Apr 2012 17:31:26 +0200
Message-ID: <20120405153126.19851.45474.stgit@linux.site>
References: <20120405152553.19851.48052.stgit@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120405152553.19851.48052.stgit@linux.site>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

If kernel forces raid to be read-only (eg. during reboot, and root
partition lies on array) monitor should not finish recovery and leave
metadata untouched.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 monitor.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/monitor.c b/monitor.c
index c987d10..6a736a0 100644
--- a/monitor.c
+++ b/monitor.c
@@ -304,6 +304,7 @@ static int read_and_act(struct active_array *a)
 	}
 
 	if (!deactivate &&
+	    a->curr_state != readonly &&
 	    a->curr_action == idle &&
 	    a->prev_action == recover) {
 		/* A recovery has finished.  Some disks may be in sync now,

