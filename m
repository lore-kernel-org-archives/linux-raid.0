Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC3D4C66;
	Fri, 22 Nov 2024 02:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732243554; cv=none; b=gBeNGw9p0ye1g5wD0jIw9Ijl7gVCh+sHIyLXMTXpV05EWJ2GBlNOD3apHJaA02cNLlG/LT5Gaj419m6jZeZ9gn57FbmyiBU3VnzS1gmVIF9oQuySkvThMAP5YaTWwJGnzUTppkThfGOq0m/M5B6BAIk/htDQfNFW193C0H8aaHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732243554; c=relaxed/simple;
	bh=bqvSoCMsXdacbGux47FYTDryU13WxZaa3CRGdb/BYjo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=PQ8WlEwYDHCADG3Pc/kPt45AT3zs4p/WkOKh71xFZda09lgwm8bMaL3nqV3ZVBRVXr1EkciHvxka/5hmm0YaMbO4Dz5lZwaxYce4f5Ln3T/J801gUBb9kjnwkJwlw/ZPiUrqK6gyJ0ASfmAtHuKgh/xt8VkCX2g5hLYsJPECtQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xvfbf3zrFz4f3jqF;
	Fri, 22 Nov 2024 10:45:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 106341A0194;
	Fri, 22 Nov 2024 10:45:48 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCHY4da8D9nlY_oCQ--.57100S3;
	Fri, 22 Nov 2024 10:45:47 +0800 (CST)
Subject: Re: [PATCH md-6.13 5/5] md/md-bitmap: move bitmap_{start, end}write
 to md upper layer
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241118114157.355749-1-yukuai1@huaweicloud.com>
 <20241118114157.355749-6-yukuai1@huaweicloud.com>
 <CALTww28JrdXoNXQNPxx2Sg9L2iL20jZZ80Y-qZzqcyF780M1fg@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e6843d53-c7f4-2e38-0a15-91b49afec8f1@huaweicloud.com>
Date: Fri, 22 Nov 2024 10:45:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww28JrdXoNXQNPxx2Sg9L2iL20jZZ80Y-qZzqcyF780M1fg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHY4da8D9nlY_oCQ--.57100S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKFyxtrWDZF4UuFW3JryxZrb_yoWfZrc_GF
	92y3s5Cw1DZFs3Ka1rur15ZFZFkFW5JFyDXr1kt390g34rXa95AFZ0v34vyw4fCa98tr93
	Gr9rXr4DGrs8ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbSfO7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/11/22 10:06, Xiao Ni 写道:
> On Mon, Nov 18, 2024 at 7:44 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> There are two BUG reports that raid5 will hang at
>> bitmap_startwrite([1],[2]), root cause is that bitmap start write and end
>> write is unbalanced, and while reviewing raid5 code, it's found that
> 
> Hi Kuai
> 
> It's better to describe more about "unbalanced" in the patch. For
> raid5, bitmap is set and cleared based on stripe->dev[] now. It looks
> like the set operation matches the clear operation already.

Ok, one place that I found is that raid5 can do extra end write while
stripe->dev[].towrite is NULL, the null checking is missing. I'll
mention that in the next version.

...

> 
> This patch looks good to me.
> 
> Reviewd-by: Xiao Ni <xni@redhat.com>
> 

Thanks for the review. I'll also remove the unused STRIPE_BITMAP_PENDING
in v2.

Kuai

> 
> .
> 

