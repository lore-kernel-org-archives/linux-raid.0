From: Song Liu <songliubraving@fb.com>
Subject: [GIT PULL] md-next 20200806
Date: Thu, 6 Aug 2020 20:31:04 +0000
Message-ID: <DC5BBD6B-C93C-4376-8120-DF48249190F7@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <DBE05FF448AFAF43A8B78D9630246A60@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-raid.ids

Hi Jens,=20

Please consider pulling the following fixes for md-next on top of your for-=
5.9/drivers
branch.=20

Thanks,
Song

The following changes since commit f59589fc89665102923725e80e12f782d5f74f67=
:

  Merge branch 'md-next' of https://git.kernel.org/pub/scm/linux/kernel/git=
/song/md into for-5.9/drivers (2020-08-03 06:38:44 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to e8abe1de43dac658dacbd04a4543e0c988a8d386:

  md-cluster: Fix potential error pointer dereference in resize_bitmaps() (=
2020-08-05 17:07:48 -0700)

----------------------------------------------------------------
Dan Carpenter (1):
      md-cluster: Fix potential error pointer dereference in resize_bitmaps=
()

Junxiao Bi (1):
      md: get sysfs entry after redundancy attr group create

 drivers/md/md-cluster.c |  1 +
 drivers/md/md.c         | 17 ++++++++++-------
 2 files changed, 11 insertions(+), 7 deletions(-)=
