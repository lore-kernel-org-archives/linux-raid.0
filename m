Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3413121170D
	for <linux-raid@vger.kernel.org>; Fri, 30 May 2025 08:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748592703; cv=none; b=R/SzU5GPMYUb8oWlK0t3fLVBpHNzXgPbtyp+fzTZ/rjhtfD3AdRmgdrmA6hdaIAdJqiFpfL/JwXVgPxXOZn4NI8aZmLPRox3QNe3c6IFn4lVYsh4HUVk046NEBdTZSSllpDgdAqtvRjG/bIfJvubzweW4nqXMX3JlaPB/FYK+94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748592703; c=relaxed/simple;
	bh=sr++aARalVvqaGqOgst4gBKesSg37y3VnlCL1LtplY4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=JdVJxD/PAkq+MZSfXEUZ3CYyS7tItiFXsCQrHqZVCVCynnfUlJTh2F1T1tl+cAd3LtZLS1LYX0Blq2q8nMUtbUwy8hdSG8aZMKEVXRhjA4TbNJ46hQEyIZN2p3epGmI7yCyxlesWg4wmXlyME+D9c9Tqz2PjcUqd9/+Gmqfp0aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4b7wth5vYvzKHMrC
	for <linux-raid@vger.kernel.org>; Fri, 30 May 2025 16:11:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 007F51A0849
	for <linux-raid@vger.kernel.org>; Fri, 30 May 2025 16:11:38 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgA3m185aDlozcDXNw--.29506S3;
	Fri, 30 May 2025 16:11:38 +0800 (CST)
Subject: Re: [PATCH 1/2] md: Don't clear MD_CLOSING until mddev is freed
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com, song@kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250515090847.2356-1-xni@redhat.com>
 <20250515090847.2356-2-xni@redhat.com>
 <fed9d361-7005-d82c-d03b-6b6e5f12d4d5@huaweicloud.com>
 <CALTww29Q+GiCW3BNQak3BvYD5EWZXQE41P4Tz8H9Kq1dPoDyVA@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <23189df4-c200-a147-0b6f-7cceeb21887f@huaweicloud.com>
Date: Fri, 30 May 2025 16:11:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww29Q+GiCW3BNQak3BvYD5EWZXQE41P4Tz8H9Kq1dPoDyVA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3m185aDlozcDXNw--.29506S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYk7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
	6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72
	CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0
	xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4c8EcI0Ec7CjxVAaw2AFwI0_JF
	0_Jw1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/05/30 15:57, Xiao Ni 写道:
> The first patch isn't used to resolve the problem that /dev/md0 can't
> be removed. So it's not useful to merge itself. I'll send all patches
> in v2, so please remove it from this PR.

Now dropped.

Thanks,
Kuai

