From: Jes.Sorensen@redhat.com
Subject: [PATCH 00/19] More fixes for resource leaks and warnings
Date: Tue,  1 Nov 2011 16:09:16 +0100
Message-ID: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

Another 'small' pile of fixes for various resource leaks, null pointer
dereferencing and out of bounds buffer access found by Coverity.

This is the bulk of these for now. Please notice that I haven't
touched super-ddf.c at all, and that is probably the single biggest
offender. Also note that I haven't addressed a number of warnings in
sysfs.c where we know for sure that files aren't bigger than a given
size. The tool obviously doesn't know this, so it spews warnings when
we strcpy() content we just read. While the code per-ce is probably
safe, we may want to switch to strncpy() just to reduce the noise
ratio?

Cheers,
Jes


Jes Sorensen (19):
  Grow_Add_device(): dev_open() return a negative fd on error
  Grow_addbitmap(): don't try to close a file descriptor which failed
    to open
  Incremental(): Check return value of dev_open() before trying to use
    it
  sysfs_unique_holder(): Check read() return value before using as
    buffer index
  remove_devices(): readlink returns -1 on error
  assemble_container_content(): fix memory leak
  Grow_restart(): free() offsets after use
  Assemble(): don't dup_super() before we need it.
  Detail(): Remember to free 'avail'
  Grow_reshape(): Fix another 'sra' leak
  enough_fd(): remember to free buffer for avail array
  Manage_subdevs(): avoid leaking super
  IncrementalScan(): Fix memory leak
  Managa_ro(): free() mdi before exiting
  Manage_runstop(): Avoid memory leak
  Monitor(): free allocated memory on exit
  bitmap_fd_read(): fix memory leak
  validate_geometry_imsm_volume(): Avoid NULL pointer dereference
  make_parts(): Avoid false positive security warning

 Assemble.c    |    9 +++++++--
 Detail.c      |    3 ++-
 Grow.c        |   19 +++++++++++++------
 Incremental.c |    7 +++++++
 Manage.c      |   56 ++++++++++++++++++++++++++++++++++++++++----------------
 Monitor.c     |    6 ++++++
 bitmap.c      |    3 +++
 mdopen.c      |   14 +++++++-------
 super-intel.c |    4 +++-
 sysfs.c       |    2 ++
 util.c        |    9 +++++----
 11 files changed, 95 insertions(+), 37 deletions(-)

-- 
1.7.6.4

