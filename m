From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/6] Reshape fixes (expansion)
Date: Tue, 08 Feb 2011 14:30:28 +0100
Message-ID: <20110208131046.8787.1777.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

The following series adds some fixes for reshape (expansion).

A while ago mdadm unit tests (suits 12 and 13) works correctly, now I've found problems.
I've learned that containers created for raid5 and raid0 has different number of blocks in mdstat.
I've put mdstat partial output to patch description:  UT FIX: imsm container can have different blocks number
I'm not 100% sure that this is fix (for changed behavior), not workaround for container creation problem.
This fix is first of fixes (3) that enables reshape (12, 13) UT.
If you find this more as workaround, this patch is good point for discussion what change is correct.

Patches:
      FIX: compare blocks on all data disks
      FIX: Compare the same units
makes changes for blocks computing verification. After those 2 more  patches UT (12, 13) works. 
Please let me know what you are thinking about them. It is possible that this is not final patch also,
but I've tried to find out what this condition should do, and change code to archive it (IMHO).

Rest of patches addresses other issues, I can observe during expansion.

BR
Adam

---

Adam Kwolek (6):
      FIX: md runs recovery instead reshape for growing single disk raid0 array
      FIX: Container can be left frozen
      FIX: compare blocks on all data disks
      FIX: Compare the same units
      UT FIX: imsm container can have different blocks number
      imsm: FIX: Wrong output string format


 Grow.c                  |    9 +++++++--
 super-intel.c           |    4 ++--
 tests/env-imsm-template |    2 +-
 3 files changed, 10 insertions(+), 5 deletions(-)

-- 
Signature
