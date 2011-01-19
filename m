From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 0/6] A few fixes connected with raid0<->raid10 takeover
Date: Wed, 19 Jan 2011 17:23:00 +0100
Message-ID: <20110119161925.8738.85284.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

The following series is based on my last series.
It include a few fixes connected with raid0<->raid10 takeover
operations for imsm metadata format.

---

Krzysztof Wojcik (6):
      Limit no-restriping operations only for raid5
      FIX: Ping manager after level change
      Check number of failed disks durig raid10->raid0 takeover
      FIX: Remove disks in mdmon for external metadata
      FIX: Reset disk state if disk is missing
      FIX: Unblock disk in kernel only if it is blocked.


 Grow.c        |   86 +++++++++++++++++++++++++++++++--------------------------
 monitor.c     |    6 +++-
 super-intel.c |    4 +++
 3 files changed, 56 insertions(+), 40 deletions(-)

-- 
Krzysztof Wojcik
