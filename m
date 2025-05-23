Received: from outbound.pv.icloud.com (p-west1-cluster2-host4-snip4-10.eps.apple.com [57.103.64.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759E6224B00
	for <linux-raid@vger.kernel.org>; Fri, 23 May 2025 09:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.64.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747991497; cv=none; b=gVIU87MgoGC2s2xLLCGFK/CNWAHiI+SChcfI1pacDRfZ0QpIketSfJ+KvyA9I1CyjcNNN0ZiElz626JXDELAtF19vJM+EnlHEQ0KLFD/y8BPUmAd7sq427x6S84EhyN7bOiRJdKvqTg+GFrVovaDGxpMf1A2vOEBeoh9GHpb3y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747991497; c=relaxed/simple;
	bh=Rn3aGzN39kw+6A/KGme0TuKu0ZDgcH2M+KObv6lUWMI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pae6Pog7TWQqJBAD2rVaKb0iBi1vs4iQOXBmIbkzB1XUNlnRt3Wl9rFrCnnX8+zmukeirhwDVf4LDSglrFqQsf2eDPRGn7P0bSAGTiDAhkhoIGHlN9lR2y04VuUm2u5QzglINF9gnrjanrDmNvp6gRdU4RQqF0w+eicM4S8UGa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ai-sast.com; spf=pass smtp.mailfrom=ai-sast.com; dkim=pass (2048-bit key) header.d=ai-sast.com header.i=@ai-sast.com header.b=LoLDulS0; arc=none smtp.client-ip=57.103.64.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ai-sast.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ai-sast.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ai-sast.com header.i=@ai-sast.com header.b="LoLDulS0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ai-sast.com; s=sig1;
	bh=kyr0ei/0QtFiSgcFQ8uCM/YBzxpFKihu5zkgiWsbYag=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme;
	b=LoLDulS0vwf7/f/79cn5wRdtShB6IMIC0B7eENYhDJfWClIgrKNXlAq4PEs40vtJz
	 ll1ySFkLS+q37l9yxdVPqbVzG9iTeepAk3OzSHPWmKV9s3OIOfpsn6a+/ebpQAcnXB
	 W8Pin1u5bsVUwi9gnK1Ka+XfXTOqUvGq/vTW54A+Hc+adBY/HnzBXDE/hEfKLgQO/6
	 2wI7cfjoEFawX+8pSwYLLEGuY5uOLvE7KLiOtvP6Izg7A6e9hbePqH3888BiZMIZb1
	 PNMPa3K7OINLvFe7/pAlfKsU0sZofa0XuXNx3mccM5sl0FH1rySaIw2/yT+5gxBbM/
	 93Qc7FE6JHQfw==
Received: from outbound.pv.icloud.com (localhost [127.0.0.1])
	by outbound.pv.icloud.com (Postfix) with ESMTPS id 2443018001C0;
	Fri, 23 May 2025 09:11:32 +0000 (UTC)
Received: from localhost.localdomain (pv-asmtp-me-k8s.p00.prod.me.com [17.56.9.36])
	by outbound.pv.icloud.com (Postfix) with ESMTPSA id 57C7318001D5;
	Fri, 23 May 2025 09:11:31 +0000 (UTC)
From: Ye Chey <yechey@ai-sast.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ye Chey <yechey@ai-sast.com>
Subject: [PATCH] md: fix potential NULL pointer dereference in md_super_write
Date: Fri, 23 May 2025 17:11:26 +0800
Message-ID: <20250523091126.99729-1-yechey@ai-sast.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: JrlDn1SXaerAFmv0sT5zdUNw7hwrJVdO
X-Proofpoint-GUID: JrlDn1SXaerAFmv0sT5zdUNw7hwrJVdO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-23_02,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 clxscore=1030 suspectscore=0 adultscore=0 spamscore=0 bulkscore=0
 phishscore=0 mlxscore=0 mlxlogscore=727 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2503310001 definitions=main-2505230080

The bio_alloc_bioset() call in md_super_write() could fail under memory
pressure and return NULL. Add a check to handle this case gracefully by
returning early, preventing a potential NULL pointer dereference.

Signed-off-by: Ye Chey <yechey@ai-sast.com>
---
 drivers/md/md.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9daa78c5f..492cbc1c7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1002,6 +1002,9 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 			      REQ_OP_WRITE | REQ_SYNC | REQ_IDLE | REQ_META
 				  | REQ_PREFLUSH | REQ_FUA,
 			      GFP_NOIO, &mddev->sync_set);
+	if (!bio) {
+		return;
+	}
 
 	atomic_inc(&rdev->nr_pending);
 
-- 
2.44.0

