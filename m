From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 0/33] Autorebuild and hot-plug
Date: Fri, 2 Jul 2010 18:11:20 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893878@irsmsx504.ger.corp.intel.com>
References: <905EDD02F158D948B186911EB64DB3D11F56FADD@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D11F56FADD@irsmsx503.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "dledford@redhat.com" <dledford@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

This series of patches contains changes related to:
1. Array auto-rebuild based on spare sharing between RAID devices of the 
same metadata type 
2. Policy definition for hot-plug events handling and areas of spare sharing
3. Handling hot-plug and unplug events in mdadm, so devices can be automatically
incorporated into mdadm arrays

1. Auto-Rebuild Monitoring application
Auto-rebuild monitor is part of monitor application (mdadm -F). In the current
code of mdadm monitor auto-rebuild feature was based on spare group assignment
in mdadm.conf file and worked only for native metadata. 
The new auto-rebuild implementation works for all metadata types. It introduces
the concept of domains that define the space of spare sharing for each metadata
type. By default all devices belong the same domain with regard to metadata 
specific constrains.

Monitoring application shall periodically check the state of MD active arrays 
and trigger a rebuild if there are eligible spare disks in other containers.
Degraded arrays are checked one by one. For each array to rebuild a potential
spare disk is searched. When it is found the monitor moves the spare to the 
degraded array using existing Manage_subdevs function. If the addition fails,
the spare device is moved back to the original container and next potential
spare is tried. The process is repeated until all arrays are checked and
the process is put into a sleep state for a configured period.

2.  Policy definition
Array auto rebuild configuration is based on DOMAIN lines in /etc/mdadm.conf
config file. Only this standard config file is supported.
The DOMAIN line defines a set of devices determined by path and platform.
Mdadm will take the same actions for all devices in the same domain and subset.
Subsets are parts of domain specific for hardware controllers and metadata
spare groups (such as storage pool id to be implemented at a later stage).
An array cannot include members and spares from more than one domain and subset.
Spare migration happens only within a subset.
It is possible to ignore subsets by using -force option.
Domains are matched from top down i.e. first line from config file that matches
given device is taken. Therefore the order of domains in config file is
important. With no DOMAIN lines in config file four default domains are assumed,
one for each metadata type: 0.90, 1.x, ddf, imsm.

The purpose of a domain is to guide:
 - Incremental mode - by specifying actions for hot-plug devices other than 
incremental (default).
 - Create and Manage modes - by identifying configurations that breach policy.
   E.g. to create an array with devices from two different domains, or to add a
   device from a given domain to an array which doesn't contain any devices from
   the domain, force- prefix in action item is required.
 - Monitor mode - by allowing spare sharing within the same domain and subset.
  Spare-groups for native arrays become obsolete.

The available options in domain line are:
* path=  Each domain line must have at least one valid  path=  entry.
path=  entries are file globs and are matched against devices
in /dev/disk/by-path. Each domain line can have more than one path.  The list
of paths and the platform determine whether a device belongs to given domain.
* platform= This is metadata type for all devices in domain.
If platform= item is missing then the same line describes four domains using
the same paths, one for each metadata type: 0.90, 1.x, ddf, imsm.
* action=The  action line indicates what kind of behavior is allowed on
hot-plug.  Each domain line must have one and only one action= entry.
In addition, each action may be prefixed with force- to indicate that 
we should skip certain safety checks. Valid action items are:
* ignore - Means that any hot-plugged device should be ignored. Specifying 
ignore as action effectively disables auto-rebuild on hot-plug for arrays 
in that domain
* incremental - Means normal incremental assembly (the default).
If the device has metadata that matches an array then it is added to the array.
* spare  - As incremental, additionally a spare record is written if it is 
a 'bare' device.
* same_port_bare - If a bare device is connected to the same port as 
previously removed device it is added as a spare to the array that the other 
device belonged to.

3.  Hot-plug action depends on DOMAIN classification which in turn depends 
on the configuration file and built-in sub-domains. Built-in sub-domains 
are defined for each metadata type and are metadata/hardware specific.
For instance IMSM metadata is controller dependent.  Based on DOMAIN line
action policy is taken on MD device that a new device matches. It can be:
  * Incremental - array member or spare device is added to matching array or 
  container.
  * same_port_bare

Hot-unplug event removes the device from array and container and stores the 
information about port location and array/volume identity of the removed 
device. The information is stored in /var/run/failed_slots directory. 
Based on the information, same_port_bare action can be taken on a bare device 
that has been plugged-in to the same port that was previously occupied 
by some MD device member.

Anna Czarnowska
Marcin Labun
Przemyslaw Hawrylewicz-Czarnowski


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
0011-fix-IncrementalRemove-leaves-open-handle.patch
0012-assembly-user-domain-subset-from-configuration-file-.patch
0013-create-respect-domains-subsets-during-create-process.patch
0014-manage-domains-support-in-Manage_subdev.patch
0015-incremental-add-domain-subset-support.patch
0016-additional-environment-dependent-code-for-platform-s.patch
0017-test-code-for-loop-device-support-added.patch
0018-Removed-uuid-setting-for-imsm-spares.patch
0019-Assemble-assembly-with-domains-two-runs-for-imsm-spa.patch
0020-Added-disk-util-functions.patch
0021-Monitor-link-containers-and-volumes-in-statelist.patch
0022-Monitor-added-function-to-get-domain-and-subset-of-a.patch
0023-Monitor-Spare-sharing-with-domain-subset-support.patch
0024-Monitor-Removed-spare-group-based-spare-sharing-code.patch
0025-Man-pages-update-with-DOMAIN-line-description.patch
0026-added-path-path_id-to-give-the-information-on-the-pa.patch
0027-extension-of-IncrementalRemove-to-store-location-por.patch
0028-update-udev-rules-to-support-path-parameter-with-rem.patch
0029-update-for-early-rules-to-support-grab.patch
0030-Incremental-for-bare-disks-checking-routine-integrat.patch
0031-Fix-problem-in-mdmon-monitor-of-using-removed-disk-f.patch
0032-Fix-the-count-of-member-devices-in-mdstat_read-funct.patch
0033-Try-exclusive-open-on-a-spare-device-before-it-is-ad.patch
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

