From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/5] Grow_continue() prepare for usage in assembly
Date: Mon, 28 Feb 2011 16:06:55 +0100
Message-ID: <20110228145815.14670.56597.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

This is first part of reshape continuation. This patch series makes (mainly) some changes to Grow_continue()
for use for reshape continuation during array assembling.

It runs reshape_array() in background (for container operation it should be also ok, as we can have only one
metadata marked for reshape at the time).
For external metadata reshape_array requires container name parameter.

For reshape invoked from assembly reshape_array cannot start reshape (this would push md to call i.e. start_reshape
vector from personality). Staring reshape is based on run() mechanism in md so reshape_array should not configure or start reshape.
It should monitor check-pointing only.


BR
Adam


---

Adam Kwolek (5):
      FIX: Do not configure and start, already started reshape
      FIX: Continue reshape in the background
      FIX: Set readonly state in Grow_continue() when necessary
      FIX: Pass container name to reshape array for external meta data
      FIX: Spelling error in dprintf output


 Grow.c |   53 ++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 40 insertions(+), 13 deletions(-)

-- 
Signature
