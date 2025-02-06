Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048495103F;
	Thu,  6 Feb 2025 01:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738806825; cv=none; b=VGE2ihbYzVrMf46QTLpZcUsH4dWCV5VQC0eVu+WVvEdwyheImwDaGRmetlpjHQWSxr36LJuhf/y/SpOOTIEH6lPtZfaUKjaf0ZB+H2q1raYSy0U/HfmD52pGquluaUCqlOCv6qYP5xFWcFFHhNyD/2I3Fpm1YoTXD+/qhBVJH48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738806825; c=relaxed/simple;
	bh=i1447m7XQLHq2APBpUMTQzWjGGeYa5kePCEYkMeHtb8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=WQ/VVNXrjtzwE/tWCammtPfgduNV9XKKw4aCqKdqTSYqzuyOR12sC17UNdWsXJTEIy48cXWPIN/4z4bn8eH3XT28Ky1HOEUfYPmi/k4I32mIiEMqrxhcY0yUnbDum22tivdBFRWlEqnMSyF18U9TvdmpJKiAbc7GfDNZRXqSMlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YpKr46sMbz4f3jMQ;
	Thu,  6 Feb 2025 09:53:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6F5011A06DC;
	Thu,  6 Feb 2025 09:53:31 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDnSl8aFqRnHiYjDA--.26918S3;
	Thu, 06 Feb 2025 09:53:31 +0800 (CST)
Subject: Re: [PATCH 6.6 0/6] md/md-bitmap: move bitmap_{start, end}write to md
 upper layer
To: Greg KH <gregkh@linuxfoundation.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: stable@vger.kernel.org, song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250127085351.3198083-1-yukuai1@huaweicloud.com>
 <2025020447-hesitant-corroding-16c1@gregkh>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <a2fce7b4-11d1-eaa8-55db-b028e5517892@huaweicloud.com>
Date: Thu, 6 Feb 2025 09:53:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <2025020447-hesitant-corroding-16c1@gregkh>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnSl8aFqRnHiYjDA--.26918S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtrWDuw4UGrW3KF4DZw43KFg_yoWxCrc_uF
	4xua48u3srXF1UWr4DtFn3Zryvk3y5WrWrtryDXFy3Jr1fZ3Z5Ga9ru3s5Z3WfWrs7JFZ5
	tayqkw4qyryDWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VU13ku3UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/02/04 19:40, Greg KH Ð´µÀ:
> On Mon, Jan 27, 2025 at 04:53:45PM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> This set fix reported problem:
>>
>> https://lore.kernel.org/all/CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com/
>> https://lore.kernel.org/all/ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io/
>>
>> See details in patch 6.
> 
> Please redo this series and describe in it what you changed from the
> original commits, as these are not just normal cherry-picks at all.

Got it, the difference is that bitmap_ops doesn't exist in 6.6.

Thanks,
Kuai

> 
> thanks,
> 
> greg k-h
> .
> 

