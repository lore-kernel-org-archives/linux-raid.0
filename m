Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F49248F5D;
	Tue, 27 May 2025 08:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748336330; cv=none; b=IZ95jsUM9otPxc/SG9yVeYLtcMKE0iKVuRvOQlIUk6oG8+BoVU4ozcu8lSgSQwzFu4eJTOkvQBX267jCoD2DaJV8UZue9lTS+XkaHeDQ5bwAFB05EE6gHMj0vTB8EkomQnTMY+z2LpRMISoIF/ZPsQgv/usAJVaBgnjTyLrO0dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748336330; c=relaxed/simple;
	bh=0+oWIcvTu/6lfVaaDvpysFM9C2wMHeo7yerphO7+h3c=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ADeSoV39oeLyOUEoZeKEoHkzu7vWp2gWuZzpGnAxspD10Gm3egIzMiy3P5/G7auvTGxf8/sX+G9mJJqD2UGb4b2cL8zOQb0uu2AIH7nk2+iesxmFsrdPvYS6urt4qVScyC0RYBKNCsc0FikIoosR0gt9cKYeJWBwZjvRtEtFSpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4b663t2Kyyz4f3lDN;
	Tue, 27 May 2025 16:58:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 172961A0BFC;
	Tue, 27 May 2025 16:58:45 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl_EfjVoXCmiNg--.23884S3;
	Tue, 27 May 2025 16:58:44 +0800 (CST)
Subject: Re: [PATCH 15/23] md/md-llbitmap: implement llbitmap IO
To: Yu Kuai <yukuai1@huaweicloud.com>, Christoph Hellwig <hch@lst.de>
Cc: xni@redhat.com, colyli@kernel.org, song@kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-16-yukuai1@huaweicloud.com>
 <20250527082709.GA32108@lst.de>
 <6eea2fad-f405-ed20-73f3-c26542b401bf@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6cf9e87e-eda2-d35b-961c-4936fbee1de9@huaweicloud.com>
Date: Tue, 27 May 2025 16:58:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <6eea2fad-f405-ed20-73f3-c26542b401bf@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCl_EfjVoXCmiNg--.23884S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYN7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
	6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVW8JVWxJwAm72
	CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4II
	rI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr4
	1l4c8EcI0Ec7CjxVAaw2AFwI0_Jw0_GFyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAq
	x4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r
	43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF
	7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxV
	W8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7V
	Ubd-PUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/05/27 16:55, Yu Kuai 写道:
> FYI, I still find splitting the additioon of the new md-llbitmap.c into
> multiple patches not helpful for reviewing it.  I'm mostly reviewing
> the applied code and hope I didn't forget to place anything into the
> right mail.

And for this, I'll switch to a single patch, I prefer this way as well.

Thanks,
Kuai

