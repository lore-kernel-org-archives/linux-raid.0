From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/9] Grow_continue() - single array.
Date: Wed, 02 Mar 2011 14:28:56 +0100
Message-ID: <20110302132426.24771.99191.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

The following series implements reshape restart from checkpoint.
It supports single array reshape.
Container operations are not fully supported (some code preparation is introduced only /fork()/).

As workaround for container operation multiple container assembly can be used.
During each assembly one array will be reshaped. mdmon switches next array metadata in to reshape state.
This information will be used during next container assembly process.

This series contains some reviewed patches that you not accept last time asn few new.

1. Calling start_reshape() I've changed, but passed flag calculation has to be a little different
   that I've  pointed in the emails (external and restart flags cannot be used together).
2. I'm resending patches for fork() and backup file check in Grow_continue().
   This is begin of support for container operations. It is somehow similar to reshape_container() idea,
   but adapted to assembly code. 
   Assembled array processing is forked. This will allow later (during detected container operation)
   to wait when mdmon set this particular array for reshape.
3. I've added fixes for imsm:
   a.Checkpoint calculation is wrong (per disk instead per array  units).
     It was visible during restart from checkpoint. Md reports it
   b.Array during reshape was marked as 'dirty'.
     This makes mdadm to start reshape from 0 on restart
4. Code for setting 'new' geometry is currently very simple. It sets new disks number only.
   I've got a little problem where to place it. You pointed sysfs_set_array() as place to do this.
   Inside sysfs_set_array() is placed a comment to set those parameters outside this function.
   I've decided to follow suggestion from comment as they seams reasonable.
   This code is narrowed to expansion case,
   but I've put 'ToDo' information in to code comments, how/where it should be changed (I hope shortly).

I think code follows direction you give me in last email (except above exclusions).

BR
Adam



---

Adam Kwolek (9):
      imsm: FIX: Variables declaration cleanup
      FIX: Block array monitoring when assembling reshaped array
      FIX: Set 'new' geometry when assembling reshaped array
      FIX: Verify Backup file name before reshape
      FIX: Continue reshape in the background
      imsm: FIX: After checkpoint mark array have to be clean
      imsm: FIX: Return blocks_per unit for general migration
      FIX: Array during reshape cannot be configured
      FIX: Do not configure and start, already started reshape


 Assemble.c    |   26 +++++++++++++++++++++++++-
 Grow.c        |   47 +++++++++++++++++++++++++++++++++++++++++------
 super-intel.c |    7 +++++--
 3 files changed, 71 insertions(+), 9 deletions(-)

-- 
Signature
