Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6133D5225;
	Thu,  5 Feb 2026 12:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770296265; cv=none; b=J+5S8C5//B9SbpOyWZ4eWnXVAH2yVbHww9CP8gT6QImBgMq96u0hWEWMz+3ot7liJPiz2/S8lTypTMchU5nBcAGtl3G1+NRjw7/S0mQN65Gb5ntKl7mYk4eKth0UvS0WpkQPoSWCV8oVkQ9Y1HcLsOMcRvLg5eCUk1puUfbTwRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770296265; c=relaxed/simple;
	bh=CVSV10zmBA6Qo50Mwjc56zDweMyB2R84Ztgktostmxg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jm8TqfJkzSueaE4YKYDdMGUYiTV8c/Azc6T1EunNafwnNmZ1Q0S1Wdu+mFKfipkun3HRjGR8THgRXGfD8UxI2xtWi3jtBlo+GDRpKnyBTmwOXY8cwJ1giapVJ1Zxdq4Vyle94lTOPLP7cS56vjhG/KKpCWcY1fu+cETeOhvvMeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4f6HLP1T8kzKHMWm;
	Thu,  5 Feb 2026 20:57:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0819F40590;
	Thu,  5 Feb 2026 20:57:42 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgBnFvfEk4RpwfpqGQ--.60208S3;
	Thu, 05 Feb 2026 20:57:41 +0800 (CST)
Message-ID: <a5d6d417-7050-9e42-4e20-59c8c893bab6@huaweicloud.com>
Date: Thu, 5 Feb 2026 20:57:39 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 00/14] folio support for sync I/O in RAID
To: yukuai@fnnas.com, linan666@huaweicloud.com, song@kernel.org
Cc: xni@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yangerkun@huawei.com, yi.zhang@huawei.com
References: <20260128075708.2259525-1-linan666@huaweicloud.com>
 <def3b536-7840-426a-9805-f62363174812@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <def3b536-7840-426a-9805-f62363174812@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBnFvfEk4RpwfpqGQ--.60208S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CF4ktw4UKw1xXw17AF13urg_yoW8XrW3pF
	4Yk3ZIka9rJr4Fkwn2qas29ryIk34fAry5Ja4fGryxWF98GF9akr4Sgws09r98G3sxJF4S
	va1UJryIqa45ZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvg4fUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/2/5 1:02, Yu Kuai 写道:
> Hi,
> 
> 在 2026/1/28 15:56, linan666@huaweicloud.com 写道:
>> From: Li Nan <linan122@huawei.com>
>>
>> This patchset adds folio support to sync operations in raid1/10.
>> Previously, we used 16 * 4K pages for 64K sync I/O. With this change,
>> we'll use a single 64K folio instead. Using folios reduces
>> resync/recovery time by 20% on HDD.
>>
>> This is the first step towards full folio support in RAID. Going forward,
>> I will replace the remaining page-based usage with folio.
>>
>> The patchset was tested with mdadm. Additional fault injection stress tests
>> were run under file systems.
> 
> For conclusion, I think you can send patch 1,8,9 first, they're not quite

Hi, kuai

Thanks for your review.

In handle_reshape_read_error(), if fix error in lbs before folio, we need
to consider 'idx' of page and offset in page, which make logical become 
complex. I prefer making the change after folio , how do you think?

> related to folio and can be applied. Then, please move patch 12,13 before patch 5

Patches 12,13 only make sense after folio support. Cleanup before folio
offers little benefit. I will merge them directly into patch 5.

> in the separate patch set, and looks like the number of patches can be small.
> 
> BTW, there are still pages in other context, do you plan to convert them?
> 

Yes, there are still many page usages in bitmap and RAID5. I will continue
folio support work with this series as a reference after it is applied.

-- 
Thanks,
Nan

