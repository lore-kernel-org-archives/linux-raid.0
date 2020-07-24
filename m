From: Song Liu <songliubraving@fb.com>
Subject: [GIT PULL] md-next 20200724
Date: Fri, 24 Jul 2020 22:12:23 +0000
Message-ID: <2C49144E-E8FF-4ECE-8897-F478AA1ED490@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <54B3FA64F9DF444B9B5266911494B7D8@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
Cc: Yufen Yu <yuyufen@huawei.com>
List-Id: linux-raid.ids

Hi Jens,=20

Please consider pulling the following changes for md-next on top of your=20
for-5.9/drivers branch.=20

Thanks,
Song


The following changes since commit ef67744e7a4c82e246cd9831208d07249c519d22=
:

  Merge branch 'md-next' of https://git.kernel.org/pub/scm/linux/kernel/git=
/song/md into for-5.9/drivers (2020-07-22 14:11:38 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 83c3e5e17b5e3057ac304383a46e3c485d00ffed:

  md/raid5: use do_div() for 64 bit divisions in raid5_sync_request (2020-0=
7-22 22:49:46 -0700)

----------------------------------------------------------------
Yufen Yu (1):
      md/raid5: use do_div() for 64 bit divisions in raid5_sync_request

 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)=
