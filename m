Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CBA13957E
	for <linux-raid@vger.kernel.org>; Mon,  6 Oct 2025 02:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759716513; cv=pass; b=of0qttumsR2QqyiV51rqmJG7oaxiM/GlfX0E31CIx6kpcLvdL+89Tg4GMuAs5lBoAPIhr8TN2khiVmP0VN9zfg54FOuoVxD6upjPsym3BrJtUzS6yrO63+Jw0ckwRBkGNJnH3NmuxbG84Ww488QW3mQVyvjDHrE5PElWf7/+2so=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759716513; c=relaxed/simple;
	bh=eZt4VLfDO7PMLr/qNMMV69IsVMhsb9BkOQKJB0Zu/pM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YYKjOLyyQzQ3uB0O/JZrgc/2fKatUXCGOO4rHHEuRHLaQM8EE7Z1owX0JQroS0+Ms2dOpfPPzmGX+fE6mugunbWhajAMlrrN3HVcYjxHpMyk+XTVMV1IjQkOUXTcanbk+k8uu9S+ogHHyXCs0hrypgkM4/0BH9yglSx7QXH+g/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=yukuai.org.cn; spf=pass smtp.mailfrom=yukuai.org.cn; dkim=pass (1024-bit key) header.d=yukuai.org.cn header.i=hailan@yukuai.org.cn header.b=V4qEwpyc; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=yukuai.org.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yukuai.org.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yukuai.org.cn header.i=hailan@yukuai.org.cn header.b="V4qEwpyc"
ARC-Seal: i=1; a=rsa-sha256; t=1759716500; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=QQnfkc3fX6JbWcpLPCKXNxVniYq2T8g1rLugPgS7VRmYkWwiHXMZ/aoWOV2L3dL7fGo0rLHDEFZLFawPDVgk7Iym7cf+Kt9je5jJDYBHANES9tWl9Q3+BLmBDZxIUjSsx4hKJ48Nr9efhm0Tj2hRjLHYb7eFE/h/2ZXz/9SwvbU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1759716500; h=Content-Type:Content-Transfer-Encoding:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To:Cc; 
	bh=14C/zWoC0l6b5Rtal+cMLhqNgRzU6XvA8hCSuPDYGWE=; 
	b=cRX5P8t5UJKfe4RGmomoV7qDZZ0Ei+LBQhnt1eZHKGRytS2EJ6FZf6IbHTlghNPSAfJJ/VWYoCYwSnQSYYq6uLjcwIUdcRVUGZ2Bcd49pgOBtCnHFpHvzusS6Lgdx5nwT9dC/CuSvAC3+SsdjExMN4j2DNuQS7m5U2awG3ov1ek=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=yukuai.org.cn;
	spf=pass  smtp.mailfrom=hailan@yukuai.org.cn;
	dmarc=pass header.from=<hailan@yukuai.org.cn>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1759716500;
	s=zmail; d=yukuai.org.cn; i=hailan@yukuai.org.cn;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=14C/zWoC0l6b5Rtal+cMLhqNgRzU6XvA8hCSuPDYGWE=;
	b=V4qEwpyctC5tKyfoI0mHLJn36x2osldTnDp39DQn1u6dB1y7EbGGpujGqUdEpOPz
	HwCiPUKnPkgJUJl9d0URcMpH7DvaBG8GguMhbFj8SGLZmmzWcEngB/xZ5N+vMNawlXv
	y3JVA4b/CuwwRGxBU3ZFrhjIfuycKip/fPEUHgB8=
Received: by mx.zohomail.com with SMTPS id 1759716496484362.8452131006227;
	Sun, 5 Oct 2025 19:08:16 -0700 (PDT)
Message-ID: <3bf12e32-db86-4958-a450-4507adc636f0@yukuai.org.cn>
Date: Mon, 6 Oct 2025 10:08:09 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: don't add empty badblocks record table in
 super_1_load()
To: colyli@fnnas.com, linux-raid@vger.kernel.org
References: <20251005162159.25864-1-colyli@fnnas.com>
From: Yu Kuai <hailan@yukuai.org.cn>
In-Reply-To: <20251005162159.25864-1-colyli@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Hi,

在 2025/10/6 0:21, colyli@fnnas.com 写道:
> From: Coly Li <colyli@fnnas.com>
>
> In super_1_load() when badblocks table is loaded from component disk,
> current code adds all records including empty ones into in-memory
> badblocks table. Because empty record's sectors count is 0, calling
> badblocks_set() with parameter sectors=0 will return -EINVAL. This isn't
> expected behavior and adding a correct component disk into the array
> will incorrectly fail.
>
> This patch fixes the issue by checking the badblock record before call-
> ing badblocks_set(). If this badblock record is empty (bb == 0), then
> skip this one and continue to try next bad record.
>
> Signed-off-by: Coly Li <colyli@fnnas.com>

This problem is from user space tools, the flag MD_FEATURE_BAD_BLCOKS means
that the rdev have badblocks presents, and this flag should not be set in
the superblock for new disk.

Please take a look at following mdadm commit, and see if your problem still
exist.

commit 4e2e208c8d3e9ba0fae88136d7c4cd0292af73b0
Author: Wu Guanghao <wuguanghao3@huawei.com>
Date:   Tue Mar 11 03:11:55 2025 +0000

     super1: Clear extra flags when initializing metadata


Thanks,
Kuai

> ---
>   drivers/md/md.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 41c476b40c7a..b4b5799b4f9f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1873,9 +1873,14 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
>   		bbp = (__le64 *)page_address(rdev->bb_page);
>   		rdev->badblocks.shift = sb->bblog_shift;
>   		for (i = 0 ; i < (sectors << (9-3)) ; i++, bbp++) {
> -			u64 bb = le64_to_cpu(*bbp);
> -			int count = bb & (0x3ff);
> -			u64 sector = bb >> 10;
> +			u64 bb, sector;
> +			int count;
> +
> +			bb = le64_to_cpu(*bbp);
> +			if (bb == 0)
> +				continue;
> +			count = bb & (0x3ff);
> +			sector = bb >> 10;
>   			sector <<= sb->bblog_shift;
>   			count <<= sb->bblog_shift;
>   			if (bb + 1 == 0)
