Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0942306B3E;
	Fri, 30 Jan 2026 07:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769759745; cv=none; b=Hj136JJ5BU4dO5VT2ogKAI/pV3JLxmFCDVU8H4qFprwhhIPD0wR57ZTv7fNWzjEWJwT4MTF2P2Dq0cnVqJvKfLTJVEiNgRX7fspdfka85vOmszTYju/Hgt34txclYgq3k1BDP++7x+k8Nhk3+Nb5CKKSjUYTBm7tIBKm0u9Ln8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769759745; c=relaxed/simple;
	bh=riaZVLdeaZAIpCz3S0BUKklFSqxz/wubBIWO/ih7BBA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RoZ7torCuiniECoYYmJPI6r+SCzSmo+U1hrLInUH/ZzjH2I80GwdnsnguY3h+cE+tMx1UyRHk4P6e8ImP8BZvVJXamEZXkOoGhXpBDnCbCwdJ0YurTN1IMNhjdSza887PrsYR9EZeHZD/0gwOfqG1xPAq8s3KRMekAatXp4Gxq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f2SwD4lFzzYQtyL;
	Fri, 30 Jan 2026 15:54:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id F2B4A40592;
	Fri, 30 Jan 2026 15:55:32 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgBnFvfxY3xpBcGEFg--.13495S3;
	Fri, 30 Jan 2026 15:55:31 +0800 (CST)
Message-ID: <f0a49805-bed6-a818-9527-7267f26aa2ab@huaweicloud.com>
Date: Fri, 30 Jan 2026 15:55:29 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] MAINTAINERS: Add Li Nan as md/raid reviewer
To: linan666@huaweicloud.com, song@kernel.org, yukuai@fnnas.com
Cc: linux-kernel@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com,
 Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <20260129130056.1014405-1-linan666@huaweicloud.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260129130056.1014405-1-linan666@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgBnFvfxY3xpBcGEFg--.13495S3
X-Coremail-Antispam: 1UD129KBjvdXoW7GrW5KF1fCr4xAry8CrWktFb_yoWfCrgEk3
	97JrW8WFy8AF47W3y8ZrZ2vr4Yyr48J3Z5W3Z0q345Xa4kJ3s5Ka95K3s5Cw17Gry8urW7
	t3Z3JFZaqws0qjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbTkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
	64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
	Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7
	Mxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
	v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUvg4fUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

Sorry for missing cc to linux-raid.

On 2026/1/29 21:00, linan666@huaweicloud.com wrote:
> From: Li Nan <linan122@huawei.com>
> 
> I've long contributed to and reviewed the md/raid subsystem. I've fixed
> numerous bugs and done code refactors, with dozens of patches merged.
> I now volunteer to work as a reviewer for this subsystem.
> 
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   MAINTAINERS | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 67db88b04537..3262c74b93b4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -24260,6 +24260,7 @@ F:	include/linux/property.h
>   SOFTWARE RAID (Multiple Disks) SUPPORT
>   M:	Song Liu <song@kernel.org>
>   M:	Yu Kuai <yukuai@fnnas.com>
> +R:	Li Nan <linan122@huawei.com>
>   L:	linux-raid@vger.kernel.org
>   S:	Supported
>   Q:	https://patchwork.kernel.org/project/linux-raid/list/

-- 
Thanks,
Nan

