Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5D9604A9
	for <linux-raid@vger.kernel.org>; Tue, 20 Feb 2024 11:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708426834; cv=none; b=Hdn9C7T1RF5PGMYn8bnfVpb5261ziRh/Fd+H2HjcknZe3SESZiqIQTpWmDtfTPgi5gQfTxKSu04xsS8jUyWuoHDVD1cvozmVV378W/2goWgLV7t8hGN3X96Z2FsD3rfjAZUMr8A5EihfQ8tMlHMEEuMQJedHQNzpQskq/QcheJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708426834; c=relaxed/simple;
	bh=goeZTsVUWl8XpsWDbgsqdphIdZ2DWCpOirbPrvz3Iag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MB2NtceVjs1BhAwcE8B2ycPgGRqRm3EXOVtfNGththq41rM3RRtVsvx2iX54DCtQtDorDR2iD+fwUEf+05z5jc31sunmoSMyY2wKaBQy+a22lPjceMFdSuhK6SxaxBrTiz2oSy17fzfTgv5lLuPcb+UEscLhLayXXtmVUAobEkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bFVDkXEU; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bFVDkXEU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708426833; x=1739962833;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=goeZTsVUWl8XpsWDbgsqdphIdZ2DWCpOirbPrvz3Iag=;
  b=bFVDkXEUnczyVWrKCHokkSlkh1XWhFSGh5FpGkazMYMHT3dRYwKdoOfV
   yDvz3mrjJezpkD6mcXZVkGB4kIDOrEaMYUUr2TUjUsSL1kIkJkDEmvqka
   DoE3c2wYWV5DBWmZdMEEgw/q/jWNxyeu6ldCmGb7/z2P9jtvy2POgZTmK
   BJjTRygHqNaKCBEfpvfBQZouNUCZb9HHH/MQQiUaYoAc7McjwoH0oRcPO
   Dj3yQ3kKMhJWWTuUjwEjUVS2yoc2hGhHPudufaYLeZlZWhdOwS0diDNKF
   SmIJEuAmnZpGtT4FmS34adLwB9YYDEm3AJYtn/GgA1Z5Sh7E+s7/pXng0
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="13934389"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="13934389"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 03:00:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="4735223"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmviesa010.fm.intel.com with ESMTP; 20 Feb 2024 03:00:31 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 6/6] mdmon: refactor md device name check in main()
Date: Tue, 20 Feb 2024 11:56:12 +0100
Message-Id: <20240220105612.31058-7-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240220105612.31058-1-mateusz.kusiak@intel.com>
References: <20240220105612.31058-1-mateusz.kusiak@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor mdmon main function to verify if fd is valid prior to checking
device name. This is due to static code analysis complaining after
change b938519e7719 ("util: remove obsolete code from get_md_name").

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 mdmon.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index a2038fe6c35f..5fdb5cdb5a49 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -302,12 +302,12 @@ static int mdmon(char *devnm, int must_fork, int takeover);
 int main(int argc, char *argv[])
 {
 	char *container_name = NULL;
-	char *devnm = NULL;
 	int status = 0;
 	int opt;
 	int all = 0;
 	int takeover = 0;
 	int dofork = 1;
+	int mdfd = -1;
 	bool help = false;
 	static struct option options[] = {
 		{"all", 0, NULL, 'a'},
@@ -410,19 +410,20 @@ int main(int argc, char *argv[])
 		free_mdstat(mdstat);
 
 		return status;
-	} else {
-		int mdfd = open_mddev(container_name, 0);
-		devnm = fd2devnm(mdfd);
+	}
+
+	mdfd = open_mddev(container_name, 0);
+	if (is_fd_valid(mdfd)) {
+		char *devnm = fd2devnm(mdfd);
 
 		close(mdfd);
-	}
 
-	if (!devnm) {
-		pr_err("%s is not a valid md device name\n",
-			container_name);
-		return 1;
+		if (devnm)
+			return mdmon(devnm, dofork && do_fork(), takeover);
 	}
-	return mdmon(devnm, dofork && do_fork(), takeover);
+
+	pr_err("%s is not a valid md device name\n", container_name);
+	return 1;
 }
 
 static int mdmon(char *devnm, int must_fork, int takeover)
-- 
2.35.3

