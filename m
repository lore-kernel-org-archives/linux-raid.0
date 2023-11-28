Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35377883E
	for <linux-raid@vger.kernel.org>; Tue, 28 Nov 2023 03:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FPAM5JkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED77C433C7;
	Tue, 28 Nov 2023 03:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701143898;
	bh=yhOOmkxhs9XhHMymqNvMNb0elULfnlngUfUmTDDJi9s=;
	h=From:To:Cc:Subject:Date:From;
	b=FPAM5JkJtvPROgz1PRiuossqxxvgCEB3DCFNvQMmutzF2fOkvYu8nB33h51ko43xf
	 YHoxco5GTs0r67S6geFj12jpdjoJ9BDolxp8av/EoTwv8aU44tIAs/TmrHvy1bMnA5
	 ZRw8rU4E/FTtq492g2TGROVIVq0yWSeNbM0Izwjp2UTfx3kAkgbIeJXFi4CFc8jKwj
	 ZjY1YdeUX1EwOfmhLHAWHRSCzZZ83be/kyYv6gIfgxo3woLM7VDUpIIiBY+jnm7u21
	 xlJxu0Oi/CL6wr+4Z2/4EJDMG0CmxrGMAWm0p+2/xuLY/O5zvWS6r3jULHHeUox0Ae
	 PcmNFqIm1wZ2A==
From: Song Liu <song@kernel.org>
To: linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	Song Liu <song@kernel.org>
Subject: [PATCH] MAINTAINERS: SOFTWARE RAID: Add Yu Kuai as Reviewer
Date: Mon, 27 Nov 2023 19:58:07 -0800
Message-Id: <20231128035807.3191738-1-song@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add Yu Kuai as reviewer for md/raid subsystem.

Signed-off-by: Song Liu <song@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 012df8ccf34e..a800acf46e6a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20106,6 +20106,7 @@ F:	include/linux/property.h
 
 SOFTWARE RAID (Multiple Disks) SUPPORT
 M:	Song Liu <song@kernel.org>
+R:	Yu Kuai <yukuai3@huawei.com>
 L:	linux-raid@vger.kernel.org
 S:	Supported
 Q:	https://patchwork.kernel.org/project/linux-raid/list/
-- 
2.34.1

