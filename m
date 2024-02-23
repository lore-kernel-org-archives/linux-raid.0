Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF20D6FB9
	for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 14:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708699923; cv=none; b=q1g+PB3QO3rUlPK+eMtp/+GcXieyfWRNIu+iCy5vJQGfRUTyFG6SRwUdseLGSP3tbzpcvIggjs1LC5uQRZy6Iesosav5Z8rSGYesSSBfiDawiiRol+33/SMdMNXSZqCvGrvkBgZ+LtCuv6VIJ7VIiO4E7pF9ByXJRND4Gf1kdA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708699923; c=relaxed/simple;
	bh=IZ3FFnIM29t/iXvx+NvXMzrByuzDKQ8g24WzUfYkFi4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JNFZVREgoRYXz2RnXZPyylHbuGjdQvCwAC+M8hg+apM4rG+OYygBFDzLOsBq3ScPJe4qesy6jDqW8vk+hxpsJ22OcUeE1WdA16WiLseRM0y2eMW5oXNg6vC7OXYEgS5n/kytW8oXYcnzJy3nuAxYRsMBY2cOJxafeWUO/F3qcbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BeWMHNJZ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BeWMHNJZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708699921; x=1740235921;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IZ3FFnIM29t/iXvx+NvXMzrByuzDKQ8g24WzUfYkFi4=;
  b=BeWMHNJZk2tctrbx1hMnDvK1P233VJjovP1LYotuuPzAuBhTDxlnhZcm
   Vv5K6yoPvMuaw9SmUSUlBm/dtxVA36gu2FCzNuwgDxcuwfTyvKgB9LS+y
   Z2TnlvzT/Kz+qQmK7v+1DdiqdXjNtuqjHLsLbvXb1QSFFyM4gfxIy4OCa
   51jxYLFORlGSr4k59tk1b0MlWAVN0/GEzc6MEqyNj2nnMZL/yol/7Crvm
   8gJNPutlFphrd3MbhRS0mq4S04hffsdAXxMJjJBnOBjUg/C4lDEHxZksN
   md+4/766qqppAjVaVBtLQfOGMGA2O0PXF3WSfk7y6tXhJKXsuAEsUwOvA
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10993"; a="20454905"
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="20454905"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 06:52:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="10495429"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 06:51:59 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 2/6] mdadm: remove TODO
Date: Fri, 23 Feb 2024 15:51:42 +0100
Message-Id: <20240223145146.3822-3-mariusz.tkaczyk@linux.intel.com>
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

This file is not updated in 16 years.
No reasons to keep it. Remove it.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 TODO | 213 -----------------------------------------------------------
 1 file changed, 213 deletions(-)
 delete mode 100644 TODO

diff --git a/TODO b/TODO
deleted file mode 100644
index 279d20db9989..000000000000
--- a/TODO
+++ /dev/null
@@ -1,213 +0,0 @@
- - add 'name' field to metadata type and use it.
- - use validate_geometry more
- - metadata should be able to check/reject bitmap stuff.
-
-DDF:
-  Three new metadata types:
-    ddf - used only to create a container.
-    ddf-bvd - used to create an array in a container
-    ddf-svd - used to create a secondary array from bvds.
-
-  Usage:
-    mdadm -C /dev/ddf1 /dev/sd[abcdef]
-    mdadm -C /dev/md1 -e ddf /dev/sd[a-f]
-    mdadm -C /dev/md1 -l container /dev/sd[a-f]
-
-        Each of these create a new ddf container using all those
-	devices.  The name 'ddf*' signals that ddf metadata should be used.
-	'-e ddf' only supports one level - 'container'.  'container' is only
-	supported by ddf.
-
-    mdadm -C /dev/md1 -l0 -n4 /dev/ddf1 # or maybe not ???
-    mdadm -C /dev/md1 -l1 -n2 /dev/sda /dev/sdb
-	If exactly one device is given, and it is a container, we select
-	devices from that container.
-	If devices are given that are already in use, they must be in use by
-	a container, and the array is created in the container.
-	If devices given are bvds, we slip under the hood to make
-	  the svd arrays.
-
-    mdadm -A /dev/ddf ......
-	base drives make a container.  Anything in that container is started
-	 auto-read-only.
-	 if /dev/ddf is already assembled, we assemble bvds and svds inside it.
-
-
-2005-dec-20
-  Want an incremental assembly mode to work nicely with udev.
-  Core usage would be something like
-       mdadm --incr-assemble /dev/newdevice
-  This would
-     - examine the device to determine  uuid etc.
-     - look for a match in /etc/mdadm.conf, abort if not found
-     - find that device and collect current contents
-     - perform an 'assemble' analysis to make sure we have the best set of devices.
-     - remove or add devices as appropriate
-     - possibly start the array if it was complete
-
-   Other usages could involve
-     - specify which array to auto-add to.
-       This requires an existing array for uuid matching... is there any point?
-
-     -
-
-
-2004-june-02
-  * Don't print 'errors' flag, it is meaningless. DONE
-  * Handle new superblock format
-  * create device file on demand, particularly partitionable devices. DONE
-      BUT figure a way to create the partition devices.
-              auto=partN
-  * Use Event: interface to listen for events. DONE, untested
-  * Make sure mdadm -As can assemble multi-level RAIDs ok.
-  * --build to build raid1 or multipath arrays 
-       clean or not ???
-  
-----------------------------------------------------------------------------
-* mdadm --monitor to monitor failed multipath paths and re-instate them.
-
-* Maybe make "--help" fit in 80x24 and have a --long-help with more info. DONE
-
-
-* maybe "missing" instead of <bold>missing</> in doco DONE
-* possibly wait for resync to start, or even finish while assembling.- NO
-
-* -Db should have a devices= entry if possible. - DONE
-* when assembling multipath arrays, ignore any error indicators. - DONE
-* rationalise --monitor usage:
-     mdadm --monitor
-  doesn't do as expected. DONE
-
-* --assemble could have a --update option. - DONE
-  following word can be:
-	sparc2.2
-	super-minor
-
-* mdadm /dev/md11, where md11 is raid0 can segfault, particularly when looking in the 
-   [UU_UUU] string ... which doesn't exist !
-It should be more sensible.  DONE
-
-Example:
-
-from  Raimund Sacherer <raimund.sacherer@ngit.at>
-
-mke2fs -m0 -q /dev/ram1 300
-mount -n -t ext2 /dev/ram1 /tmp
-echo DEVICE /dev/[sh]* >> /tmp/mdadm.conf
-mdadm -Esb /dev/[sh]* 2>/dev/null >> /tmp/mdadm.conf
-mdadm -ARsc /tmp/mdadm.conf
-umount /tmp
-
-
-?? Allow -S /dev/md? - current complains subsequent not a/d/r - DONE
-
-* new "Query" mode to subsume --detail and --examine.
-   --query or -Q, takes a device and tells if it is an MD device,
-   and also tells in a raid superblock is found. 
- DONE
-
-* write mdstat.c to parse /proc/mdstat file
-   Build list of arrays:  name, rebuild-percent
-  DONE
-
-* parse /proc/partitions and map major/minor into /dev/* names,
-  and use that for default DEVICE list ????
-
-* --detail --scan to read /proc/mdstat, and then iterate over these,
-    but assume --brief.  --verbose can override
-    check each subdevice to see if it is in conf_get_devs.
-    Warn if not.
-  DONE, but don't warn yet...
-
-* Support multipath ... maybe...
-  maybe DONE
-
-* --follow to syslog 
-
-* --follow to move spares around DONE
-
-* --follow to notice other events: DONE
-     rebuild started
-     spare activated
-     spare removed
-     spare added
-
-------------------------------------
-- --examine --scan scans all drives and build an mdadm.conf file DONE
-
-- check superblock checksum in examine DONE
-- report "chunk" or "rounding" depending on raid level DONE
-- report "linear" instead of "-1" for raid level DONE
-- decode ayout depending on raid level DONE
-- --verbose and --force flags. DONE
-
-- set md_minor, *_disks for Create  - DONE
-- for create raid5, how to choose between 
-   all working, but not insync
-   one missing, one spare, insync  DONE (--force)
-- and for raid1 - some failed drives...  (missing)
-
-- when RUN_ARRAY, make sure *_disks counts are right
-
-- get --detail to extract extra stuff from superblock,
-   like uuid  DONE
-- --detail --brief to give a config file line DONE
-- parse config file. DONE
-- test...
-
-- when --assemble --scan, if an underlying device is an md device, 
-  then try to assemble that device first.
-
-
-- mdadm -S /dev/md0 /dev/md1 gives internal error FIXED
-
-- mdadm --detail --scan print summary of what it can find? DONE
-
-
----------
-Assemble doesn't add spares. - DONE
-Create to allow "missing" name for devices.
-Create to accept "--force" for do exactly what is requested
-- get Assemble to upgrade devices if force flag.
-ARRAY lines in config file to have super_minor=n
-ARRAY lines in config file to have device=pattern, and only accept
-   those devices
-   If UUID given, insist on that
-   If not, but super_minor given, require all found with that minor
-    to have same uuid
-   If only device given, all valid supers on those devices must have 
-    same uuid
-allow /dev/mdX as first argument before any options
-Possible --dry-run option for create and assemble--force
-
-Assemble to check that all devices mentioned in superblock
-  are present.
-
-New mode: --Monitor (or --Follow)
-  Periodically check status of all arrays (listed in config file).
-  Log every event and apparent cause - or differences
-  Email and alert - or run a program - for important events
-  Move spares around if necessary.
-
-  An Array line can have a spare-group= field that indicates that
-   the array shares spares with other arrays with the same
-   spare-group name.
-   If an array has a failed and no spares, then check all other
-     arrays in the spare group.  If one has no failures and a spare,
-     then consider that spare.
-    Choose the smallest considered spare that is large enough.
-    If there is one, then hot-remove it from it's home, and
-    hot-add it to the array in question.
-
-  --mail-to address  
-  --alert-handler program
-  
-  Will also extract information from /proc/mdstat if present,
-  and consider 20% marks in rebuild as events.
-
-  Events are:
-     drive fails  - causes mail to be sent
-     rebuild started
-     spare activated
-     spare removed
-     spare added
-- 
2.35.3

