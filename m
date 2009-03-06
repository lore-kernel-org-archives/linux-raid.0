From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/3] Support setting the array size from userspace
Date: Thu, 05 Mar 2009 17:24:43 -0700
Message-ID: <20090306002341.9882.61625.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, jacek.danecki@intel.com
List-Id: linux-raid.ids

This series, against the 'md/for-next' branch, adds a sysfs attribute
for pinning the array size.  As discussed earlier this is being
initiated to support the extra size rounding expected for Intel(R)
Matrix metadata arrays.  For example a 20GB 4-disk raid5 array created
in the orom will have the per-device size set to 13981448 sectors.  MD
calculates the array size as 41944320 sectors while the metadata records
the size as 41943040 sectors.

Tested against a raid5 grow from 4 to 5 disks, and a grow that attempts
to set the size smaller than the userspace pinned size.  The attribute
displays 'default' when the size is unpinned, to aid debug.

---

Dan Williams (3):
      md: 'array_size' sysfs attribute
      md: centralize ->array_sectors modifications
      md: add 'size' as a personality method


 drivers/md/faulty.c       |   14 ++++++
 drivers/md/linear.c       |   15 ++++++-
 drivers/md/md.c           |   97 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/multipath.c    |   11 +++++
 drivers/md/raid0.c        |   22 ++++++++--
 drivers/md/raid1.c        |   19 +++++++--
 drivers/md/raid10.c       |   27 ++++++++++++-
 drivers/md/raid5.c        |   49 +++++++++++++++++------
 include/linux/raid/md.h   |    2 +
 include/linux/raid/md_k.h |    2 +
 10 files changed, 229 insertions(+), 29 deletions(-)

