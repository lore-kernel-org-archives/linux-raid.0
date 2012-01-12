From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/4] Reshape problems during double raid0 processing
Date: Thu, 12 Jan 2012 08:12:24 +0100
Message-ID: <20120112070822.5168.97729.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

The following series fixes problems found during double raid0 container reshape.
1. Second raid0 reshape doesn't start
2. Second raid0 array reshape is not finalized in metadata

BR
Adam

---

Adam Kwolek (4):
      FIX: Typo error in fprint command
      FIX: mdmon check in reshape_container() can cause a problem
      FIX: External metadata sometimes is not updated
      FIX: Takeover mdmon when grow is continued from command line


 Grow.c  |   11 ++++-------
 mdadm.h |    1 +
 util.c  |   53 ++++++++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 49 insertions(+), 16 deletions(-)

-- 
Signature
