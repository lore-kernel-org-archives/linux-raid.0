Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7793EAC98;
	Wed, 20 May 2026 11:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276400; cv=none; b=LjWU1kZKR3c8vRSwO9+8rsKtbf5McIwz25oNXhVJzxCNLuCt7D+eUjGdynKjdp0qWmA1yWvr9vNkoe3x8qgTZfC2v1C6/2GouTW6Ob7yo+E4ndB669Jak33q1e7vtGIujyYjvggcFZW57YAfnYyd4a8V2CdPMSPFpC1vFsE63OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276400; c=relaxed/simple;
	bh=XJmAvrSMvPOIV12F2+BSOQ/gLGmo3x+WSY6AQHuN5Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mxzmisMg4JXV675akrxQKHPqyReEcT07MrG+XBMJGBnivzCH16/NTqjX6uhs8Q7o8eFPgp7LghyvyomX2psMEcmGhEs2pBVwhpaaYD2ziRsj60lNATZqhmzHCAD1lMRbJwFwvd50xPDqfSmXtCL9SHXR2edpeS8ecwTAMugSg5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E071F000E9;
	Wed, 20 May 2026 11:26:37 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: yukuai@fygo.io,
	linan122@huawei.com,
	xiao@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: update Yu Kuai's email address
Date: Wed, 20 May 2026 19:26:27 +0800
Message-ID: <20260520112627.1264368-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Update Yu Kuai's maintainer entries to use the new fygo.io address.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 882214b0e7db..89940659ef40 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4478,7 +4478,7 @@ F:	Documentation/filesystems/befs.rst
 F:	fs/befs/
 
 BFQ I/O SCHEDULER
-M:	Yu Kuai <yukuai@fnnas.com>
+M:	Yu Kuai <yukuai@fygo.io>
 L:	linux-block@vger.kernel.org
 S:	Odd Fixes
 F:	Documentation/block/bfq-iosched.rst
@@ -24796,7 +24796,7 @@ F:	include/linux/property.h
 
 SOFTWARE RAID (Multiple Disks) SUPPORT
 M:	Song Liu <song@kernel.org>
-M:	Yu Kuai <yukuai@fnnas.com>
+M:	Yu Kuai <yukuai@fygo.io>
 R:	Li Nan <linan122@huawei.com>
 R:	Xiao Ni <xiao@kernel.org>
 L:	linux-raid@vger.kernel.org
-- 
2.51.0

