From: Jes.Sorensen@redhat.com
Subject: [PATCH v2 0/3] Fix mdadm vs udev race in Incremental and Assemble
Date: Fri, 21 Oct 2011 15:33:17 +0200
Message-ID: <1319204000-6661-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, lukasz.dorau@intel.com, adam.kwolek@intel.com, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

When I posted this yesterday I missed a couple of exist cases in the
patch changing the locking scheme for Incremental_container(). Not
sure how I managed that, but fixed in v2 of the patch. The other two
patches remain onchanged.

This patch set fixes the problem with mdadm racing udev during during
incremental or regular assembly of IMSM raids.

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

 Incremental.c |   30 ++++++++++++++----------------
 mdadm.c       |    6 ++++++
 2 files changed, 20 insertions(+), 16 deletions(-)

-- 
1.7.4.4

