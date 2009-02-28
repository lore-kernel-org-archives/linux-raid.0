From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm git pull] support for removed disks / imsm updates
Date: Fri, 27 Feb 2009 17:05:32 -0700
Message-ID: <1235779532.26302.32.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Jacek Danecki <jacek.danecki@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Hi Neil,

This update brings:

1/ Various imsm fixes, importantly some updates due to a clarification
of how the Windows driver marks disk failures
2/ Support for handling removed disks as currently all container
manipulations fail once a live disk is hot-unplugged.
3/ An initial mdmon man page
4/ imsm auto layout support
5/ Updates to --incremental in pursuit of assembling external metadata
arrays in the initramfs via udev events

The one "fix" that is missing from this update is to teach mdmon to kick
"non-fresh" drives similar to what the kernel does at initial assembly.
I dropped the attempt after realizing I would need to take an O_EXCL
open on the container in an awkward place.  I guess it is not necessary,
but it is a quirk of containers that known failed drives can be allowed
back into the container.

Thanks to Jacek Danecki and my colleagues in Poland for identifying the
removed disks problem and working through the regressions on this
release.  Also along these lines you will see that I have moved
development to github to allow more collaboration on this tree.

Please have a look.

Is it about time for a -devel3 release?

Regards,
Dan

---

The following changes since commit 6c40598f598874d1d4c2c4d0da0c2a9b873d768d:
  NeilBrown (1):
        Merge branch 'master' into devel-3.0

are available in the git repository at:

  git://github.com/djbw/mdadm.git master

Dan Williams (24):
      imsm: don't check raid1 chunk size
      imsm: block creation of devices with identical names
      imsm: provide a simulated option-rom for regression tests
      test: fix a call to udevsettle
      imsm: fix missing initializations of the per-disk extents pointer
      imsm: fixup container spare uuids by default
      imsm: fix activate spare to ignore foreign disks
      imsm: introduce get_imsm_disk_slot
      imsm: fix mark_failure / introduce mark_missing
      imsm: verify single sector mpb checksums
      imsm: retry load_imsm_mpb if we suspect mdmon has made modifications
      sysfs: allow sysfs_read to detect and drop removed disks
      mdmon: fix removed disk handling
      mdmon: record added disks
      Manage: permit '--remove detached' for containers
      Create: wait_for container creation
      Create: fixup 'insert_point', dependent on 'subdevs', for auto-layout
      imsm: auto layout
      mdmon: fix missed 'clean' event
      mdmon: man page
      mdmon: update cmdline when scanning
      Incremental: fix 'name_to_use' in the container case
      Incremental: honor --no-degraded to delay assembly
      imsm: display supported chunk sizes in --detail-platform

 Create.c                                           |    7 +-
 Incremental.c                                      |   16 +-
 Manage.c                                           |    9 +-
 managemon.c                                        |   32 ++-
 mdadm.8                                            |    5 +
 mdadm.c                                            |    1 +
 mdadm.h                                            |   34 +-
 mdmon.8                                            |  138 +++++++
 mdmon.c                                            |    9 +-
 monitor.c                                          |   49 +--
 platform-intel.c                                   |   18 +
 super-ddf.c                                        |    8 +-
 super-intel.c                                      |  386 ++++++++++++++++----
 sysfs.c                                            |   26 +-
 test                                               |    2 +-
 tests/09imsm-create-fail-rebuild                   |   56 +++
 tests/env-08imsm-overlap                           |   69 ++++-
 tests/{env-imsm => env-09imsm-create-fail-rebuild} |   35 ++-
 18 files changed, 760 insertions(+), 140 deletions(-)
 create mode 100644 mdmon.8
 create mode 100644 tests/09imsm-create-fail-rebuild
 mode change 120000 => 100644 tests/env-08imsm-overlap
 rename tests/{env-imsm => env-09imsm-create-fail-rebuild} (66%)


