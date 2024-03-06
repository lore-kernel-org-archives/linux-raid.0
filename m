Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6368D7FBC8
	for <linux-raid@vger.kernel.org>; Wed,  6 Mar 2024 12:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709729182; cv=none; b=nkkj6HHGfhCmE9t4aVG74CGvG5OJgdIYpkbhS2pzfw2MScSTh7nrRSgfkt8cbIpJMDAiekfjwOGCKngJi0oNUOQ4r4LDTENDHL+fjsdiHWAQqdGq66ItqroKEtInOKLI0fabrjnap0ZH9l/wa7BU+WK7gi0ANe45/L/gkZdUJ8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709729182; c=relaxed/simple;
	bh=PH/FNfvW8rd9WHIvsjocIVYwbH2rk1N9mETJym040PQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HAHY9O4Vp8OWhzo7UotXgWPZuoJK6X+vUbPNHCyldlSzr5sLPgmNsQDwtdysmROGjGwHWZWOrEDb0WWPyC+WkbR/4xyQj3mRaxIrhJC/1d3Ap4IlZaCrNfrjaZ4zCok3lFy2nYYbqmW+6SjsLVyzEoLbPr5niX8kIXSzPJww7ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VH4Ojlff; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VH4Ojlff"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709729181; x=1741265181;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PH/FNfvW8rd9WHIvsjocIVYwbH2rk1N9mETJym040PQ=;
  b=VH4OjlffvIc2t6B0TdZd00gzSuOWkmCdEUUt17r0u1B+y+NjNDtTbCt3
   oKH3YpMDWiw6haZ8fO4O9U3VHpBJxQ316whuwp98XfhBvHVu3GVpPkQqR
   sj93mBU28c6SNzZAP6LXM+n3PjenZg6VP6UVIUTUcBke+LifhuV5CnNNf
   I8G81evGVZytoAedus5uWXROzWfS2nl3fVN8iw77a3eqJzRBXnQqdDMWX
   iXVLXEsk/df1dkxoD1v8KnCt+XB5OJ7xwMWQweOQK6UfIptyJc9C5ZDtJ
   yDqqtFXEeqTjtSabWkerp2jT6Iaw+XVSl78b8Lt9KByLvIBYjwHVqqYfN
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="4452959"
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="4452959"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 04:46:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="14301995"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 04:46:19 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH] mdadm: remove inventory file
Date: Wed,  6 Mar 2024 13:45:53 +0100
Message-Id: <20240306124553.29390-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is a file with repo content list. It is outdated already.
Remove it.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 inventory | 284 ------------------------------------------------------
 1 file changed, 284 deletions(-)
 delete mode 100755 inventory

diff --git a/inventory b/inventory
deleted file mode 100755
index c4801b49fd59..000000000000
--- a/inventory
+++ /dev/null
@@ -1,284 +0,0 @@
-
-.gitignore
-ANNOUNCE-3.0
-ANNOUNCE-3.0.1
-ANNOUNCE-3.0.2
-ANNOUNCE-3.0.3
-ANNOUNCE-3.1
-ANNOUNCE-3.1.1
-ANNOUNCE-3.1.2
-ANNOUNCE-3.1.3
-ANNOUNCE-3.1.4
-ANNOUNCE-3.1.5
-ANNOUNCE-3.2
-ANNOUNCE-3.2.1
-ANNOUNCE-3.2.2
-ANNOUNCE-3.2.3
-ANNOUNCE-3.2.4
-ANNOUNCE-3.2.5
-ANNOUNCE-3.2.6
-ANNOUNCE-3.3
-ANNOUNCE-3.3.1
-ANNOUNCE-3.3.2
-ANNOUNCE-3.3.3
-ANNOUNCE-3.3.4
-ANNOUNCE-3.4
-ANNOUNCE-4.0
-ANNOUNCE-4.1
-ANNOUNCE-4.2
-Assemble.c
-Build.c
-COPYING
-ChangeLog
-Create.c
-Detail.c
-Dump.c
-Examine.c
-Grow.c
-INSTALL
-Incremental.c
-Kill.c
-Makefile
-Manage.c
-Monitor.c
-Query.c
-README.initramfs
-ReadMe.c
-TODO
-bitmap.c
-bitmap.h
-clustermd_tests/
-clustermd_tests/00r10_Create
-clustermd_tests/00r1_Create
-clustermd_tests/01r10_Grow_bitmap-switch
-clustermd_tests/01r10_Grow_resize
-clustermd_tests/01r1_Grow_add
-clustermd_tests/01r1_Grow_bitmap-switch
-clustermd_tests/01r1_Grow_resize
-clustermd_tests/02r10_Manage_add
-clustermd_tests/02r10_Manage_add-spare
-clustermd_tests/02r10_Manage_re-add
-clustermd_tests/02r1_Manage_add
-clustermd_tests/02r1_Manage_add-spare
-clustermd_tests/02r1_Manage_re-add
-clustermd_tests/03r10_switch-recovery
-clustermd_tests/03r10_switch-resync
-clustermd_tests/03r1_switch-recovery
-clustermd_tests/03r1_switch-resync
-clustermd_tests/cluster_conf
-clustermd_tests/func.sh
-config.c
-coverity-gcc-hack.h
-crc32.c
-crc32.h
-crc32c.c
-dlink.c
-dlink.h
-external-reshape-design.txt
-inventory
-lib.c
-makedist
-managemon.c
-mapfile.c
-maps.c
-md.4
-md5.h
-md_p.h
-md_u.h
-mdadm.8.in
-mdadm.c
-mdadm.conf-example
-mdadm.conf.5
-mdadm.h
-mdadm.spec
-mdmon-design.txt
-mdmon.8
-mdmon.c
-mdmon.h
-mdopen.c
-mdstat.c
-misc/
-misc/mdcheck
-misc/syslog-events
-mkinitramfs
-monitor.c
-msg.c
-msg.h
-part.h
-platform-intel.c
-platform-intel.h
-policy.c
-probe_roms.c
-probe_roms.h
-pwgr.c
-raid5extend.c
-raid6check.8
-raid6check.c
-restripe.c
-sg_io.c
-sha1.c
-sha1.h
-super-ddf.c
-super-gpt.c
-super-intel.c
-super-mbr.c
-super0.c
-super1.c
-swap_super.c
-sysfs.c
-systemd/
-systemd/SUSE-mdadm_env.sh
-systemd/mdadm-grow-continue@.service
-systemd/mdadm-last-resort@.service
-systemd/mdadm-last-resort@.timer
-systemd/mdadm.shutdown
-systemd/mdcheck_continue.service
-systemd/mdcheck_continue.timer
-systemd/mdcheck_start.service
-systemd/mdcheck_start.timer
-systemd/mdmon@.service
-systemd/mdmonitor-oneshot.service
-systemd/mdmonitor-oneshot.timer
-systemd/mdmonitor.service
-test
-tests/
-tests/00linear
-tests/00multipath
-tests/00names
-tests/00raid0
-tests/00raid1
-tests/00raid10
-tests/00raid4
-tests/00raid5
-tests/00raid6
-tests/00readonly
-tests/01r1fail
-tests/01r5fail
-tests/01r5integ
-tests/01raid6integ
-tests/01replace
-tests/02lineargrow
-tests/02r1add
-tests/02r1grow
-tests/02r5grow
-tests/02r6grow
-tests/03assem-incr
-tests/03r0assem
-tests/03r5assem
-tests/03r5assem-failed
-tests/03r5assemV1
-tests/04r0update
-tests/04r1update
-tests/04r5swap
-tests/04update-metadata
-tests/04update-uuid
-tests/05r1-add-internalbitmap
-tests/05r1-add-internalbitmap-v1a
-tests/05r1-add-internalbitmap-v1b
-tests/05r1-add-internalbitmap-v1c
-tests/05r1-bitmapfile
-tests/05r1-failfast
-tests/05r1-grow-external
-tests/05r1-grow-internal
-tests/05r1-grow-internal-1
-tests/05r1-internalbitmap
-tests/05r1-internalbitmap-v1a
-tests/05r1-internalbitmap-v1b
-tests/05r1-internalbitmap-v1c
-tests/05r1-n3-bitmapfile
-tests/05r1-re-add
-tests/05r1-re-add-nosuper
-tests/05r1-remove-internalbitmap
-tests/05r1-remove-internalbitmap-v1a
-tests/05r1-remove-internalbitmap-v1b
-tests/05r1-remove-internalbitmap-v1c
-tests/05r5-bitmapfile
-tests/05r5-internalbitmap
-tests/05r6-bitmapfile
-tests/05r6tor0
-tests/06name
-tests/06sysfs
-tests/06wrmostly
-tests/07autoassemble
-tests/07autodetect
-tests/07changelevelintr
-tests/07changelevels
-tests/07layouts
-tests/07reshape5intr
-tests/07revert-grow
-tests/07revert-inplace
-tests/07revert-shrink
-tests/07testreshape5
-tests/09imsm-assemble
-tests/09imsm-create-fail-rebuild
-tests/09imsm-overlap
-tests/10ddf-assemble-missing
-tests/10ddf-create
-tests/10ddf-create-fail-rebuild
-tests/10ddf-fail-create-race
-tests/10ddf-fail-readd
-tests/10ddf-fail-readd-readonly
-tests/10ddf-fail-spare
-tests/10ddf-fail-stop-readd
-tests/10ddf-fail-twice
-tests/10ddf-fail-two-spares
-tests/10ddf-geometry
-tests/10ddf-incremental-wrong-order
-tests/10ddf-sudden-degraded
-tests/11spare-migration
-tests/12imsm-r0_2d-grow-r0_3d
-tests/12imsm-r0_2d-grow-r0_4d
-tests/12imsm-r0_2d-grow-r0_5d
-tests/12imsm-r0_3d-grow-r0_4d
-tests/12imsm-r5_3d-grow-r5_4d
-tests/12imsm-r5_3d-grow-r5_5d
-tests/13imsm-r0_r0_2d-grow-r0_r0_4d
-tests/13imsm-r0_r0_2d-grow-r0_r0_5d
-tests/13imsm-r0_r0_3d-grow-r0_r0_4d
-tests/13imsm-r0_r5_3d-grow-r0_r5_4d
-tests/13imsm-r0_r5_3d-grow-r0_r5_5d
-tests/13imsm-r5_r0_3d-grow-r5_r0_4d
-tests/13imsm-r5_r0_3d-grow-r5_r0_5d
-tests/14imsm-r0_3d-r5_3d-migrate-r5_4d-r5_4d
-tests/14imsm-r0_3d_no_spares-migrate-r5_3d
-tests/14imsm-r0_r0_2d-takeover-r10_4d
-tests/14imsm-r10_4d-grow-r10_5d
-tests/14imsm-r10_r5_4d-takeover-r0_2d
-tests/14imsm-r1_2d-grow-r1_3d
-tests/14imsm-r1_2d-takeover-r0_2d
-tests/14imsm-r5_3d-grow-r5_5d-no-spares
-tests/14imsm-r5_3d-migrate-r4_3d
-tests/15imsm-r0_3d_64k-migrate-r0_3d_256k
-tests/15imsm-r5_3d_4k-migrate-r5_3d_256k
-tests/15imsm-r5_3d_64k-migrate-r5_3d_256k
-tests/15imsm-r5_6d_4k-migrate-r5_6d_256k
-tests/15imsm-r5_r0_3d_64k-migrate-r5_r0_3d_256k
-tests/16imsm-r0_3d-migrate-r5_4d
-tests/16imsm-r0_5d-migrate-r5_6d
-tests/16imsm-r5_3d-migrate-r0_3d
-tests/16imsm-r5_5d-migrate-r0_5d
-tests/18imsm-1d-takeover-r0_1d
-tests/18imsm-1d-takeover-r1_2d
-tests/18imsm-r0_2d-takeover-r10_4d
-tests/18imsm-r10_4d-takeover-r0_2d
-tests/18imsm-r1_2d-takeover-r0_1d
-tests/19raid6auto-repair
-tests/19raid6check
-tests/19raid6repair
-tests/19repair-does-not-destroy
-tests/20raid5journal
-tests/21raid5cache
-tests/ToTest
-tests/env-ddf-template
-tests/env-imsm-template
-tests/func.sh
-tests/imsm-grow-template
-tests/utils
-udev-md-clustered-confirm-device.rules
-udev-md-raid-arrays.rules
-udev-md-raid-assembly.rules
-udev-md-raid-creating.rules
-udev-md-raid-safe-timeouts.rules
-util.c
-uuid.c
-xmalloc.c
-- 
2.35.3

