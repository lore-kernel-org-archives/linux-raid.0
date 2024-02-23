Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2BA224DF
	for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 14:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708699923; cv=none; b=nMpVver/ACZPLhK1yraGMy/x2vtdRbBhu7B6rb8mBUhroJackN2biBjpKOdCQr1Z8tDWfU2dfnoEWzBgGOvFEbVGwetfYShDAqqaCu595+Y74wHOIjpDjKG6tOl/Kr+XBzQ0iCpGtmyIuMXNP65z8zdEIOawHtTNAIaKeIVPc1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708699923; c=relaxed/simple;
	bh=VBpMSMYWHS/Ca+bj3uEpJ6zA3aWhw1iuaJHUqpm6GHM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tG2CDAXq8bsXwaVqCXHwcgllgQ+rSa/Lv5B6HWVINmJRFtY22QBEzuhzXzHEimbsgK8DHvJ+ifw/kvdBwiLfKVqvG+2F0oI+r0B0f6jJihmQ2o6OVOzaafYlXa67jZKlXpw50q970F3mCUiTRmtRzGjDxwyAoe5xRql9HP9yJIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KG0sd+BH; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KG0sd+BH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708699919; x=1740235919;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VBpMSMYWHS/Ca+bj3uEpJ6zA3aWhw1iuaJHUqpm6GHM=;
  b=KG0sd+BHln8odcQCxvV5G6qCWG5Oz1fw54FRdzxAmeHBRuKnL/WmPb5X
   ADTtz9qHSwMF+xc/iZC6wXnX2hn0sOq7OcTqYZ4OhYBg9RzD7kVl3vQEH
   RYBTTNDjZv8y74Kt9i5bu1nRwiYpzFBW6ySOjdTV8dnEMV3IjKSFDX4yR
   Ixg8R5RP8jAjolwDXUbgSIbWDhgoeSmokoeHXE3Va4ddLKt8cp62bfu/P
   HPdYGmh8WDhrjx5a/FlxS80qS082vfsegSYr1mxpf6Uie9iZ+cvmTNi+Q
   Kldt2073mxL4O1ytLLTRfRnfkhPbYhhCUv91znH14umkyHRlbEFMaI2ja
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10993"; a="20454898"
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="20454898"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 06:51:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="10495426"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 06:51:57 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 1/6] mdadm: remove ANNOUNCEs
Date: Fri, 23 Feb 2024 15:51:41 +0100
Message-Id: <20240223145146.3822-2-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240223145146.3822-1-mariusz.tkaczyk@linux.intel.com>
References: <20240223145146.3822-1-mariusz.tkaczyk@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Release stuff is not necessary in repository. Remove it.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 ANNOUNCE-3.0   |  98 ---------------------------------
 ANNOUNCE-3.0.1 |  22 --------
 ANNOUNCE-3.0.2 |  21 --------
 ANNOUNCE-3.0.3 |  29 ----------
 ANNOUNCE-3.1   |  33 ------------
 ANNOUNCE-3.1.1 |  39 --------------
 ANNOUNCE-3.1.2 |  46 ----------------
 ANNOUNCE-3.1.3 |  46 ----------------
 ANNOUNCE-3.1.4 |  37 -------------
 ANNOUNCE-3.1.5 |  42 ---------------
 ANNOUNCE-3.2   |  77 --------------------------
 ANNOUNCE-3.2.1 |  75 --------------------------
 ANNOUNCE-3.2.2 |  36 -------------
 ANNOUNCE-3.2.3 |  24 ---------
 ANNOUNCE-3.2.4 | 144 -------------------------------------------------
 ANNOUNCE-3.2.5 |  31 -----------
 ANNOUNCE-3.2.6 |  57 --------------------
 ANNOUNCE-3.3   |  63 ----------------------
 ANNOUNCE-3.3.1 |  23 --------
 ANNOUNCE-3.3.2 |  16 ------
 ANNOUNCE-3.3.3 |  18 -------
 ANNOUNCE-3.3.4 |  37 -------------
 ANNOUNCE-3.4   |  24 ---------
 ANNOUNCE-4.0   |  22 --------
 ANNOUNCE-4.1   |  16 ------
 ANNOUNCE-4.2   |  19 -------
 26 files changed, 1095 deletions(-)
 delete mode 100644 ANNOUNCE-3.0
 delete mode 100644 ANNOUNCE-3.0.1
 delete mode 100644 ANNOUNCE-3.0.2
 delete mode 100644 ANNOUNCE-3.0.3
 delete mode 100644 ANNOUNCE-3.1
 delete mode 100644 ANNOUNCE-3.1.1
 delete mode 100644 ANNOUNCE-3.1.2
 delete mode 100644 ANNOUNCE-3.1.3
 delete mode 100644 ANNOUNCE-3.1.4
 delete mode 100644 ANNOUNCE-3.1.5
 delete mode 100644 ANNOUNCE-3.2
 delete mode 100644 ANNOUNCE-3.2.1
 delete mode 100644 ANNOUNCE-3.2.2
 delete mode 100644 ANNOUNCE-3.2.3
 delete mode 100644 ANNOUNCE-3.2.4
 delete mode 100644 ANNOUNCE-3.2.5
 delete mode 100644 ANNOUNCE-3.2.6
 delete mode 100644 ANNOUNCE-3.3
 delete mode 100644 ANNOUNCE-3.3.1
 delete mode 100644 ANNOUNCE-3.3.2
 delete mode 100644 ANNOUNCE-3.3.3
 delete mode 100644 ANNOUNCE-3.3.4
 delete mode 100644 ANNOUNCE-3.4
 delete mode 100644 ANNOUNCE-4.0
 delete mode 100644 ANNOUNCE-4.1
 delete mode 100644 ANNOUNCE-4.2

diff --git a/ANNOUNCE-3.0 b/ANNOUNCE-3.0
deleted file mode 100644
index f2d4f8475506..000000000000
--- a/ANNOUNCE-3.0
+++ /dev/null
@@ -1,98 +0,0 @@
-Subject:  ANNOUNCE: mdadm 3.0 - A tool for managing Soft RAID under Linux
-
-I am pleased to (finally) announce the availability of
-   mdadm version 3.0
-
-It is available at the usual places:
-   countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://neil.brown.name/mdadm
-   http://neil.brown.name/git?p=mdadm
-
-
-This is a major new version and as such should be treated with some
-caution.  However it has seen substantial testing and is considerred
-to be ready for wide use.
-
-
-The significant change which justifies the new major version number is
-that mdadm can now handle metadata updates entirely in userspace.
-This allows mdadm to support metadata formats that the kernel knows
-nothing about.
-
-Currently two such metadata formats are supported:
-  - DDF  - The SNIA standard format
-  - Intel Matrix - The metadata used by recent Intel ICH controlers.
-
-Also the approach to device names has changed significantly.
-
-If udev is installed on the system, mdadm will not create any devices
-in /dev.  Rather it allows udev to manage those devices.  For this to work
-as expected, the included udev rules file should be installed.
-
-If udev is not installed, mdadm will still create devices and symlinks 
-as required, and will also remove them when the array is stopped.
-
-mdadm now requires all devices which do not have a standard name (mdX
-or md_dX) to live in the directory /dev/md/.  Names in this directory
-will always be created as symlinks back to the standard name in /dev.
-
-The man pages contain some information about the new externally managed
-metadata.  However see below for a more condensed overview.
-
-Externally managed metadata introduces the concept of a 'container'.
-A container is a collection of (normally) physical devices which have
-a common set of metadata.  A container is assembled as an md array, but
-is left 'inactive'.
-
-A container can contain one or more data arrays.  These are composed from
-slices (partitions?) of various devices in the container.
-
-For example, a 5 devices DDF set can container a RAID1 using the first
-half of two devices, a RAID0 using the first half of the remain 3 devices,
-and a RAID5 over thte second half of all 5 devices.
-
-A container can be created with
-
-   mdadm --create /dev/md0 -e ddf -n5 /dev/sd[abcde]
-
-or "-e imsm" to use the Intel Matrix Storage Manager.
-
-An array can be created within a container either by giving the
-container name and the only member:
-
-   mdadm -C /dev/md1 --level raid1 -n 2 /dev/md0
-
-or by listing the component devices
-
-   mdadm -C /dev/md2 --level raid0 -n 3 /dev/sd[cde]
-
-To assemble a container, it is easiest just to pass each device in turn to 
-mdadm -I
-
-  for i in /dev/sd[abcde]
-  do mdadm -I $i
-  done
-
-This will assemble the container and the components.
-
-Alternately the container can be assembled explicitly
-
-   mdadm -A /dev/md0 /dev/sd[abcde]
-
-Then the components can all be assembled with
-
-   mdadm -I /dev/md0
-
-For each container, mdadm will start a program called "mdmon" which will
-monitor the array and effect any metadata updates needed.  The array is
-initially assembled readonly. It is up to "mdmon" to mark the metadata 
-as 'dirty' and which the array to 'read-write'.
-
-The version 0.90 and 1.x metadata formats supported by previous
-versions for mdadm are still supported and the kernel still performs
-the same updates it use to.  The new 'mdmon' approach is only used for
-newly introduced metadata types.
-
-NeilBrown 2nd June 2009
diff --git a/ANNOUNCE-3.0.1 b/ANNOUNCE-3.0.1
deleted file mode 100644
index 91b44284b32e..000000000000
--- a/ANNOUNCE-3.0.1
+++ /dev/null
@@ -1,22 +0,0 @@
-Subject:  ANNOUNCE: mdadm 3.0.1 - A tool for managing Soft RAID under Linux
-
-I am pleased to announce the availability of
-   mdadm version 3.0.1
-
-It is available at the usual places:
-   countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://neil.brown.name/mdadm
-   http://neil.brown.name/git?p=mdadm
-
-
-This contains only minor bug fixes over 3.0.  If you are using
-3.0, you could consider upgrading.
-
-The brief change log is:
-   -    Fix various segfaults
-   -    Fixed for --examine with containers
-   -    Lots of other little fixes.
-
-NeilBrown 25th September 2009
diff --git a/ANNOUNCE-3.0.2 b/ANNOUNCE-3.0.2
deleted file mode 100644
index 93643d178e21..000000000000
--- a/ANNOUNCE-3.0.2
+++ /dev/null
@@ -1,21 +0,0 @@
-Subject:  ANNOUNCE: mdadm 3.0.2 - A tool for managing Soft RAID under Linux
-
-I am pleased to announce the availability of
-   mdadm version 3.0.2
-
-It is available at the usual places:
-   countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://neil.brown.name/mdadm
-   http://neil.brown.name/git?p=mdadm
-
-
-This just contains one bugfix over 3.0.1 - I was obviously a bit hasty
-in releasing that one.
-
-The brief change log is:
-   -    Fix crash when hosthost is not set, as often happens in
-	early boot.
-
-NeilBrown 25th September 2009
diff --git a/ANNOUNCE-3.0.3 b/ANNOUNCE-3.0.3
deleted file mode 100644
index d6117a1ddc29..000000000000
--- a/ANNOUNCE-3.0.3
+++ /dev/null
@@ -1,29 +0,0 @@
-Subject:  ANNOUNCE: mdadm 3.0.3 - A tool for managing Soft RAID under Linux
-
-I am pleased to announce the availability of
-   mdadm version 3.0.3
-
-It is available at the usual places:
-   countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://neil.brown.name/mdadm
-   http://neil.brown.name/git?p=mdadm
-
-
-This contains a collection of bug fixes and minor enhancements over
-3.0.1.
-
-The brief change log is:
-   -    Improvements for creating arrays giving just a name, like 'foo',
-	rather than the full '/dev/md/foo'.
-   -    Improvements for assembling member arrays of containers.
-   -    Improvements to test suite
-   -    Add option to change increment for RebuildNN messages reported
-	by "mdadm --monitor"
-   -    Improvements to mdmon 'hand-over' from initrd to final root.
-   -    Handle merging of devices that have left an IMSM array and are
-	being re-incorporated.
-   -    Add missing space in "--detail --brief" output.
-	
-NeilBrown 22nd October 2009
diff --git a/ANNOUNCE-3.1 b/ANNOUNCE-3.1
deleted file mode 100644
index 343b85da6274..000000000000
--- a/ANNOUNCE-3.1
+++ /dev/null
@@ -1,33 +0,0 @@
-Subject:  ANNOUNCE: mdadm 3.1 - A tool for managing Soft RAID under Linux
-
-Hot on the heals of 3.0.3 I am pleased to announce the availability of
-   mdadm version 3.1
-
-It is available at the usual places:
-   countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://neil.brown.name/mdadm
-   http://neil.brown.name/git?p=mdadm
-
-
-It contains significant feature enhancements over 3.0.x
-
-The brief change log is:
-   -    Support --grow to change the layout of RAID4/5/6
-   -    Support --grow to change the chunksize of raid 4/5/6
-   -    Support --grow to change level from RAID1 -> RAID5 -> RAID6 and
-        back.
-   -    Support --grow to reduce the number of devices in RAID4/5/6.
-   -    Support restart of these grow options which assembling an array 
-	which is partially grown.
-   -    Assorted tests of this code, and of different RAID6 layouts.
-
-Note that a 2.6.31 or later is needed to have access to these.
-Reducing devices in a RAID4/5/6 requires 2.6.32.
-Changing RAID5 to RAID1 requires 2.6.33.
-
-You should only upgrade if you need to use, or which to test, these
-features.
-	
-NeilBrown 22nd October 2009
diff --git a/ANNOUNCE-3.1.1 b/ANNOUNCE-3.1.1
deleted file mode 100644
index 9e480dc0e315..000000000000
--- a/ANNOUNCE-3.1.1
+++ /dev/null
@@ -1,39 +0,0 @@
-Subject:  ANNOUNCE: mdadm 3.1.1 - A tool for managing Soft RAID under Linux
-
-I am pleased to announce the availability of
-   mdadm version 3.1.1
-
-It is available at the usual places:
-   countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://neil.brown.name/mdadm
-   http://neil.brown.name/git?p=mdadm
-
-This is a bugfix release over 3.1, which was withdrawn due to serious
-bugs.  So it might be best to ignore 3.1 and say that this is a significant
-feature release over 3.0.x
-
-Significant changes are:
-  - RAID level conversion between RAID1, RAID5, and RAID6 are
-    possible were the kernel supports it (2.6.32 at least)
-  - online chunksize and layout changing for RAID5 and RAID6
-    where the kernel supports it.
-  - reduce the number of devices in a RAID4/5/6 array.
-
-  - The default metadata is not v1.1.  This metadata is stored at the
-    start of the device so is safer in many ways but could interfere with
-    boot loaded.  The old default (0.90) is still available and fully
-    supported.
-
-  - The default chunksize is now 512K rather than 64K.  This seems more
-    appropriate for modern devices.
-
-  - The default bitmap chunksize for internal bitmaps is now at least
-    64Meg as fine grained bitmaps tend to impact performance more for
-    little extra gain.
-
-This release is believed to be stable and you should feel free to
-upgrade to 3.1.1.
-
-NeilBrown 19th November 2009
diff --git a/ANNOUNCE-3.1.2 b/ANNOUNCE-3.1.2
deleted file mode 100644
index 321b8bef4fae..000000000000
--- a/ANNOUNCE-3.1.2
+++ /dev/null
@@ -1,46 +0,0 @@
-Subject:  ANNOUNCE: mdadm 3.1.2 - A tool for managing Soft RAID under Linux
-
-I am pleased to announce the availability of
-   mdadm version 3.1.2
-
-It is available at the usual places:
-   countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://neil.brown.name/mdadm
-   http://neil.brown.name/git?p=mdadm
-
-This is a bugfix/stability release over 3.1.1.
-
-Significant changes are:
-  - The default metadata has change again (sorry about that).
-    It is now v1.2 and will hopefully stay that way.  It turned
-    out there with boot-block issues with v1.1 which make it 
-    unsuitable for a default, though in many cases it is still
-    suitable to use.
-  - Stopping a container is not permitted when members are still
-    active
-  - Add 'homehost' to the valid words for the "AUTO" config file
-    line.  When followed by "-all", this causes mdadm to
-    auto-assemble any array belonging to this host, but not
-    auto-assemble anything else.
-  - Fix some bugs with "--grow --chunksize=" for changing chunksize.
-  - VAR_RUN can be easily changed at compile time just like ALT_RUN.
-    This gives distros more flexability in how to manage the
-    pid and sock files that mdmon needs.
-  - Various mdmon fixes
-  - Alway make bitmap 4K-aligned if at all possible.
-  - If mdadm.conf lists arrays which have inter-dependencies,
-    the previously had to be listed in the "right" order.  Now
-    any order should work.
-  - Fix --force assembly of v1.x arrays which are in the process
-    of recovering.
-  - Add section on 'scrubbing' to 'md' man page.
-  - Various command-line-option parsing improvements.
-  - ... and lots of other bug fixes.
-
-
-This release is believed to be stable and you should feel free to
-upgrade to 3.1.2
-
-NeilBrown 10th March 2010
diff --git a/ANNOUNCE-3.1.3 b/ANNOUNCE-3.1.3
deleted file mode 100644
index 95b2b6c1cf6d..000000000000
--- a/ANNOUNCE-3.1.3
+++ /dev/null
@@ -1,46 +0,0 @@
-Subject:  ANNOUNCE: mdadm 3.1.3 - A tool for managing Soft RAID under Linux
-
-I am pleased to announce the availability of
-   mdadm version 3.1.3
-
-It is available at the usual places:
-   countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://neil.brown.name/mdadm
-   http://neil.brown.name/git?p=mdadm
-
-This is a bugfix/stability release over 3.1.2
-
-Significant changes are:
-   -    mapfile now lives in a fixed location which default to
-        /dev/.mdadm/map but can be changed at compile time.  This
-	location is choses and most distros provide it during early
-	boot and preserve it through.  As long a /dev exists and is
-	writable, /dev/.mdadm will be created.
-	Other files file communication with mdmon live here too.
-	This fixes a bug reported by Debian and Gentoo users where
-	udev would spin in early-boot.
-   -    IMSM and DDF metadata will not be recognised on partitions
-        as they should only be used on whole-disks.
-   -    Various overflows causes by 2G drives have been addressed.
-   -    A subarray of an IMSM contain can now be killed with
-        --kill-subarray.  Also subarrays can be renamed with
-	--update-subarray
-   -    -If (or --incremental --fail) can be used  from udev to
-        fail and remove from all arrays a device which has been
-	unplugged from the system.  i.e. hot-unplug-support.
-   -    "mdadm /dev/mdX --re-add missing" will look for any device
-        that looks like it should be a member of /dev/mdX but isn't
-	and will automatically --re-add it
-   -    Now compile with -Wextra to get extra warnings.
-   -    Lots of minor bug fixes, documentation improvements, etcc
-
-This release is believed to be stable and you should feel free to
-upgrade to 3.1.3
-
-It is expected that the next release will be 3.2 with a number of new
-features.  3.1.4 will only happen if important bugs show up before 3.2
-is stable.
-
-NeilBrown 6th August 2010
diff --git a/ANNOUNCE-3.1.4 b/ANNOUNCE-3.1.4
deleted file mode 100644
index c157a36aa636..000000000000
--- a/ANNOUNCE-3.1.4
+++ /dev/null
@@ -1,37 +0,0 @@
-Subject:  ANNOUNCE: mdadm 3.1.4 - A tool for managing Soft RAID under Linux
-
-I am pleased to announce the availability of
-   mdadm version 3.1.4
-
-It is available at the usual places:
-   countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://neil.brown.name/mdadm
-   http://neil.brown.name/git?p=mdadm
-
-This is a bugfix/stability release over 3.1.3.
-3.1.3 had a couple of embarrasing regressions and a couple of other
-issues surfaces which had easy fixes so I decided to make a 3.1.4
-release after all.
-
-Two fixes related to configs that aren't using udev:
-   - Don't remove md devices which 'standard' names on --stop
-   - Allow dev_open to work on read-only /dev
-And fixed regressions:
-   - Allow --incremental to add spares to an array
-   - Accept --no-degraded as a deprecated option rather than
-            throwing an error
-   - Return correct success status when --incrmental assembling 
-     a container which does not yet have enough devices.
-   - Don't link mdadm with pthreads, only mdmon needs it.
-   - Fix compiler warning due to bad use of snprintf
-   - Fix spare migration
-
-This release is believed to be stable and you should feel free to
-upgrade to 3.1.4
-
-It is expected that the next release will be 3.2 with a number of new
-features.
-
-NeilBrown 31st August 2010
diff --git a/ANNOUNCE-3.1.5 b/ANNOUNCE-3.1.5
deleted file mode 100644
index baa1f9218b43..000000000000
--- a/ANNOUNCE-3.1.5
+++ /dev/null
@@ -1,42 +0,0 @@
-Subject:  ANNOUNCE: mdadm 3.1.5 - A tool for managing Soft RAID under Linux
-
-I am pleased to announce the availability of
-   mdadm version 3.1.5
-
-It is available at the usual places:
-   countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://neil.brown.name/mdadm
-   http://neil.brown.name/git?p=mdadm
-
-This is a bugfix/stability release over 3.1.4.  It contains all the
-important bugfixes found while working on 3.2 and 3.2.1.  It will be
-the last 3.1.x release - 3.2.1 is expected to be released in a few days.
-
-Changes include:
-  - Fixes for v1.x metadata on big-endian machines.
-  - man page improvements
-  - Improve '--detail --export' when run on partitions of an md array.
-  - Fix regression with removing 'failed' or 'detached' devices.
-  - Fixes for "--assemble --force" in various unusual cases.
-  - Allow '-Y' to mean --export.  This was documented but not implemented.
-  - Various fixed for handling 'ddf' metadata.  This is now more reliable
-    but could benefit from more interoperability testing.
-  - Correctly list subarrays of a container in "--detail" output.
-  - Improve checks on whether the requested number of devices is supported
-    by the metadata - both for --create and --grow.
-  - Don't remove partitions from a device that is being included in an
-    array until we are fully committed to including it.
-  - Allow "--assemble --update=no-bitmap" so an array with a corrupt
-    bitmap can still be assembled.
-  - Don't allow --add to succeed if it looks like a "--re-add" is probably
-    wanted, but cannot succeed.  This avoids inadvertently turning
-    devices into spares when an array is failed.
-
-This release is believed to be stable and you should feel free to
-upgrade to 3.1.5
-
-
-NeilBrown 23rd March 2011
-
diff --git a/ANNOUNCE-3.2 b/ANNOUNCE-3.2
deleted file mode 100644
index 9e282bc68e51..000000000000
--- a/ANNOUNCE-3.2
+++ /dev/null
@@ -1,77 +0,0 @@
-Subject:  ANNOUNCE: mdadm 3.2 - A tool for managing Soft RAID under Linux (DEVEL ONLY)
-
-I am pleased to announce the availability of
-   mdadm version 3.2
-
-It is available at the usual places:
-   countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://neil.brown.name/mdadm devel-3.2
-   http://neil.brown.name/git?p=mdadm
-
-This is a "Developers only" release.  Please don't consider using it
-or making it available to others without reading the following.
-
-
-By far the most significant change in this release related to the
-management of reshaping arrays.  This code has been substantially
-re-written so that it can work with 'externally managed metadata' -
-Intel's IMSM in particular.  We now support level migration and
-OnLine Capacity Expansion on these arrays.
-
-However, while the code largely works it has not been tested
-exhaustively so there are likely to be problems.  As the reshape code
-for native metadata arrays was changed as part of this rewrite these
-problems could also result in regressions for reshape of native
-metadata.
-
-It is partly to encourage greater testing that this release is being
-made.  Any reports of problem - particular reproducible recipes for
-triggering the problems - will be gratefully received.
-
-It is hopped that a "3.2.1" release will be available in early March
-which will be a bugfix release over this and can be considered
-suitable for general use.
-
-Other changes of note:
-
- - Policy framework.
-   Various policy statements can be made in the mdadm.conf to guide
-   the behaviour of mdadm, particular with regards to how new devices
-   are treated by "mdadm -I".
-   Depending on the 'action' associated with a device (identified by
-   its 'path') such need devices can be automatically re-added to and
-   existing array that they previously fell out off, or automatically
-   added as a spare if they appear to contain no data.
-
- - mdadm now has a limited understanding of partition tables.  This
-   allows the policy framework to make decisions about partitioned
-   devices as well.
-
- - --incremental --remove can be told what --path the device was on,
-   and this info will be recorded so that another device appearing at
-   the same physical location can be preferentially added to the same
-   array (provides the spare-same-slot action policy applied to the
-   path).
-
- - A new flags "--invalid-backup" flag is available in --assemble
-   mode.  This can be used to re-assemble an array which was stopping
-   in the middle of a reshape, and for which the 'backup file' is no
-   longer available or is corrupted.  The array may have some
-   corruption in it at the point where reshape was up to, but at least
-   the rest of the array will become available.
-   
-
- - Various internal restructuring - more is needed.
-
-
-Any feed back and bug reports are always welcomed at:
-    linux-raid@vger.kernel.org
-
-And please:  don't use this in production - particularly not the
---grow functionality.
-
-NeilBrown 1st February 2011
-
-
diff --git a/ANNOUNCE-3.2.1 b/ANNOUNCE-3.2.1
deleted file mode 100644
index 0e7826ca25f5..000000000000
--- a/ANNOUNCE-3.2.1
+++ /dev/null
@@ -1,75 +0,0 @@
-
-
-I am pleased to announce the availability of
-   mdadm version 3.2.1
-
-It is available at the usual places:
-   countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://neil.brown.name/mdadm
-   http://neil.brown.name/git/mdadm
-
-Many of the changes in this release are of internal interest only,
-restructuring and refactoring code and so forth.
-
-Most of the bugs found and fixed during development for 3.2.1 have been
-back-ported for the recently-release 3.1.5 so this release primarily
-provides a few new features over 3.1.5.
-
-They include:
-  - policy framework
-     Policy can be expressed for moving spare devices between arrays, and
-     for how to handle hot-plugged devices.  This policy can be different
-     for devices plugged in to different controllers etc.
-     This, for example, allows a configuration where when a device is plugged
-     in it is immediately included in an md array as a hot spare and
-     possibly starts recovery immediately if an array is degraded.
-
-  - some understanding of mbr and gpt paritition tables
-     This is primarly to support the new hot-plug support.  If a
-     device is plugged in and policy suggests it should have a partition table,
-     the partition table will be copied from a suitably similar device, and
-     then the partitions will hot-plug and can then be added to md arrays.
-
-  - "--incremental --remove" can remember where a device was removed from
-    so if a device gets plugged back in the same place, special policy applies
-    to it, allowing it to be included in an array even if a general hotplug
-    will not be included.
-
-  - enhanced reshape options, including growing a RAID0 by converting to RAID4,
-    restriping, and converting back.  Also convertions between RAID0 and
-    RAID10 and between RAID1 and RAID10 are possible (with a suitably recent
-    kernel).
-
-  - spare migration for IMSM arrays.
-     Spare migration can now work across 'containers' using non-native metadata
-     and specifically Intel's IMSM arrays support spare migrations.
-
-  - OLCE and level migration for Intel IMSM arrays.
-     OnLine Capacity Expansion and level migration (e.g. RAID0 -> RAID5) is
-     supported for Intel Matrix Storage Manager arrays.
-     This support is currently 'experimental' for technical reasons.  It can
-     be enabled with "export MDADM_EXPERIMENTAL=1"
-
-  - avoid including wayward devices
-     If you split a RAID1, mount the two halves as two separate degraded RAID1s,
-     and then later bring the two back together, it is possible that the md 
-     metadata won't properly show that one must over-ride the other.
-     mdadm now does extra checking to detect this possibilty and avoid
-     potentially corrupting data.
-
-  - remove any possible confusion between similar options.
-     e.g. --brief and --bitmap were mapped to 'b' and mdadm wouldn't
-     notice if one was used where the other was expected.
-
-  - allow K,M,G suffixes on chunk sizes
-
-
-While mdadm-3.2.1 is considered to be reasonably stable, you should
-only use it if you want to try out the new features, or if you
-generally like to be on the bleeding edge.   If the new features are not
-important to you, then 3.1.5 is probably the appropriate version to be using
-until 3.2.2 comes out.
-
-NeilBrown 28th March 2011
diff --git a/ANNOUNCE-3.2.2 b/ANNOUNCE-3.2.2
deleted file mode 100644
index b70d18b95bff..000000000000
--- a/ANNOUNCE-3.2.2
+++ /dev/null
@@ -1,36 +0,0 @@
-Subject:  ANNOUNCE: mdadm 3.2.2 - A tool for managing Soft RAID under Linux
-
-I am pleased to announce the availability of
-   mdadm version 3.2.2
-
-It is available at the usual places:
-   countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://neil.brown.name/mdadm
-   http://neil.brown.name/git/mdadm
-
-This release is largely a stablising release for the 3.2 series.
-Many of the changes just fix bugs introduces in 3.2 or 3.2.1.
-
-There are some new features.  They are:
-  - reshaping IMSM (Intel metadata) arrays is no longer 'experimental',
-    it should work properly and be largely compatible with IMSM drivers in
-    other platforms.
-  - --assume-clean can be used with --grow --size to avoid resyncing the
-    new part of the array.  This is only support with very new kernels.
-  - RAID0 arrays can have chunksize which is not a power of 2.  This has been
-    supported in the kernel for a while but is only now supprted by
-    mdadm.
-
-  - A new tool 'raid6check' is available which can check a RAID6 array,
-    or part of it, and report which device is most inconsistent with the
-    others if any stripe is inconsistent.   This is still under development
-    and does not have a man page yet.  If anyone tries it out and has any
-    questions or experience to report, they would be most welcome on
-    linux-raid@vger.kernel.org.
-
-Future releases in the 3.2 series will only be made if bugfixes are needed.
-The next release to add features is expected to be 3.3.
-
-NeilBrown 17th June 2011
diff --git a/ANNOUNCE-3.2.3 b/ANNOUNCE-3.2.3
deleted file mode 100644
index 8a8dba4661cd..000000000000
--- a/ANNOUNCE-3.2.3
+++ /dev/null
@@ -1,24 +0,0 @@
-Subject:  ANNOUNCE: mdadm 3.2.3 - A tool for managing Soft RAID under Linux
-
-I am pleased to announce the availability of
-   mdadm version 3.2.3
-
-It is available at the usual places:
-   countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://neil.brown.name/mdadm
-   http://neil.brown.name/git/mdadm
-
-This release is largely a bugfix release for the 3.2 series with many
-minor fixes with little or no impact.
-
-The largest single area of change is support for reshape of Intel
-IMSM arrays (OnLine Capacity Explansion and Level Migtration).
-Among other fixes, this now has a better chance of surviving if a
-device fails during reshape.
-
-Upgrading is recommended - particularly if you use mdadm for IMSM
-arrays - but not essential.
-
-NeilBrown 23rd December 2011
diff --git a/ANNOUNCE-3.2.4 b/ANNOUNCE-3.2.4
deleted file mode 100644
index e321678604c0..000000000000
--- a/ANNOUNCE-3.2.4
+++ /dev/null
@@ -1,144 +0,0 @@
-Subject:  ANNOUNCE: mdadm 3.2.4 - A tool for managing Soft RAID under Linux
-
-I am pleased to announce the availability of
-   mdadm version 3.2.4
-
-It is available at the usual places, now including github:
-   countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://github.com/neilbrown/mdadm
-   git://neil.brown.name/mdadm
-   http://neil.brown.name/git/mdadm
-
-This release is largely a bugfix release for the 3.2 series with many
-minor fixes with little or no impact.
-
-"--oneline" log of changes is below.  Some notable ones are:
-
- - --offroot argument to improve interactions between mdmon and initrd
- - --prefer argument to select which /dev names to display in some
-   circumstances.
- - relax restructions on when "--add" will be allowed
- - Fix bug with adding write-intent-bitmap to active array
- - Now defaults to "/run/mdadm" for storing run-time files.
-
-Upgrading is encouraged.
-
-The next mdadm release is expected to be 3.3 with a number of new
-features.
-
-NeilBrown 9th May 2012
-
-77b3ac8 monitor: make return from read_and_act more symbolic.
-68226a8 monitor: ensure we retry soon when 'remove' fails.
-8453f8d fix: Monitor sometimes crashes
-90fa1a2 Work around gcc-4.7's strict aliasing checks
-0c4304c fix: container creation with --incremental used.
-5d1c7cd FIX: External metadata sometimes is not updated
-3c20f98 FIX: mdmon check in reshape_container() can cause a problem
-59ab9f5 FIX: Typo error in fprint command
-9587c37 imsm: load_super_imsm_all function refactoring
-ec50f7b imsm: load_imsm_super_all supports loading metadata from the device list
-ca9de18 imsm: validate the number of imsm volumes per controller
-30602f5 imsm: display fd in error trace when when store_imsm_mpb failes
-eb155f6 mdmon: Use getopt_long() to parse command line options
-08ca2ad Add --offroot argument to mdadm
-da82751 Add --offroot argument to mdmon
-a0963a8 Spawn mdmon with --offroot if mdadm was launched with --offroot
-f878b24 imsm: fix, the second array need to have the whole available space on devices
-d597705 getinfo_super1: Use MaxSector in place of sb->size
-6ef8905 super1: make aread/awrite always use an aligned buffer.
-de5a472 Remove avail_disks arg from 'enough'.
-da8fe5a Assemble: fix --force assemble during reshape.
-b10c663 config: fix handing of 'homehost' in AUTO line.
-92d49ec FIX: NULL pointer to strdup() can be passed
-d2bde6d imsm: FIX: No new missing disks are allowed during general migration
-111e9fd FIX: Array is not run when expansion disks are added
-bf5cf7c imsm: FIX: imsm_get_allowed_degradation() doesn't count degradation for raid1
-50927b1 Fix: Sometimes mdmon throws core dump during reshape
-78340e2 Flush mdmon before next reshape step during container operation
-e174219 imsm: FIX: Chunk size migration problem
-f93346e FIX: use md position to reshape restart
-6a75c8c imsm: FIX: use md position to reshape restart
-51d83f5 imsm: FIX: Clear migration record when migration switches to next volume.
-e1dd332 FIX: restart reshape when reshape process is stopped just between 2 reshapes
-1ca90aa FIX: Do not try to (continue) reshape using inactive array
-9f1b0f0 config: conf_match should ignore devname when not set.
-d669228 Use posix_memalign() for memory used to write bitmaps
-178950e FIX: Changes in '0' case for reshape position verification
-9200d41 avoid double-free upon "old buggy kernel" sysfs_read failure
-4011421 Print error message if failing to write super for 1.x metadata
-0011874 Use MDMON_DIR for pid files created in Monitor.c
-56d1885 Assemble: don't use O_EXCL until we have checked device content.
-b720636 Assemble: support assembling of a RAID0 being reshaped.
-c69ffac Manage: allow --re-add to failed array.
-52f07f5 Reset bad flag on map update
-911cead super1: support superblocks up to 4K.
-ad6db3c Create: reduce the verbosity of 'default_layout'.
-b2bfdfa super1.c don't keep recalculating bitmap pointer
-4122675 Define and use SUPER1_SIZE for allocations
-1afa930 init_super1() memset full buffer allocated for superblock
-2de0b8a match_metadata_desc1(): Use calloc instead of malloc+memset
-3c0bcd4 Use 4K buffer alignment for superblock allocations
-308340a Use struct align_fd to cache fd's block size for aligned reads/writes
-65ed615 match_metadata_desc0(): Use calloc instead of malloc+memset
-de89706 Generalize ROUND_UP() macro and introduce matching ROUND_UP_PTR()
-0a2f189 super1.c: use ROUND_UP/ROUND_UP_PTR
-654a381 super-intel.c: Use ROUND_UP() instead of manually coding it
-42d5dfd __write_init_super_ddf(): Use posix_memalign() instead of static aligned buffer
-d4633e0 Examine: fix array size calculation for RAID10.
-e62b778 Assemble: improve verbose logging when including old devices.
-0073a6e Remove possible crash during RAID6 -> RAID5 reshape.
-69fe207 Incremental: fix adding devices with --incremental
-bcbb311 Manage: replace 'return 1' with 'goto abort'.
-9f58469 Manage: freeze recovery while adding multiple devices.
-ae6c05a Create: round off size for RAID1 arrays.
-5ca3a90 Grow: print useful error when converting RAID1->RAID5 will fail.
-c07d640 Fix tests/05r1-re-add-nosupper
-2d762ad Fix the new ROUND_UP macro.
-fd324b0 sysfs: fixed sysfs_freeze_array array to work properly with Manage_subdevs.
-5551b11 imsm: avoid overflows for disks over 1TB
-97f81ee clear hi bits if not used after loading metadata from disk
-e03640b simplify calculating array_blocks
-29cd082 show 2TB volumes/disks support in --detail-platform
-2cc699a check volume size in validate_geometry_imsm_orom
-9126b9a check that no disk over 2TB is used to create container when no support
-027c374 imsm: set 2tb disk attribute for spare
-3556c2f Fix typo: wan -> want
-15632a9 parse_size: distinguish between 0 and error.
-fbdef49 Bitmap_offset is a signed number
-508a7f1 super1: leave more space in front of data by default.
-40110b9 Fix two typos in fprintf messages
-342460c mdadm man page: fix typo
-0e7f69a imsm: display maximum volumes per controller and array
-36fd8cc imsm: FIX: Update function imsm_num_data_members() for Raid1/10
-7abc987 imsm: FIX: Add volume size expand support to imsm_analyze_change()
-f3871fd imsm: Add new metadata update for volume size expansion
-54397ed imsm: Execute size change for external metatdata
-016e00f FIX: Support metadata changes rollback
-fbf3d20 imsm: FIX: Support metadata changes rollback
-44f6f18 FIX: Extend size of raid0 array
-7e7e9a4 FIX: Respect metadata size limitations
-65a9798 FIX: Detect error and rollback metadata
-13bcac9 imsm: Add function imsm_get_free_size()
-b130333 imsm: Support setting max size for size change operation
-c41e00b imsm: FIX: Component size alignment check
-58d26a2 FIX: Size change is possible as standalone change only
-4aecb54 FIX: Assembled second array is in read only state during reshape
-ae2416e FIX: resolve make everything compilation error
-480f356 Raid limit of 1024 when scanning for devices.
-c2ecf5f Add --prefer option for --detail and --monitor
-0a99975 Relax restrictions on when --add is permitted.
-7ce0570 imsm: fix: rebuild does not continue after reboot
-b51702b fix: correct extending size of raid0 array
-34a1395 Fix sign extension of bitmap_offset in super1.c
-012a864 Introduce sysfs_set_num_signed() and use it to set bitmap/offset
-5d7b407 imsm: fix: thunderdome may drop 2tb attribute
-5ffdc2d Update test for "is udev active".
-96fd06e Adjust to new standard of /run
-974e039 test: don't worry too much about array size.
-b0a658f Grow: failing the set the per-device size is not an error.
-36614e9 super-intel.c: Don't try to close negative fd
-562aa10 super-intel.c: Fix resource leak from opendir()
-
diff --git a/ANNOUNCE-3.2.5 b/ANNOUNCE-3.2.5
deleted file mode 100644
index 396da12a6f61..000000000000
--- a/ANNOUNCE-3.2.5
+++ /dev/null
@@ -1,31 +0,0 @@
-Subject:  ANNOUNCE: mdadm 3.2.5 - A tool for managing Soft RAID under Linux
-
-I am somewhat disappointed to have to announce the availability of
-   mdadm version 3.2.5
-
-It is available at the usual places, now including github:
-   countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://github.com/neilbrown/mdadm
-   git://neil.brown.name/mdadm
-   http://neil.brown.name/git/mdadm
-
-This release primarily fixes a serious regression in 3.2.4.
-This regression does *not* cause any risk to data.  It simply
-means that adding a device with "--add" would sometime fail
-when it should not.
-
-The fix also includes a couple of minor fixes such as making
-the "--layout=preserve" option to "--grow" work again.
-
-A reminder that the default location for runtime files is now
-"/run/mdadm".  If you compile this for a distro that does not
-have "/run", you will need to compile with an alternate setting for
-MAP_DIR. e.g.
-   make MAP_DIR=/var/run/mdadm
-or
-   make MAP_DIR=/dev/.mdadm
-
-NeilBrown 18th May 2012
-
diff --git a/ANNOUNCE-3.2.6 b/ANNOUNCE-3.2.6
deleted file mode 100644
index f5cfd4920576..000000000000
--- a/ANNOUNCE-3.2.6
+++ /dev/null
@@ -1,57 +0,0 @@
-Subject:  ANNOUNCE: mdadm 3.2.6 - A tool for managing Soft RAID under Linux
-
-I am pleased to announce the availability of
-   mdadm version 3.2.6
-
-It is available at the usual places, now including github:
-   countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://github.com/neilbrown/mdadm
-   git://neil.brown.name/mdadm
-   http://neil.brown.name/git/mdadm
-
-This is a stablity release which adds a number of bugfixs to 3.2.5.
-There are no real stand-out fixes, just lots of little bits and pieces.
-
-Below is the "git log --oneline --reverse" list of changes since
-3.2.5.
-
-NeilBrown 25th October 2012
-
-b7e05d2 udev-rules: prevent systemd from mount devices before they are ready.
-0d478e2 mdadm: Fix Segmentation fault.
-42f0ca1 imsm: fix: correct checking volume's degradation
-fcf2195 Monitor: fix inconsistencies in values for ->percent
-5f862fb Monitor: Report NewArray when an array the disappeared, reappears.
-6f51b1c Monitor: fix reporting for Fail vs FailSpare etc.
-68ad53b mdmon: fix arg parsing.
-517f135 Assemble: don't leak memory with fdlist.
-090900c udev-rules: prevent systemd from mount devices before they are ready.
-446e000 sha1.h: remove ansidecl.h header inclusion
-ec894f5 Manage: zero metadata before adding to 'external' array.
-3a84db5 ddf: allow a non-spare to be used to recovery a missing device.
-c5d61ca ddf: hack to fix container recognition.
-23084aa mdmon: fix arg processing for -a
-c4e96a3 mdmon: allow --takeover when original was started with --offroot
-80841df find_free_devnum: avoid auto-using names in /etc/mdadm.conf
-c5c56d6 mapfile: fix mapfile rebuild for containers
-aec89f6 fix segfaults in Detail()
-2117ad1 Fix 'enough' function for RAID10.
-0bc300d Use --offroot flag when assembling md arrays via --incrmental
-ac78f24 Grow: make warning about old metadata more explicit.
-14026ab Replace sha1.h with slightly older version.
-6f6809f Add zlib license to crc32.c
-5267ba0 Handles spaces in array names better.
-c51f288 imsm: allow --assume-clean to work.
-acf7076 Grow: allow --grow --continue to work for native metadata.
-335d2a6 Grow: fix a couple of typos with --assume-clean usage
-9ff1427 Fix open_container
-3713633 mdadm: super0: do not override uuid with homehost
-31bff58 Trivial bugfix and spelling fixes.
-e1e539f Detail: don't report a faulty device as 'spare' or 'rebuilding'.
-22a6461 super0: allow creation of array on 2TB+ devices.
-a5d47a2 Create new md devices consistently
-eb48676 Monitor: don't complain about non-monitorable arrays in mdadm.conf
-ecdf2d7 Query: don't be confused by partition tables.
-f7b75c1 Query: allow member of non-0.90 arrays to be better reported.
diff --git a/ANNOUNCE-3.3 b/ANNOUNCE-3.3
deleted file mode 100644
index f770aa13137f..000000000000
--- a/ANNOUNCE-3.3
+++ /dev/null
@@ -1,63 +0,0 @@
-Subject: ANNOUNCE: mdadm 3.3 - A tools for managing md Soft RAID under Linux
-
-I am pleased to announce the availability of
-   mdadm version 3.3
-
-It is available at the usual places:
-   http://www.kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://github.com/neilbrown/mdadm
-   git://neil.brown.name/mdadm
-   http://git.neil.brown.name/git/mdadm
-
-This is a major new release so don't be too surprised if there are a
-few issues.  If I hear about them they will be fixed in 3.3.1.
-git log reports nearly 500 changes since 3.2.6 so I won't list them
-all.
-
-Some highlights are:
-
-- Some array reshapes can proceed without needing backup file.
-  This is done by changing the 'data_offset' so we never need to write
-  any data back over where it was before.  If there is no "head space"
-  or "tail space" to allow data_offset to change, the old mechanism
-  with a backup file can still be used.
-- RAID10 arrays can be reshaped to change the number of devices,
-  change the chunk size, or change the layout between 'near'
-  and 'offset'.
-  This will always change data_offset, and will fail if there is no
-  room for data_offset to be moved.
-- "--assemble --update=metadata" can convert a 0.90 array to a 1.0 array.
-- bad-block-logs are supported (but not heavily tested yet)
-- "--assemble --update=revert-reshape" can be used to undo a reshape
-  that has just been started but isn't really wanted.  This is very
-  new and while it passes basic tests it cannot be guaranteed.
-- improved locking between --incremental and --assemble
-- uses systemd to run "mdmon" if systemd is configured to do that.
-- kernel names of md devices can be non-numeric. e.g. "md_home" rather than
-  "md0".  This will probably confuse lots of other tools, so you need to
-       echo CREATE names=yes >> /etc/mdadm.conf
-  or the feature will not be used.  (you also need a reasonably new kernel).
-- "--stop" can be given a kernel name instead of a device name. i.e
-     mdadm --stop md4
-  will work even if /dev/md4 doesn't exist.
-- "--detail --export" has some information about the devices in the array
-- --dump and --restore can be used to backup and restore the metadata on an
-   array.
-- Hot-replace is supported with
-     mdadm /dev/mdX --replace /dev/foo
-  and
-     mdadm /dev/mdX --replace /dev/foo --with /dev/bar
-- Config file can be a directory in which case all "*.conf" files are
-  read in lexical order.
-  Default is to read /etc/mdadm.conf and then /etc/mdadm.conf.d
-  Thus
-      echo CREATE name=yes > /etc/mdadm.conf.d/names.conf
-  will also enable the use of named md devices.
-
-- Lots of improvements to DDF support including adding support for
-  RAID10 (thanks Martin Wilck).
-
-and lots of bugfixes and other little changes.
-
-NeilBrown 3rd September 2013
diff --git a/ANNOUNCE-3.3.1 b/ANNOUNCE-3.3.1
deleted file mode 100644
index 7d5e666ed1b5..000000000000
--- a/ANNOUNCE-3.3.1
+++ /dev/null
@@ -1,23 +0,0 @@
-Subject: ANNOUNCE: mdadm 3.3.1 - A tool for managing md Soft RAID under Linux
-
-I am pleased to announce the availability of
-   mdadm version 3.3.1
-
-It is available at the usual places:
-   http://www.kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://github.com/neilbrown/mdadm
-   git://neil.brown.name/mdadm
-   http://git.neil.brown.name/git/mdadm.git
-
-The main changes are:
- - lots of work on "DDF" support.  Hopefully it will be more stable
-   now.  Bug reports are always welcome.
- - improved interactions with 'systemd'.  Where possible, background
-   tasks are run from systemd (if it is present) rather then forking
-   disassociationg from the session.  This is important because udev
-   doesn't really let you disassociate.
-
-though there are a number of other little bug fixes too.
-
-NeilBrown 5th June 2014
diff --git a/ANNOUNCE-3.3.2 b/ANNOUNCE-3.3.2
deleted file mode 100644
index 6b549611ef13..000000000000
--- a/ANNOUNCE-3.3.2
+++ /dev/null
@@ -1,16 +0,0 @@
-Subject: ANNOUNCE: mdadm 3.3.2 - A tool for managing md Soft RAID under Linux
-
-I am pleased to announce the availability of
-   mdadm version 3.3.2
-
-It is available at the usual places:
-   http://www.kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://github.com/neilbrown/mdadm
-   git://neil.brown.name/mdadm
-   http://git.neil.brown.name/git/mdadm.git
-
-Changes since 3.3.1 are mostly little bugfixes and some man-page
-updates.
-
-NeilBrown 21st August 2014
diff --git a/ANNOUNCE-3.3.3 b/ANNOUNCE-3.3.3
deleted file mode 100644
index ac1b2173b5c0..000000000000
--- a/ANNOUNCE-3.3.3
+++ /dev/null
@@ -1,18 +0,0 @@
-Subject: ANNOUNCE: mdadm 3.3.3 - A tool for managing md Soft RAID under Linux
-
-I am pleased to announce the availability of
-   mdadm version 3.3.3
-
-It is available at the usual places:
-   http://www.kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://github.com/neilbrown/mdadm
-   git://neil.brown.name/mdadm
-   http://git.neil.brown.name/git/mdadm.git
-
-The 100 changes since 3.3.3 are mostly little bugfixes and some improvements
-to the selftests.
-raid6check now handle all RAID6 layouts including DDF correctly.
-See git log for the rest.
-
-NeilBrown 24th July 2015
diff --git a/ANNOUNCE-3.3.4 b/ANNOUNCE-3.3.4
deleted file mode 100644
index 52b94562af51..000000000000
--- a/ANNOUNCE-3.3.4
+++ /dev/null
@@ -1,37 +0,0 @@
-Subject: ANNOUNCE: mdadm 3.3.4 - A tool for managing md Soft RAID under Linux
-
-I am somewhat disappointed to have to announce the availability of
-   mdadm version 3.3.4
-
-It is available at the usual places:
-   http://www.kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://github.com/neilbrown/mdadm
-   git://neil.brown.name/mdadm
-   http://git.neil.brown.name/git/mdadm.git
-
-In mdadm-3.3 a change was made to how IMSM (Intel Matrix Storage
-Manager) metadata was handled.  Previously an IMSM array would only
-be assembled if it was attached to an IMSM controller.
-
-In 3.3 this was relaxed as there are circumstances where the
-controller is not properly detected.  Unfortunately this has negative
-consequences which have only just come to light.
-
-If you have an IMSM RAID1 configured and then disable RAID in the
-BIOS, the metadata will remain on the devices.  If you then install
-some other OS on one device and then install Linux on the other, Linux
-might eventually start noticing the IMSM metadata (depending a bit on whether
-mdadm is included in the initramfs) and might start up the RAID1.  This could
-copy one device over the other, thus trashing one of the installations.
-
-Not good.
-
-So with this release IMSM arrays will only be assembled if attached to
-an IMSM controller, or if "--force" is given to --assemble, or if the
-environment variable IMSM_NO_PLATFORM is set (used primarily for
-testing).
-
-I strongly recommend upgrading to 3.3.4 if you are using 3.3 or later.
-
-NeilBrown 3rd August 2015.
diff --git a/ANNOUNCE-3.4 b/ANNOUNCE-3.4
deleted file mode 100644
index 2689732de524..000000000000
--- a/ANNOUNCE-3.4
+++ /dev/null
@@ -1,24 +0,0 @@
-Subject: ANNOUNCE: mdadm 3.4 - A tool for managing md Soft RAID under Linux
-
-I am pleased to announce the availability of
-   mdadm version 3.4
-
-It is available at the usual places:
-   http://www.kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://github.com/neilbrown/mdadm
-   git://neil.brown.name/mdadm
-   http://git.neil.brown.name/git/mdadm
-
-The new second-level version number reflects significant new
-functionality, particular support for journalled RAID5/6 and clustered
-RAID1.  This new support is probably still buggy.  Please report bugs.
-
-There are also a number of fixes for Intel's IMSM metadata support,
-and an assortment of minor bug fixes.
-
-I plan for this to be the last release of mdadm that I provide as I am
-retiring from MD and mdadm maintenance.  Jes Sorensen has volunteered
-to oversee mdadm for the next while.  Thanks Jes!
-
-NeilBrown 28th January 2016
diff --git a/ANNOUNCE-4.0 b/ANNOUNCE-4.0
deleted file mode 100644
index f79c5408c923..000000000000
--- a/ANNOUNCE-4.0
+++ /dev/null
@@ -1,22 +0,0 @@
-Subject: ANNOUNCE: mdadm 4.0 - A tool for managing md Soft RAID under Linux
-
-I am pleased to announce the availability of
-   mdadm version 4.0
-
-It is available at the usual places:
-   http://www.kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
-   http://git.kernel.org/cgit/utils/mdadm/
-
-The update in major version number primarily indicates this is a
-release by it's new maintainer. In addition it contains a large number
-of fixes in particular for IMSM RAID and clustered RAID support.  In
-addition this release includes support for IMSM 4k sector drives,
-failfast and better documentation for journaled RAID.
-
-This is my first release of mdadm. Please thank Neil Brown for his
-previous work as maintainer and blame me for all the bugs I caused
-since taking over.
-
-Jes Sorensen, 2017-01-09
diff --git a/ANNOUNCE-4.1 b/ANNOUNCE-4.1
deleted file mode 100644
index a273b9a008ec..000000000000
--- a/ANNOUNCE-4.1
+++ /dev/null
@@ -1,16 +0,0 @@
-Subject: ANNOUNCE: mdadm 4.1 - A tool for managing md Soft RAID under Linux
-
-I am pleased to announce the availability of
-   mdadm version 4.1
-
-It is available at the usual places:
-   http://www.kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
-   http://git.kernel.org/cgit/utils/mdadm/
-
-The update constitutes more than one year of enhancements and bug fixes
-including for IMSM RAID, Partial Parity Log, clustered RAID support,
-improved testing, and gcc-8 support.
-
-Jes Sorensen, 2018-10-01
diff --git a/ANNOUNCE-4.2 b/ANNOUNCE-4.2
deleted file mode 100644
index 8b22d09ffef2..000000000000
--- a/ANNOUNCE-4.2
+++ /dev/null
@@ -1,19 +0,0 @@
-Subject: ANNOUNCE: mdadm 4.2 - A tool for managing md Soft RAID under Linux
-
-I am pleased to finally announce the availability of mdadm-4.2.
-get 4.2 out the door soon.
-
-It is available at the usual places:
-   http://www.kernel.org/pub/linux/utils/raid/mdadm/
-and via git at
-   git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
-   http://git.kernel.org/cgit/utils/mdadm/
-
-The release includes more than two years of development and bugfixes,
-so it is difficult to remember everything. Highlights include
-enhancements and bug fixes including for IMSM RAID, Partial Parity
-Log, clustered RAID support, improved testing, and gcc-9 support.
-
-Thank you everyone who contributed to this release!
-
-Jes Sorensen, 2021-12-30
-- 
2.35.3

