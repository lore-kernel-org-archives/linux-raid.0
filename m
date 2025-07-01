Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8859218C12;
	Tue,  1 Jul 2025 02:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751335388; cv=none; b=SDzyMj7lxQIK2dQ6VjYU5wUHWfmjnmH6sX7ygtzg/argkPmB/xW+bKsQEWNH9ntdf5X3Y/FeokwmJGLN39ZHEiotweKUl63OIvs5fOt0oUtxhgYs24N4HaGoKVKo8aU+oI9eqgQx3uduiwHJGmMhaHUOqGZSujTulgc6UV+FAa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751335388; c=relaxed/simple;
	bh=N9azdm4DxVdewLUb+pWeRsyf3KqubtqYELLkbK3M4Mc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=rUO/G5VlMTWKvzgLqrVa3ZBhI0sHNTGqdHltJufDMYJ7Zg3m7dDvxp39inhducDyOWtJBxKe+syfoDDF4bTOdW9U0OY8GTjlEXOrGA+F608Rpx+FzFpfGPlBSez3r7cw3lj3rSIhmw1rD98bD3h8WYNZL+WODncIt940xqORW4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bWRBb3q9JzKHMwB;
	Tue,  1 Jul 2025 10:03:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id E45301A1024;
	Tue,  1 Jul 2025 10:03:01 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP2 (Coremail) with SMTP id Syh0CgBHfArTQWNosTYVAQ--.33413S3;
	Tue, 01 Jul 2025 10:03:01 +0800 (CST)
Subject: Re: [PATCH 16/23] md/md-llbitmap: implement bit state machine
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, colyli@kernel.org, song@kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-17-yukuai1@huaweicloud.com>
 <c76f44c0-fc61-41da-a16b-5a3510141487@redhat.com>
 <cf6d7be1-af73-216c-b2ab-b34a8890450d@huaweicloud.com>
 <CALTww2-RT64+twHo3=Djpuj81jArmePQShGynDrRtYab3c1i2w@mail.gmail.com>
 <93166d88-710f-c416-b009-5d57f870b152@huaweicloud.com>
 <CALTww2820X=HU3Zuu+z19oCaPL+oQ4bMNostoAgfDk1-3nB3aQ@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <ede16ca4-96ef-e8e6-45fd-1c88cddc7f4a@huaweicloud.com>
Date: Tue, 1 Jul 2025 10:02:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww2820X=HU3Zuu+z19oCaPL+oQ4bMNostoAgfDk1-3nB3aQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHfArTQWNosTYVAQ--.33413S3
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

在 2025/07/01 9:55, Xiao Ni 写道:
> If there is a filesystem and the write io returns. The discard must
> see the memory changes without any memory barrier apis?

It's the filesystem itself should manage free blocks, and gurantee
discard can only be issued to free blocks that is not used at all.

Thanks,
Kuai

