From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/9] recovering an imsm raid5 array
Date: Thu, 25 Aug 2011 19:13:59 -0700
Message-ID: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

I run imsm raid5 and raid1 arrays on my personal systems and was
recently bit by the bug that was fixed in commit 1a2487c2 "FIX: imsm:
OROM does not recognize degraded arrays (V2)".  In the process of
investigating that I pulled the wrong disk and ended up in a dual
degraded situation.

These patches (ordered in roughly increasing order of required review)
are the features needed to get the array up and running again, as well
as some random fixes spotted along the way.

The most important patch for recovery being patch7 "imsm: support
'missing' devices at Create", allowing the mdadm raid5 recovery path of
recreating the raid array with what one thinks are the good disks /
order, and then  attempt to mount the filesystem to see if the guess was
correct.

Example, create degraded raid5 with slot1 missing.

mdadm --create /dev/md0 /dev/sd[ac] -n 2 -e imsm
mdadm --create /dev/md1 /dev/sda missing /dev/sdc -n 3 -l 5

However, during this process I wanted to make sure I could get back to
the exact same metadata that was on the disks, to root cause what went
wrong, examine the metadata offline, or backup a step if I made a
mistake in the recovery process.  Patch9 implements --dump support, the
fact that something like this has not been implemented already is maybe
a clue that it is not such a great idea?  I can imagine someone messing
up their configuration if they restored a metadata image to the wrong
device, but if you know what you are doing it could be a useful hack.

---

Dan Williams (9):
      imsm: fix max disks per array
      imsm: fix, stop metadata updates to newly failed devices
      imsm: fix display spares
      sysfs: fix sysfs_disk_to_scsi_id
      imsm: fix reserved sectors for spares
      mdmon: fix, close spare activation race
      imsm: support 'missing' devices at Create
      util: allow regular files through test_partition()
      mdadm: 'dump' support


 Examine.c     |   42 ++++++++++++++++
 ReadMe.c      |    1 
 managemon.c   |    5 ++
 mdadm.8.in    |   13 +++++
 mdadm.c       |   11 ++++
 mdadm.h       |    3 +
 super-intel.c |  146 +++++++++++++++++++++++++++++++++++++--------------------
 sysfs.c       |   30 ++++--------
 util.c        |    6 ++
 9 files changed, 182 insertions(+), 75 deletions(-)
