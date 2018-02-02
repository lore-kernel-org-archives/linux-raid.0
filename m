From: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Subject: [PATCH 0/5] Setting write hint in MD RAID
Date: Fri,  2 Feb 2018 14:50:34 +0100
Message-ID: <20180202135039.32086-1-mariusz.dabrowski@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Mariusz Dabrowski <mariusz.dabrowski@intel.com>
List-Id: linux-raid.ids

This patchset adds support for write hints in MD driver. This is a new
feature for NVMe drives compliant to 1.3 specification and introduced to
Linux in kernel 4.13. Write hint has to be copied from bio containing user
data to bios sent to RAID members. Additionally, write hint can be set for
internal data like parity and PPL in RAID 5.

Setting write hint for parity is done with simple classification algorithm
which works for sequential IO workload. It tries to predict which parity
request are going to be overwritten in a moment and sets write hint for
them. This algorithm uses stripe cache to count updates of each parity
chunk. Parity request will be predicted as "soon-overwritten" if nubmer of
parity updates is smaller than number of data chunks in stripe.

For PPL there is no special algorithm. It is updated very frequently so we
can set write hint for each PPL write.

We have performed our internal tests which prove that setting write hint
for parity and PPL can significantly reduce write amplification.

Mariusz Dabrowski (5):
  raid1: copy write hint from master bio to behind bio
  raid5: copy write hint from origin bio to stripe
  raid5: sysfs attribute for write hint policy
  raid5: set write hint for parity
  raid5: set write hint for PPL

 Documentation/admin-guide/md.rst |  16 +++++
 drivers/md/raid1.c               |   2 +
 drivers/md/raid5-ppl.c           |   4 ++
 drivers/md/raid5.c               | 147 +++++++++++++++++++++++++++++++++++++--
 drivers/md/raid5.h               |  10 +++
 5 files changed, 175 insertions(+), 4 deletions(-)

-- 
2.16.1

