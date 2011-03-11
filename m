From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/2] Checkpointing fixes
Date: Fri, 11 Mar 2011 12:59:04 +0100
Message-ID: <20110311115051.12324.75830.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

The following series implements fixes for checkpointing.
I've observe that restart from checkpoint occurs too far in array (it skipped some area).
It happen due to wrong initialization of last_checkpoint field. It has to be done in per disk units,
but setting it to reshape_position value causes initialization in per array units (multiplied by number of data disks)
First patch fixes this.
To keep checkpoint calculation consistent, I've decided to do similar thing for imsm (2'nd patch) and keep checkpoints 
per disk. During reshape_progress initialization it is recalculated in to reshape position.

This patches has to be applied on my yesterdays fixes.

BR
Adam


---

Adam Kwolek (2):
      imsm: FIX: Store checkpoint in per disk units
      FIX: Last_checkpoint has to be initialized in per disk units


 managemon.c   |    9 +++++++++
 super-intel.c |    8 ++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

-- 
Signature
