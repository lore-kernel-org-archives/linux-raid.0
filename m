From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 0/2] FIX: Process hangs at wait_barrier
Date: Fri, 04 Feb 2011 14:18:18 +0100
Message-ID: <20110204130757.6426.81544.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Patches resolve problem with process crash at wait_barrier()
after raid0->raid10 takeover.
First patch resolve this particular problem.
Solution is similar to RAID1 barrier implementation.
Second is proposal for general protection against barrier
become negative.

---

Krzysztof Wojcik (2):
      FIX: md: process hangs at wait_barrier after 0->10 takeover
      FIX: md: Prevent barrier become negative


 drivers/md/raid1.c  |    3 ++-
 drivers/md/raid10.c |    9 ++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

-- 
Krzysztof Wojcik
