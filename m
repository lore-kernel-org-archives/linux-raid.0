From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 0/35] Autorebuild updated
Date: Mon, 16 Aug 2010 10:38:12 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8F9A7@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

This is updated series of patches forming autorebuild functionality.

There are no changes in the first 19 patches from original series of 33 sent on 5. July 2010.
Patches 11 and 32 were applied by Neil so they are omitted in this updated series.
As a consequence of this and other changes the numbering has changed.
Monitor has been updated as suggested in comments to patches 20 and 21,
that is: linking of containers and volumes has been simplified and
the information about states of devices in container is read from superblock
loaded on a container instead of reading from each device separately. This is only done
once in each cycle and only when there are degraded arrays.
New option -no-sharing has been added to Monitor mode and spare sharing is allowed in only
one instance of Monitor.
Patches 26 and 27 (now 31, 32) have been reworked as advised.
Patch 31 (now 35) is included for correct functioning in some cases but was not updated.
There is still work in progress on this part.
Patch 33 from old series is removed. 

To summarize: all code changes are in patches 19-29, 31-34.
Regards
Anna Czarnowska

0001-hotunplug-we-are-testing-mdstat-not-ent-which-is-und.patch
0002-Few-fixes-and-sample-udev-rules-file-to-capture-bloc.patch
0003-Config-option-parsing-for-new-DOMAIN-line-support.patch
0004-Support-for-new-disk-hot-plug-actions-with-DOMAINs.patch
0005-Partition-action-support-in-DOMAIN-line.patch
0006-Updates-to-udev-rules-and-ReadMe.c-for-incremental-g.patch
0007-add-general-domain-subset-lists-manipulation-routine.patch
0008-imsm-platform-dependent-domain-boundaries.patch
0009-processing-of-domain-entries-made-after-config-is-lo.patch
0010-update-domain-search-to-new-structures-added-subset-.patch
0011-assembly-user-domain-subset-from-configuration-file-.patch
0012-create-respect-domains-subsets-during-create-process.patch
0013-manage-domains-support-in-Manage_subdev.patch
0014-incremental-add-domain-subset-support.patch
0015-additional-environment-dependent-code-for-platform-s.patch
0016-test-code-for-loop-device-support-added.patch
0017-Removed-uuid-setting-for-imsm-spares.patch
0018-Assemble-assembly-with-domains-two-runs-for-imsm-spa.patch
0019-Util-get-device-size-from-id.patch
0020-Monitor-set-err-on-arrays-not-in-mdstat.patch
0021-Monitor-removed-spare-group-based-spare-sharing-code.patch
0022-mdadm-added-no-sharing-parameter-for-Monitor-mode.patch
0023-Monitor-link-container-volumes-in-statelist.patch
0024-imsm-create-mdinfo-list-of-disks-in-a-container-from.patch
0025-Monitor-fill-devstate-of-containers-based-on-superty.patch
0026-Monitor-get-array-domain-and-subset-function-added.patch
0027-Monitor-added-function-move_spare.patch
0028-Monitor-added-spare-sharing-and-dev-suitable-functio.patch
0029-Monitor-autorebuild-funcionality-added.patch
0030-Man-pages-update-with-DOMAIN-line-description.patch
0031-added-path-path_id-to-give-the-information-on-the-pa.patch
0032-extension-of-IncrementalRemove-to-store-location-por.patch
0033-update-udev-rules-to-support-path-parameter-with-rem.patch
0034-Incremental-for-bare-disks-checking-routine-integrat.patch
0035-Fix-problem-in-mdmon-monitor-of-using-removed-disk-f.patch

 Assemble.c          |   66 ++++-
 Create.c            |   29 ++
 Incremental.c       |  425 +++++++++++++++++++++++++-
 Makefile            |    9 +-
 Manage.c            |   51 +++-
 Monitor.c           |  526 +++++++++++++++++++++++++-------
 ReadMe.c            |   25 +-
 config.c            |  865 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 managemon.c         |   38 +++
 mapfile.c           |   71 +++++
 mdadm.8.in          |   23 +-
 mdadm.c             |   49 +++-
 mdadm.conf.5        |  146 ++++++++--
 mdadm.h             |  119 +++++++-
 mdstat.c            |   15 +-
 super-intel.c       |  263 ++++++++++++----
 udev-early-md.rules |   28 ++
 udev-md-raid.rules  |    6 +-
 util.c              |  277 ++++++++++++++++
 19 files changed, 2789 insertions(+), 242 deletions(-)

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

