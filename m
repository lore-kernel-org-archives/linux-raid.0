Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC3B33CE86;
	Thu, 20 Aug 2026 21:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787260090; cv=none; b=dWYuKOo1tZunTkhDyueMCdyXjz+HkaSdapzuFbuk6xz4jQPqpAcdjb4oj4SNQaDnAjuMsbwrqXK85SXXU2qFZIYDFwPgebJgUGL8ZVgg0isP6eQaViB2CMXT3GCXYBblyn+jBoKockgTEclRQRYW8Cx+v3lwZmSMAvVOXyy1DPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787260090; c=relaxed/simple;
	bh=YjymKqafH5iq1pxMG50aj9Ce0z3orJEy33n15quSfAM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XSzhlEPxmwHqBbY7kFDFKOPcfBxJ6LO5a6j9qU1WYy0+Q7cblqQ5774zmfNHNalSjdM4+a9VOt+PckJUh43W7MYfTMDXX5nsXLnGGkl3tlh0JqYuNNtODI32Yr8CpwDTE/oDhBQyoT05KcNbGcCRiE9h0PJEryYLfGzWeTfgkyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=QFkUPk53; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="QFkUPk53"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=3MrXK8duEoEc25OZXQJo70Rz1o/CTExuLYZC06YeBQM=; b=QFkUPk531zZDcd4jLKb/8HA8HU
	/mZvt8z9kxYmMwcAlaVDO1WcGmXA7weJaFcesdsC11jE04WuKxz88idxlHhqT9rmjx9V4I/U2/JgW
	CmhF7tTfX1ijatk7tnpGI6w0Ep89jINM0/QX3ziy5SLYIUPwypaxe4L/yIyRVs9xyF6dnuuoAvCGk
	3xn+oLkiSZV9fmBgYykUQ5tBp4U3jzYu2eDQoyAvV/A5xmhWeHO6Za7FRheMBjiP3kWvRiLmxODCR
	iQjj6bGq1Jv9cHtbuGUecAjuOzz0zzD3VmdQtPTPo8835oBMARrEGiZ26k4YrGYlf4LPZx2Jk9Xlk
	MuaU+yLA==;
Received: from [151.115.150.205] (port=38124 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1wx9zZ-00000009ZWc-3hX1;
	Thu, 20 Aug 2026 23:08:05 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: song@kernel.org,
	yukuai@fygo.io
Cc: magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH] md: reject v0.90 arrays with too many devices
Date: Thu, 20 Aug 2026 21:07:03 +0000
Message-ID: <20260820210703.3035608-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

The v0.90 superblock has room for MD_SB_DISKS device descriptors, but
super_90_load() only rejects nonpositive raid_disks values. A crafted
superblock can therefore copy a larger value into mddev->raid_disks. When
metadata is next updated, super_90_sync() walks sb->disks[] up to that
count and reads and writes beyond the 4 KiB superblock buffer.

A checksum-valid RAID1 member advertising 64 devices can be assembled by
mdadm --incremental --run. The first write to the array then produces
out-of-bounds writes from super_90_sync() under KASAN.

Reject device counts that cannot be represented by the v0.90 format while
loading the superblock.

Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d1465bcd86c8..873a0e5fce7d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1398,7 +1398,7 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 		goto abort;
 	}
 
-	if (sb->raid_disks <= 0)
+	if (sb->raid_disks <= 0 || sb->raid_disks > MD_SB_DISKS)
 		goto abort;
 
 	if (md_csum_fold(calc_sb_csum(sb)) != md_csum_fold(sb->sb_csum)) {
-- 
2.47.3

