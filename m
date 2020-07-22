From: Song Liu <songliubraving@fb.com>
Subject: [GIT PULL] md-next 20200722
Date: Wed, 22 Jul 2020 18:54:05 +0000
Message-ID: <62A334F9-B486-4101-9803-AD72B4D5F66F@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <BD5EB86FF2A9C6468BEE81E1FF0B56AE@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Vitaly Mayatskikh <vmayatskikh@digitalocean.com>, Randy Dunlap <rdunlap@infradead.org>, Zhao Heming <heming.zhao@suse.com>, Yufen Yu <yuyufen@huawei.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

Hi Jens,=20

Please consider pulling the following changes for md-next on top of your=20
for-5.9/drivers branch.=20

Thanks,
Song


The following changes since commit 659bf827ba8f1183b714341d8a1d4b1e446178d9=
:

  block: add max_active_zones to blk-sysfs (2020-07-15 14:26:11 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to fe630de009d0729584d79c78f43121e07c745fdc:

  md/raid10: avoid deadlock on recovery. (2020-07-22 11:44:54 -0700)

----------------------------------------------------------------
Damien Le Moal (4):
      md: Fix compilation warning
      md: raid5-cache: Remove set but unused variable
      md: raid5: Fix compilation warning
      md: raid10: Fix compilation warning

Guoqing Jiang (3):
      raid5: call clear_batch_ready before set STRIPE_ACTIVE
      raid5: put the comment of clear_batch_ready to the right place
      raid5: remove the meaningless check in raid5_make_request

Randy Dunlap (1):
      raid: md_p.h: drop duplicated word in a comment

Vitaly Mayatskikh (1):
      md/raid10: avoid deadlock on recovery.

Yufen Yu (3):
      md/raid456: convert macro STRIPE_* to RAID5_STRIPE_*
      md/raid5: set default stripe_size as 4096
      md/raid5: support config stripe_size by sysfs entry

Zhao Heming (2):
      md-cluster: fix safemode_delay value when converting to clustered bit=
map
      md-cluster: fix rmmod issue when md_cluster convert bitmap to none

 drivers/md/md.c                |  24 +++++++++-----
 drivers/md/raid10.c            |  18 ++++++++---
 drivers/md/raid5-cache.c       |  12 +++----
 drivers/md/raid5-ppl.c         |  11 ++++---
 drivers/md/raid5.c             | 340 +++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++----------------------------------------------------------=
------------
 drivers/md/raid5.h             |  53 +++++++++++++++++++++----------
 include/uapi/linux/raid/md_p.h |   2 +-
 7 files changed, 298 insertions(+), 162 deletions(-)=
