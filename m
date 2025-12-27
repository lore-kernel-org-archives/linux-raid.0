Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088443A1E8C;
	Sat, 27 Dec 2025 01:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766799278; cv=none; b=l0SCgDXq3+4nQptNBhLY5E5u31owArsNJmQfDl3+YqXYwtnJiJGOCfmhEN5B29SQ70Q1JBJbkGkfKfwgaW76I3zXfjJJVNfz5zGWwrcdO2SAbA+Fpyz11S/cwYDrJG45+4IgupkP7mQEahEZpxCaEAtJCg/qw924+d2veVkGvqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766799278; c=relaxed/simple;
	bh=CKQxgTcRgEI1IfDbIslRP9Lk5+lARk47Uy7ixNNvDV0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nebi66n1Bpb+s5r2eRvVmMrdlZ7fM5vnl9kYTUDy+PVDjPiM1pOPn6pxL8NcL1GKeYZTY1XpbWQJhgCcjUwAuDiC7y1yh9McQN9N7BtU0tZfGijOSia8jEtmrX53c7eVxqzjftwVerA9nGJB3D7bHfIMFva13lADIulr3lLJZ2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ddQ4D3zvTzYQtpL;
	Sat, 27 Dec 2025 09:33:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 79030405D0;
	Sat, 27 Dec 2025 09:34:31 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXePilN09p1lJ3Bg--.26831S3;
	Sat, 27 Dec 2025 09:34:31 +0800 (CST)
Message-ID: <7f022f36-f543-a767-36e0-18df6d7ade1a@huaweicloud.com>
Date: Sat, 27 Dec 2025 09:34:29 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 06/15] md/raid1,raid10: use folio for sync path IO
To: linan666@huaweicloud.com, song@kernel.org, yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, xni@redhat.com,
 yangerkun@huawei.com, yi.zhang@huawei.com
References: <20251217120013.2616531-1-linan666@huaweicloud.com>
 <20251217120013.2616531-7-linan666@huaweicloud.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20251217120013.2616531-7-linan666@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXePilN09p1lJ3Bg--.26831S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tF1xJw1UWr45XF1fWry3urg_yoW8JFyfp3
	ZxWw4fZr4rJFWfuFsxGr4DCw1fK3W8tayUJFsrJw1rXF1xZr9xKF4UXa18Xr95XrW8GF1x
	Xr15tr45uF15A3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9E14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbsYFJUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/12/17 20:00, linan666@huaweicloud.com 写道:
> From: Li Nan <linan122@huawei.com>
> 
> Convert all IO on the sync path to use folios. Rename page-related
> identifiers to match folio.
> 
> Retain some now-unnecessary while and for loops to minimize code
> changes, clean them up in a subsequent patch.
> 
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/md.c       |   2 +-
>   drivers/md/raid1-10.c |  60 ++++--------
>   drivers/md/raid1.c    | 155 ++++++++++++++-----------------
>   drivers/md/raid10.c   | 207 +++++++++++++++++++-----------------------
>   4 files changed, 179 insertions(+), 245 deletions(-)
> 

This patch misses modifications to functions raid1_alloc_init_r1buf() and
raid10_alloc_init_r10buf(). They will be included with other suggestions in v2.


  static struct r1bio *raid1_alloc_init_r1buf(struct r1conf *conf)
  {
         struct r1bio *r1bio = mempool_alloc(&conf->r1buf_pool, GFP_NOIO);
-       struct resync_pages *rps;
+       struct resync_folio *rfs;
         struct bio *bio;
         int i;


  static struct r10bio *raid10_alloc_init_r10buf(struct r10conf *conf)
  {
         struct r10bio *r10bio = mempool_alloc(&conf->r10buf_pool, GFP_NOIO);
-       struct rsync_pages *rp;
+       struct resync_folio *rf;
         struct bio *bio;
         int nalloc;
         int i;

-- 
Thanks,
Nan

