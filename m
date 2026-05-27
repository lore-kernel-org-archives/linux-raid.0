Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F44332623
	for <linux-raid@vger.kernel.org>; Wed, 27 May 2026 14:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779891582; cv=none; b=cS+wdIh9cfEYPJMM08D1eOmShnoZWHqu0JVUh9vrLyFx4+VnDzyouujs4VdhB2D9KN5ZCiZikda3SdSCALDnz98GaC0Zm5gm3LgkP8e1BfRCzxilmVNP62/AGiYye/p2z+OW27GcuJ4bBBi68r6O5ti83Ug1BPnXWetCjURFoFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779891582; c=relaxed/simple;
	bh=mQJDqouUJlZEmzrPX3pemtvDGOwxEDWZtCzN8N6Wvcs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PYxEIA7K6R4l8jqkxawWwCOXocD60klaApvZWjBRbGKL5o5wx2bn6/Aayk6hwZyEsq+9HvyWNzBgN7b2kPa6zPVXZlyJNkDJJJySap2XlVa2b07zv/QPeHjx5x844rd5sDFB8G7Q03HnqoadRvDbkaMKfcfKJnlyoSWlnVgpABo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fSn048pb; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fSn048pb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779891578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oYfOcauSnsZXq0jgGW6lCEoP3kXGvAARdsZ808vv1Ho=;
	b=fSn048pb27K1Qwwqb5vPjjFU9qog955DeaR0blGdoMRihaU+PbcPjGMaKK0bmdFtO2BOMQ
	dMiwYTypNL/P4GZ4WXNxGHupddhFe5Md+RzO1Gc9sE9/Q/J6N5UwTum1EDifIQQ0nlZCpT
	NtEUB6aC4GgP+fLQv9o39jkBLSHCAZs=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/raid0: use str_plural helper in dump_zones
Date: Wed, 27 May 2026 16:19:33 +0200
Message-ID: <20260527141932.1243503-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=987; i=thorsten.blum@linux.dev; h=from:subject; bh=mQJDqouUJlZEmzrPX3pemtvDGOwxEDWZtCzN8N6Wvcs=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFlif0veS4adUHrRsS41pIDtckal6al23+c8dy+e/Mx7z Y5z2ud7HaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjARFQWG/xGnPb453Vr87N+M bevEVxVqHXy9eOGff195Vjw1uNIgf28BI8OEy89vnvW5ei7LInaf8/5D+8qDJsqLd93l1dh6iV/ droQLAA==
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace the manual ternary "s" pluralization with str_plural() to
simplify the code.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/md/raid0.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 5e38a51e349a..699c2de8983a 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -14,6 +14,7 @@
 #include <linux/seq_file.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/string_choices.h>
 #include <trace/events/block.h>
 #include "md.h"
 #include "raid0.h"
@@ -43,7 +44,7 @@ static void dump_zones(struct mddev *mddev)
 	int raid_disks = conf->strip_zone[0].nb_dev;
 	pr_debug("md: RAID0 configuration for %s - %d zone%s\n",
 		 mdname(mddev),
-		 conf->nr_strip_zones, conf->nr_strip_zones==1?"":"s");
+		 conf->nr_strip_zones, str_plural(conf->nr_strip_zones));
 	for (j = 0; j < conf->nr_strip_zones; j++) {
 		char line[200];
 		int len = 0;
