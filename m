From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 0/2] Fixes for double degraded array
Date: Wed, 23 Mar 2011 16:04:11 +0100
Message-ID: <20110323150115.15226.20076.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Two fixes for double degraded array;
1. Fix in mdmon
2. Fix for raid0->raid10 takeover tests

---

Krzysztof Wojcik (2):
      FIX: imsm: Rebuild does not start on second failed disk
      FIX: Tests: raid0->raid10 without degradation


 monitor.c                          |    4 ++++
 tests/18imsm-r0_2d-takeover-r10_4d |    4 +++-
 tests/env-imsm-template            |    7 -------
 tests/imsm-grow-template           |    7 ++-----
 4 files changed, 9 insertions(+), 13 deletions(-)

-- 
Krzysztof Wojcik
