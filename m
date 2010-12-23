From: Przemyslaw Czarnowski
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 0/5] Autorebuild, spare/spare-same-slot fixes
Date: Thu, 23 Dec 2010 17:02:00 +0100
Message-ID: <20101223155614.5562.4773.stgit@gklab-170-211.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

The following series changes (improves) behaviors implemented so far in 
Incremental for bare disks.
It enables some features for containers working so far only for native
metadata (size check and degradation) and fixes domain checking for 
"same slot" action.

---

Przemyslaw Czarnowski (5):
      external: get number of failed disks for container
      Added test for array degradation for spare-same-slot
      Skip domain check for spare-same-slot
      Validate size of potential spare disk for external metadata (with containers)
      Consider target only for spare-same-domain


 Incremental.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 66 insertions(+), 13 deletions(-)

-- 
Best Regards
Przemyslaw Czarnowski
