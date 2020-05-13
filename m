From: Song Liu <songliubraving@fb.com>
Subject: [GIT PULL] md-next 20200513
Date: Wed, 13 May 2020 20:42:03 +0000
Message-ID: <196CD868-7B35-4174-AFAF-9786943E4B0C@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <439AA8606C84A04483693A5A748046C1@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
Cc: Coly Li <colyli@suse.de>, Christoph Hellwig <hch@infradead.org>, David Jeffery <djeffery@redhat.com>, Guoqing Jiang <jgq516@gmail.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, "wangxiongfeng2@huawei.com" <wangxiongfeng2@huawei.com>
List-Id: linux-raid.ids

Hi Jens,=20

Please consider pulling the following changes for md-next on top of your
for-5.8/drivers branch.=20

Thanks,
Song


The following changes since commit 91bf5ec3421df5ec620e9abc9afa0ddacbbdefef=
:

 Merge tag 'floppy-for-5.8' of https://github.com/evdenis/linux-floppy into=
 for-5.8/drivers (2020-05-12 11:35:49 -0600)

are available in the Git repository at:

 git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 358369f03ac94637c9fd9d8f94a2dfde86b9f25f:

 md/raid1: Replace zero-length array with flexible-array (2020-05-13 12:02:=
23 -0700)

----------------------------------------------------------------
Christoph Hellwig (1):
     md: stop using ->queuedata

Coly Li (4):
     md: use memalloc scope APIs in mddev_suspend()/mddev_resume()
     raid5: remove gfp flags from scribble_alloc()
     raid5: update code comment of scribble_alloc()
     md: remove redundant memalloc scope API usage

David Jeffery (1):
     md/raid1: release pending accounting for an I/O only after write-behin=
d is also finished

Guoqing Jiang (5):
     md: add checkings before flush md_misc_wq
     md: add new workqueue for delete rdev
     md: don't flush workqueue unconditionally in md_open
     md: flush md_rdev_misc_wq for HOT_ADD_DISK case
     md: remove the extra line for ->hot_add_disk

Gustavo A. R. Silva (1):
     md/raid1: Replace zero-length array with flexible-array

Xiongfeng Wang (1):
     md: add a newline when printing parameter 'start_ro' by sysfs

drivers/md/md-linear.h |  2 +-
drivers/md/md.c        | 71 +++++++++++++++++++++++++++++++++++++++++++++++=
+-----------------------
drivers/md/md.h        |  1 +
drivers/md/raid1.c     | 13 +++++++------
drivers/md/raid1.h     |  2 +-
drivers/md/raid10.h    |  2 +-
drivers/md/raid5.c     | 22 ++++++++++++++--------
7 files changed, 73 insertions(+), 40 deletions(-)=
