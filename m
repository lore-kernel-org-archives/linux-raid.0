From: Song Liu <songliubraving@fb.com>
Subject: [GIT PULL] md-next 20200317
Date: Tue, 17 Mar 2020 19:57:34 +0000
Message-ID: <7CD08FA9-5302-4885-98C5-CDF974CC225C@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <53FC40BA56C5BF479D69BA59CF5CC2BC@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
Cc: Kernel Team <Kernel-team@fb.com>, Guoqing Jiang <jgq516@gmail.com>, "khlebnikov@yandex-team.ru" <khlebnikov@yandex-team.ru>
List-Id: linux-raid.ids

Hi Jens,=20

Please consider pulling the following changes for md-next on top of your=20
for-5.7/drivers branch.=20

Thanks,
Song


The following changes since commit e83995c9f84161900b80d337d6df358a7803870a=
:

  floppy: rename the global "fdc" variable to "current_fdc" (2020-03-16 08:=
26:58 -0600)

are available in the Git repository at:

  ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/song/md.git md-nex=
t

for you to fetch changes up to e74d93e96d721c4297f2a900ad0191890d2fc2b0:

  block: keep bdi->io_pages in sync with max_sectors_kb for stacked devices=
 (2020-03-17 10:53:07 -0700)

----------------------------------------------------------------
Guoqing Jiang (1):
      md: check arrays is suspended in mddev_detach before call quiesce ope=
rations

Konstantin Khlebnikov (1):
      block: keep bdi->io_pages in sync with max_sectors_kb for stacked dev=
ices

 block/blk-settings.c | 3 +++
 drivers/md/md.c      | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)=
