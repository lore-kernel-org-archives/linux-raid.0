From: Song Liu <songliubraving@fb.com>
Subject: [GIT PULL] md-next 20200802
Date: Mon, 3 Aug 2020 06:59:02 +0000
Message-ID: <1B094166-6B2F-4181-B389-8C5B564CD485@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <7EB313009BBF0E4E93475456E604D083@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
Cc: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Xiao Ni <xni@redhat.com>, ChangSyun Peng <allenpeng@synology.com>, Sebastian Parschauer <s.parschauer@gmx.de>
List-Id: linux-raid.ids

Hi Jens,=20

Please consider pulling the following changes for md-next on top of your
for-5.9/drivers branch.

The following changes since commit a9e8e18aaf914bf273ed63480c4c3d8dd626c95f=
:

  Merge branch 'nvme-5.9' of git://git.infradead.org/nvme into for-5.9/driv=
ers (2020-07-29 11:22:40 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 45a4d8fd6c7926e7991a1b29233d725fe12935da:

  md/raid5: Allow degraded raid6 to do rmw (2020-08-02 23:54:31 -0700)

----------------------------------------------------------------
ChangSyun Peng (2):
      md/raid5: Fix Force reconstruct-write io stuck in degraded raid5
      md/raid5: Allow degraded raid6 to do rmw

Guoqing Jiang (4):
      md/raid5: remove the redundant setting of STRIPE_HANDLE
      md: print errno in super_written
      raid5-cache: hold spinlock instead of mutex in r5c_journal_mode_show
      raid5: don't duplicate code for different paths in handle_stripe

Sebastian Parschauer (1):
      md: register new md sysfs file 'uuid' read-only

Xiao Ni (1):
      md: fix max sectors calculation for super 1.0

 Documentation/admin-guide/md.rst |  4 ++++
 drivers/md/md.c                  | 47 ++++++++++++++++++++++++++++++++++++=
++++++-----
 drivers/md/raid5-cache.c         |  9 +++------
 drivers/md/raid5.c               | 40 ++++++++++++++++++++++--------------=
----
 4 files changed, 71 insertions(+), 29 deletions(-)=
