Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE58BC43334
	for <linux-raid@archiver.kernel.org>; Thu,  7 Jul 2022 13:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235463AbiGGNlH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Jul 2022 09:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234799AbiGGNlG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 7 Jul 2022 09:41:06 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AA118349
        for <linux-raid@vger.kernel.org>; Thu,  7 Jul 2022 06:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657201262; x=1688737262;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KmKKXfez0xd1c6wpBf17VGcyJ6B2YtTsnh8/qP7kVbw=;
  b=iXF/FMHWQS7f6YUq2EZRXC22uQ/dzee0K2jTJrWMQaGD9QoSvwlsmHlz
   HTtHSAoDqIjPKRj1evqL77AaLcIdUq3N2g0CrK53wDW9yfjlOtOts2wXi
   5pzBpeN0EkN6zopmRwccJgwjXvbZN9ALLS5/VPToINzrER30tSqs9eLPO
   4ryRSNHkF+koaszm2OzXzf6opZZ0QGA0p4oXyoN1NzeUmVBiZ9v6McQKz
   z1DGz4YRsU3vnQ2C6yXKMMS8fQjbL6W00lGF5mkx7mkvPdcJqsSRyBea4
   s+slw1XmgLUy1FAgBYcHfpJ2DiF3KdVi6GEhEFZkAGLWywkE5U6cf0ZXJ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="267055600"
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="267055600"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 06:41:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="920593243"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.57])
  by fmsmga005.fm.intel.com with ESMTP; 07 Jul 2022 06:40:59 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH] mdadm: Correct typos, punctuation and grammar in man
Date:   Thu,  7 Jul 2022 15:26:20 +0200
Message-Id: <20220707132620.28668-1-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 mdadm.8.in | 142 ++++++++++++++++++++++++++---------------------------
 1 file changed, 71 insertions(+), 71 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 0be02e4a..b9977d89 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -158,7 +158,7 @@ adding new spares and removing faulty devices.
 .B Misc
 This is an 'everything else' mode that supports operations on active
 arrays, operations on component devices such as erasing old superblocks, and
-information gathering operations.
+information-gathering operations.
 .\"This mode allows operations on independent devices such as examine MD
 .\"superblocks, erasing old superblocks and stopping active arrays.
 
@@ -231,12 +231,12 @@ mode to be assumed.
 
 .TP
 .BR \-h ", " \-\-help
-Display general help message or, after one of the above options, a
+Display a general help message or, after one of the above options, a
 mode-specific help message.
 
 .TP
 .B \-\-help\-options
-Display more detailed help about command line parsing and some commonly
+Display more detailed help about command-line parsing and some commonly
 used options.
 
 .TP
@@ -266,7 +266,7 @@ the exact meaning of this option in different contexts.
 
 .TP
 .BR \-c ", " \-\-config=
-Specify the config file or directory.  If not specified, default config file
+Specify the config file or directory.  If not specified, the default config file
 and default conf.d directory will be used.  See
 .BR mdadm.conf (5)
 for more details.
@@ -345,8 +345,8 @@ last partition, if that partition starts on a 64K boundary.
 .el
 .IP "1, 1.0, 1.1, 1.2 default"
 Use the new version-1 format superblock.  This has fewer restrictions.
-It can easily be moved between hosts with different endian-ness, and a
-recovery operation can be checkpointed and restarted.  The different
+It can easily be moved between hosts with different endian-ness, and during a
+recovery operation checkpoint can be made, and recovery can be restarted. The different
 sub-versions store the superblock at different locations on the
 device, either at the end (for 1.0), at the start (for 1.1) or 4K from
 the start (for 1.2).  "1" is equivalent to "1.2" (the commonly
@@ -379,7 +379,7 @@ When creating an array, the
 .B homehost
 will be recorded in the metadata.  For version-1 superblocks, it will
 be prefixed to the array name.  For version-0.90 superblocks, part of
-the SHA1 hash of the hostname will be stored in the later half of the
+the SHA1 hash of the hostname will be stored in the latter half of the
 UUID.
 
 When reporting information about an array, any array which is tagged
@@ -403,7 +403,7 @@ When
 .I mdadm
 needs to print the name for a device it normally finds the name in
 .B /dev
-which refers to the device and is shortest.  When a path component is
+which refers to the device and is the shortest.  When a path component is
 given with
 .B \-\-prefer
 .I mdadm
@@ -478,9 +478,9 @@ still be larger than any replacement.
 
 This option can be used with
 .B \-\-create
-for determining initial size of an array. For external metadata,
+for determining the initial size of an array. For external metadata,
 it can be used on a volume, but not on a container itself.
-Setting initial size of
+Setting the initial size of
 .B RAID 0
 array is only valid for external metadata.
 
@@ -551,14 +551,14 @@ default when building an array with no persistent metadata is 64KB.
 This is only meaningful for RAID0, RAID4, RAID5, RAID6, and RAID10.
 
 RAID4, RAID5, RAID6, and RAID10 require the chunk size to be a power
-of 2.  In any case it must be a multiple of 4KB.
+of 2.  In any case, it must be a multiple of 4KB.
 
 A suffix of 'K', 'M', 'G' or 'T' can be given to indicate Kilobytes,
 Megabytes, Gigabytes or Terabytes respectively.
 
 .TP
 .BR \-\-rounding=
-Specify rounding factor for a Linear array.  The size of each
+Specify the rounding factor for a Linear array.  The size of each
 component will be rounded down to a multiple of this size.
 This is a synonym for
 .B \-\-chunk
@@ -673,7 +673,7 @@ signals 'far' copies
 (multiple copies have very different offsets).
 See md(4) for more detail about 'near', 'offset', and 'far'.
 
-The number is the number of copies of each datablock.  2 is normal, 3
+The number is the number of copies of each data block.  2 is normal, 3
 can be useful.  This number can be at most equal to the number of
 devices in the array.  It does not need to divide evenly into that
 number (e.g. it is perfectly legal to have an 'n2' layout for an array
@@ -684,7 +684,7 @@ A bug introduced in Linux 3.14 means that RAID0 arrays
 started using a different layout.  This could lead to
 data corruption.  Since Linux 5.4 (and various stable releases that received
 backports), the kernel will not accept such an array unless
-a layout is explictly set.  It can be set to
+a layout is explicitly set.  It can be set to
 .RB ' original '
 or
 .RB ' alternate '.
@@ -760,13 +760,13 @@ or by selecting a different consistency policy with
 
 .TP
 .BR \-\-bitmap\-chunk=
-Set the chunksize of the bitmap.  Each bit corresponds to that many
+Set the chunk size of the bitmap.  Each bit corresponds to that many
 Kilobytes of storage.
-When using a file based bitmap, the default is to use the smallest
-size that is at-least 4 and requires no more than 2^21 chunks.
+When using a file-based bitmap, the default is to use the smallest
+size that is at least 4 and requires no more than 2^21 chunks.
 When using an
 .B internal
-bitmap, the chunksize defaults to 64Meg, or larger if necessary to
+bitmap, the chunk size defaults to 64Meg, or larger if necessary to
 fit the bitmap into the available space.
 
 A suffix of 'K', 'M', 'G' or 'T' can be given to indicate Kilobytes,
@@ -840,7 +840,7 @@ can be used with that command to avoid the automatic resync.
 .BR \-\-backup\-file=
 This is needed when
 .B \-\-grow
-is used to increase the number of raid-devices in a RAID5 or RAID6 if
+is used to increase the number of raid devices in a RAID5 or RAID6 if
 there are no spare devices available, or to shrink, change RAID level
 or layout.  See the GROW MODE section below on RAID\-DEVICES CHANGES.
 The file must be stored on a separate device, not on the RAID array
@@ -879,7 +879,7 @@ When creating an array,
 .B \-\-data\-offset
 can be specified as
 .BR variable .
-In the case each member device is expected to have a offset appended
+In the case each member device is expected to have an offset appended
 to the name, separated by a colon.  This makes it possible to recreate
 exactly an array which has varying data offsets (as can happen when
 different versions of
@@ -943,7 +943,7 @@ Insist that
 .I mdadm
 accept the geometry and layout specified without question.  Normally
 .I mdadm
-will not allow creation of an array with only one device, and will try
+will not allow the creation of an array with only one device, and will try
 to create a RAID5 array with one missing drive (as this makes the
 initial resync work faster).  With
 .BR \-\-force ,
@@ -1004,7 +1004,7 @@ number added, e.g.
 If the md device name is in a 'standard' format as described in DEVICE
 NAMES, then it will be created, if necessary, with the appropriate
 device number based on that name.  If the device name is not in one of these
-formats, then a unused device number will be allocated.  The device
+formats, then an unused device number will be allocated.  The device
 number will be considered unused if there is no active array for that
 number, and there is no entry in /dev for that number and with a
 non-standard name.  Names that are not in 'standard' format are only
@@ -1032,21 +1032,21 @@ then
 .B \-\-add
 can be used to add some extra devices to be included in the array.
 In most cases this is not needed as the extra devices can be added as
-spares first, and then the number of raid-disks can be changed.
-However for RAID0, it is not possible to add spares.  So to increase
+spares first, and then the number of raid disks can be changed.
+However, for RAID0 it is not possible to add spares.  So to increase
 the number of devices in a RAID0, it is necessary to set the new
 number of devices, and to add the new devices, in the same command.
 
 .TP
 .BR \-\-nodes
-Only works when the array is for clustered environment. It specifies
+Only works when the array is for the clustered environment. It specifies
 the maximum number of nodes in the cluster that will use this device
 simultaneously. If not specified, this defaults to 4.
 
 .TP
 .BR \-\-write-journal
 Specify journal device for the RAID-4/5/6 array. The journal device
-should be a SSD with reasonable lifetime.
+should be an SSD with a reasonable lifetime.
 
 .TP
 .BR \-\-symlinks
@@ -1055,15 +1055,15 @@ be 'no' or 'yes' and work with --create and --build.
 
 .TP
 .BR \-k ", " \-\-consistency\-policy=
-Specify how the array maintains consistency in case of unexpected shutdown.
+Specify how the array maintains consistency in case of an unexpected shutdown.
 Only relevant for RAID levels with redundancy.
-Currently supported options are:
+Currently, supported options are:
 .RS
 
 .TP
 .B resync
 Full resync is performed and all redundancy is regenerated when the array is
-started after unclean shutdown.
+started after an unclean shutdown.
 
 .TP
 .B bitmap
@@ -1072,8 +1072,8 @@ Resync assisted by a write-intent bitmap. Implicitly selected when using
 
 .TP
 .B journal
-For RAID levels 4/5/6, journal device is used to log transactions and replay
-after unclean shutdown. Implicitly selected when using
+For RAID levels 4/5/6, the journal device is used to log transactions and replay
+after an unclean shutdown. Implicitly selected when using
 .BR \-\-write\-journal .
 
 .TP
@@ -1241,8 +1241,8 @@ This can be useful if
 .B \-\-examine
 reports a different "Preferred Minor" to
 .BR \-\-detail .
-In some cases this update will be performed automatically
-by the kernel driver.  In particular the update happens automatically
+In some cases, this update will be performed automatically
+by the kernel driver.  In particular, the update happens automatically
 at the first write to an array with redundancy (RAID level 1 or
 greater) on a 2.6 (or later) kernel.
 
@@ -1282,7 +1282,7 @@ For version-1 superblocks, this involves updating the name.
 The
 .B home\-cluster
 option will change the cluster name as recorded in the superblock and
-bitmap. This option only works for clustered environment.
+bitmap. This option only works for the clustered environment.
 
 The
 .B resync
@@ -1319,7 +1319,7 @@ useful when the component device has changed size (typically become
 larger).  The version 1 metadata records the amount of the device that
 can be used to store data, so if a device in a version 1.1 or 1.2
 array becomes larger, the metadata will still be visible, but the
-extra space will not.  In this case it might be useful to assemble the
+extra space will not.  In this case, it might be useful to assemble the
 array with
 .BR \-\-update=devicesize .
 This will cause
@@ -1395,8 +1395,8 @@ This option should be used with great caution.
 
 .TP
 .BR \-\-freeze\-reshape
-Option is intended to be used in start-up scripts during initrd boot phase.
-When array under reshape is assembled during initrd phase, this option
+Option is intended to be used in start-up scripts during the initrd boot phase.
+When the array under reshape is assembled during the initrd phase, this option
 stops reshape after reshape critical section is being restored. This happens
 before file system pivot operation and avoids loss of file system context.
 Losing file system context would cause reshape to be broken.
@@ -1446,9 +1446,9 @@ re\-add a device that was previously removed from an array.
 If the metadata on the device reports that it is a member of the
 array, and the slot that it used is still vacant, then the device will
 be added back to the array in the same position.  This will normally
-cause the data for that device to be recovered.  However based on the
+cause the data for that device to be recovered.  However, based on the
 event count on the device, the recovery may only require sections that
-are flagged a write-intent bitmap to be recovered or may not require
+are flagged as a write-intent bitmap to be recovered or may not require
 any recovery at all.
 
 When used on an array that has no metadata (i.e. it was built with
@@ -1489,7 +1489,7 @@ Add a device as a spare.  This is similar to
 except that it does not attempt
 .B \-\-re\-add
 first.  The device will be added as a spare even if it looks like it
-could be an recent member of the array.
+could be a recent member of the array.
 
 .TP
 .BR \-r ", " \-\-remove
@@ -1506,12 +1506,12 @@ and names like
 .B set-A
 can be given to
 .BR \-\-remove .
-The first causes all failed device to be removed.  The second causes
+The first causes all failed devices to be removed.  The second causes
 any device which is no longer connected to the system (i.e an 'open'
 returns
 .BR ENXIO )
 to be removed.
-The third will remove a set as describe below under
+The third will remove a set as described below under
 .BR \-\-fail .
 
 .TP
@@ -1528,7 +1528,7 @@ For RAID10 arrays where the number of copies evenly divides the number
 of devices, the devices can be conceptually divided into sets where
 each set contains a single complete copy of the data on the array.
 Sometimes a RAID10 array will be configured so that these sets are on
-separate controllers.  In this case all the devices in one set can be
+separate controllers.  In this case, all the devices in one set can be
 failed by giving a name like
 .B set\-A
 or
@@ -1560,7 +1560,7 @@ devices.  The devices listed after
 .B \-\-with
 will be preferentially used to replace the devices listed after
 .BR \-\-replace .
-These device must already be spare devices in the array.
+These devices must already be spare devices in the array.
 
 .TP
 .BR \-\-write\-mostly
@@ -1584,7 +1584,7 @@ the device is found or <slot>:missing in case the device is not found.
 .TP
 .BR \-\-add-journal
 Add journal to an existing array, or recreate journal for RAID-4/5/6 array
-that lost a journal device. To avoid interrupting on-going write opertions,
+that lost a journal device. To avoid interrupting ongoing write operations,
 .B \-\-add-journal
 only works for array in Read-Only state.
 
@@ -1643,7 +1643,7 @@ Print details of the platform's RAID capabilities (firmware / hardware
 topology) for a given metadata format. If used without argument, mdadm
 will scan all controllers looking for their capabilities. Otherwise, mdadm
 will only look at the controller specified by the argument in form of an
-absolute filepath or a link, e.g.
+absolute file path or a link, e.g.
 .IR /sys/devices/pci0000:00/0000:00:1f.2 .
 
 .TP
@@ -1752,7 +1752,7 @@ doesn't appear to be valid.
 
 .B Note:
 Be careful to call \-\-zero\-superblock with clustered raid, make sure
-array isn't used or assembled in other cluster node before execute it.
+the array isn't used or assembled in another cluster node before executing it.
 
 .TP
 .B \-\-kill\-subarray=
@@ -1799,7 +1799,7 @@ For each md device given, or each device in /proc/mdstat if
 is given, arrange for the array to be marked clean as soon as possible.
 .I mdadm
 will return with success if the array uses external metadata and we
-successfully waited.  For native arrays this returns immediately as the
+successfully waited.  For native arrays, this returns immediately as the
 kernel handles dirty-clean transitions at shutdown.  No action is taken
 if safe-mode handling is disabled.
 
@@ -1970,7 +1970,7 @@ Usage:
 .PP
 This usage assembles one or more RAID arrays from pre-existing components.
 For each array, mdadm needs to know the md device, the identity of the
-array, and a number of component-devices.  These can be found in a number of ways.
+array, and a number of component devices.  These can be found in a number of ways.
 
 In the first usage example (without the
 .BR \-\-scan )
@@ -2010,7 +2010,7 @@ The config file is only used if explicitly named with
 .B \-\-config
 or requested with (a possibly implicit)
 .BR \-\-scan .
-In the later case, default config file is used.  See
+In the latter case, the default config file is used.  See
 .BR mdadm.conf (5)
 for more details.
 
@@ -2051,11 +2051,11 @@ itself.
 In Linux kernels prior to version 2.6.28 there were two distinctly
 different types of md devices that could be created: one that could be
 partitioned using standard partitioning tools and one that could not.
-Since 2.6.28 that distinction is no longer relevant as both type of
+Since 2.6.28 that distinction is no longer relevant as both types of
 devices can be partitioned.
 .I mdadm
 will normally create the type that originally could not be partitioned
-as it has a well defined major number (9).
+as it has a well-defined major number (9).
 
 Prior to 2.6.28, it is important that mdadm chooses the correct type
 of array device to use.  This can be controlled with the
@@ -2102,7 +2102,7 @@ an array, and if the superblock is tagged as belonging to the given
 home host, it will automatically choose a device name and try to
 assemble the array.  If the array uses version-0.90 metadata, then the
 .B minor
-number as recorded in the superblock is used to create a name in
+number, as recorded in the superblock, is used to create a name in
 .B /dev/md/
 so for example
 .BR /dev/md/3 .
@@ -2134,8 +2134,8 @@ for further details.
 Note: Auto assembly cannot be used for assembling and activating some
 arrays which are undergoing reshape.  In particular as the
 .B backup\-file
-cannot be given, any reshape which requires a backup-file to continue
-cannot be started by auto assembly.  An array which is growing to more
+cannot be given, any reshape which requires a backup file to continue
+cannot be started by the auto assembly.  An array which is growing to more
 devices and has passed the critical section can be assembled using
 auto-assembly.
 
@@ -2242,7 +2242,7 @@ When creating a partition based array, using
 .I mdadm
 with version-1.x metadata, the partition type should be set to
 .B 0xDA
-(non fs-data).  This type selection allows for greater precision since
+(non fs-data).  This type of selection allows for greater precision since
 using any other [RAID auto-detect (0xFD) or a GNU/Linux partition (0x83)],
 might create problems in the event of array recovery through a live cdrom.
 
@@ -2258,7 +2258,7 @@ when creating a v0.90 array will silently override any
 setting.
 .\"If the
 .\".B \-\-size
-.\"option is given, it is not necessary to list any component-devices in this command.
+.\"option is given, it is not necessary to list any component devices in this command.
 .\"They can be added later, before a
 .\".B \-\-run.
 .\"If no
@@ -2272,7 +2272,7 @@ requested with the
 .B \-\-bitmap
 option or a different consistency policy is selected with the
 .B \-\-consistency\-policy
-option. In any case space for a bitmap will be reserved so that one
+option. In any case, space for a bitmap will be reserved so that one
 can be added later with
 .BR "\-\-grow \-\-bitmap=internal" .
 
@@ -2322,7 +2322,7 @@ will firstly mark
 as faulty in
 .B /dev/md0
 and will then remove it from the array and finally add it back
-in as a spare.  However only one md array can be affected by a single
+in as a spare.  However, only one md array can be affected by a single
 command.
 
 When a device is added to an active array, mdadm checks to see if it
@@ -2468,13 +2468,13 @@ If the device contains RAID metadata, a file will be created in the
 .I directory
 and the metadata will be written to it.  The file will be the same
 size as the device and have the metadata written in the file at the
-same locate that it exists in the device.  However the file will be "sparse" so
+same locate that it exists in the device.  However, the file will be "sparse" so
 that only those blocks containing metadata will be allocated. The
 total space used will be small.
 
-The file name used in the
+The filename used in the
 .I directory
-will be the base name of the device.   Further if any links appear in
+will be the base name of the device.   Further, if any links appear in
 .I /dev/disk/by-id
 which point to the device, then hard links to the file will be created
 in
@@ -2494,7 +2494,7 @@ This is the reverse of
 will locate a file in the directory that has a name appropriate for
 the given device and will restore metadata from it.  Names that match
 .I /dev/disk/by-id
-names are preferred, however if two of those refer to different files,
+names are preferred. However, if two of those refer to different files,
 .I mdadm
 will not choose between them but will abort the operation.
 
@@ -2576,7 +2576,7 @@ and if the destination array has a failed drive but no spares.
 
 If any devices are listed on the command line,
 .I mdadm
-will only monitor those devices.  Otherwise all arrays listed in the
+will only monitor those devices.  Otherwise, all arrays listed in the
 configuration file will be monitored.  Further, if
 .B \-\-scan
 is given, then any other md devices that appear in
@@ -2633,10 +2633,10 @@ check, repair). (syslog priority: Warning)
 .BI Rebuild NN
 Where
 .I NN
-is a two-digit number (ie. 05, 48). This indicates that rebuild
+is a two-digit number (ie. 05, 48). This indicates that the rebuild
 has passed that many percent of the total. The events are generated
 with fixed increment since 0. Increment size may be specified with
-a commandline option (default is 20). (syslog priority: Warning)
+a command-line option (default is 20). (syslog priority: Warning)
 
 .TP
 .B RebuildFinished
@@ -2744,7 +2744,7 @@ When
 detects that an array in a spare group has fewer active
 devices than necessary for the complete array, and has no spare
 devices, it will look for another array in the same spare group that
-has a full complement of working drive and a spare.  It will then
+has a full complement of a working drive and a spare.  It will then
 attempt to remove the spare from the second drive and add it to the
 first.
 If the removal succeeds but the adding fails, then it is added back to
@@ -2762,7 +2762,7 @@ array.
 For this to work, the kernel must support the necessary change.
 Various types of growth are being added during 2.6 development.
 
-Currently the supported changes include
+Currently, the supported changes include
 .IP \(bu 4
 change the "size" attribute for RAID1, RAID4, RAID5 and RAID6.
 .IP \(bu 4
@@ -2821,7 +2821,7 @@ after growing, or to reduce its size
 .B prior
 to shrinking the array.
 
-Also the size of an array cannot be changed while it has an active
+Also, the size of an array cannot be changed while it has an active
 bitmap.  If an array has a bitmap, it must be removed before the size
 can be changed. Once the change is complete a new bitmap can be created.
 
@@ -2901,7 +2901,7 @@ long time.  A
 is required.  If the array is not simultaneously being grown or
 shrunk, so that the array size will remain the same - for example,
 reshaping a 3-drive RAID5 into a 4-drive RAID6 - the backup file will
-be used not just for a "cricital section" but throughout the reshape
+be used not just for a "critical section" but throughout the reshape
 operation, as described below under LAYOUT CHANGES.
 
 .SS CHUNK-SIZE AND LAYOUT CHANGES
@@ -2919,7 +2919,7 @@ slowly.
 If the reshape is interrupted for any reason, this backup file must be
 made available to
 .B "mdadm --assemble"
-so the array can be reassembled.  Consequently the file cannot be
+so the array can be reassembled.  Consequently, the file cannot be
 stored on the device being reshaped.
 
 
-- 
2.26.2

