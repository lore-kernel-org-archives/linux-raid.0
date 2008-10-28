From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm git pull] "--assemble --scan" support for imsm
Date: Tue, 28 Oct 2008 14:44:01 -0700
Message-ID: <1225230241.5778.26.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

This update allows imsm containers and member arrays to be discovered
with '-Eb' and subsequently assembled with '-As'.

For example here is a test for assembling a 4 drive container with (1)
4-disk raid5 array plus one spare.

# echo "DEVICES /dev/loop[0-4]" > tmp/mdadm.conf

# mdadm -Ebsc tmp/mdadm.conf >> tmp/mdadm.conf

# cat tmp/mdadm.conf
DEVICES /dev/loop[0-4]
ARRAY /dev/imsm metadata=imsm auto=md UUID=b98f5dbe-aa859e7b-0e369b89-a80986d4
ARRAY /dev/md/r1 container=/dev/imsm member=0 auto=mdp UUID=3538e39c-b397c2e9-1aa031f9-2bc0eca4
   spares=1

# mdadm -Asvc tmp/mdadm.conf
mdadm: looking for devices for /dev/imsm
mdadm: /dev/loop4 is identified as a member of /dev/imsm, slot -1.
mdadm: /dev/loop3 is identified as a member of /dev/imsm, slot -1.
mdadm: /dev/loop2 is identified as a member of /dev/imsm, slot -1.
mdadm: /dev/loop1 is identified as a member of /dev/imsm, slot -1.
mdadm: /dev/loop0 is identified as a member of /dev/imsm, slot -1.
mdadm: added /dev/loop3 to /dev/imsm as -1
mdadm: added /dev/loop2 to /dev/imsm as -1
mdadm: added /dev/loop1 to /dev/imsm as -1
mdadm: added /dev/loop0 to /dev/imsm as -1
mdadm: added /dev/loop4 to /dev/imsm as -1
mdadm: Container /dev/imsm has been assembled with 5 drives
mdadm: looking to assemble member array 0 inside container /dev/imsm
mdadm: match found for member 0

I suppose brief_examine_super_imsm() can be updated to look at the
currently running kernel and not specify auto=mdp if the "extended
partition" capability is available.  Is there a quick way to check for
this capability?  You can see that I tagged this support as
"preliminary" as it does not attempt to address the multiple container
case, I left it alone for now as that solution depends on the device
name rework.

Please have a look.

Thanks,
Dan

The following changes since commit b01b06bda8dce132e6eb3c3826ad0f4b94ebdf43:
  NeilBrown (1):
        Merge branch 'master' into devel-3.0

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/mdadm.git devel

Dan Williams (7):
      update copyright headers
      imsm: update metadata immediately on "add spare" events
      Examine: fix MD_DISK_SYNC is a bit not a flag
      imsm: return associated uuid for spares
      imsm: copy raid device info when associating spares
      imsm: include members in ->brief_examine
      Preliminary -As support for container member arrays

 Assemble.c    |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 Examine.c     |    2 +-
 Incremental.c |    6 ++++++
 config.c      |    2 ++
 managemon.c   |   19 +++++++++++++++++++
 mdadm.h       |    1 +
 mdmon.c       |   28 +++++++++++++++++++---------
 mdmon.h       |   20 ++++++++++++++++++++
 monitor.c     |   19 +++++++++++++++++++
 sg_io.c       |    2 +-
 super-intel.c |   53 ++++++++++++++++++++++++++++++++++++++++++++---------
 util.c        |    9 +++++++++
 12 files changed, 187 insertions(+), 20 deletions(-)


