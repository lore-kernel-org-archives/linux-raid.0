Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7609335502D
	for <linux-raid@vger.kernel.org>; Tue, 21 Oct 2025 12:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761049700; cv=none; b=VT9dxBVzvXMDK068V2Krl2JE+QNVt8+XVfzEradSXkdQLgLMYPM2Z3uoQfVZRqb6JwEj9+E542xl8mqTAtj/Y/zTcOEKHNG7XUX0XK0293nS/O7wqx04jR1ZzE0rT5Hn8ZZY0oAU1QDfqjBfCkGtR8dWSH58lawn68qnPnCIXj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761049700; c=relaxed/simple;
	bh=lf2Sb+8Zk7twZPuvQ/6AL+NWO66Sm6H3vLwzlI2jZEk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=GtuAQnxsrKmE0rPNHzn0X+5HhxadpQSCMmUYZNCpk0AeWsGMDgPYFShEdXdsQ8C02HXk+ywY2inZdIC3IL1nVRY9ZfJAIvp2X6ZnMgTsBbZS1G6wF1IfOgBlFv8XM4VyHtCql5MxaQOa9LX3K/P9Llrv9BLtk79dt2iB/Jsr4ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE37C4CEF1;
	Tue, 21 Oct 2025 12:28:19 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: yukuai@fnnas.com,
	song@kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Update Yu Kuai's E-mail address
Date: Tue, 21 Oct 2025 20:28:00 +0800
Message-ID: <20251021122800.3158836-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change to my new email address on fnnas.com.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0554bf05b426..ec818c5b8cc8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4269,7 +4269,7 @@ F:	Documentation/filesystems/befs.rst
 F:	fs/befs/
 
 BFQ I/O SCHEDULER
-M:	Yu Kuai <yukuai3@huawei.com>
+M:	Yu Kuai <yukuai@fnnas.com>
 L:	linux-block@vger.kernel.org
 S:	Odd Fixes
 F:	Documentation/block/bfq-iosched.rst
@@ -23610,7 +23610,7 @@ F:	include/linux/property.h
 
 SOFTWARE RAID (Multiple Disks) SUPPORT
 M:	Song Liu <song@kernel.org>
-M:	Yu Kuai <yukuai3@huawei.com>
+M:	Yu Kuai <yukuai@fnnas.com>
 L:	linux-raid@vger.kernel.org
 S:	Supported
 Q:	https://patchwork.kernel.org/project/linux-raid/list/
-- 
2.51.0

