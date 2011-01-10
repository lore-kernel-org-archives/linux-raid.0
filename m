From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 00/13] OLCE for external meta Raid5/single array
Date: Mon, 10 Jan 2011 12:27:25 +0100
Message-ID: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

This patches enables raid5/single array Online Capacity Expansion using container operation.
I've decided to post smaller series to allow us for closer/adaptive work.

Main changes in code:
- metadata is reloaded between reshape_super() and reshape_array(), reshape_super() doesn't modify local anchor
- disk slot is set by md (index == -1), this propably has to be fixed in md
- suspend_lo has to be set to suspend_hi value after reshape to unblock array
- fixes


The main problems I can see:
- cannot add spare disks to container (add spare to raid0 works),
  I've payed no attantion for it so far as  I'm using workaround for tests: create container with bigger disks number before any array is created.
- adding disks to md with set index/slot should be fixed/investigated in md (for details look patches description)
- array cannot be opened excl. in reshape_array() 
  As I've put information in patch, it is possible caused by mdmon, I cannot see double array open operation in mdadm.
  On mdadm begin open_dev_excl() is possible.

BR
Adam

---

Adam Kwolek (13):
      FIX: Fill sys_name for disk add
      FIX: parity disks use for redundant levels only
      FIX/WORKAROUND: Arrays cannot be opened exclusively
      FIX: Cannot unmount array after reshape
      Finalize reshape after adding disks to array
      FIX/WORKAROUND: added disks are not used by reshape process /md/
      FIX: wrong flags are passed to function
      imsm: FIX: update disks status in container_contents()
      msm: FIX: when mdadm reloads anchor not need for local modyfication
      FIX: load anchor to get all information
      imsm: FIX: when monitor is active post update
      imsm: FIX: allow for container reshape any unset size value
      Manage reshape process in manage_reshape vector.


 Grow.c        |   29 +++++++++++++++++++++--------
 monitor.c     |   11 +++++++++++
 super-intel.c |   30 +++++++++++++-----------------
 3 files changed, 45 insertions(+), 25 deletions(-)

-- 
Signature
