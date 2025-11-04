Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB3DC8F0;
	Tue,  4 Nov 2025 07:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762240045; cv=none; b=uVWRUMzO0LA490HDf1jrwWiRt2sFTevmTON7sSrtmztx4rFLo7LEx/ybJ3nOBE7dp5m5muE5TUYpWCSqauC4UnBCh7STZD/OBu76QjKqWfWp1cNxL3rR2xaggBaEULa3R1/ErgYHXc5/2uv4IxvFZu5gC0ybu0WXZWY8toEy/zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762240045; c=relaxed/simple;
	bh=CDLjxDp0J6AWH+fWfa/5gsuhMy2CuNa0+28qvBEUVaM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fV/XwpZmXz5HBg3bfTM7skhlB76dPphDQPsntQE+qH0GWBAYcC+2f8j6uAKyus7vvPtuY9p880vyeWUYCeH/sDgHYOhvmUZSQmgyOlh76YmucOGAHGqW4gqa3AMZ6yDpklenEH4bd7/AKJdVClBHnooqeDGtG9zdvjKnGLymghA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4d0zzP31kpzKHMMg;
	Tue,  4 Nov 2025 15:07:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id D52CF1A07BB;
	Tue,  4 Nov 2025 15:07:18 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQkpglpwlChCg--.56389S3;
	Tue, 04 Nov 2025 15:07:18 +0800 (CST)
Message-ID: <e810ef97-c713-cc1a-646b-58278ebd25ff@huaweicloud.com>
Date: Tue, 4 Nov 2025 15:07:16 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v9 4/5] md: add check_new_feature module parameter
To: Xiao Ni <xni@redhat.com>, linan666@huaweicloud.com
Cc: corbet@lwn.net, song@kernel.org, yukuai@fnnas.com, hare@suse.de,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20251103125757.1405796-1-linan666@huaweicloud.com>
 <20251103125757.1405796-5-linan666@huaweicloud.com>
 <CALTww29-7U=o=RzS=pfo-zqLYY_O2o+PXw-8PLXqFRf=wdthvQ@mail.gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <CALTww29-7U=o=RzS=pfo-zqLYY_O2o+PXw-8PLXqFRf=wdthvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQkpglpwlChCg--.56389S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtr4fuFy7Wr15GF4DJF1kXwb_yoWDJrbEgw
	40yrZxZF18AFsFkwsxAr1Svr4qgF4UGry5Aw48Aw1ru348Xay0gF9YkrnYq3Z8XFZYyF9I
	vFySyFya9wn2vjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbqxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIF
	xwACI402YVCY1x02628vn2kIc2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14
	v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8Zw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbQV
	y7UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/11/4 9:47, Xiao Ni 写道:
> On Mon, Nov 3, 2025 at 9:06 PM <linan666@huaweicloud.com> wrote:
>>
>> From: Li Nan <linan122@huawei.com>
>>
>> Raid checks if pad3 is zero when loading superblock from disk. Arrays
>> created with new features may fail to assemble on old kernels as pad3
>> is used.
>>
>> Add module parameter check_new_feature to bypass this check.
>>
>> Signed-off-by: Li Nan <linan122@huawei.com>
> 
> Hi
> 
> Thanks for finding this problem in time. The default of this kernel
> module is true. I don't think people can check new kernel modules
> after updating to a new kernel. They will find the array can't
> assemble and report bugs. You already use pad3, is it good to remove
> the check about pad3 directly here?
> 
> By the way, have you run the regression tests?
> 

Sorry for missing this reply earlier. I ran mdadm tests and tested new
RAID on old kernels with check_new_feature both on and off. All passed.

> Regards
> Xiao
> 
> 
> .

-- 
Thanks,
Nan

