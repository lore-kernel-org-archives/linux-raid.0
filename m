Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9303461FFE
	for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 05:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776836146; cv=none; b=J7YLjRbt/7pveVvI5eCETYODiXPbGRoEwy6xHhArscupxWIST3nBTBftKyQ6A/+iA/HUJ7qUPdWUrTLQc2s3QNjNjRxmGhGqgZq0p5qAbUE8E/z5mLOTbEjCRoOwDZ2PTvMsK4XLuvG4Y1WHyjw4FH482sBGi1rLYgdeXWuCCmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776836146; c=relaxed/simple;
	bh=loOUS5E6VOrm5T8+Ff+XfP0gT76n8lLCxYJvTx2vS2U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=qaFoEhceWQOJ0cBbU7+qcTlBLqFpWjI0aXMTWD4a2wEF5qDox/6TIShkMJvl/MX/reQ9NrmgDK8LW+rk4L3Pp+NMHbuv3rd9sx9EYp39aJ2JWQdJwFuxDOwaecViFuV0is5WI5gG64o9M8WyZ6ks/V45B55ckjO8xFyZD4/p+sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=XiMxAHBd; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XiMxAHBd"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260422053541epoutp045009605fbcf47ed206dc484d32fe6e1d~olw5lwt_s1742917429epoutp04r
	for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 05:35:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260422053541epoutp045009605fbcf47ed206dc484d32fe6e1d~olw5lwt_s1742917429epoutp04r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1776836141;
	bh=loOUS5E6VOrm5T8+Ff+XfP0gT76n8lLCxYJvTx2vS2U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XiMxAHBddcgoaGSAejXZeG6mmlqLgwWRbwjZ++hoOKhvJzP9dfr4zLogMHh1IO4/j
	 jeuXUxMS4LpdlSuZW7CmvLixjxHIFHvyo/oTQraXsAzjTuNBLyJyyQ4oJh0a0HUigB
	 qsPG7b4Sxg26eIaoZ5EhLJWzQ1flajHdTcyiwNKo=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260422053540epcas5p39f4e1d11fd779659a4b994ec75142669~olw5ZtbKV1946519465epcas5p3V;
	Wed, 22 Apr 2026 05:35:40 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.89]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4g0nxl5LnLz6B9mF; Wed, 22 Apr
	2026 05:35:39 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260422053539epcas5p17a529dd8e361d903389eaa76d8626a03~olw31Cg1e1824418244epcas5p1_;
	Wed, 22 Apr 2026 05:35:39 +0000 (GMT)
Received: from green245.gost (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260422053537epsmtip15ecd16b5ed208f01e6b0ad913717187c~olw2G6xo91451414514epsmtip1s;
	Wed, 22 Apr 2026 05:35:37 +0000 (GMT)
Date: Wed, 22 Apr 2026 11:00:57 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: "song@kernel.org" <song@kernel.org>, "yukuai@fnnas.com"
	<yukuai@fnnas.com>, "linan122@huawei.com" <linan122@huawei.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>, "sagi@grimberg.me"
	<sagi@grimberg.me>, "linux-raid@vger.kernel.org"
	<linux-raid@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, Kiran Modukuri <kmodukuri@nvidia.com>
Subject: Re: [PATCH V3 1/3] block: clear BLK_FEAT_PCI_P2PDMA in
 blk_stack_limits() for non-supporting devices
Message-ID: <20260422053057.fuj3nqkystzeqhq2@green245.gost>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <a2a14d08-cb31-453a-9ddd-71f7dd4d6992@nvidia.com>
X-CMS-MailID: 20260422053539epcas5p17a529dd8e361d903389eaa76d8626a03
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----njBzzhCGtS-aHlIth.2Pj0w1Th4tsb8PwJn50ZNtPKFt4kYn=_33152_"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260417101607epcas5p204981188700b5f9e3135d80ed7f16eb1
References: <20260416212633.72650-1-kch@nvidia.com>
	<20260416212633.72650-2-kch@nvidia.com>
	<CGME20260417101607epcas5p204981188700b5f9e3135d80ed7f16eb1@epcas5p2.samsung.com>
	<20260417101127.uku7q65akj6gwwh4@green245.gost>
	<a2a14d08-cb31-453a-9ddd-71f7dd4d6992@nvidia.com>

------njBzzhCGtS-aHlIth.2Pj0w1Th4tsb8PwJn50ZNtPKFt4kYn=_33152_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On 21/04/26 10:30PM, Chaitanya Kulkarni wrote:
>On 4/17/26 03:11, Nitesh Shetty wrote:
>> On 16/04/26 02:26PM, Chaitanya Kulkarni wrote:
>>> BLK_FEAT_NOWAIT and BLK_FEAT_POLL are cleared in blk_stack_limits()
>>> when an underlying device does not support them.  Apply the same
>>> treatment to BLK_FEAT_PCI_P2PDMA: stacking drivers set it
>>> unconditionally and rely on the core to clear it whenever a
>>> non-supporting member device is stacked.
>>>
>>> Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
>>> ---

Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>

------njBzzhCGtS-aHlIth.2Pj0w1Th4tsb8PwJn50ZNtPKFt4kYn=_33152_
Content-Type: text/plain; charset="utf-8"


------njBzzhCGtS-aHlIth.2Pj0w1Th4tsb8PwJn50ZNtPKFt4kYn=_33152_--
