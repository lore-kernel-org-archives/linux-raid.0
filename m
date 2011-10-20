From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/3] Fix mdadm vs udev race in Incremental and Assemble
Date: Thu, 20 Oct 2011 12:06:15 +0200
Message-ID: <1319105178-7697-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, lukasz.dorau@intel.com, adam.kwolek@intel.com, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

This patch set fixes the problem with mdadm racing udev during during
incremental or regular assembly of IMSM raids. This set fixes a bug in
the initial patch I posted earlier, and adds the locking to Assemble()
which I didn't have in the first round.

There are three patches to the set:
1) Hold the lock while running Incremental_container() to avoid udev
   (or someone else like a boot script) kicking off an additional
   mdadm instance to try and assemble the container in parallel.
2) Don't send udev a 'change' event to handle incremental assembly
   since we are about to do it ourselves anyway.
3) Hold the lock during Assemble() again to avoid udev kicking in
   behind our backs.

With these patches in place, I can no longer reproduce the case I was
seeing on Fedora 16 Beta where an array would not come up correctly.

Patches are on top of Neil's current git repository.

Comments?

Cheers,
Jes


Jes Sorensen (3):
  Remove race for starting container devices.
  Don't tell sysfs to launch the container as we are doing it ourselves
  Hold the map lock while performing Assemble to avoid races with udev

 Incremental.c |   27 ++++++++++++++-------------
 mdadm.c       |    6 ++++++
 2 files changed, 20 insertions(+), 13 deletions(-)

-- 
1.7.6.4

