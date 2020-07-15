From: Song Liu <songliubraving@fb.com>
Subject: [GIT PULL] md-next 20200714
Date: Wed, 15 Jul 2020 06:53:15 +0000
Message-ID: <FBE6B82B-E360-4EAF-999D-AFBC6BC5F058@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <F3C4813CA6067943BC1E18B5F8D96A5F@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>, Zhao Heming <heming.zhao@suse.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Colin Ian King <colin.king@canonical.com>
List-Id: linux-raid.ids

Hi Jens,=20

Please consider pulling the following changes for md-next on top of your fo=
r-5.9/drivers=20
branch.=20

Thanks,
Song


The following changes since commit 2eaac320db515b2ec681f6a4bad4f67a7be84ce8=
:

  rsxx: switch from 'pci_free_consistent()' to 'dma_free_coherent()' (2020-=
07-11 09:27:09 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 60f80d6f2d07a6d8aee485a1d1252327eeee0c81:

  md-cluster: fix wild pointer of unlock_all_bitmaps() (2020-07-14 23:38:32=
 -0700)

----------------------------------------------------------------
Artur Paszkiewicz (1):
      md: improve io stats accounting

Colin Ian King (1):
      md: raid0/linear: fix dereference before null check on pointer mddev

Junxiao Bi (1):
      md: fix deadlock causing by sysfs_notify

Song Liu (1):
      md/raid5-cache: clear MD_SB_CHANGE_PENDING before flushing stripes

Zhao Heming (1):
      md-cluster: fix wild pointer of unlock_all_bitmaps()

 drivers/md/md-bitmap.c   |   2 +-
 drivers/md/md-cluster.c  |   1 +
 drivers/md/md.c          | 110 +++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++------------------------------
 drivers/md/md.h          |   9 ++++++++-
 drivers/md/raid10.c      |   2 +-
 drivers/md/raid5-cache.c |   7 +++++++
 drivers/md/raid5.c       |   6 +++---
 7 files changed, 101 insertions(+), 36 deletions(-)=
