Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91DE79B6F
	for <linux-raid@vger.kernel.org>; Tue,  4 Jun 2024 16:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717519137; cv=none; b=ZWnf+p1hivpPsRqBGUwCXyShMtAiGfGNLM4wo4qguswLIK+14YfHETGz4nFjsANM6573EeFjMQz9UV7kJ+CqNGNweZZZ/qgduoJYJtlL2/3hf3UNGS95UiZtqytGXWBjR0tIJkUfIM4FfNHN0iiQptwiziMqmXljK0H1LO6mMmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717519137; c=relaxed/simple;
	bh=Q/G1zf/y511ix9xiXvv9mnNG908U9FI+07DJPQSL3UU=;
	h=From:To:Cc:Date:Message-Id:In-Reply-To:References:MIME-Version:
	 Subject; b=iB/z70Zr1Vf9nOXW95phBq7Woxib/P/9sK2H/N4r3We96MW3IUpZqqt1K4Qp24YmOvvpuY0951p9Ccte4xrZ0OGtERtCXmsjG43CxZpTsymWd1698q9qpsXH+kWFbY5PyYd/114i6ZNNuE1lD+NfJJhOHvjOqYyD0OHwXMWq5Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=LdXz1/b1; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="LdXz1/b1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
	Message-Id:Date:Cc:To:From:content-disposition;
	bh=Q0Iy3dx/zS6LNun889GojcffT8Z0wrYR+zt6WgVonhU=; b=LdXz1/b13IAPXHpOGvT14HZ6Gz
	Qk3gaBWIBPhT8Mf0OWLw58CRi2RSIVwtSwFLvVJRpZM5vFEEJoAXPeZB1MzWtPnk8Q7Wi+Cjo02fr
	Tbsw7Ngh/vk5R5a9m6S9R21m8QMy2T9hzlx9KU0xSeUO8wtfbs9sk0u/pJeKWCNe2stZqNHDV2C9p
	VFUsdyZsQqayLzjfmFfqpXT7n2DfAtK7XBCl29g+LoglmGRRwpELgXZKMDxiABDsJdefCiVl+4CLW
	M3I7saA+9d3XcNevZ55kTR7bOZYaglVj4rkBYT8e2Tq6ZM/RpiV4XcVv3F+tM4yHoijvg4qlCzNYQ
	VCHtklSA==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
	by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <gunthorp@deltatee.com>)
	id 1sEXBT-000frt-0f;
	Tue, 04 Jun 2024 10:38:51 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.96)
	(envelope-from <gunthorp@deltatee.com>)
	id 1sEXBG-003Let-2U;
	Tue, 04 Jun 2024 10:38:38 -0600
From: Logan Gunthorpe <logang@deltatee.com>
To: linux-raid@vger.kernel.org,
	Jes Sorensen <jes@trained-monkey.org>,
	Xiao Ni <xni@redhat.com>
Cc: Guoqing Jiang <guoqing.jiang@linux.dev>,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Logan Gunthorpe <logang@deltatee.com>
Date: Tue,  4 Jun 2024 10:38:37 -0600
Message-Id: <20240604163837.798219-3-logang@deltatee.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240604163837.798219-1-logang@deltatee.com>
References: <20240604163837.798219-1-logang@deltatee.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jes@trained-monkey.org, xni@redhat.com, guoqing.jiang@linux.dev, mariusz.tkaczyk@linux.intel.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
X-Spam-Level: 
Subject: [PATCH mdadm 2/2] mdadm: Block SIGCHLD processes before starting children
X-SA-Exim-Version: 4.2.1 (built Wed, 06 Jul 2022 17:57:39 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)

There is a small race condition noticed during code review, but
never actully hit in practice, with the write_zero feature.

If a write zeros fork finishes quickly before wait_for_zero_forks()
gets called, then the SIGCHLD will be delivered before the signalfd
is setup.

While this is only theoretical, fix this by blocking the SIGCHLD
signal before forking any children.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 Create.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Create.c b/Create.c
index 4f992a22b7c9..bd4875e4a408 100644
--- a/Create.c
+++ b/Create.c
@@ -401,6 +401,7 @@ static int add_disks(int mdfd, struct mdinfo *info, struct shape *s,
 	 */
 	sigemptyset(&sigset);
 	sigaddset(&sigset, SIGINT);
+	sigaddset(&sigset, SIGCHLD);
 	sigprocmask(SIG_BLOCK, &sigset, &orig_sigset);
 	memset(zero_pids, 0, sizeof(zero_pids));
 
-- 
2.39.2

