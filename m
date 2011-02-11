From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/4] Raid0 <-> Raid5 migrations (imsm)
Date: Fri, 11 Feb 2011 14:43:50 +0100
Message-ID: <20110211133959.6212.57757.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

The following series implements Raid5 <-> Raid0 migrations
for imsm metadata.

Patches should be applied on top of patches previously sent by me.

BR
Adam


---

Adam Kwolek (4):
      FIX: Target disk number depends on source raid level
      imsm: process update for raid level migrations
      imsm: prepare memory for level migration update
      imsm: prepare update for level migrations reshape


 Grow.c        |    2 
 super-intel.c |  272 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 270 insertions(+), 4 deletions(-)

-- 
Signature
