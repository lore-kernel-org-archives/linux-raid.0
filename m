Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039912253F3
	for <linux-raid@vger.kernel.org>; Wed, 11 Jun 2025 06:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749622297; cv=none; b=db/Ut4DEVuPyrbj7mHWi9F5YPhoNyfOLHwsREY0GnV/0/LfE3NrMuy0qMdfjR8FggYL6CcGW268z28Xq8G441l/5dkjlT3CrkfbXgN1kUq+PFhibdy2WbySY3EiXId9ZxoZ+g1rKhwAvVaOnIOcvTiGXGqUHpKc+9GK/FGEhDTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749622297; c=relaxed/simple;
	bh=Ltz/OVUfOdYY4OwLi670c/CDCe8I1rwlw6sVanpQk9E=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=IFpsgWP6w49p1oGoL6iw0hSO1LhbL6jgIHLalfSmAGdcwL/dWcTKggUC8uLb11rFw6hwaW3stFW3uknZYaHpxoQdRDRHPoi8gWx09/BgzhPE8F/aZeJfJODXze4Upeul5rGOD1YhdmbHgNRYprFmIj4xHOsl5E3U9NKSL11Qjxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bHFfX5wTfzYQtqb
	for <linux-raid@vger.kernel.org>; Wed, 11 Jun 2025 14:11:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D21871A13CC
	for <linux-raid@vger.kernel.org>; Wed, 11 Jun 2025 14:11:31 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXu18THkloIgapPA--.14502S3;
	Wed, 11 Jun 2025 14:11:31 +0800 (CST)
Subject: Re: [PATCH 2/3] md: Don't clear MD_CLOSING until mddev is freed
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: ncroxon@redhat.com, song@kernel.org, yukuai1@huaweicloud.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250610072022.98907-1-xni@redhat.com>
 <20250610072022.98907-3-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <2e31aea2-b56f-0417-6783-e6b2a050e0d9@huaweicloud.com>
Date: Wed, 11 Jun 2025 14:11:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250610072022.98907-3-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXu18THkloIgapPA--.14502S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYk7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
	6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72
	CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0
	xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4c8EcI0Ec7CjxVAaw2AFwI0_JF
	0_Jw1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUF9a9DUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/06/10 15:20, Xiao Ni Ð´µÀ:
> UNTIL_STOP is used to avoid mddev is freed on the last close before adding
> disks to mddev. And it should be cleared when stopping an array which is
> mentioned in commit efeb53c0e572 ("md: Allow md devices to be created by
> name."). So reset ->hold_active to 0 in md_clean.
> 
> And MD_CLOSING should be kept until mddev is freed to avoid reopen.
> 
> Signed-off-by: Xiao Ni<xni@redhat.com>
> ---
>   drivers/md/md.c | 16 ++++------------
>   1 file changed, 4 insertions(+), 12 deletions(-)

Reviewed-by: Yu Kuai <yukuai3@huawei.com>

