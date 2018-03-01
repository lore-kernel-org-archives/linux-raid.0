From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.16-rc3
Date: Thu, 1 Mar 2018 10:00:17 -0800
Message-ID: <20180301180017.nemyluj5dvbmitzp@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
A few bug fixes for MD, please pull:
- Fix raid5-ppl flush request handling hang from Artur
- Fix a potential deadlock in raid5/10 reshape from BingJing
- Fix a deadlock for dm-raid from Heinz
- Fix two md-cluster of raid10 from Lidong and Guoqing
- Fix a NULL deference problem in device removal from Neil
- Fix a NULL deference problem in raid1/raid10 in specific condition from Yufen
- Other cleanup and fixes

Thanks,
Shaohua

The following changes since commit c786427f57b6dc4f56f9a84da52b41216e94f125:

  Merge tag 'for-linus-20180217' of git://git.kernel.dk/linux-block (2018-02-17 10:20:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git for-next

for you to fetch changes up to 3de59bb9d551428cbdc76a9ea57883f82e350b4d:

  md/raid1: fix NULL pointer dereference (2018-02-25 10:44:39 -0800)

----------------------------------------------------------------
Aliaksei Karaliou (1):
      md/raid5: simplify uninitialization of shrinker

Arnd Bergmann (1):
      md: raid5: avoid string overflow warning

Artur Paszkiewicz (1):
      raid5-ppl: fix handling flush requests

BingJing Chang (1):
      md: fix a potential deadlock of raid5/raid10 reshape

Guoqing Jiang (1):
      raid10: change the size of resync window for clustered raid

Heinz Mauelshagen (1):
      md: fix md_write_start() deadlock w/o metadata devices

Lidong Zhong (1):
      md-cluster: choose correct label when clustered layout is not supported

Luis de Bethencourt (1):
      md/raid1: Fix trailing semicolon

Markus Elfring (1):
      md-multipath: Use seq_putc() in multipath_status()

NeilBrown (2):
      md: document lifetime of internal rdev pointer.
      md: only allow remove_and_add_spares when no sync_thread running.

Xiao Ni (1):
      MD: Free bioset when md_run fails

Yufen Yu (2):
      md raid10: fix NULL deference in handle_write_completed()
      md/raid1: fix NULL pointer dereference

 drivers/md/md-multipath.c |  2 +-
 drivers/md/md.c           | 53 ++++++++++++++++++++++++++++++++++++++++++-----
 drivers/md/md.h           |  2 ++
 drivers/md/raid1.c        | 13 +++++++++++-
 drivers/md/raid1.h        | 12 +++++++++++
 drivers/md/raid10.c       | 18 +++++++---------
 drivers/md/raid10.h       | 13 ++++++++++++
 drivers/md/raid5-log.h    |  3 ++-
 drivers/md/raid5-ppl.c    | 10 +++++++++
 drivers/md/raid5.c        | 19 ++++++-----------
 drivers/md/raid5.h        | 12 +++++++++++
 11 files changed, 125 insertions(+), 32 deletions(-)
