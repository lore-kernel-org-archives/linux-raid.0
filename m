Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5D21B7F3
	for <linux-raid@vger.kernel.org>; Tue, 16 Jan 2024 11:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AXgccyfG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705404406; x=1736940406;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bPqdCBNCtFJ6rYiCOTKYqNDBlaXmmDRJ76b5eSdNank=;
  b=AXgccyfGco1Tdy8RUAwT3pBH9LkfRUGkSpQuXn+v1EQTnY9JYt7MreUR
   +LP3i+EmPJZXGH3UaBegTtSG0al4D3ZAAmpNP4RSRwsvswvE8Cg4NYbBo
   0wP4SPtUkqM0mYajfjvlQ9Xw+HuMmt5GDK6DK8zkeVQXfl3Na3B+XzwYl
   fUDEicIjTRYOGGohTSIXfjXHhyyPAengxrgovGEJdwjmGQjWK079YCe6m
   s/IXbdJmZH7JssTDqN4DGS0FGTBZyhrrLuRmOzqbQ5WmOb2WoPZMzxR7B
   Ad8QxKhj0uq0ZI4Ho6mjQLbmIfGVpfz9LKOpRfi+4AWj9MCMQhk69kHfB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="21307406"
X-IronPort-AV: E=Sophos;i="6.05,199,1701158400"; 
   d="scan'208";a="21307406"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 03:26:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,199,1701158400"; 
   d="scan'208";a="26111964"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmviesa001.fm.intel.com with ESMTP; 16 Jan 2024 03:26:45 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 7/8] Grow: Move update_tail assign to Grow_reshape()
Date: Tue, 16 Jan 2024 12:24:33 +0100
Message-Id: <20240116112434.30705-8-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240116112434.30705-1-mateusz.kusiak@intel.com>
References: <20240116112434.30705-1-mateusz.kusiak@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Due to e919fb0af245 ("FIX: Enable metadata updates for raid0") code
can't enter super-intel.c:3415, resulting in checkpoint not being
saved to metadata for second volume in matrix raid array.
This results in checkpoint being stuck at last value for the
first volume.

Move st->update_tail to Grow_reshape() so it is assigned for each
volume.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 Grow.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/Grow.c b/Grow.c
index f95dae82ef0d..5498e54fec11 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2085,9 +2085,10 @@ int Grow_reshape(char *devname, int fd,
 			if (!mdmon_running(st->container_devnm))
 				start_mdmon(st->container_devnm);
 			ping_monitor(container);
-			if (mdmon_running(st->container_devnm) &&
-					st->update_tail == NULL)
-				st->update_tail = &st->updates;
+			if (mdmon_running(st->container_devnm) == false) {
+				pr_err("No mdmon found. Grow cannot continue.\n");
+				goto release;
+			}
 		}
 
 		if (s->size == MAX_SIZE)
@@ -3048,6 +3049,8 @@ static int reshape_array(char *container, int fd, char *devname,
 		dprintf("Cannot get array information.\n");
 		goto release;
 	}
+	if (st->update_tail == NULL)
+		st->update_tail = &st->updates;
 	if (array.level == 0 && info->component_size == 0) {
 		get_dev_size(fd, NULL, &array_size);
 		info->component_size = array_size / array.raid_disks;
@@ -5152,9 +5155,7 @@ int Grow_continue_command(char *devname, int fd,
 			start_mdmon(container);
 		ping_monitor(container);
 
-		if (mdmon_running(container))
-			st->update_tail = &st->updates;
-		else {
+		if (mdmon_running(container) == false) {
 			pr_err("No mdmon found. Grow cannot continue.\n");
 			ret_val = 1;
 			goto Grow_continue_command_exit;
-- 
2.35.3

