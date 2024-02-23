Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8065D73F
	for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 14:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708699924; cv=none; b=qqI5Wzx4C/7rXi1+2a9FxmZveIiMSGlLF+eD0XfWdF6sUU9zC2wg2e3dsnNMLXVh9kKGemOSRYbSXrrcwU4YQAk7scVsf+thyJQS3gVRZKuXVMR78D9ICZwqR5u0eXh6nUN7Fs3T2tJ8sjGN4vhuPL7ir10CF4DClrfKaA8H2+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708699924; c=relaxed/simple;
	bh=ajHZdYbYqKC7UCFnRQjeQEYfskW8RMZcIM2s4OnxBxI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=udruIVs4rub4leper7KpuTrjUaNLAUMonBki23zrTuGAcfcy9Uk0tTXFjWD2QtYW4kFy+VPww6hpiCm1sYnADJ4u0jnbS+qKlRW4Lh06TF3uQDMc51404UPEDoQjQB+ofxpoNSpA0fD9Fs3+X0jNL/cdaP6FRNjQNiu+XplIO1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OdRhJE8z; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OdRhJE8z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708699922; x=1740235922;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ajHZdYbYqKC7UCFnRQjeQEYfskW8RMZcIM2s4OnxBxI=;
  b=OdRhJE8zSn3Os6I/2W9OAX3LtTPvcQ50YLQcPzbgWA7UJO+iVCm+cNT7
   TmHFH5B0qLWuy+vyDdcxEMbhbUHk7WlYuCrQQTixVKDd14Te6CSHo5rpr
   Pw8HySr+3Sedul3kblp1a+K2iRmckblrdH0qKgx2Km5hQrpIPNqrR9fEN
   n5Mx/qCS9xAiMSlKGz5fzyvPRgc8MjrFnN/wq2KbvbPnFKmqw6eTTZ4AC
   Ziaji+VI83UPUF/NAEc5F2hBaNH+LmXQra+M69yzO/1828Pund2guQs6M
   BQ1Sx5NQK+jIm4qiHTfQqFeMp1N3Vd6QgAHav2MIh+UJomBZPK5VUF6bi
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10993"; a="20454915"
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="20454915"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 06:52:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="10495433"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 06:52:01 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 3/6] mdadm: remove makedist
Date: Fri, 23 Feb 2024 15:51:43 +0100
Message-Id: <20240223145146.3822-4-mariusz.tkaczyk@linux.intel.com>
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

Archives are generated kernel.org automation, no need to submit
them manually, so remove legacy solution.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 makedist | 96 --------------------------------------------------------
 1 file changed, 96 deletions(-)
 delete mode 100755 makedist

diff --git a/makedist b/makedist
deleted file mode 100755
index 0c4b39eba9a9..000000000000
--- a/makedist
+++ /dev/null
@@ -1,96 +0,0 @@
-#!/bin/sh
-# avoid silly sorting
-export LANG=C
-arg=$1
-target=~/public_html/source/mdadm
-if [ " $arg" = " test" ]
-then
-  target=/tmp/mdadm-test
-  rm -rf $target
-  mkdir -p $target
-fi
-if [ -d $target ]
-then :
-else echo $target is not a directory
-     exit 2
-fi
-set `grep '^#define VERSION' ReadMe.c `
-version=`echo $3 | sed -e 's/"//g'`
-grep "^.TH MDADM 8 .. v$version" mdadm.8.in > /dev/null 2>&1 ||
- {
-   echo mdadm.8.in does not mention version $version.
-   exit 1
- }
-grep "^.TH MDMON 8 .. v$version" mdmon.8 > /dev/null 2>&1 ||
- {
-   echo mdmon.8 does not mention version $version.
-   exit 1
- }
-rpmv=`echo $version | tr - _`
-grep "^Version: *$rpmv$" mdadm.spec > /dev/null 2>&1 ||
- {
-   echo mdadm.spec does not mention version $version.
-   exit 1
- }
-if [ -f ANNOUNCE-$version ]
-then :
-else
-   echo ANNOUNCE-$version does not exist
-   exit 1
-fi
-if grep "^ANNOUNCE-$version\$" inventory
-then :
-else { cat inventory ; echo ANNOUNCE-$version ; } | sort -o inventory
-fi
-
-echo version = $version
-base=mdadm-$rpmv.tar.gz
-if [ " $arg" != " diff" ]
-then
-  if [ -f $target/$base ]
-  then
-    echo $target/$base exists.
-    exit 1
-  fi
-  trap "rm $target/$base; exit" 1 2 3
-  git archive --prefix=mdadm-$rpmv/ HEAD | gzip --best > $target/$base
-  chmod a+r $target/$base
-  ls -l $target/$base
-  if tar tzf $target/$base | sed 's,[^/]*/,,' | sort | diff -u inventory -
-  then : correct files found
-  else echo "Extra files, or inventory is out-of-date"
-       rm $target/$base
-       exit 1
-  fi
-  rpmbuild -ta $target/$base || exit 1
-  find ~/rpmbuild/RPMS -name "*mdadm-$version-*" \
-     -exec cp {} $target/RPM \;
-  cp ANNOUNCE-$version $target/ANNOUNCE
-  cp ChangeLog $target/ChangeLog
-  if [ " $arg" != " test" ]
-  then
-    echo -n "Confirm signing this release? "
-    read a
-    if [ " $a" != " y" ]; then echo OK - bye. ; exit 1; fi
-    if zcat $target/$base | gpg -ba > $target/$base.sign && gpg -ba $target/ANNOUNCE
-    then
-      kup put $target/$base  $target/$base.sign \
-	  /pub/linux/utils/raid/mdadm/mdadm-$version.tar.gz
-      kup put $target/ANNOUNCE $target/ANNOUNCE.asc /pub/linux/utils/raid/mdadm/ANNOUNCE
-    else
-      echo signing failed
-      exit 1
-    fi
-  fi
-else
-  if [ ! -f $target/$base ]
-  then
-    echo $target/$base does not exist.
-    exit 1
-  fi
-  ( cd .. ; ln -s mdadm.v2 mdadm-$version ; tar chf - --exclude=.git --exclude="TAGS" --exclude='*,v' --exclude='*~' --exclude='*.o' --exclude mdadm --exclude=mdadm'.[^ch0-9]' --exclude=RCS mdadm-$version ; rm mdadm-$version ) | gzip --best > /var/tmp/mdadm-new.tgz
-  mkdir /var/tmp/mdadm-old ; zcat $target/$base | ( cd /var/tmp/mdadm-old ; tar xf - )
-  mkdir /var/tmp/mdadm-new ; zcat /var/tmp/mdadm-new.tgz | ( cd /var/tmp/mdadm-new ; tar xf - )
-  diff -ru /var/tmp/mdadm-old /var/tmp/mdadm-new
-  rm -rf /var/tmp/mdadm-old /var/tmp/mdadm-new /var/tmp/mdadm-new.tgz
-fi
-- 
2.35.3

