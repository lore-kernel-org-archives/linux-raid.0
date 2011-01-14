From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/2] fixes for manually-added spares in raid5
Date: Fri, 14 Jan 2011 13:38:24 +0100
Message-ID: <20110114123139.14953.81620.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

After patch "md/raid5: handle manually-added spares in start_reshape." spres with set slot are almost used by md for raid5 reshape.
It works this way: before and after reshape process disks number in array is the same, new disks are not used during reshape process.
This is addressed by first patch.

Second problem I've found is for degraded arrays (i.e. takeovered raid0). Scenario is as follow:
1. Create raid0 array using 2 disks
2. add 2 spare disks to container
3. expand capacity to 4 disks in array

In result we will get raid0 build on 3 disks with one spare disk. this is due to fact that disk degradataion is not used
for comparing disks slot number (disk used for degraded slot is considered as present in array)
This is addressed by second patch.

BR
Adam


---

Adam Kwolek (2):
      md/raid5: FIX: reshape on degraded devices has wrong configuration
      md/raid5: FIX: manually-added spare is not used


 drivers/md/raid5.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

-- 
Signature
