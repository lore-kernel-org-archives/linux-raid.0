From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/8] Set of fixes for expansion
Date: Tue, 01 Feb 2011 14:48:56 +0100
Message-ID: <20110201134226.13398.4071.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Fixes are related to reshape finalization and next array reshape start.
First patch allows to reach checkpointing end of array. This enables
reshape finalization code in set_array_state() (not used so far).

Then array finalization code in mdmon is put in to single place 
and setting array size mechanism after reshape in mdmon is enabled.
This makes setting size in mdadm not necessary.

Some code cleanup (debug strings, put common code in to function)
was introduced also.

BR
Adam

---

Adam Kwolek (8):
      imsm: move common code for array size calculation to function
      imsm: FIX: Debug strings cleanup
      FIX: Do not set array size after reshape in mdadm
      imsm: fix: imsm_num_data_members() can return error
      imsm: FIX: put expansion finalization in to one place
      imsm: FIX: Size is already set in metadata
      imsm: FIX: array size is wrong
      FIX: Last checkpoint is not set


 Grow.c        |   35 --------------
 monitor.c     |   18 +++++++
 super-intel.c |  141 ++++++++++++++++++++++++++-------------------------------
 3 files changed, 82 insertions(+), 112 deletions(-)

-- 
Signature
