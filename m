Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DF310A1E;
	Tue, 27 May 2025 02:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748314114; cv=none; b=L5S1QzogXtNrQp1vWbq0LJ3bPcZELR+8pNohHYuuwZAyeNLNKC2GT44dAhiF+KpWWf4p3rLEWSL2gBWIsdws4Rhb41eixXG5w3BeeAuM7zQhU/q8UEBjt4elhZrlVPLqC1XLj8+ncBx3tlq4s7GY1LOVasm6UuzTq9coD/K5xgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748314114; c=relaxed/simple;
	bh=TYr+3U6fOV83c7+gV8TJqOEfjngi1bb4/1WmymZOfNM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=KZEKxJVzaSgG73xI4zY3e5fr+KcRd2tRxQgw6hxysP2vxBd4zj3tN6433+Y9vbAJgFGF5AFM4LA0jRAEfzax61ZS1GvqXlpxKgDG3iluEO9foMG21IOZreW4GCxIWfp5ttszyQ/bLckLkep1Tqyuo1rIh5bjkIDmBnM/z7JY0sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4b5xs905wqzYQvCL;
	Tue, 27 May 2025 10:48:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 275FF1A150C;
	Tue, 27 May 2025 10:48:28 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDXOl_6JzVoLkKHNg--.26116S3;
	Tue, 27 May 2025 10:48:28 +0800 (CST)
Subject: Re: [PATCH 09/23] md/md-bitmap: add a new method blocks_synced() in
 bitmap_operations
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, colyli@kernel.org, song@kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-10-yukuai1@huaweicloud.com>
 <CALTww2_SUyLUFzQgLe+z0UFmcS72o1JDEkPfR5FEsOmj8CDsXw@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <150960a5-376d-61ca-2996-6ce0e553e956@huaweicloud.com>
Date: Tue, 27 May 2025 10:48:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww2_SUyLUFzQgLe+z0UFmcS72o1JDEkPfR5FEsOmj8CDsXw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXOl_6JzVoLkKHNg--.26116S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtFyrXF45Ar17XFyxAF18Xwb_yoWDCrgEgF
	15C3WUWw1kGr42y3sxKr1DWrWvg345Wr4UX343Jr45XFW8Ja90g3WkCrWkWrs7Xa90yrn5
	C3yFqr47t395ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/05/27 10:35, Xiao Ni 写道:
> On Sat, May 24, 2025 at 2:18 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Currently, raid456 must perform a whole array initial recovery to build
>> initail xor data, then IO to the array won't have to read all the blocks
>> in underlying disks.
>>
>> This behavior will affect IO performance a lot, and nowadays there are
>> huge disks and the initial recovery can take a long time. Hence llbitmap
>> will support lazy initial recovery in following patches. This method is
>> used to check if data blocks is synced or not, if not then IO will still
>> have to read all blocks for raid456.
> 
> Hi Kuai
> 
> In function handle_stripe_dirtying, if the io is behind resync, it
> will force rcw. Does this interface have the same function？

This api is not the same, this api is used by lazy initial recovery
for the raid5, means initial recovery is skipped and resync is not
in progress, handle_stripe_dirtying can't handle this case.

Thanks,
Kuai

