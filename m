From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm git pull] support for detecting platform raid capabilities
	and some fixes
Date: Wed, 26 Nov 2008 16:45:00 -0700
Message-ID: <1227743100.31146.41.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-raid.ids

Hi Neil,

This is hopefully the tail of the feature additions from me for
mdadm-3.0-final.  It adds the capability for mdadm to detect platform
raid capabilities, and honor them when creating new arrays.  For example
here is the output of the new --detail-platform option on an imsm
enabled platform:

# mdadm --detail-platform -e imsm
       Platform : Intel(R) Matrix Storage Manager
        Version : 7.6.0.1011
    RAID Levels : raid0 raid1 raid10 raid5
      Max Disks : 6
    Max Volumes : 2
 I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2
          Port0 : /dev/sda (5RA4GKSS)
          Port1 : /dev/sdb (5RA4GKNC)
          Port2 : /dev/sdc (5RA4GKT8)
          Port3 : /dev/sdd (5RA4GQWR)
          Port5 : /dev/sde (5RA4GQYG)

This implementation crawls through sysfs to put this information
together, I believe it is crawling in a future proof fashion, but here
are my assumptions:
1/ /sys/bus/pci/drivers/ahci/<x>/device will identify a pci ahci device
with a bus id of 'x'.  This allows mdadm to detect which disks are
attached to which controller.
2/ The 'scsi_host' objects in /sys/bus/pci/drivers/ahci/<x> are named
'host%d' and there is one host per physical ahci port.  This is not
critical but allows the 'Port' information to be displayed.

It relies on /sys/dev/block so requires at least 2.6.27.

Other notables:
1/ An attempt to cover the delay between mdadm creating an array and the
friendly-named device node showing up in /dev/md/ by calling 'udevadm
settle' before starting starting Incremental assembly.  This
specifically fixes scripts that do:
mdadm -A /dev/md/<container>
mdadm -I /dev/md/<container>
There is a good chance there is a better place to put this call, but
putting it in create_mddev didn't work, and moving it up in main()
resulted in a hang.  I didn't want to hold up the other patches for this
debug.
2/ --wait-clean now honors the --scan option to allow shutdown scripts
to generically wait for any external metadata devices to finish
lingering writes.
3/ Now that we can do checking against the platform there are cases
where ->add_to_super should fail.

Please have a look.

Thanks,
Dan

PS: consuming large amounts of turkey may slow my responses until
Monday :-)

The following changes since commit a30b2ecd4a4215b0c0017edc6df538c264a97e85:
  NeilBrown (1):
        Assemble: don't auto-assemble if any arrays are listed in mdadm.conf

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/mdadm.git devel

Dan Williams (10):
      some warn_unused_result fixups
      udevadm settle barrier before invoking incremental assembly
      Support --wait-clean --scan
      allow add_to_super to return errors
      imsm: fix metadata reservation
      imsm: detect option-rom capabilities
      imsm: sysfs support routines for determining device connectivity
      imsm: validate arrays being created against firmware capabilities
      introduce --detail-platform to display platform raid capabilities
      imsm: provide a detail_platform method

 Create.c         |    8 +-
 Detail.c         |   41 ++++++++
 Makefile         |    6 +-
 Manage.c         |    9 ++-
 ReadMe.c         |    2 +
 mdadm.8          |   44 ++++++++--
 mdadm.c          |   28 +++++-
 mdadm.h          |    8 ++-
 mdopen.c         |   14 ++-
 platform-intel.c |  268 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 platform-intel.h |  129 ++++++++++++++++++++++++++
 super-ddf.c      |    9 +-
 super-intel.c    |  236 ++++++++++++++++++++++++++++++++++++++++++++----
 super0.c         |    5 +-
 super1.c         |    5 +-
 15 files changed, 765 insertions(+), 47 deletions(-)
 create mode 100644 platform-intel.c
 create mode 100644 platform-intel.h


