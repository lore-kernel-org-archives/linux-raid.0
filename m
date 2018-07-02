From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.18-rc3
Date: Mon, 2 Jul 2018 09:47:50 -0700
Message-ID: <20180702164750.GA24121@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
Two small fixes for MD:
- An error handling fix from me
- A recover bug fix for raid10 from BingJing
please pull!

Thanks,
Shaohua


The following changes since commit 9ffc59d57228d74809700be6f7ecb1db10292f05:

  Merge tag '4.18-rc1-more-smb3-fixes' of git://git.samba.org/sfrench/cifs-2.6 (2018-06-18 14:28:19 +0900)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git for-next

for you to fetch changes up to bda3153998f3eb2cafa4a6311971143628eacdbc:

  md/raid10: fix that replacement cannot complete recovery after reassemble (2018-06-28 13:04:49 -0700)

----------------------------------------------------------------
BingJing Chang (1):
      md/raid10: fix that replacement cannot complete recovery after reassemble

Shaohua Li (1):
      MD: cleanup resources in failure

 drivers/md/md.c     | 8 +++++---
 drivers/md/raid10.c | 7 +++++++
 2 files changed, 12 insertions(+), 3 deletions(-)
