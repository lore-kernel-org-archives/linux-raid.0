From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD for 4.7-rc1
Date: Thu, 19 May 2016 11:34:03 -0700
Message-ID: <20160519183403.GA38667@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Hi Linus,

pleae pull MD update for 4.7. It includes several patches from Guoqing fixing
md-cluster bugs and several patches from Heinz fixing dm-raid bugs.

Thanks,
Shaohua

The following changes since commit 4810d9682971e8eee659f96e4f9d9154e3c6c0b4:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security (2016-05-04 11:14:00 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git tags/md/4.7-rc1

for you to fetch changes up to 1fa9a1ad0a9db3c745fe0c1bfa73fd87901fd7f3:

  md-cluster: check the return value of process_recvd_msg (2016-05-09 09:24:04 -0700)

----------------------------------------------------------------
Guoqing Jiang (15):
      md-cluster: change resync lock from asynchronous to synchronous
      md-cluser: make resync_finish only called after pers->sync_request
      md-cluster: wake up thread to continue recovery
      md-cluster: unregister thread if err happened
      md-cluster: fix locking when node joins cluster during message broadcast
      md-cluster: change array_sectors and update size are not supported
      md-cluster: wakeup thread if activated a spare disk
      md-cluster: always setup in-memory bitmap
      md-cluster: sync bitmap when node received RESYNCING msg
      md-cluster/bitmap: fix wrong calcuation of offset
      md-cluster/bitmap: fix wrong page num in bitmap_file_clear_bit and bitmap_file_set_bit
      md-cluster/bitmap: unplug bitmap to sync dirty pages to disk
      md: set MD_CHANGE_PENDING in a atomic region
      md-cluster: gather resync infos and enable recv_thread after bitmap is ready
      md-cluster: check the return value of process_recvd_msg

Heinz Mauelshagen (3):
      md: md.c: fix oops in mddev_suspend for raid0
      md: raid10: add prerequisite to run underneath dm-raid
      md: raid5: add prerequisite to run underneath dm-raid

kbuild test robot (1):
      md-cluster: fix ifnullfree.cocci warnings

 Documentation/md-cluster.txt |  6 +++
 drivers/md/bitmap.c          | 88 +++++++++++++++++++++++++++++++++++-----
 drivers/md/bitmap.h          |  3 ++
 drivers/md/md-cluster.c      | 96 ++++++++++++++++++++++++++++++++++++--------
 drivers/md/md-cluster.h      |  1 +
 drivers/md/md.c              | 86 ++++++++++++++++++++++++---------------
 drivers/md/raid1.c           |  4 +-
 drivers/md/raid10.c          | 20 +++++----
 drivers/md/raid5-cache.c     |  4 +-
 drivers/md/raid5.c           | 10 +++--
 include/linux/bitops.h       | 16 ++++++++
 11 files changed, 257 insertions(+), 77 deletions(-)
