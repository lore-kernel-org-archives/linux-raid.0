Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500A68BEC
	for <linux-raid@vger.kernel.org>; Fri,  8 Aug 2025 01:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754616450; cv=none; b=Q5ku9L3PL50GNwyqdfsonVOKmRdTzm7ZtqbjQHUzhcK58MOtfkMhSAW1s0q/hI5tvsSCAPmQsimUGG4pYqddxojUUsxUAC3k+vDp3okLYSMzbdoNcoEY2QPVo6BpDlsY0t314yI3I2YvnmR9gdmm1Mam17LmNSwKgAMGdqcDjFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754616450; c=relaxed/simple;
	bh=goB5n6a3KBd6IuEbuuoEuYZDPrhLqiQwpJrpUFLiWVQ=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=faY1wNRxikKTdrl4Cz9ENBZD4emsZHDDiLGEn+kzYnVYP/O9lUX6nABBKAsXrGzPH5tfO1XW/KRmrDw9nyog0zS9wSc/Dv+wU6wmcUL8xY2baYCzoaAI9wsEhjJX/u1ZQiYxEanpcyvJ9XOd49sfDIZ0mw0OIYJWXN8tVRNVig4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bymbx20KpzKHMSG
	for <linux-raid@vger.kernel.org>; Fri,  8 Aug 2025 09:27:25 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6243F1A01A6
	for <linux-raid@vger.kernel.org>; Fri,  8 Aug 2025 09:27:24 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgC3MxR6UpVoJxvECw--.33672S3;
	Fri, 08 Aug 2025 09:27:24 +0800 (CST)
Subject: Re: md: In raid1_write_request(), when WriteErrorSeen and first_bad
 <= r1_bio->sector , why max_sectors is updated?
To: chen cheng <chenchneg33@gmail.com>, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <CAD8sxFKbdvqruUGv-mr=AOCTyf_s778dqMMdDdNi9nTdgR5F+Q@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <740d9d0a-1ffb-dd78-598f-1e86953888d5@huaweicloud.com>
Date: Fri, 8 Aug 2025 09:27:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAD8sxFKbdvqruUGv-mr=AOCTyf_s778dqMMdDdNi9nTdgR5F+Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC3MxR6UpVoJxvECw--.33672S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtw1DtFW7Zr1rGr1fCFWDtwb_yoWkZFbEyr
	10kFWDXw1UAFWrKryjvF97WrsrZrWDGry5GFyavw1rJw4kZ3WkArsag34fZryfJryUGr98
	tr13Jr93t39rXjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbzkYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1lIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
	k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/08/07 20:57, chen cheng 写道:
> if (test_bit(WriteErrorSeen, &rdev->flags)) {
>          ...
>          if (is_bad && first_bad <= r1_bio->sector) {
>                  bad_sectors -= (r1_bio->sector - first_bad);
>                  if (bad_sectors < max_sectors)
>                          max_sectors = bad_sectors;
>                  rdev_dec_pending(rdev, mddev);
>                  continue;
>          }
> 
>          ...
> }
> 
> 
> When the condition "is_bad && first_bad <= r1_bio->sector" is true,
> this rdev device will be skipped and will no participate in io, so I
> think the following code snippet is unnecessary:
> 
> bad_sectors -= (r1_bio->sector - first_bad);
> if (bad_sectors < max_sectors)
>      max_sectors = bad_sectors;
> 
> So I am confused why we need to update max_sectors in this case?
> 
> .
> 

Becase other good rdevs still have to hanlde this IO, and this IO must
to be splited to bypass badblock regions.

However, please notice maillist is exclusively for active kernel
development like patch submit and review, bug reports and discussion.
It is encouraged to discuss if you understand implemantaion details and
figure out something is wrong or can be improved, but it is not
appropriate for implementation specific question like this.

Thanks,
Kuai

