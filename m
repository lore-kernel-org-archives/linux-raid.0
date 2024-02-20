Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C81B762C5
	for <linux-raid@vger.kernel.org>; Tue, 20 Feb 2024 16:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708445107; cv=none; b=GCJCu/33oiXmvmaOOd/L0b8ZR1GS5SfNlHU+3MF9ICnLe+oEYcgVbqydcN43LVy6eLhSaWRjY6/Z9St/Xv5WDtNReNnofE+3PE/Lu7fpnZd9KVg18xAMu+ihsWPFNdRYAn3XeibLEbHwN5GS7GwMBcuEUaTznZrVby9bOJ3vODA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708445107; c=relaxed/simple;
	bh=KUdQYVhU8pyZHWKXweZAJvUFtZv/7ujdRQwcFgO8Hxw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZzXr+KYeaLRXN3zGm2X2XDV+pzY4TgwyOF+dtN0XcQBkwxwlaU4v3ZQuHP+89Uu2IijRAzo6sJIhI2Gncm+PWMINmlq+R6QO9obkmBtJr4XJ+o/QNNL76BCvQf3cFkvzZEOi5zXNqb/tUxcyVn1iAVZxooJHhI1e1hNTE5RJlak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b27v0JzP; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b27v0JzP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708445106; x=1739981106;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KUdQYVhU8pyZHWKXweZAJvUFtZv/7ujdRQwcFgO8Hxw=;
  b=b27v0JzPBWC7EHfGjb6S2vdH1LRyFLr9ivL3OsI8MLCE7b2J35XCddaH
   F07R1qwqotEP9PAc4tXIHDe59uy66ZjVplqwbpTlAtdjw3Cwft3kBvJl+
   /0+EuMRjztiHgMPE0J/RkNCmgthWafNcCv4zGcAF2SLgfKIYGedH/v3+E
   SVSY2Dl5GxLELEsOtmeFW9c8X5/kLckFhfxfws7AMr36xEASp7mxx3VzU
   4n/U4OWN/uZMOy4kwtJt3RuVFdhyDujDOYm92pNKknTOxMj6ZmsYi7Ewe
   UB0RRPVTbnawf+ia34vmKmG9/XadxjTyx+jXUxIc9XUqX8IJFMvjYfJzq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10990"; a="6327214"
X-IronPort-AV: E=Sophos;i="6.06,174,1705392000"; 
   d="scan'208";a="6327214"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 08:05:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,174,1705392000"; 
   d="scan'208";a="9523905"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by orviesa005.jf.intel.com with ESMTP; 20 Feb 2024 08:05:03 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH] test: run tests on system level mdadm
Date: Tue, 20 Feb 2024 17:04:44 +0100
Message-Id: <20240220160444.3139-1-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The tests run with MDADM_NO_SYSTEMCTL flag by default, however it has
no effect on udev. In case of external metadata, even if flag is set,
udev will trigger systemd to launch mdmon.

This commit changes test execution level, so the tests are run on system
level mdadm, meaning local build must be installed prior to running
tests.

Add warning that the tests are run on system level mdadm and local
build must be installed first.

Do not call mdadm with "quiet" as it makes it not display critical
messages necessary for debug.

Remove forcing speed_limit and add restoring system speed_limit_max
after test execution.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 test          | 27 ++++++++++++++++++---------
 tests/func.sh |  1 -
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/test b/test
index 49a36c3b8ef2..338c2db44fa7 100755
--- a/test
+++ b/test
@@ -1,11 +1,12 @@
 #!/bin/bash
 #
 # run test suite for mdadm
-mdadm=$PWD/mdadm
+mdadm=`which mdadm`
 targetdir="/var/tmp"
 logdir="$targetdir"
 config=/tmp/mdadm.conf
 testdir=$PWD/tests
+system_speed_limit=`cat /proc/sys/dev/raid/speed_limit_max`
 devlist=
 
 savelogs=0
@@ -20,9 +21,6 @@ DEVTYPE=loop
 INTEGRITY=yes
 LVM_VOLGROUP=mdtest
 
-# make sure to test local mdmon, not system one
-export MDADM_NO_SYSTEMCTL=1
-
 # assume md0, md1, md2 exist in /dev
 md0=/dev/md0
 md1=/dev/md1
@@ -41,7 +39,10 @@ ctrl_c() {
 	ctrl_c_error=1
 }
 
-# mdadm always adds --quiet, and we want to see any unexpected messages
+restore_system_speed_limit() {
+	echo $system_speed_limit > /proc/sys/dev/raid/speed_limit_max
+}
+
 mdadm() {
 	rm -f $targetdir/stderr
 	case $* in
@@ -63,10 +64,10 @@ mdadm() {
 					$mdadm --zero $args > /dev/null
 			}
 		done
-		$mdadm 2> $targetdir/stderr --quiet "$@" --auto=yes
+		$mdadm 2> $targetdir/stderr "$@" --auto=yes
 		;;
 	* )
-		$mdadm 2> $targetdir/stderr --quiet "$@"
+		$mdadm 2> $targetdir/stderr "$@"
 		;;
 	esac
 	rv=$?
@@ -99,8 +100,6 @@ do_test() {
 		fi
 
 		rm -f $targetdir/stderr
-		# this might have been reset: restore the default.
-		echo 2000 > /proc/sys/dev/raid/speed_limit_max
 		do_clean
 		# source script in a subshell, so it has access to our
 		# namespace, but cannot change it.
@@ -122,6 +121,7 @@ do_test() {
 				echo "  (KNOWN BROKEN TEST: $_broken_msg)"
 			fi
 		fi
+		restore_system_speed_limit
 		[ "$savelogs" == "1" ] &&
 			mv -f $targetdir/log $logdir/$_basename.log
 		[ "$ctrl_c_error" == "1" ] && exit 1
@@ -299,7 +299,15 @@ parse_args() {
 	done
 }
 
+print_warning() {
+	cat <<-EOF
+	Warning! Tests are performed on system level mdadm!
+	If you want to test local build, you need to install it first!
+	EOF
+}
+
 main() {
+	print_warning
 	do_setup
 
 	echo "Testing on linux-$(uname -r) kernel"
@@ -329,6 +337,7 @@ main() {
 			break
 		fi
 	done
+
 	exit 0
 }
 
diff --git a/tests/func.sh b/tests/func.sh
index 1c1a28a2a9c8..b474442b6abe 100644
--- a/tests/func.sh
+++ b/tests/func.sh
@@ -213,7 +213,6 @@ do_setup() {
 	path1=$dev7
 	ulimit -c unlimited
 	[ -f /proc/mdstat ] || modprobe md_mod
-	echo 2000 > /proc/sys/dev/raid/speed_limit_max
 	echo 0 > /sys/module/md_mod/parameters/start_ro
 }
 
-- 
2.35.3

