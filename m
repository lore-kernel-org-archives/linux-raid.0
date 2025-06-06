Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684BF219317
	for <linux-raid@vger.kernel.org>; Fri,  6 Jun 2025 08:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749199740; cv=none; b=VSHc2esYMaTRB8ot+N2oztkyn8DpEIufVbuPx1f1bf7v4OXKZmWYQ7yIhpM89uYJ68Ri8W12pFM0uy1Kuh9FugOr3SzrpDfdB1px1Icl8I2Lp13yrC/WrlLujP1/Dn8V/bLiHNakJ+mTQRwsANrVOyti/gDruspSGsMrKbZY5To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749199740; c=relaxed/simple;
	bh=RUrM5w41xCiNX8VLYeK4Yjv4DepW5xvzrjW/17PJDyo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=fvDe82SYmGKhfJW84FXppx0LnBmBExSYXQTbvPIksEhGo9WiO2gbQpSW/+X13NP9mkPnFzaAZmcfZxviLsKqtP84FtgQxxcBnd9FSFENiKK0+n731eRsl7ur56Bs7P79rLTyzJS+mpcP6Cin1UAWWMQUORF0IEEjo5gi9CVgvJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bDFNQ0rxwzKHNLw
	for <linux-raid@vger.kernel.org>; Fri,  6 Jun 2025 16:48:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7AB781A1AA8
	for <linux-raid@vger.kernel.org>; Fri,  6 Jun 2025 16:48:52 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCH619zq0JoJW+vOg--.52752S3;
	Fri, 06 Jun 2025 16:48:52 +0800 (CST)
Subject: Re: [PATCH 1/3] md: call del_gendisk in control path
To: Yu Kuai <yukuai1@huaweicloud.com>, Xiao Ni <xni@redhat.com>,
 linux-raid@vger.kernel.org
Cc: ncroxon@redhat.com, song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250604090742.37089-1-xni@redhat.com>
 <20250604090742.37089-2-xni@redhat.com>
 <30a77424-e5f4-ee83-52a2-cab7e3cbc1ed@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <cd3e67e6-05c2-56f8-9bcc-c95d0f05df92@huaweicloud.com>
Date: Fri, 6 Jun 2025 16:48:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <30a77424-e5f4-ee83-52a2-cab7e3cbc1ed@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCH619zq0JoJW+vOg--.52752S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYk7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8I
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

Hi,

在 2025/06/06 16:46, Yu Kuai 写道:
> +    if (!ret && test_bit(MD_DELETED, &mddev->flags)) {
> +        ret = -EBUSY;

And I think ENODEV is better here.

Thanks,
Kuai

