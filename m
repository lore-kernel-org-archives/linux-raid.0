Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F6F2E3390
	for <linux-raid@vger.kernel.org>; Thu, 13 Mar 2025 03:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741834849; cv=none; b=EwpMXwXPq+nXHOWBWnDJNSkmI4hDZcX8wbQ2LNimmcH9lnozQ7AccF68njQ3ks6S68ivG4BnXyHCZd15u/Og25yWrgDBsAPk61sh2B4Lz6eVyVksN7SD+4y87iEPXUEK7HJqZMnM5DJW3dSaFGVLA2O1FBKJV4O4tEMNTkZ/zOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741834849; c=relaxed/simple;
	bh=5W3bYSmJgEN/zIatek/UbOG+/H3ggt9GvcBvsmbcgew=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Io50gIKBB90yDYZfx2iUtjqXZyLgLt81LKPZosL9+iD7TablVMALSIFu4GmO9W1NuxDbrEB/HnESMzd/92ajrhodVu2jvHK10/3tDSpFDM8L7DkcTCZGn40gpMhMGp0WcWUFG45d61ZVhfus8jg0ANtS9GpUF1UD4CKel1oTZVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZCsgR31Jrz4f3lgS
	for <linux-raid@vger.kernel.org>; Thu, 13 Mar 2025 11:00:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4C2D91A1273
	for <linux-raid@vger.kernel.org>; Thu, 13 Mar 2025 11:00:43 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB32l5ZStJnZyxbGQ--.42869S3;
	Thu, 13 Mar 2025 11:00:43 +0800 (CST)
Subject: Re: [PATCH v3] md/md-bitmap: fix wrong bitmap_limit for clustermd
 when write sb
To: Su Yue <l@damenly.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Su Yue <glass.su@suse.com>, linux-raid@vger.kernel.org, hch@lst.de,
 ofir.gal@volumez.com, heming.zhao@suse.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250303033918.32136-1-glass.su@suse.com>
 <47caca95-7bd9-69d0-6a28-231e0b0f1831@huaweicloud.com>
 <zfhzpxdr.fsf@damenly.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <af9cbf48-2eae-f9b9-2a8b-ffa995b6e987@huaweicloud.com>
Date: Thu, 13 Mar 2025 11:00:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <zfhzpxdr.fsf@damenly.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB32l5ZStJnZyxbGQ--.42869S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYy7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2js
	IEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE
	5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeV
	CFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2
	V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCF54CYxVCY1x0262kKe7AKxVWUAV
	WUtwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/03/05 18:47, Su Yue 写道:
> Since it's a bug fix, could you please queue it to 6.14 if the merge window
> is still open?

Sorry that I forgot to reply.

Since this problem is not introduced in this merge window, and current
6.14-rc6 is a bit late. This fix should be queued to 6.15-rc1.

Thanks,
Kuai

