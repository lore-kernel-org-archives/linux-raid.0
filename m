From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm git pull] platform support v2 and other fixes
Date: Mon, 08 Dec 2008 18:29:17 -0700
Message-ID: <1228786157.9780.19.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

So here is a second attempt at platform support.  I asked around about
scanning for the option-rom and the solution I settled on was to port
the kernel's "Adapter ROM" detection code to userspace (probe_roms.c
from arch/x86/kernel/probe_roms_32.c).  This at least makes mdadm bug
compatible with the kernel, and avoids scanning the entire region
indiscriminately.

Create support got two major fixes:
1/ calculating a common start offset by merging get_extents() results
2/ explicitly passing the target member disks in the metadata update
message

Despite the platform support and these fixes I am still investigating
whether mdadm can create configurations that the option-rom does not
understand.  Stay tuned...

Lastly I added a regression test to stress the overlapping create case,
it adds some infrastructure for tests to define their own environment.

As always, please have a look.

Thanks,
Dan

The following changes since commit 5a52a340905d1a9d0a268ce2621f55db6b3fd423:
  NeilBrown (1):
        Merge branch 'master' into devel-3.0

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/mdadm.git devel

Dan Williams (17):
      fix ->metadata_version checking in Wait()
      wait_for container assembly
      imsm: fix setting of device size for raid1
      imsm: correct start offset handling at create time
      imsm: pass disk info in create message
      port arch/x86/kernel/probe_roms_32.c for use in 'platform' support
      imsm: detect option-rom capabilities
      imsm: sysfs support routines for determining device connectivity
      imsm: validate arrays being created against firmware capabilities
      introduce --detail-platform to display platform raid capabilities
      imsm: provide a detail_platform method
      imsm: convert dev_tbl to devlist
      imsm: reverse swapped arguments to posix_memalign in imsm_prepare_update
      imsm: don't take chunk_size into account for raid1
      test: enable per-test custom environment setup/teardown
      workaround a hald interaction and quiet cleanup
      imsm: test overlapping creates

 Assemble.c               |    1 +
 Detail.c                 |   41 +++
 Makefile                 |   13 +-
 Monitor.c                |    2 +-
 ReadMe.c                 |    2 +
 mdadm.8                  |   35 ++-
 mdadm.c                  |    4 +
 mdadm.h                  |    6 +
 platform-intel.c         |  239 +++++++++++++
 platform-intel.h         |  129 +++++++
 probe_roms.c             |  279 +++++++++++++++
 probe_roms.h             |   24 ++
 super-ddf.c              |    1 +
 super-intel.c            |  845 ++++++++++++++++++++++++++++++++++++++++------
 super0.c                 |    1 +
 super1.c                 |    1 +
 test                     |   21 ++-
 tests/08imsm-overlap     |   25 ++
 tests/env-08imsm-overlap |    1 +
 tests/env-imsm           |   68 ++++
 20 files changed, 1620 insertions(+), 118 deletions(-)
 create mode 100644 platform-intel.c
 create mode 100644 platform-intel.h
 create mode 100644 probe_roms.c
 create mode 100644 probe_roms.h
 create mode 100644 tests/08imsm-overlap
 create mode 120000 tests/env-08imsm-overlap
 create mode 100644 tests/env-imsm


