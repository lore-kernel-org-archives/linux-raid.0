From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [AUTOREBUILD 0/8] Autorebuild monitor patches based on user defined
 policy
Date: Fri, 1 Oct 2010 13:36:48 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D171D09950@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From f423b226f10cfe3b416c5e0580dde45cd8ca887d Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Wed, 29 Sep 2010 06:12:38 +0200
Subject: [AUTOREBUILD 0/8] Autorebuild monitor patches based on user defined policy

This is updated series of patches forming autorebuild functionality in mdadm 
monitor based on new policy code.

Autorebuild Monitoring application:
Autorebuild monitor is part of monitor application (mdadm -F). In the current
code of mdadm monitor autorebuild feature was based on spare group assignment in
mdadm.conf file and worked only for native metadata. 
The new autorebuild implementation works for all metadata types. It uses 
the concept of domains in mdadm.conf introduced by Neil Brown. 
Monitoring application shall periodically check the state of MD active arrays
and trigger a rebuild if there are eligible spare disks in other containers.
Degraded arrays are checked one by one. For each array a potential spare disk
is searched. If the spare disk matches the domain of the degraded array and
the domain action allows for spare sharing the spare is moved using existing
Manage_subdevs function. If the addition fails, the spare device is moved back
to the original container and next potential spare is tried. The process is 
repeated until all arrays are checked and the process is put into a sleep state
for a configured period.

The design of mdadm monitor requires that there is only one autorebuild process running.
Therefore a new option -no-sharing has been added to Monitor mode, and spare sharing is
allowed in only one instance of Monitor. User is still able to start Monitoring functions
in multiple instances.

The autorebuild build-in assumptions are:
1\spares are shared between the arrays of the same metadata
2\spares are moved only from containers/volumes that are not degraded
3\spares are moved to containers/volumes lacking a *good* spare (size)


0001-Monitor-set-err-on-arrays-not-in-mdstat.patch
0002-Monitor-removed-spare-group-based-spare-sharing-code.patch
0003-mdadm-added-no-sharing-parameter-for-Monitor-mode.patch
0004-Monitor-link-container-volumes-in-statelist.patch
0005-imsm-create-mdinfo-list-of-disks-in-a-container-from.patch
0006-Monitor-autorebuild-funcionality-added.patch
0007-Monitor-Respect-policy-in-auto-rebuild-in-mdadm-moni.patch
0008-Monitor-Helper-functions-added-for-spare_sharing-in-.patch


 Monitor.c     |  605 +++++++++++++++++++++++++++++++++++++++++++++++----------
 ReadMe.c      |    2 +
 mdadm.c       |    8 +-
 mdadm.h       |    8 +-
 super-intel.c |   53 +++++
 5 files changed, 565 insertions(+), 111 deletions(-)


