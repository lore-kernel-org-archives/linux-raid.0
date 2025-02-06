Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169FB29CE7;
	Thu,  6 Feb 2025 01:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738806413; cv=none; b=EJy8OeH/6p/W9l0lH7V9hsMmcRqp1Ux6UWy6P8dfyqUraIPabYUjR1N5OaeYMn9rIaDmDu1HCMIjs5N+C/CaysoM6CglyBdzFMaQSn+pkrFhD5Jj32GlyGVKyinVzrtSUOL5/tNoPl8qdKVIQd4QULM5HHXeLT8O8i9FegsFkag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738806413; c=relaxed/simple;
	bh=0iVgT1w5B4gmeQcT82ZRE/DkTWebIxCWtPimGoFnG9I=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=pgwL8GuQGqI9IoDr0YGWOKCWOktS3Jkvnc4bv72BRms/AhRsr3sKMEH448C14dzcLEKPCXhSIQKMNZH4RvdVi0p2rpYhZN82wXyWs0TyuIfwJ7gn9aV9/sIeDpPfVtmzNRqOdWWDFlMThXilG2tg8FX0MKIQ6d7Lg0lGbVekxQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YpKhK5HhCz4f3jXJ;
	Thu,  6 Feb 2025 09:46:25 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D72FD1A163F;
	Thu,  6 Feb 2025 09:46:46 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgA3m1+DFKRnVLgiDA--.30010S3;
	Thu, 06 Feb 2025 09:46:44 +0800 (CST)
Subject: Re: [PATCH 6.13 0/5] md/md-bitmap: move bitmap_{start, end}write to
 md upper layer
To: Greg KH <gregkh@linuxfoundation.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: stable@vger.kernel.org, song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250127084928.3197157-1-yukuai1@huaweicloud.com>
 <2025012752-jolly-chowtime-d498@gregkh>
 <2025012755-dimmed-dismount-a5a5@gregkh>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <12f66889-519b-230d-ae91-8203298a9a58@huaweicloud.com>
Date: Thu, 6 Feb 2025 09:46:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <2025012755-dimmed-dismount-a5a5@gregkh>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3m1+DFKRnVLgiDA--.30010S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uFy3XrWrZr4kWF1rJry5Jwb_yoW8GF15pF
	WFvFsxKFs8tryxXrZ2yr4jg3WFqws5Zr43W34rt34fCr45ZF92gr40qrWYgF9xWFykKw4Y
	9r4IqF4DX348ta7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUZYFZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/01/27 20:45, Greg KH Ð´µÀ:
> On Mon, Jan 27, 2025 at 10:11:30AM +0100, Greg KH wrote:
>> On Mon, Jan 27, 2025 at 04:49:23PM +0800, Yu Kuai wrote:
>>> This set fix reported problem:
>>>
>>> https://lore.kernel.org/all/CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com/
>>> https://lore.kernel.org/all/ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io/
>>>
>>> See details in patch 5.
>>
>> Why were these all not properly taggeed for stable inclusion to start
>> with?

Because the orignal problem in raid5 is not 100% clear, I don't know
what's the exact fix tag here, raid5 is quite complicated :(

So this set fix the problem by refactor, removing all related code in
raid5, and reimplement the logical in md.c. Please notice this refactor
can also improve performance for raid5.

I can't reporduce this problem myself, however, it's tested by other
folks that v4.19 is still affected, while I don't think this *refactor*
will be possible in that version. I'll suggest people to upgrade their
kernel to v6.6+ first if they're really affected...
> 
> Also, as these are not in a released kernel just yet, why should we
> include them in one now before 6.14-rc1 is out?

I just want to send v6.6 version before the Chinese New Year, becaue
6.14-rc1 will be released while I'm on vacation.

Thanks,
Kuai

> 
> thanks,
> 
> greg k-h
> .
> 

