Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89D1171E62;
	Tue, 28 May 2024 13:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716904197; cv=none; b=SFoVz4Tu6amBtBVz3wo5MgqX7HYb0JVx8WcWnOvr9BfaFPK+3z62gwyNAfLP2vJ2zxZ2gYnC/be3U5sVhsaNtzTO5Z1e7dEReHIcdhg27vVqWnR7+kHpkGKsu0YMliGhQAFKy0gqhQhCYlFeNt9Tk84oAkSawIaYxiqo4mcifZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716904197; c=relaxed/simple;
	bh=Nc6MCCKPcIdAj3+9dNaCNtQ8Lul5I7+BKaFDnHDpSlQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tvjG5mF/B18T1VuExvdQP6KsJL/VfqrhuQQqnkByOy7m/1RfuH/0h2ESWHssH70kel/pJB2CDBfsdcCEaCcR2VU3JBIdMBnQ/h/+6Cz144l8HP/YVR4qKz10CXhsuNPeWz/HdBT8bAX+HVzc1GZ4628/WRkeIMO7HY1PLzqyfgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4VpYm32mwCz4f3jXs;
	Tue, 28 May 2024 21:49:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id A1FB21A016E;
	Tue, 28 May 2024 21:49:48 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP2 (Coremail) with SMTP id Syh0CgAnmAv44FVmYpoPOQ--.23340S3;
	Tue, 28 May 2024 21:49:48 +0800 (CST)
Message-ID: <bc582a25-2124-2aa8-f26b-94fd5a50f900@huaweicloud.com>
Date: Tue, 28 May 2024 21:49:44 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2] md: make md_flush_request() more readable
To: Christoph Hellwig <hch@infradead.org>, linan666@huaweicloud.com
Cc: song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
 houtao1@huawei.com, yangerkun@huawei.com
References: <20240528203149.2383260-1-linan666@huaweicloud.com>
 <ZlXa5mFl9x4Lk4KQ@infradead.org>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <ZlXa5mFl9x4Lk4KQ@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgAnmAv44FVmYpoPOQ--.23340S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYD7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvE
	ncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I
	8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0E
	jII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I
	8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AK
	xVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcV
	AFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8I
	cIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
	0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQZ23UUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2024/5/28 21:23, Christoph Hellwig 写道:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> .
As suggested by Kuai, I will use bio_sectors instead of bi_size in v3.

-       if (bio->bi_iter.bi_size == 0) {
+       if (!bio_sectors(bio)) {

There is no any other changes, could I add your review by in v3?

-- 
Thanks,
Nan

