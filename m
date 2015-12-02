From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 00/17] mdadm: SCSI enclosure based array
Date: Tue, 1 Dec 2015 16:25:16 -0800
Message-ID: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, dan.j.williams@intel.com, shli@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

These patches by Dan Williams enable creating RAID array based on
SCSI enclosures.

mdadm gets information about SCSI enclosure through ses module in
kernel, and creates array for HDDs in an enclosure.

New udev rules are added to make drive swap in the enclosure based
array easier.

Typical array create flow looks like:

  /* examine enclosures in the system */
  mdadm --detail-platform --brief --enclosure > /etc/mdadm.conf

  /* create policy for enclosure0 and enclosure1 */
  echo "POLICY domain=domain0 action=spare slot=enclosure0" >> /etc/mdadm.conf
  echo "POLICY domain=domain1 action=spare slot=enclosure1" >> /etc/mdadm.conf

  /* add md-ses program */
  echo "PROGRAM /usr/share/mdadm/md-ses" >> /etc/mdadm.conf

  /* create md0 and md1 */
  mdadm --create /dev/md0 enclosure0 -n 15 -l 6 -e 1.2 -c 1024 --run
  mdadm --create /dev/md1 enclosure1 -n 15 -l 6 -e 1.2 -c 1024 --run

  /* add array to mdadm.conf */
  mdadm -Eb enclosure0 enclosure1 >> /etc/mdadm.conf

  /* create udev rules that add drives to array */
  mdadm --udev-rules --enclosure > /lib/udev/rules.d/65-md-raid-hotswap.rules

Dan Williams (15):
  udev rules and infrastructure for /dev/disk/by-slot
  mdadm: allow a /dev/disk/by-slot as domain path descriptor
  'act_spare' should be the minimum requirement for dynamic domains
  fix variable offset when ':' is present in the device name
  imsm: quiet detail platform
  ses: workaround sysfs deprecated
  prepare for enclosure platform details
  enclosure detection/enumeration
  Add --brief support to --enclosure
  config: ENCLOSURE keyword and enclosure device list expansion
  policy: enable enclosure names for domain definitions
  invoke hot-add policy on "change" events
  Toggle enclosure leds in response to raid events
  scsi mode sense/select support
  SCSIMODE: configuration file support for mode page settings.

Song Liu (2):
  Clear MBR in when Kill superblock
  In generated udev rules, skip RAID members

 Create.c                            |  10 +-
 Detail.c                            |  63 +++----
 Incremental.c                       |   9 +
 Kill.c                              |  22 +++
 Makefile                            |  31 +++-
 Monitor.c                           |   3 +
 ReadMe.c                            |   2 +
 config.c                            | 281 +++++++++++++++++++++++++++-
 contrib/md-ses                      | 310 +++++++++++++++++++++++++++++++
 enclosure.c                         | 355 ++++++++++++++++++++++++++++++++++++
 forward-scsi-uevents                |  14 ++
 mdadm.c                             |  99 +++++++---
 mdadm.h                             |  31 +++-
 policy.c                            | 116 +++++++++---
 ses_slot_id                         | 144 +++++++++++++++
 sg_io.c                             | 170 ++++++++++++++++-
 sg_io.h                             |  27 +++
 super-intel.c                       |  29 ++-
 sysfs.c                             |  11 +-
 udev-enclosure-slot.rules.in        |  11 ++
 udev-workaround-sysfs-deprecated.in |   2 +
 util.c                              |   7 +
 22 files changed, 1648 insertions(+), 99 deletions(-)
 create mode 100755 contrib/md-ses
 create mode 100644 enclosure.c
 create mode 100755 forward-scsi-uevents
 create mode 100755 ses_slot_id
 create mode 100644 sg_io.h
 create mode 100644 udev-enclosure-slot.rules.in
 create mode 100644 udev-workaround-sysfs-deprecated.in

--
2.4.6
