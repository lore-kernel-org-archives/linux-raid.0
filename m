From: NeilBrown <neilb@suse.de>
Subject: PULL REQUEST - md updates for 2.6.38
Date: Fri, 14 Jan 2011 09:18:55 +1100
Message-ID: <20110114091855.29910ed3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Linus,
 please pull some md update as below.

 There is an unfortunately high number for fixes for regressions - obvi=
ously
 someone hasn't been doing methodical testing as often as he would like=
 to.

 Most of this is bug fixes.  For the few that are new functionality, mo=
st of
 them are related to our work to make md and dm able to share more code=
=2E

Thanks,
NeilBrown



The following changes since commit 3c0eee3fe6a3a1c745379547c7e7c904aa64=
f6d5:

  Linux 2.6.37 (2011-01-04 16:50:19 -0800)

are available in the git repository at:
  git://neil.brown.name/md/ for-linus

Joe Perches (1):
      md: Fix single printks with multiple KERN_<level>s

Jonathan Brassow (4):
      md/raid5: use sysfs_notify_dirent_safe to avoid NULL pointer
      md-new-param-to-calc_dev_sboffset
      md-new-param-to_sync_page_io
      md: separate meta and data devs

NeilBrown (10):
      md: fix regression with re-adding devices to arrays with no metad=
ata
      md: fix regression resulting in delays in clearing bits in a bitm=
ap
      md: Ensure no IO request to get md device before it is properly i=
nitialised.
      md: md_stop_writes requires mddev_lock.
      md: Be more careful about clearing flags bit in ->recovery
      md: Don't let implementation detail of curr_resync leak out throu=
gh sysfs.
      md: allow suspend_lo and suspend_hi to decrease as well as increa=
se.
      md/raid5: handle manually-added spares in start_reshape.
      md: range check slot number when manually adding a spare.
      md: Fix removal of extra drives when converting RAID6 to RAID5

R=E9mi R=E9rolle (1):
      md: fix sync_completed reporting for very large drives (>2TB)

 drivers/md/bitmap.c |   12 ++-
 drivers/md/md.c     |  197 +++++++++++++++++++++++++++++++------------=
--------
 drivers/md/md.h     |   13 +++-
 drivers/md/raid1.c  |   33 ++++-----
 drivers/md/raid10.c |   17 +++--
 drivers/md/raid5.c  |   16 +++--
 6 files changed, 172 insertions(+), 116 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
