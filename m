From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 0/6] Add raid0<->raid10 takeover support for imsm metadata
Date: Thu, 13 Jan 2011 16:32:18 +0100
Message-ID: <20110113152722.20266.24174.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

The following series implements raid0<->raid10 takeover support
for imsm metadata format.
It contains also some fixes for generic takeover flow.

---

Krzysztof Wojcik (6):
      Define imsm_analyze_change function
      Set reshape.after.data_disks for raid0<->raid10 takeover
      Unfreeze for non re-striping transitions
      Add raid10 -> raid0 takeover support
      raid0->raid10 takeover- create metadata update
      raid0->raid10 takeover- allocate memory for added disks


 Grow.c        |    5 +
 super-intel.c |  289 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 282 insertions(+), 12 deletions(-)

-- 
Krzyszto Wojcik
