Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1E923958A;
	Tue,  6 Jan 2026 02:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767667490; cv=none; b=KTvg4YkK/p9QImpZTJi176qPG/4avrB53Xz9h72GJn2uuZ8hWkZqlo2JWb/CwpuKt6HP6z8KgH6QqY2H4nM4uFsiLXiC7/qR6Bi3IVLih6Drd6zfXfpXU+1KEywgIR246DwJdiFRVK5BOpF/UE9sSGB0QmPxjsw/ZD2WOkticSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767667490; c=relaxed/simple;
	bh=Pq1sWJnUYCI3d9dcfPNUac6MHt7y7N+DfmmYIODjtI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l4GFkU1UHAqtwS80FJDXx2sOXeF68kOdaZpjGund0iwo2rQxK/IpdWWn7pw7y9LnZpLdG2+5jYvR+QaHfeZczHAaNsFPicJELwXRCH6B2uNcju3qKlTr5QmyY+z4CTzt3pXrht9XKCzymOxRlrrm4PKRZokmi32NTGo3EK/dSpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dlb8k37cvzKHLyb;
	Tue,  6 Jan 2026 10:44:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 887EB4057A;
	Tue,  6 Jan 2026 10:44:45 +0800 (CST)
Received: from [10.174.178.72] (unknown [10.174.178.72])
	by APP4 (Coremail) with SMTP id gCh0CgBHqPgbd1xpkccoCw--.63449S3;
	Tue, 06 Jan 2026 10:44:45 +0800 (CST)
Message-ID: <d00be167-741a-4569-a51e-38b36325826e@huaweicloud.com>
Date: Tue, 6 Jan 2026 10:44:38 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/5] md/raid1: introduce a new sync action to repair
 badblocks
To: Roman Mamedov <rm@romanrm.net>
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 houtao1@huawei.com, linan122@h-partners.com, zhengqixing@huawei.com
References: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
 <20251231161130.21ffe50f@nvm>
From: Zheng Qixing <zhengqixing@huaweicloud.com>
In-Reply-To: <20251231161130.21ffe50f@nvm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHqPgbd1xpkccoCw--.63449S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CF15Jr1kGFW7Kw13WFyDJrb_yoW8WryUpr
	Z8K3WUKr1kGF18G3WDZa40934kKw1fGrW7Jr1rG3WUu345Ww1IvFsrXw45Xa4qyrnav34Y
	vr4DWryrJFWkZaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUF1
	v3UUUUU
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

Hi,

在 2025/12/31 19:11, Roman Mamedov 写道:
> On Wed, 31 Dec 2025 15:09:47 +0800
> Zheng Qixing <zhengqixing@huaweicloud.com> wrote:
>
>> From: Zheng Qixing <zhengqixing@huawei.com>
>>
>> In RAID1, some sectors may be marked as bad blocks due to I/O errors.
>> In certain scenarios, these bad blocks might not be permanent, and
>> issuing I/Os again could succeed.
>>
>> To address this situation, a new sync action ('rectify') introduced
>> into RAID1 , allowing users to actively trigger the repair of existing
>> bad blocks and clear it in sys bad_blocks.
>>
>> When echo rectify into /sys/block/md*/md/sync_action, a healthy disk is
>> selected from the array to read data and then writes it to the disk where
>> the bad block is located. If the write request succeeds, the bad block
>> record can be cleared.
> Could you also check here that it reads back successfully, and only then clear?
>
> Otherwise there are cases when the block won't read even after rewriting it.

Thanks for your suggestions.

I'm a bit worried that reading the data again before clearing the bad 
blocks might

affect the performance of the bad block repair process.


> Side note, on some hardware it might be necessary to rewrite a larger area
> around the problematic block, to finally trigger a remap. Not 512B, but at
> least the native sector size, which is often 4K.


Are you referring to the case where we have logical 512B sectors but 
physical 4K sectors?

I'm not entirely clear on one aspect:

Can a physical 4K block have partial recovery (e.g., one 512B sector 
succeeds while the other 7 fail)?


Thanks,

Qixing


