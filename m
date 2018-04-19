From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.17-rc1
Date: Thu, 19 Apr 2018 09:13:21 -0700
Message-ID: <20180419161321.y46imb6tt65i4zyk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
3 small fixes for MD:
- md-cluster fix for faulty device from Guoqing
- writehint fix for writebehind IO for raid1 from Mariusz
- a live lock fix for interrupted recovery from Yufen
Please pull!


The following changes since commit f8cf2f16a7c95acce497bfafa90e7c6d8397d653:

  Merge branch 'next-integrity' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security (2018-04-07 16:53:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git tags/md/4.17-rc1

for you to fetch changes up to dba40d46ebf41e3f7ac9480609529bb6037a918d:

  raid1: copy write hint from master bio to behind bio (2018-04-09 08:54:34 -0700)

----------------------------------------------------------------
Guoqing Jiang (1):
      md-cluster: don't update recovery_offset for faulty device

Mariusz Dabrowski (1):
      raid1: copy write hint from master bio to behind bio

Yufen Yu (1):
      md/raid1: exit sync request if MD_RECOVERY_INTR is set

 drivers/md/md.c    |  6 ++++--
 drivers/md/raid1.c | 25 ++++++++++++++++++++-----
 2 files changed, 24 insertions(+), 7 deletions(-)
