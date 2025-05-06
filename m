Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5549428B50A
	for <linux-raid@vger.kernel.org>; Tue,  6 May 2025 03:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746502482; cv=none; b=ZueOXRa/xmiB+UYEeoQhMZnGBfd/3o/2a1wZlOB1R020TuI0leGdqWg0paQTOAI8QKrKsNrdjoE02aYZp+9EuxKDJHdk/flVFj/cdKKJ+NC2BdXn+kfrHrEOoji75w/A/BHk82hX7KN5aGJ85KaBMi/zF0pxxFv1e3hrQgahELY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746502482; c=relaxed/simple;
	bh=fBdE7J0erJn+pAW/jcb8C+z/UrlNrv7uFds7GIQlWw0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=AxgRA/j1s60hHl5ib2H2kWaGRGretQpSOaTUikxV6jnzun40PMbdCtRWCx3VHmvfAtmBeitED91aPW7eLOSH0zWxtBaUzRtVA/oJEgTRt4a94TRgkDcWYmCDME+qX4oBeDPDfAY/46jM8kPqMZ/xlYUYLF7suTtFQU5fq6FtJCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Zs3sY5VQpz4f3lCf
	for <linux-raid@vger.kernel.org>; Tue,  6 May 2025 11:34:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B426D1A018D
	for <linux-raid@vger.kernel.org>; Tue,  6 May 2025 11:34:35 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB3219KgxlokY1ILg--.44384S3;
	Tue, 06 May 2025 11:34:35 +0800 (CST)
Subject: Re: [RFC PATCH] fix a reshape checking logic inside
 make_stripe_request()
To: Coly Li <i@coly.li>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Coly Li <colyli@kernel.org>, linux-raid@vger.kernel.org,
 Logan Gunthorpe <logang@deltatee.com>, Xiao Ni <xni@redhat.com>,
 Song Liu <song@kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
References: <20250505152831.5418-1-colyli@kernel.org>
 <fgqrzhv5mbmrusocjkeybja6leaeeoi2r4hwihphi4lni2w3xg@meakhkiyuiab>
 <ba1a64b6-db88-077b-2216-3b34d2cc55b3@huaweicloud.com>
 <9E1AEF87-FF33-4F0F-A8A4-97A1E2EB9EFA@coly.li>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <65461649-c3a5-3cd2-3df7-71cab52dfbea@huaweicloud.com>
Date: Tue, 6 May 2025 11:34:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <9E1AEF87-FF33-4F0F-A8A4-97A1E2EB9EFA@coly.li>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3219KgxlokY1ILg--.44384S3
X-Coremail-Antispam: 1UD129KBjvJXoWrur13ury7JF4rCw15Ar15CFg_yoW8Jr1xpF
	13JFyYkw4xt34IyFs8Jr1UJF18Grsaya4DJr43G347CrWDJwn3XF1UKr4fGa4fK34DZFyY
	qa1UJr1Utr4kWaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUBVbkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/05/06 10:34, Coly Li 写道:
> For the above code, I don’t see how only unlikely(previous) help on branch prediction and prefetch,
> IMHO the following form may help to achieve expected unlikely() result,
> 
>            if (unlikely(previous && !stripe_ahead_of_reshape(mddev, conf, sh))) {
> 
> Thanks.

What you mean you don't see *only unlikely*, for example:

int test0(int a, int b)
{
         if (a && b)
                 return 1;
         return 0;
}

int test1(int a, int b)
{
         if (unlikely(a) && b)
                 return 1;

         return 0;
}

You can see unlikely will generate setne/movzbl/test assemble code:

test0:
    0x0000000000401130 <+10>:    cmpl   $0x0,-0x4(%rbp)
    0x0000000000401134 <+14>:    je     0x401143 <test0+29>
    0x0000000000401136 <+16>:    cmpl   $0x0,-0x8(%rbp)
    0x000000000040113a <+20>:    je     0x401143 <test0+29>

test1:
    0x0000000000401154 <+10>:    cmpl   $0x0,-0x4(%rbp)
    0x0000000000401158 <+14>:    setne  %al
    0x000000000040115b <+17>:    movzbl %al,%eax
    0x000000000040115e <+20>:    test   %rax,%rax
    0x0000000000401161 <+23>:    je     0x401170 <test1+38>
    0x0000000000401163 <+25>:    cmpl   $0x0,-0x8(%rbp)

BTW, what you suggested is the same as:

if (unlikely(previous) && unlikely(!stripe_ahead_of_reshape(mddev, conf, 
sh)))

Thanks,
Kuai

