Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7983559D0;
	Fri,  6 Feb 2026 09:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770368873; cv=none; b=CNmmKBzMNb+fXVe2ZuSNvLavZ944B0tsMtog69z8zsfUvld10ytphan2OizdFdLkDvkZHKOLb2W+Nf4jH2iSaBKXrS9iLS9iBSTJAr5WIkpOVP1db9a/jCo6ci2ugzqE6hqPtlM/WSGkcRG4TwXzAA/qt/V4dMExuah1eNrNISE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770368873; c=relaxed/simple;
	bh=+HVZfeRZMAMG60Hu45Y/DAqUuDhBIaEhQO4tS4tpKDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S1cXZGsZTK0H19jOXoomKfqaG4sHRg5diHIDDZcUoU5PlhGO2PbVvq3GdNiLTn+fVF2HXuWbOEbDmfJamN6Ty3so1Wljj44uZE1yZ5Lxa9Pu8FAy+GtIfDlpWeU/MQPJMT04PWRao52b7/+Czylu9uRmcKoB3I7bpHhjeF3BQn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f6pB30b5lzYQtLH;
	Fri,  6 Feb 2026 17:06:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4136740577;
	Fri,  6 Feb 2026 17:07:43 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPldr4Vpv9nPGQ--.20424S3;
	Fri, 06 Feb 2026 17:07:43 +0800 (CST)
Message-ID: <151dd7eb-4dd0-9183-41eb-d54dfaea3285@huaweicloud.com>
Date: Fri, 6 Feb 2026 17:07:41 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 03/14] md/raid1: use folio for tmppage
To: yukuai@fnnas.com, Li Nan <linan666@huaweicloud.com>, song@kernel.org
Cc: xni@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yangerkun@huawei.com, yi.zhang@huawei.com
References: <20260128075708.2259525-1-linan666@huaweicloud.com>
 <20260128075708.2259525-4-linan666@huaweicloud.com>
 <b19b6eb8-b5c1-4ca2-a80e-f177370085bf@fnnas.com>
 <4b57e9b4-e660-a7df-4655-93c2815ec758@huaweicloud.com>
 <44521568-3ac0-4374-9c3b-756b8e18192f@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <44521568-3ac0-4374-9c3b-756b8e18192f@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPldr4Vpv9nPGQ--.20424S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYC7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvE
	ncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I
	8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0E
	jII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4c
	8EcI0Ec7CjxVAaw2AFwI0_JF0_Jw1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUQZ23U
	UUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/2/5 15:33, Yu Kuai 写道:
> Hi,
> 
> 在 2026/2/5 15:23, Li Nan 写道:
>> Yeah, should we introduce safe_put_folio()? Or just check NULL here.
> 
> Yes, and don't copy implementation. Just convert safe_put_page(page) to
> safe_put_folio(page_folio(page)) first.
> 

page cannot be NULL in page_folio(), and the code would be:

if (page)
   safe_put_folio(page_folio(page))

This also looks odd. Keeping both functions and removing the page one
after the last reference to it in RAID5 is removed seems better. What do
you think?

-- 
Thanks,
Nan

