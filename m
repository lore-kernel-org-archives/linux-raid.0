From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 00/13] md patches for the current merge window
Date: Wed, 12 Jan 2011 09:12:46 +1100
Message-ID: <20110111221050.12732.31647.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jonathan Brassow <jbrassow@redhat.com>, Mike Snitzer <snitzer@redhat.com>, =?utf-8?b?UsOpbWk=?= =?utf-8?q?R=C3=A9rolle?= <rrerolle@lacie.com>, Joe Perches <joe@perches.com>
List-Id: linux-raid.ids

The following assortment of patches for md are planned to be submitted
for the current merge window, probably in a couple of days.  Any
comments most welcome.

Some are bug fixes, some of minor changes to prepare for future work,
nothing is really significant

They are all currently in my for-next branch
   git://neil.brown.name/md for-next
and so should appear in -next today or tomorrow.

Thanks,
NeilBrown

---

Joe Perches (1):
      md: Fix single printks with multiple KERN_<level>s

Jonathan Brassow (4):
      md: separate meta and data devs
      md-new-param-to_sync_page_io
      md-new-param-to-calc_dev_sboffset
      md/raid5: use sysfs_notify_dirent_safe to avoid NULL pointer

NeilBrown (7):
      md: allow suspend_lo and suspend_hi to decrease as well as increa=
se.
      md: Don't let implementation detail of curr_resync leak out throu=
gh sysfs.
      md: Be more careful about clearing flags bit in ->recovery
      md: md_stop_writes requires mddev_lock.
      md: Ensure no IO request to get md device before it is properly i=
nitialised.
      md: fix regression resulting in delays in clearing bits in a bitm=
ap
      md: fix regression with re-adding devices to arrays with no metad=
ata

R=C3=A9mi R=C3=A9rolle (1):
      md: fix sync_completed reporting for very large drives (>2TB)


 drivers/md/bitmap.c |   12 ++-
 drivers/md/md.c     |  187 +++++++++++++++++++++++++++++++------------=
--------
 drivers/md/md.h     |   13 +++-
 drivers/md/raid1.c  |   33 ++++-----
 drivers/md/raid10.c |   17 ++---
 drivers/md/raid5.c  |    7 +-
 6 files changed, 157 insertions(+), 112 deletions(-)

--=20
Signature

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
