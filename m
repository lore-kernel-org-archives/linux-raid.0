From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.8
Date: Thu, 28 Jul 2016 10:36:04 -0700
Message-ID: <20160728173604.GA91639@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Hi,

Please pull MD update for 4.8. The patches are based on 4.7 rc initiall=
y, I
merged them to lastest upstream to fix merge conflict against block lay=
er
changes:
- A bunch of patches from Neil Brown to fix RCU usage
- Two performance improvement patches from Tomasz Majchrzak
- Alexey Obitotskiy fixes module refcount issue
- Arnd Bergmann fixes time granularity
- Cong Wang fixes a list corruption issue
- Guoqing Jiang fixes a deadlock in md-cluster
- A null pointer deference fix from me
- Song Liu fixes misuse of raid6 rmw
- Other trival/cleanup fixes from Guoqing Jiang and Xiao Ni

Thanks,
Shaohua

The following changes since commit 194dc870a5890e855ecffb30f3b80ba7c88f=
96d6:

  Add braces to avoid "ambiguous =E2=80=98else=E2=80=99" compiler warni=
ngs (2016-07-27 20:03:31 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git for-linus

for you to fetch changes up to 3f35e210ed4617a68b6baa9b7ac6c72bf7e313d9=
:

  Merge branch 'mymd/for-next' into mymd/for-linus (2016-07-28 09:34:14=
 -0700)

----------------------------------------------------------------
Alexey Obitotskiy (1):
      Fix kernel module refcount handling

Arnd Bergmann (1):
      md: use seconds granularity for error logging

Cong Wang (1):
      md: use a mutex to protect a global list

Guoqing Jiang (2):
      md-cluster: fix deadlock issue when add disk to an recoverying ar=
ray
      md: simplify the code with md_kick_rdev_from_array

NeilBrown (17):
      md: disconnect device from personality before trying to remove it=
=2E
      md/raid1, raid10: don't recheck "Faulty" flag in read-balance.
      md/raid10: fix refounct imbalance when resyncing an array with a =
replacement device.
      md/raid10: add rcu protection in raid10_status.
      md/raid10: add rcu protection to rdev access in raid10_sync_reque=
st.
      md/raid10: add rcu protection to rdev access during reshape.
      md/raid10: minor code improvement in fix_read_error()
      md/raid10: simplify print_conf a little.
      md/raid1: small cleanup in raid1_end_read/write_request
      md/raid1: small code cleanup in end_sync_write
      md/raid1: add rcu protection to rdev in fix_read_error
      md/raid5: add rcu protection to rdev accesses in handle_failed_sy=
nc.
      md/raid5: add rcu protection to rdev accesses in want_replace
      md/raid5: add rcu protection to rdev accesses in raid5_status.
      md/multipath: add rcu protection to rdev access in multipath_stat=
us.
      md: be extra careful not to take a reference to a Faulty device.
      md: reduce the number of synchronize_rcu() calls when multiple de=
vices fail.

Shaohua Li (2):
      MD: fix null pointer deference
      Merge branch 'mymd/for-next' into mymd/for-linus

Song Liu (1):
      right meaning of PARITY_ENABLE_RMW and PARITY_PREFER_RMW

Tomasz Majchrzak (3):
      raid1/raid10: slow down resync if there is non-resync activity pe=
nding
      md: add missing sysfs_notify on array_state update
      raid10: improve random reads performance

Xiao Ni (1):
      MD:Update superblock when err =3D=3D 0 in size_store

 drivers/md/md.c        |  74 +++++++++++----
 drivers/md/md.h        |  10 +-
 drivers/md/multipath.c |  29 +++---
 drivers/md/raid1.c     | 130 ++++++++++++-------------
 drivers/md/raid10.c    | 250 ++++++++++++++++++++++++++++++-----------=
--------
 drivers/md/raid10.h    |   3 +-
 drivers/md/raid5.c     |  45 +++++----
 7 files changed, 328 insertions(+), 213 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
