From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/7] Grow_continue, use in assembly (cont.)
Date: Tue, 01 Mar 2011 15:56:41 +0100
Message-ID: <20110301144932.10678.20916.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

The following series implements next part of resuming reshape from checkpoint.
In this series call to invoke reshape is included.
It is required to have backup file to run reshape, so backup file validation is added
(without checking in file system)
Array seams to be configured for reshape, monitor is blocked and doesn't makes changes
to process. On the end of reshape monitor unblock is placed also.

In patch:
   Continue reshape after assembling array
some plans for supporting container operations is placed.

Reshape restoring is not working yet (a few more pathes are still required)
I hope some of therm I'll post tomorrow.

BR
Adam

---

Adam Kwolek (7):
      FIX: array is frozen after reshape
      Continue reshape after assembling array
      FIX: Block monitor when starting array with reshape in progress
      Add block_subarray()
      FIX: configure disks slot for expansion
      FIX: reshape in md should wait for monitoring process (external metadata)
      FIX: Verify Backup file name before reshape


 Assemble.c    |   64 +++++++++++++++++++++++++++++++++++++++++++++------------
 Grow.c        |   15 ++++++++++++-
 Incremental.c |    1 +
 msg.c         |   18 ++++++++++++----
 msg.h         |    2 ++
 5 files changed, 81 insertions(+), 19 deletions(-)

-- 
Signature
