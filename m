Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29EF371876
	for <linux-raid@vger.kernel.org>; Fri, 17 Apr 2026 10:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776420974; cv=none; b=QjFB5AvxQxwHpJstZbpERUsVNKlv/DE3uHl2koYI4EfPwz7qFhWAe71aN+i6nQ2dnsDBcl0Kx3qyjYBeexa8fXI7BFWWVh6nVE8vWo21uClpdR+cXbzN1eFp9qlSmdgosJ9FwVbNdZuMc6XgkUBa9zrzgel+JldllIs2XqNakLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776420974; c=relaxed/simple;
	bh=K4O8u+BRfFdijfvgCn5acsrprBugqpmop9CIo8OU7k8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=SSCa6075H1msRDsQ4ty6n8CzNaeot3AUZPxGg+8gB2NkpLM+0u0k3kfyG6wpUm1kRU5dRyttX3oJVDo0DFLrQntcY1s/Vi/Hbz9tEK+aWx+kPJoPb8ikdDVbpu4/tb5arhKZ6afU49dM+hBDdyP42Pnh6rKZI2K0JuGtpwpRpa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ROWg8L5g; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ROWg8L5g"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260417101609epoutp047dda3cbd6e10a438d5bff3308c2e8f57~nHXWyZzcG1363713637epoutp04T
	for <linux-raid@vger.kernel.org>; Fri, 17 Apr 2026 10:16:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260417101609epoutp047dda3cbd6e10a438d5bff3308c2e8f57~nHXWyZzcG1363713637epoutp04T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1776420969;
	bh=mKMTmrjCcICgSQXz4u0hmUlvqN+uZXoVAXQrXwB9CuU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ROWg8L5gRbqqmMpmwUxGBJf1dGsYghFMKAsoUiQlG/iPDupbe2ux99f4Y0FdwDfQt
	 CgPwCdE8aO8RfrutB6ZklKVLEADChQu2Vl0L47sTrbwLz+N047Clt4iDCU3oeJK6Nj
	 c4ll2XX+a63G28wYW6/4fEr4LUaxhUCh4BIL6+6g=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260417101608epcas5p34ab6abece4a948679a75b9a349cb0279~nHXWKjvh52808728087epcas5p3n;
	Fri, 17 Apr 2026 10:16:08 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.95]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4fxrPg4f39z6B9mB; Fri, 17 Apr
	2026 10:16:07 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260417101607epcas5p204981188700b5f9e3135d80ed7f16eb1~nHXUzaUUJ3187631876epcas5p2s;
	Fri, 17 Apr 2026 10:16:07 +0000 (GMT)
Received: from green245.gost (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260417101605epsmtip2a5dcdcc651cd4df1a7aa945ba063c6dc~nHXS_iqX91345213452epsmtip2H;
	Fri, 17 Apr 2026 10:16:05 +0000 (GMT)
Date: Fri, 17 Apr 2026 15:41:27 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Chaitanya Kulkarni <kch@nvidia.com>
Cc: song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
	kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	kmodukuri@nvidia.com
Subject: Re: [PATCH V3 1/3] block: clear BLK_FEAT_PCI_P2PDMA in
 blk_stack_limits() for non-supporting devices
Message-ID: <20260417101127.uku7q65akj6gwwh4@green245.gost>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260416212633.72650-2-kch@nvidia.com>
X-CMS-MailID: 20260417101607epcas5p204981188700b5f9e3135d80ed7f16eb1
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----9zlBZcaXwhNlkY1lQONG7VXpdyX9cJiniG-eU7bnr-KNWM7L=_219b6_"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260417101607epcas5p204981188700b5f9e3135d80ed7f16eb1
References: <20260416212633.72650-1-kch@nvidia.com>
	<20260416212633.72650-2-kch@nvidia.com>
	<CGME20260417101607epcas5p204981188700b5f9e3135d80ed7f16eb1@epcas5p2.samsung.com>

------9zlBZcaXwhNlkY1lQONG7VXpdyX9cJiniG-eU7bnr-KNWM7L=_219b6_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 16/04/26 02:26PM, Chaitanya Kulkarni wrote:
>BLK_FEAT_NOWAIT and BLK_FEAT_POLL are cleared in blk_stack_limits()
>when an underlying device does not support them.  Apply the same
>treatment to BLK_FEAT_PCI_P2PDMA: stacking drivers set it
>unconditionally and rely on the core to clear it whenever a
>non-supporting member device is stacked.
>
>Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
>---
> block/blk-settings.c | 2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/block/blk-settings.c b/block/blk-settings.c
>index 78c83817b9d3..8274631290db 100644
>--- a/block/blk-settings.c
>+++ b/block/blk-settings.c
>@@ -795,6 +795,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
> 		t->features &= ~BLK_FEAT_NOWAIT;
> 	if (!(b->features & BLK_FEAT_POLL))
> 		t->features &= ~BLK_FEAT_POLL;
>+	if (!(b->features & BLK_FEAT_PCI_P2PDMA))
>+		t->features &= ~BLK_FEAT_PCI_P2PDMA;
>
> 	t->flags |= (b->flags & BLK_FLAG_MISALIGNED);
I think you need below patch[1] as well to unset this here.
Also I feel better to include Mike,Mikulas and dm-devel mailing list as well.

Thanks,
Nitesh

[1]
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index dc2eff6b739d..0442c1f4c686 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -590,7 +590,8 @@ int dm_split_args(int *argc, char ***argvp, char *input)
  static void dm_set_stacking_limits(struct queue_limits *limits)
  {
  	blk_set_stacking_limits(limits);
-	limits->features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT | BLK_FEAT_POLL;
+	limits->features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT | BLK_FEAT_POLL \
+	BLK_FEAT_PCI_P2PDMA;
  }

------9zlBZcaXwhNlkY1lQONG7VXpdyX9cJiniG-eU7bnr-KNWM7L=_219b6_
Content-Type: text/plain; charset="utf-8"


------9zlBZcaXwhNlkY1lQONG7VXpdyX9cJiniG-eU7bnr-KNWM7L=_219b6_--
