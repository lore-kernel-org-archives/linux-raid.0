From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH v2 0/3] Refactor and revamp the 'test' script
Date: Wed, 14 Jun 2017 21:02:50 +0800
Message-ID: <1497445373-27985-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Hi, Jes;
  Mainly added the suggestions from v1. I'm awared that these patches
maybe still to improve, draft them just from my understanding. I would
improve for any defect, and thanks for your patience to point out.

Still need ideas about testdev():
- Now the 'test' has supported new arguments like --disks= to test physical
  devices, but testdev() in all cases was designed by loop mode, we should
  decide whether or not the 'disk' mode also supports the testdev() testing.
  Currently, I have ignored the testdev() testing and make it 'return 0' if
  has set --dev=disk mode in this patch version.

For --raidtype:
- I have devided the raid levels to
  raid0|linear|raid1|raid456|raid10|ddf|imsm
For --disks:
- It supports user to specify physical devices as follow.
  Example: ./test --dev=disk --disks=/dev/sda{5..16} or
           ./test --dev=disk --disks=/dev/sd{a..m}

Changes from v1:
- Refactor and improve all functions of test 'script'.
- Add --raidtype argument to support testing different raid
  level cases.
- Add --disks argument to support testing physical devices

v1 mail-tree:
[PATCH 0/3] mdadm/test: Refactor the codes of 'test' script
RFC patch mail-tree:
[PATCH RFC] test: revise 'test' and make it easier to understand


Thanks very much,
-Zhilong

Zhilong Liu (3):
  mdadm/test: Refactor and revamp 'test' script
  mdadm/test: Add '--raidtype=' to run different raidlevel cases
  mdadm/test: Add '--disks=' to support testing phsical devices

 test | 464 +++++++++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 285 insertions(+), 179 deletions(-)

-- 
2.6.6

