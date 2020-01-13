From: Song Liu <songliubraving@fb.com>
Subject: [GIT PULL] md-next 20200113
Date: Mon, 13 Jan 2020 19:55:14 +0000
Message-ID: <153C0E51-CDFC-430C-8125-486CCC73406D@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <174754EE23A24F40AF29649D288F0577@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
Cc: Zhiqiang Liu <liuzhiqiang26@huawei.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>, Kernel Team <Kernel-team@fb.com>
List-Id: linux-raid.ids

Hi Jens,=20

Please consider pull the following changes for md-next on top of your for-5=
.6/block=20
branch (I didn't find for-5.6/drivers branch).=20

Thanks,
Song



The following changes since commit 8e42d239cb027143915cae13eb2ecf1360ee24de=
:

  block: mark zone-mgmt bios with REQ_SYNC (2020-01-09 07:59:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to d0d2d8ba0494655a01b97542c083e51b29cf8637:

  md/raid1: introduce wait_for_serialization (2020-01-13 11:44:10 -0800)

----------------------------------------------------------------
Guoqing Jiang (11):
      raid5: remove worker_cnt_per_group argument from alloc_thread_groups
      md: rename wb stuffs
      md: fix a typo s/creat/create
      md: prepare for enable raid1 io serialization
      md: add serialize_policy sysfs node for raid1
      md: reorgnize mddev_create/destroy_serial_pool
      raid1: serialize the overlap write
      md: don't destroy serial_info_pool if serialize_policy is true
      md: introduce a new struct for IO serialization
      md/raid1: use bucket based mechanism for IO serialization
      md/raid1: introduce wait_for_serialization

Zhengyuan Liu (3):
      raid6/test: fix a compilation error
      raid6/test: fix a compilation warning
      md/raid6: fix algorithm choice under larger PAGE_SIZE

Zhiqiang Liu (1):
      md-bitmap: small cleanups

 drivers/md/md-bitmap.c  |  25 ++++++++++----------
 drivers/md/md.c         | 254 ++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++--------------------------------------=
-----
 drivers/md/md.h         |  45 +++++++++++++++++++++---------------
 drivers/md/raid1.c      | 111 ++++++++++++++++++++++++++++++++++++++++++++=
++++---------------------------------------
 drivers/md/raid5.c      |  21 ++++++-----------
 include/linux/raid/pq.h |   7 +++++-
 lib/raid6/algos.c       |  63 ++++++++++++++++++++++++++++++++------------=
------
 lib/raid6/mktables.c    |   2 +-
 8 files changed, 353 insertions(+), 175 deletions(-)=
