From: Jes.Sorensen@redhat.com
Subject: [PATCH 00/12] More leak and NULL pointer dereference fixes
Date: Wed,  2 Nov 2011 15:42:05 +0100
Message-ID: <1320244937-9739-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

As promised, here is another batch of fixes for small memory leaks,
use of invalid file descriptors and NULL pointer dereferences.

The coverity output is starting to look a lot better by now :)

Cheers,
Jes


Jes Sorensen (12):
  mdadm: add missing break for UpdateSubarray
  ping_monitor(): check file descriptor is valid before using and
    closing it
  mdstat_read(): Check return value of dup() before using file
    descriptor
  get_component_size(): Check read() return value for error before
    using it
  array_try_spare(): open_dev() returns -1 on error, not zero
  disk_init_and_add(): Fail if opening sysfs file descriptors fail
  close_aa(): Verify file descriptors are valid before trying to close
    them
  ahci_enumerate_ports(): Don't close fd that failed to open
  unblock_monitor(): Check sra is valid before dereferencing
  Manage_ro(): Check pointer rather than dereferencing it
  fd2devname(): Don't dereference NULL pointer
  match_metadata_desc(): Fix memory leak

 Incremental.c |    2 +-
 Manage.c      |    2 +-
 managemon.c   |   21 ++++++++++++++++-----
 mdadm.c       |    1 +
 mdstat.c      |    7 ++++++-
 msg.c         |   11 +++++++++--
 super-intel.c |    8 +++++---
 super-mbr.c   |    7 ++++---
 sysfs.c       |    2 +-
 9 files changed, 44 insertions(+), 17 deletions(-)

-- 
1.7.6.4

