Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FFC6BFC0;
	Mon, 30 Jun 2025 06:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751263778; cv=none; b=tIli6f5jT9+ofw7bnce4PjOtzUtRgSsfHvRNhF8epRXhNoDu/5CSXLAzuZCCqwKikxiTw3gfmBz6WVUZLEpqujKriaHpDrhc1LJJw3JAXQvy1Nvo1f85s3kp6NevNyy34ketZa4slj7abMrOzh/H2/OqG7HTQiyHZyNBeJvhVho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751263778; c=relaxed/simple;
	bh=TnK1WWG76ls+5mFQW9ETSEMY1f2TUQl0680rqrPC2s8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=C5LCX3Bn8DDQrkmvjA8O1sHOjvHJIU5SKndqKVR6fn5aSxJDdmqQUaGMtc8e2lfcavXUhR0692TjmvoIjkk9wG/AyhW/aVfW9sv67LgDHldTU7lH6LH/3cCqQxwbakEKt5FbXfDvwrfJEW9x8h6sx0Ott4kZXh2U1LX0KHAhh5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bVwjT43wBzYQtG8;
	Mon, 30 Jun 2025 14:09:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 70E061A13F8;
	Mon, 30 Jun 2025 14:09:32 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP3 (Coremail) with SMTP id _Ch0CgA3mSYaKmJolXe7AA--.51861S3;
	Mon, 30 Jun 2025 14:09:32 +0800 (CST)
Subject: Re: [PATCH 00/23] md/llbitmap: md/md-llbitmap: introduce a new
 lockless bitmap
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, colyli@kernel.org, song@kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <808d3fb3-92a9-4a25-a70c-7408f20fb554@redhat.com>
 <288be678-990b-86f9-1ffd-858cee18eef3@huaweicloud.com>
 <CALTww28grnb=2tpJOG1o+rKG4rD7chjtV3Nmx9D1GJjQtVqWhA@mail.gmail.com>
 <3836a568-20c0-c034-7d7f-42a22fe77b4e@huaweicloud.com>
 <CALTww281F6VhwfR+WRwSs0BYDdJai8aA0i9wg-gdu4emvhjFng@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <5d61b6cc-43a8-fe2f-0d5a-17b167c136f2@huaweicloud.com>
Date: Mon, 30 Jun 2025 14:09:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww281F6VhwfR+WRwSs0BYDdJai8aA0i9wg-gdu4emvhjFng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgA3mSYaKmJolXe7AA--.51861S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYK7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
	6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72
	CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4II
	rI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr4
	1l4c8EcI0Ec7CjxVAaw2AFwI0_Jw0_GFyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAq
	x4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r
	43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF
	7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxV
	WUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU
	oOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/06/30 13:38, Xiao Ni 写道:
>> I don't quite understand, in my case, mdadm -As works fine.
> Sorry for this, I forgot I removed the codes in function llbitmap_state_machine
>          //if (c == BitNeedSync)
>          //  need_resync = true;
Ok.

> The reason I do this: I find if the status table changes like this, it
> doesn't need to check the original status anymore
> -               [BitmapActionReload]            = BitNone,
> +               [BitmapActionReload]            = BitNeedSync,//?

However, we don't want do dirty the bitmap page in this case, as nothing
chagned in the bitmap. And because of this, we have to check the old
value anyway...

Thanks,
Kuai

