From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/8] OLCE Raid5/0 single array for external meta
Date: Wed, 12 Jan 2011 14:54:18 +0100
Message-ID: <20110112132954.15045.41564.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Thank you for review previous OLCE series. 

I've reviewed metadata update method to avoid as you pointed layering violation.

The previous approach was prepared to minimize places to do the same things.
1. one for metadata update via mdmon
2. second for direct metadata update by mdata (no mdmon case)

Current approach, is a try for making one updates processing patch for mdmon and "no mdmon" case.
1. mdmon case:
   a) reshape_super()
           - prepare update
           - append_metadata_update()
           - apply last update in queue (top of '->updates')  using prepare/process update functions
                update is not removed from queue
   b) sync_metadata() to flush update to mdmon

2. no mdmon case
  a) reshape_super()
     Works in the same way as in "mdmon case"
   b) sync_metadata() to flush metadata (already updated) to array
     if there is any update in update queue it is released, it is assumed that only one direct update
     is curently supported.


This mechanism is implemented in patches:
      imsm: FIX: old devices memory has to be released
      imsm: FIX: local mdadm update shouldn't be done in update creation function.
      imsm: FIX: mdadm should process local data
      FIX: put update in to queue for local meta update

The rest are mainly bug fixes.

The one patch "FIX: reload metadata for container operation" needs more comments.
So far I've to reload metadata in reshape_container(), I've learned that you prefer reload metadat on the end of reshape_array().
I think that we should proceed in the same way when reshape_array() is forked externally and code returns to caller.

I'm waiting for your review, meanwhile I'll make some work for next arrays in container reshape

BR
Adam




---

Adam Kwolek (8):
      FIX: reload metadata for container operation
      Finalize reshape after adding disks to array
      imsm: FIX: spares are not counted
      FIX: Cannot load container information
      imsm: FIX: old devices memory has to be released
      imsm: FIX: local mdadm update shouldn't be done in update creation function.
      imsm: FIX: mdadm should process local data
      FIX: put update in to queue for local meta update


 Grow.c        |   28 ++++++++++++++--
 monitor.c     |   11 ++++++
 super-intel.c |  101 ++++++++++++++++++---------------------------------------
 util.c        |   10 +++++-
 4 files changed, 76 insertions(+), 74 deletions(-)

-- 
Signature
