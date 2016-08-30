From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.8-rc4
Date: Tue, 30 Aug 2016 10:48:00 -0700
Message-ID: <20160830174800.GA31286@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Hi,
please pull MD update for 4.8-rc4. This update includes several bug fixes:
- Alexey Obitotskiy fixes hang for faulty raid5 array with external management
- Song Liu fixes two raid5 journal realted bugs
- Tomasz Majchrzak fixes a bad block recording issue and an accounting issue for raid10
- ZhengYuan Liu fixes an accounting issue for raid5
- I fix a potential race condition and memory leak with DIF/DIX enabled
- other trival fixes

Thanks,
Shaohua

The following changes since commit d761f3ed6e71bcca724a6e9e39efcac65b7b4ac1:

  Merge branch 'x86-microcode-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2016-07-30 13:18:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git tags/md/4.8-rc4

for you to fetch changes up to 45c91d808ff989d950e260dab9f89e8f4a3c9c2c:

  raid5: avoid unnecessary bio data set (2016-08-24 10:21:53 -0700)

----------------------------------------------------------------
Alexey Obitotskiy (1):
      md: Prevent IO hold during accessing to faulty raid5 array

Artur Paszkiewicz (1):
      md: don't print the same repeated messages about delayed sync operation

Guoqing Jiang (1):
      md: remove obsolete ret in md_start_sync

Shaohua Li (3):
      MD: hold mddev lock to change bitmap location
      raid5: fix memory leak of bio integrity data
      raid5: avoid unnecessary bio data set

Song Liu (2):
      md: do not count journal as spare in GET_ARRAY_INFO
      r5cache: set MD_JOURNAL_CLEAN correctly

Tomasz Majchrzak (2):
      raid10: increment write counter after bio is split
      raid10: record correct address of bad block

Wei Yongjun (1):
      md-cluster: fix error return code in join()

ZhengYuan Liu (1):
      raid5: fix incorrectly counter of conf->empty_inactive_list_nr

 drivers/md/bitmap.c     | 47 +++++++++++++++++++++++++-----------
 drivers/md/md-cluster.c | 12 +++++++---
 drivers/md/md.c         | 28 ++++++++++++----------
 drivers/md/raid10.c     | 13 +++++-----
 drivers/md/raid5.c      | 64 +++++++++++++++++++++++++++++++++----------------
 5 files changed, 107 insertions(+), 57 deletions(-)
