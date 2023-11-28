Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4AEF192
	for <linux-raid@vger.kernel.org>; Mon, 27 Nov 2023 22:31:05 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4SfXdw1YDSz4f3jrn
	for <linux-raid@vger.kernel.org>; Tue, 28 Nov 2023 14:31:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 1D3211A0270
	for <linux-raid@vger.kernel.org>; Tue, 28 Nov 2023 14:31:02 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgA3iA4jiWVl2vKaCA--.14S3;
	Tue, 28 Nov 2023 14:31:00 +0800 (CST)
Subject: Re: [PATCH] MAINTAINERS: SOFTWARE RAID: Add Yu Kuai as Reviewer
To: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Cc: yukuai1@huaweicloud.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20231128035807.3191738-1-song@kernel.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <3288fd05-2816-95a4-1ff6-87dfa63f4be6@huaweicloud.com>
Date: Tue, 28 Nov 2023 14:30:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20231128035807.3191738-1-song@kernel.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgA3iA4jiWVl2vKaCA--.14S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Xr18ur1xKF4rXryxAryxKrg_yoWxAwbEya
	yfGryxXF4rJF4Iq348ur92vr4rtr4fJFyfZ3Z7AanxXFyDAr95tw4kJ3s5KwnrWr93WFyk
	Z3WfXrsagr9xXjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4xFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CEbIxv
	r21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUywZ7UUU
	UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2023/11/28 11:58, Song Liu Ð´µÀ:
> Add Yu Kuai as reviewer for md/raid subsystem.
> 
> Signed-off-by: Song Liu <song@kernel.org>

Thanks,
Acked-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   MAINTAINERS | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 012df8ccf34e..a800acf46e6a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20106,6 +20106,7 @@ F:	include/linux/property.h
>   
>   SOFTWARE RAID (Multiple Disks) SUPPORT
>   M:	Song Liu <song@kernel.org>
> +R:	Yu Kuai <yukuai3@huawei.com>
>   L:	linux-raid@vger.kernel.org
>   S:	Supported
>   Q:	https://patchwork.kernel.org/project/linux-raid/list/
> 

