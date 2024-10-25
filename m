Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EDD41A8F;
	Fri, 25 Oct 2024 01:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729819478; cv=none; b=U6OGiYTiYaJ1lWUO+1OmYHGzicS8hW6uCua6j39PiQWI7DKZR2Y+h+TH7Hq3PCk9iiM/GNSkZ52h+hUuoW0LPgY1JOroyCn5A7Qbgsp7l34q0A1nafmhWcNHn1AXE5xyp6DMi4yixAbBLXamFCgDwPMgwFRQ564YzYyHvzuPlHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729819478; c=relaxed/simple;
	bh=wKtiNMIN/NCY53g5VgT49t40kiaKbtP78DtPLoSRc6Q=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=gcKY/pv5E20tdM/qKpgR12/6MhoTAY3wANn5vsMTQEtxNPyI49YG0jH7AdInHHYIrgpI8RsRQEl/S5giRCL65Tg7ESTy7UIpV1bEZ0VbfjNUlQerXoe055j0MyyCf5bMjJty2u26Hqmdh1r+xu57TT/vxpRdA+Jy9T67910keFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XZQ6s04R5z4f3jt4;
	Fri, 25 Oct 2024 09:24:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 60E921A058E;
	Fri, 25 Oct 2024 09:24:33 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgAHPMhP8xpny3wqFA--.394S3;
	Fri, 25 Oct 2024 09:24:33 +0800 (CST)
Subject: Re: [PATCH RFC 5/6] md/raid1: Handle bio_split() errors
To: John Garry <john.g.garry@oracle.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, martin.petersen@oracle.com,
 "yangerkun@huawei.com" <yangerkun@huawei.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
 <20240919092302.3094725-6-john.g.garry@oracle.com>
 <bc4c414c-a7aa-358b-71c1-598af05f005f@huaweicloud.com>
 <0161641d-daef-4804-b4d2-4a83f625bc77@oracle.com>
 <c03de5c7-20b8-3973-a843-fc010f121631@huaweicloud.com>
 <68d10e83-b196-4935-a350-464b82c30e44@oracle.com>
 <169b94ae-8711-1821-75a7-7e3a600745e4@huaweicloud.com>
 <1ca75a4f-3c6b-46ff-a5fd-f34936a0fb12@oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6f61236a-5cbb-a820-31db-b3ea2ec8805a@huaweicloud.com>
Date: Fri, 25 Oct 2024 09:24:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1ca75a4f-3c6b-46ff-a5fd-f34936a0fb12@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHPMhP8xpny3wqFA--.394S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKF1rXFyxWF1kAr17Jr13Arb_yoWDXFXEqF
	4xCF4xCry5uF43CFn8JF1rKrWDCryfXFyay3yIyF4jy34DZr9rJr4UWr95Xr4F9rn7CF1Y
	vr4v9a4rCF1fujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/10/24 21:51, John Garry 写道:
> On 24/10/2024 04:08, Yu Kuai wrote:
>>>
>>> I could just have this pattern:
> 
> Hi Kuai,
> 
>>>
>>> bio->bi_status = errno_to_blk_status(err);
>>> set_bit(R1BIO_Uptodate, &r1_bio->state);
>>> raid_end_bio_io(r1_bio);
>>>
>> I can live with this. 🙂
>>
>>> Is there a neater way to do this?
>>
>> Perhaps add a new filed 'status' in r1bio? And initialize it to
>> BLK_STS_IOERR;
>>
>> Then replace:
>> set_bit(R1BIO_Uptodate, &r1_bio->state);
>> to:
>> r1_bio->status = BLK_STS_OK;
> 
> So are you saying that R1BIO_Uptodate could be dropped then?
> 
>>
>> and change call_bio_endio:
>> bio->bi_status = r1_bio->status;
>>
>> finially here:
>> r1_bio->status = errno_to_blk_status(err);
>> raid_end_bio_io(r1_bio);
> 
> Why not just set bio->bi_status directly?

Because you have to set R1BIO_Uptodate in this case, and this is not
what this flag means.

Like I said, I can live with this, it's up to you. :)

Thanks,
Kuai

> 
> Cheers,
> John
> 
> 
> .
> 

