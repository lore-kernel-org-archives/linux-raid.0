From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm git pull] random fixes and compatibility updates for imsm
Date: Mon, 10 Nov 2008 11:20:52 -0700
Message-ID: <1226341252.23442.13.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

This release updates support for creating imsm arrays to use the lowest
possible metadata version based on the contents of the container.  For
example all versions of the option-ROM support raid0 so when creating a
raid0 array tag the metadata as version "1.0.00" even if the platform
supports a higher version.

There are also a couple fixes for fallout from the device name rework.

Please have a look.

Thanks,
Dan


The following changes since commit 01cbfcc854c031a18cf7542c5430734e69ef33fb:
  NeilBrown (1):
        Create: don't wait for device to appear if we didn't actually start the array

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/mdadm.git devel

Dan Williams (8):
      imsm: cleanup ->match_home and comment on return value
      imsm: cleanup migration definitions and usage
      imsm: add definitions for recent imsm versions
      imsm: fixup disk status definition endianess
      imsm: compatibility fixes for creating imsm arrays
      imsm: fix uuid_from_super given 'signature' is not constant
      fix remove_devices()
      fix add_dev() handling of broken links

 Manage.c      |   10 ++-
 super-intel.c |  244 +++++++++++++++++++++++++++++++++++++++------------------
 util.c        |    4 +-
 3 files changed, 175 insertions(+), 83 deletions(-)


