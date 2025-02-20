Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3883D1D5AB9;
	Thu, 20 Feb 2025 03:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740021593; cv=none; b=XgyeFTGf+M2Fm+qG4quY+5a6U3+7jMqy0wxmr4RDqKTJZ3XEdFbFZZ0ZHKMIRLifukIQEzxvtQTMm/NgeP0qPF2Y6lXo79Ey/0tSPZ4J7hyCsW48EnQZzUPzADJFgWg9JnCTdP0Ub23sjMbrlm+F1XCyCAhTAyt/1b7Vv9Y2pHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740021593; c=relaxed/simple;
	bh=SNhE8K7wXdB/gzG9CS7l+aoTGIwn1SxIZQqrrhY05yE=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=qILi1BxS7/zWXyfTg05PEBJ8gDD93DRT3l8r1/hf1ilm07XlPjOFHmtTyFBUyzdWtyRBO4JbdfqruniEKR47lFBRGdDUCymRE4SLN+Mq6AoIwU5xE9oro5hLRCTmEz9DAgsmLxCdF4idWVzCNlKjUaI6gnDQkqeyNt/xvY1pW7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Yyz0x4bNTz1wn6P;
	Thu, 20 Feb 2025 11:15:45 +0800 (CST)
Received: from kwepemk500007.china.huawei.com (unknown [7.202.194.92])
	by mail.maildlp.com (Postfix) with ESMTPS id DE9F0180216;
	Thu, 20 Feb 2025 11:19:41 +0800 (CST)
Received: from [10.174.179.143] (10.174.179.143) by
 kwepemk500007.china.huawei.com (7.202.194.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 20 Feb 2025 11:19:41 +0800
Subject: Re: [BUG] possible race between md_free_disk and md_notify_reboot
To: Guillaume Morin <guillaume@morinfr.org>, Yu Kuai <yukuai1@huaweicloud.com>
CC: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<song@kernel.org>
References: <ad286d5c-fd60-682f-bd89-710a79a710a0@huaweicloud.com>
 <82BF5B2B-7508-47DB-9845-8A5F19E0D0E5@morinfr.org>
From: Yu Kuai <yukuai3@huawei.com>
Message-ID: <53e93d6e-7b73-968b-c5f2-92d1b124ecd5@huawei.com>
Date: Thu, 20 Feb 2025 11:19:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <82BF5B2B-7508-47DB-9845-8A5F19E0D0E5@morinfr.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemk500007.china.huawei.com (7.202.194.92)

Hi,

在 2025/02/20 11:05, Guillaume Morin 写道:
> how it was guaranteed that mddev_get() would fail as mddev_free() does not check or synchronize with the active atomic

Please check how mddev is freed, start from mddev_put(). There might be
something wrong, but it's not what you said.
