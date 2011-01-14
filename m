From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 0/2] Supplement for raid0->raid10 takeover for imsm metadata
Date: Fri, 14 Jan 2011 16:57:16 +0100
Message-ID: <20110114155044.7904.91011.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

This series supplements last raid0<->raid10 series.
Patch "raid0->raid10 takeover- allocate memory for added disks"
replaces the last patch of last series.
Patch "raid0->raid10 takeover- process metadata update"
imlements final metadata update.


---

Krzysztof Wojcik (2):
      raid0->raid10 takeover- allocate memory for added disks
      raid0->raid10 takeover- process metadata update


 super-intel.c |  128 ++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 112 insertions(+), 16 deletions(-)

-- 
Krzysztof Wojcik
