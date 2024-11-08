Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E3C8F54;
	Fri,  8 Nov 2024 06:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731046048; cv=none; b=iBCc1SIMF7u4sWKmvJCb1l7Qq2n8AuZ5CtI+T2i03JdzAOWT1UuZ52ZIbXNRL3FWpgh7lJjdc0z/bl/8QLeWNRt8OVe44r/jO604JcHnQ0nJetxUUppLAOrTObIYVOUyz9fzAylhWNijx3hzgIhD7u7RggREnlItDcwADbEYeR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731046048; c=relaxed/simple;
	bh=nbhbqXWbS5drLYz+th6wmfd3iaPgrJv2NgPZK6FH9m8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=pNAzGItPK8vfgRb55gAGWQBE+IR9x8fsa7Tneac6wM2EkRVJwu9VAAcw3h5D/9RSZc/xCwZ56AvxFvIvSkcFosRgUSg/ftAUIvURVKlMONJdBYBCugLbs59gDoaiL/x4MZ5DEiTACkw84IHv85i1+iwoFv2Z2XiEuw6VYsg4kzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Xl7kb0LWYz4f3jsX;
	Fri,  8 Nov 2024 14:07:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1A4491A018D;
	Fri,  8 Nov 2024 14:07:21 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgB3U4eXqi1nbFy3BA--.31515S3;
	Fri, 08 Nov 2024 14:07:20 +0800 (CST)
Subject: Re: [PATCH md-6.13] md: remove bitmap file support
To: =?UTF-8?Q?Dragan_Milivojevi=c4=87?= <galileo@pkm-inc.com>,
 Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241107125911.311347-1-yukuai1@huaweicloud.com>
 <CAPhsuW7Ry0iUs6X7P4jL5CX3+8EGfb5uL=g-q_8jVR-g19ummQ@mail.gmail.com>
 <ef4dcb9e-a2fa-d9dc-70c1-e58af6e71227@huaweicloud.com>
 <CAPhsuW4tcXqL3K3Pdgy_LDK9E6wnuzSkgWbmyXXqAa=qjAnv7A@mail.gmail.com>
 <CALtW_agCsNM66DppGO-0Trq2Nzyn3ytg1t8OKACnRT5Yar7vUQ@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8ae77126-3e26-2c6a-edb6-83d2f1090ebe@huaweicloud.com>
Date: Fri, 8 Nov 2024 14:07:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALtW_agCsNM66DppGO-0Trq2Nzyn3ytg1t8OKACnRT5Yar7vUQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3U4eXqi1nbFy3BA--.31515S3
X-Coremail-Antispam: 1UD129KBjvdXoWruFWUArWDGr48Gw4UXF43ZFb_yoWfXrc_W3
	WxA3y8J34UGrs5tr1agr15Ars3t3y7Xa4rJ3yrJayIqa45Xas8Jr48C34F9393Ww1ktrnr
	Kryavr9rXw43WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CEbIxv
	r21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjfUYCJmUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/11/08 13:15, Dragan Milivojević 写道:
> On Fri, 8 Nov 2024 at 02:29, Song Liu <song@kernel.org> wrote:
> 
>> I think we should ship this with 6.14 (not 6.13), so that we have
>> more time testing different combinations of old/new mdadm
>> and kernel. WDYT?
> 
> I'm not sure if bitmap performance fixes are already included
> but if not please include those too. Internal bitmap kills performance
> and external bitmap was a workaround for that issue.

I don't think external bitmap can workaround the performance degradation
problem, because the global lock for the bitmap are the one to blame for
this, it's the same for external or internal bitmap.

Do you know that is there anyone using external bitmap in the real
world? And is there numbers for performance? We'll have to consider
to keep it untill the new lockless bitmap is ready if so.

Thanks,
Kuai

> .
> 

