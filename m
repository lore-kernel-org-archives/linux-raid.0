From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/3] Continue expansion after reboot
Date: Tue, 22 Feb 2011 15:13:15 +0100
Message-ID: <20110222135440.7582.87319.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Currently reshaped/expanded array is assembled but it stays in inactive state.
This patches allows for array assembly when array is under expansion.
Array with reshape/expansion information in metadata is assembled
and reshape process continues automatically.

Next step:
Problem is how to address container operation during assembly.
1. After first array being reshaped, assebly process looks if mdmon
   sets migration for other array in container. If yes it continues work
   for next array.

2. Assembly process performs reshape of currently reshaped array only.
   Mdmon sets next array for reshape and user triggers manually mdadm
   to finish container operation with just the same parameters set.

Reshape finish can be executed for container operation by container re-assembly
also (this works in current code).


BR
Adam




---

Adam Kwolek (3):
      FIX: Assemble device in reshape state with new disks number
      imsm: FIX: Report correct array size during reshape
      imsm: FIX: initalize reshape progress as it is stored in metatdata


 Assemble.c    |    2 ++
 super-intel.c |   24 +++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletions(-)

-- 
Signature
