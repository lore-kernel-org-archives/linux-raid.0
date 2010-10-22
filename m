From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/2] reshape fixlets for 2.6.37
Date: Fri, 22 Oct 2010 11:03:49 -0700
Message-ID: <20101022180311.6563.6666.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Hi Neil,

Here are two fixes that we discovered while implementing the external
reshape code.  The second one is tagged for -stable as current versions
of mdadm may not assemble a native array that is being expanded by more
than 1 disk.  Incremental assembly, however, does work in this case.

---

Dan Williams (2):
      md/raid5: skip wait for MD_CHANGE_DEVS acknowledgement in the external case
      md/raid5: initialize ->recovery_offset when growing raid_disks

 drivers/md/raid5.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

