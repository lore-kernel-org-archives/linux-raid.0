From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm PATCH 00/13] rebuild / resync checkpointing and other external
	metadata fixes
Date: Tue, 22 Dec 2009 16:59:19 -0700
Message-ID: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

Hi Neil,

The latter half of this update consumes the new
md/dev-XXX/recovery_start attribute for checkpointing and resuming
resync/rebuild operations.  It requires one more kernel patch [1] on top
of 2.6.33-rc1 to ensure that mdmon sees the recovery state.  One caveat
is that we only get checkpoint events when the sync_action == idle, at
array shutdown or as a part of 'mdadm --wait-clean --scan'.

The other bits are a collection of fixes to address unrelated issues
discovered along the way.  The result is pushed out to:

	git://github.com:djbw/mdadm.git master

Please have a look.

Thanks,
Dan

[1]: http://marc.info/?l=linux-raid&m=126144478304488&w=2

---

Dan Williams (13):
      imsm: catch attempt to auto-layout zero-length arrays
      imsm: honor orom constraints for auto-layout
      imsm: fix spare promotion
      imsm: fix thunderdome segfault
      util: fix devnum2devname for devnum == 0
      imsm: cleanup print_imsm_dev()
      mdmon: cleanup manage_member() leak
      mdmon: cleanup resync_start
      Add scaffolding for handling md/dev-XXX/recovery_start
      Introduce MaxSector
      Teach sysfs_add_disk() callers to use ->recovery_start versus 'insync' parameter
      Support external metadata recovery-resume
      imsm: add support for checkpointing via 'curr_migr_unit'


 Create.c      |    2 
 Manage.c      |    1 
 bitmap.c      |    2 
 managemon.c   |   93 ++++++++----
 mdadm.h       |   27 +++-
 mdmon.h       |    7 -
 monitor.c     |   23 +--
 super-ddf.c   |   14 +-
 super-intel.c |  432 +++++++++++++++++++++++++++++++++++++++++++++++----------
 super1.c      |    6 -
 sysfs.c       |   15 ++
 util.c        |   24 +++
 12 files changed, 493 insertions(+), 153 deletions(-)

