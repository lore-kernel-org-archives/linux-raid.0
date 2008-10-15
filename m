From: Dan Williams <dan.j.williams@intel.com>
Subject: [git pull] updates for mdadm-3.0 and imsm support
Date: Wed, 15 Oct 2008 16:26:24 -0700
Message-ID: <1224113184.25423.31.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

This update brings:
1/ Bug fixes for imsm metadata, including a serial number handling
problem that was preventing assembly
2/ Support for checkpointing resync and rebuild
3/ The '--switch-root' option to mdmon to aid starting and stopping
mdmon in the initramfs environment
4/ Random fixes and cleanups

Testing continues, but this is the version I am running on my ich6r
based MythTV box (raid1).

Question:
Should "mdadm -Is" be updated to support assembling the external
metadata arrays defined in mdadm.conf?  Currently I have modified an
initramfs to perform:

mdadm -As
mdadm -I /dev/imsm

...which works but I would like the name of the container to be
implicit.  The alternative:

 for i in /dev/sd[abcde]
 do mdadm -I $i
 done

...results in the array(s) being started too early.

In any event, please have a look.

Thanks,
Dan

The following changes since commit c04d54461f199dd31e2b83e07b3df5b71930898e:
  NeilBrown (1):
        Updates version numbers for 3.0-devel1 release.

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/mdadm.git devel

Dan Williams (26):
      imsm: more serial handling fixups
      imsm: confirm raid10 layout, fix up handling raid10 failures
      sysfs: dprintf when we fail to write a sysfs file
      imsm: trust sector reservation from metadata
      monitor: protect against CONFIG_LBD=n
      --wait-clean: shorten timeout
      Extend --wait-clean to checkpoint resync
      imsm: enable checkpointing of migration (resync/rebuild)
      imsm: fix mpb_size calculation in write_super_imsm
      imsm: manage a list of missing disks
      imsm: determine failed indexes from the most up-to-date disk
      trivial warn_unused_result squashing
      non-trivial warn_unused_result fixes, write_init_super_ddf
      non-trivial warn_unused_result fixes, activate_spare
      non-trivial warn_unused_result fix, prepare_update
      sysfs_open leaks devnum2devname() result
      mdmon: periodically retry to create the socket
      fname_as_uuid: print uuids msb first
      imsm: show uuid in ->examine_super()
      Allow a uuid of all f's to always match
      Treat all devices at the container level as spares
      mdmon: terminate clean
      mdmon: wait after trying to kill
      mdmon: --switch-root
      quiet WaitClean()
      mdmon: suicide prevention

 Assemble.c          |   13 ++-
 Makefile            |    5 +-
 Monitor.c           |   50 ++++++---
 bitmap.c            |    5 +-
 config.c            |   10 +-
 kernel-patch-2.6.27 |   36 ++++++
 managemon.c         |   30 +++--
 mdadm.8             |   13 ++-
 mdadm.c             |    2 +-
 mdadm.h             |   11 ++-
 mdmon.c             |  239 +++++++++++++++++++++++++++-----------
 mdmon.h             |   21 ++--
 monitor.c           |   45 ++++++-
 super-ddf.c         |  167 ++++++++++++++++++++-------
 super-intel.c       |  320 +++++++++++++++++++++++++++++++++++++++++----------
 super0.c            |   20 +++-
 super1.c            |   24 +++-
 sysfs.c             |   17 ++-
 util.c              |   19 +++-
 19 files changed, 799 insertions(+), 248 deletions(-)
 create mode 100644 kernel-patch-2.6.27


