Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9563A9002;
	Wed,  4 Feb 2026 09:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770197543; cv=none; b=OGaySwpdl4tuRSzV4TnxgCXHoot2phVDhuNC79FU5V/sT+hPI63MnSfkdONGRxpUj7+6qKLLJmA/BNwuC2MbPflRX/19UoYHj93WDQZ9PEEXUKK4Q7/KGG2letfrKurSfoyo36uACXuz+MK29kV8TwD9aCy9/r1Suh1mokRkY5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770197543; c=relaxed/simple;
	bh=C8Nw35gbt9JNaa/Mko5ruVPS0QDzqsN3uCB1BQ0XIVQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oQmdUGmzF3vWC8DoIIWeMig9ifXSYI2EJq33CkcZiVv/5EfzONrRIf7SvytoMS1FbfVGNiNghHn1kUsE4JI5+QnAvY94RfkCGCItuh7QUJW6Gxcz4zDxlkE1ZePpfb374WKszeU97ETLHavzRgmAN0rLyFcXvFVzJVHH0H+TAg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4f5Zqv4pD3zKHMhf;
	Wed,  4 Feb 2026 17:31:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B218840574;
	Wed,  4 Feb 2026 17:32:18 +0800 (CST)
Received: from [10.174.178.72] (unknown [10.174.178.72])
	by APP4 (Coremail) with SMTP id gCh0CgC3ZPUhEoNpBXLiGA--.14844S3;
	Wed, 04 Feb 2026 17:32:18 +0800 (CST)
Message-ID: <aa75ffc2-902e-4520-b914-0316d22b5fc8@huaweicloud.com>
Date: Wed, 4 Feb 2026 17:32:17 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 0/5] md/raid1: introduce a new sync action to repair
 badblocks
To: Christoph Hellwig <hch@infradead.org>
Cc: song@kernel.org, yukuai@fnnas.com, linan122@huawei.com, xni@redhat.com,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
 Zheng Qixing <zhengqixing@huawei.com>
References: <20260203061259.609206-1-zhengqixing@huaweicloud.com>
 <aYGkSwDZTLLbjm6p@infradead.org>
 <a1b70bef-27df-45d0-abbb-2d6b75ef5f4c@huaweicloud.com>
 <aYIi1JoZnDMq8rNe@infradead.org>
From: Zheng Qixing <zhengqixing@huaweicloud.com>
In-Reply-To: <aYIi1JoZnDMq8rNe@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC3ZPUhEoNpBXLiGA--.14844S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WF48Kr1xAFWxAr4rurW8tFb_yoW8Xw1DpF
	WayFy8Jr4DtFnak3s7A3yjq3WFkw1kK3yfG3Z5W34qgrZxXFyjqF42kFW5XF9rJrn3XayU
	ZFW5Zry8AF4kZaDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8
	imRUUUUUU==
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

resend..

在 2026/2/4 0:31, Christoph Hellwig 写道:
> On Tue, Feb 03, 2026 at 04:08:23PM +0800, Zheng Qixing wrote:
>> Hi,
>>
>> 在 2026/2/3 15:31, Christoph Hellwig 写道:
>>> Just curious, but what kind of devices do you see that have
>>> permanent bad blocks at a fixed location that are not fixed by
>>> rewriting the sector?
>> The bad_blocks entries record sectors where I/O failed, which
>> indicates that the device-internal remapping did not succeed
>> at that time.
>>
>> `rectify` does not assume a permanently bad or fixed LBA. Its
>> purpose is to trigger an additional rewrite, giving the underlying
>> device (e.g. FTL or firmware) another opportunity to perform its
>> own remapping.
> Well, what devices do you see where writes fail, but rewrites
> fix them?

I understand your concerns, but I do not have a concrete example tied
to a specific device model...

The intent here is to provide an additional rewrite opportunity, which
allows the write path to be exercised again and gives the underlying
device or stack a chance to recover or remap the affected range.

For remote storage devices, I/O may fail due to network or transport
issues. If the final attempt fails, MD can record the affected range in
bad_blocks. This behavior does not appear to be tied to a specific
device model.

For local storage, some controllers may have limitations or corner cases
in their remapping mechanisms. In such cases, a sector that could
potentially be recovered may be marked as bad, leaving no opportunity
for a subsequent successful rewrite.

