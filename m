From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [Patch 00/17] Autorebuild
Date: Fri, 29 Oct 2010 15:13:40 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FAF@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

This is updated series of patches forming autorebuild functionality in mdadm monitor based on new policy code.

Autorebuild Monitoring application:
Autorebuild monitor is part of monitor application (mdadm -F). In the current code of mdadm monitor autorebuild feature was based on spare group assignment in mdadm.conf file and worked only for native metadata. This code has been retained for compatibility with old config format.
The new autorebuild implementation works also for external metadata types. It uses the concept of domains in mdadm.conf introduced by Neil Brown. 
Monitoring application periodically checks the state of MD active arrays and triggers a rebuild if there are eligible spare disks in other arrays/containers.
Degraded arrays are checked one by one. If there is a spare disk in other array/container that matches the domain of the degraded array and the domain action allows for spare sharing the spare is moved using existing Manage_subdevs function. If the addition fails, the spare device is moved back to the original container and next potential spare is tried. The process is repeated until all arrays are checked and the process is put into a sleep state for a configured period.

New option --no-sharing has been added to Monitor mode to be able to run monitoring only (without moving spares). This is recommended when many instances of monitor are to be run on the same set of devices.
Spare sharing is allowed in only one instance of Monitor running with --scan option. User is still able to start Monitoring functions in multiple instances without --scan option.

The autorebuild build-in assumptions are:
1\spares are shared between the arrays of the same metadata 2\spares are moved only from containers/volumes that are not degraded 3\spares are moved to containers/volumes lacking a *good* spare (size)

Anna Czarnowska
Przemyslaw Hawrylewicz-Czarnowski
Marcin Labun

0001-added-path-path_id-to-give-the-information-on-the-pa.patch
0002-Update-of-udev-rules-to-support-IMSM-devices.patch
0003-extension-of-IncrementalRemove-to-store-location-pat.patch
0004-Incremental-for-bare-disks-implementation-of-spare-s.patch
0005-Util-get-device-size-from-id.patch
0006-Monitor-set-err-on-arrays-not-in-mdstat.patch
0007-Monitor-spare-group-based-spare-sharing-moved-to-sep.patch
0008-mdadm-added-no-sharing-option-for-Monitor-mode.patch
0009-Monitor-avoid-skipping-checks-on-external-arays.patch
0010-Monitor-include-containers-in-scan-mode.patch
0011-Monitor-link-containers-with-subarrays-in-statelist.patch
0012-imsm-create-mdinfo-list-of-disks-in-a-container-from.patch
0013-Monitor-autorebuild-functionality-added.patch
0014-Monitor-Respect-policy-in-auto-rebuild-in-mdadm-moni.patch
0015-Monitor-more-accurate-size-check-when-looking-for-sp.patch
0016-IMSM-Fix-problem-in-mdmon-monitor-of-using-removed-d.patch
0017-Policy-is-aware-of-metadata-disk-s-controller-domain.patch

Incremental.c      |  230 +++++++++++++++---
Makefile           |    3 +
Monitor.c          |  691 ++++++++++++++++++++++++++++++++++++++++++++--------
ReadMe.c           |    4 +
managemon.c        |   38 +++
mdadm.c            |   29 ++-
mdadm.h            |   49 ++++-
policy.c           |  134 +++++++++-
super-intel.c      |  274 ++++++++++++++++++---
udev-md-raid.rules |    7 +-
util.c             |   23 ++
11 files changed, 1290 insertions(+), 192 deletions(-)
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

