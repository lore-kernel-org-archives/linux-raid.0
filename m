From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm PATCH 00/12] External metadata updates and other fixes for
	3.0.3
Date: Tue, 13 Oct 2009 19:10:16 -0700
Message-ID: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, krzysztof.wojcik@intel.com, ed.ciechanowski@intel.com, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

Hi Neil,

The following changes are available at:

	git://github.com/djbw/mdadm.git

The stand out change in the diffstat is the incorporation of the
Option-ROM logic for handling arrays with different 'family numbers'.
The scheme the Option-ROM uses to resolve conflicts is not completely
amenable to mdadm's container scheme.  The end result is a corner case
that requires user intervention.  The user will need to assign new
container membership ids to prodigal disks that are returned to their
system of origin.  More details in the commit log and code comments.

Also notable are the changes to cleanup mdmon instance management.  I
kept the status quo in deciding against implementing an "abstract
namespace socket" for the control path.  Initramfs environments can take
two paths:
1/ Use the built-in 'newroot' option to hand off monitoring to an
   mdmon binary launched from the target file system.  Currently Dracut
   will not be able to use this method as its 'switch_root' command does
   not allow an mdmon instance to be launched between $NEWROOT/dev and
   $NEWROOT/sys being available and the initramfs exiting.
2/ Keep the mdmon instance from the initramfs running until it can be
   killed by the final-root initscripts.  The socket will not be available
   so this should be done while the file system is still read only and
   any writes from journal recovery have quiesced.

In testing this I noticed that wait_for() (util.c) occasionally timed
out on Fedora 11, but not Fedora 9.  Increasing the loop count to 50 got
around the issue, but need to investigate what is holding up our
requested symlink.

Thanks,
Dan

Dan Williams (12):
      imsm: cleanup disk status tests
      imsm: kill close() of component device
      imsm: disambiguate family_num
      imsm: fix spare record writeout race
      imsm: fix/support --update
      ddf: prevent superblock being zeroed on --update
      imsm: add --update=uuid support
      imsm: regression test for prodigal array member scenario
      Detail: export MD_UUID from mapfile
      mdmon: avoid writes in the startup path for mdmon on root arrays
      mdmon: exec(2) when the switchroot argument is not "/"
      mdmon: preserve socket over chroot

 Assemble.c                |    3 
 Detail.c                  |    5 
 managemon.c               |    6 
 mdadm.c                   |    4 
 mdadm.h                   |    8 
 mdmon.c                   |  107 +++---
 msg.c                     |   14 +
 msg.h                     |    1 
 super-ddf.c               |   27 +-
 super-intel.c             |  799 ++++++++++++++++++++++++++++++++-------------
 sysfs.c                   |    5 
 tests/09imsm-assemble     |   46 +++
 tests/env-09imsm-assemble |   32 ++
 util.c                    |   12 -
 14 files changed, 780 insertions(+), 289 deletions(-)
 create mode 100644 tests/09imsm-assemble
 create mode 100644 tests/env-09imsm-assemble
