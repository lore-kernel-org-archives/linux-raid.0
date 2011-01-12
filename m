From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 0/6] raid10->raid0 takeover for imsm metadata
Date: Wed, 12 Jan 2011 17:00:49 +0100
Message-ID: <20110112155905.18013.73701.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

---

Krzysztof Wojcik (6):
      reshape_super reorganization
      Define imsm_analyze_change function
      Set delta_disks for raid10 -> raid0 takeover
      FIX: Mistake in delta_disk comparison.
      Remove code for non re-striping operations.
      Add raid10 -> raid0 takeover support


 Grow.c        |   80 +++++---------
 super-intel.c |  322 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 334 insertions(+), 68 deletions(-)

-- 
Signature
