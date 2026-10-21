Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.249.212.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792544420;
	b=PE/wYnE+ase4DIntMTCCGLmLVXG2ljKNRuyVB6gxskj4Hfk+eZCdipUCXLHtJB12r+BO
	 PV/7EL2oI/RGpIV19WEIXUUAp6gezYkh1/RLmKMypAxEaUE15GUYOc+0xCqo9IMf56H8K
	 /VeUWbffo8fhl5cT5Bq1mB0nwkQUSvfrHRF98KIGAVS04UMtE4JQzy/AIFpujqXbHaMKc
	 wq5IZWINF55JfD8LfqjV2TV+BFVqHHdiiy/7X8x4a+LThC72S/kjIavxy3i45E89SWFQ/
	 pU/UMI8myKaG/SR6iiGre7GSdThf+d7Qa0NaSSfSkQnl0XVBoaPGrgKt5DsVDZBAVkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792544420;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=lKaMXO6A9FG34UhzMzov2zcmA1FJblBJ4naK4GIm76A=;
	b=lSG8+Qcu4PjaCZFU/ThIEVbeSuK4fRlOE2jmXa5SGh+THztUqSnKEUhzINrg4WZ8d9u9
	 JuYGx1u6pUdnIBbbRDcVPGgIYIh5W4zaNCfvNK8z10cuSq+ijU5r7cs3cdOc2csROKUgU
	 pMifkegJ1UG5bhPocMzU0ke0Fn/xfVeX982uYjtUeOSOfujnSci5NQSoekfqnCYKXXf2/
	 ftKJqCN8lT0/Xz6mOsnt0S6d33zHemOfATEWsoCShjKE6PNfcQ4N3YswOBa8ppnp2CS2T
	 HJHR/adXOXpBfpXGj3LyfX3F3Yft3in3l6nWQJwiT6we+TZPm6swOqKveVlqg6M9KpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=none smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=45.249.212.51
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D52A606A319
	for <linux-raid@vger.kernel.org>; Wed, 21 Oct 2026 01:00:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D52A606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j8WCw4GNCzYQtml
	for <linux-raid@vger.kernel.org>; Wed, 21 Oct 2026 09:00:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 64DE240573
	for <linux-raid@vger.kernel.org>; Wed, 21 Oct 2026 09:00:15 +0800 (CST)
Received: from [10.174.178.164] (unknown [10.174.178.164])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAXTu2dDthqOEHnBA--.19257S3;
	Wed, 21 Oct 2026 09:00:15 +0800 (CST)
Message-ID: <cc3dc99d-cb3e-49b6-b01d-1eaedabfae0e@huaweicloud.com>
Date: Wed, 21 Oct 2026 09:00:12 +0800
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/6] md: fix takeover failure handling and raid0 size
 calculation
To: Bruce Johnston <bjohnsto@redhat.com>, Zizhi Wo <wozizhi@huaweicloud.com>,
 yukuai@fygo.io, Li Nan <magiclinan@didiglobal.com>
Cc: linux-raid@vger.kernel.org, yangerkun <yangerkun@huawei.com>,
 "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>
References: <20261019010827.2922617-1-wozizhi@huaweicloud.com>
 <atenHrzZVtzu5YOa@vdo-obuilder-bjohnston.permabit.com>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <atenHrzZVtzu5YOa@vdo-obuilder-bjohnston.permabit.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXTu2dDthqOEHnBA--.19257S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ur15GF43Gw47AF1rKrW7urg_yoW8tw47p3
	9xJ3WY9398G34Svwnxtry8A3yFyw1xGF1UtF9xJw48WFy2vry7CrykKryruF98X3s5Xa4j
	yws8Xr9akFyqyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkm14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r12
	6r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUYCJmUUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

Hi,

在 2026/10/21 1:38, Bruce Johnston 写道:
> I was wondering how you would feel about splitting up this series
> into two separate patch sets. 1 for the takeover failure rework and
> the other for the code cleanup.

Thanks, I see your point. IMO the split is a little tricky though:
- 1-3 are one fix: stale mddev state after a failed takeover.
- 4 is also a fix and touches the same takeover functions, so it shares
the context of patch 1-3.
- 5 is the only pure cleanup, but it rewrites the check for 4.
- 6 is a size fix, and uses the helper from 5.

So the chain is [1-3] -> 4 -> 5 -> 6. I'd slightly prefer to keep them
together for that reason. Of course, this also depends on what Yu Kuai,
Li Nan and the other maintainers think. What do you think?

Thanks,
Zizhi Wo

> 
> On Mon, Oct 19, 2026 at 09:08:21AM +0800, Zizhi Wo wrote:
>> From: Zizhi Wo <wozizhi@huawei.com>
>>
>> Patches 1-3 fix the inconsistent mddev state left behind when a takeover
>> fails.
>>
>> Patch 4 rejects a raid0 takeover whose zones cannot cover the capacity the
>> gendisk advertises, fixing a syzbot BUG() in find_zone().
>>
>> Patch 5 factors out the member-size rounding. Patch 6 uses it in
>> raid0_size(), where the power-of-2 mask is not a round down for a
>> non-power-of-2 chunk.
>>
>> Changes since v1:
>>   - Added 3 patches fixing the inconsistent mddev state left behind by a
>>     failed takeover in raid0, raid10 and raid5.
>>   - Patch 4: expanded the commit message with a paragraph addressing the
>>     issue previously reported by Sashiko.
>>
>> v1:
>> https://lore.kernel.org/all/20261017005802.2212102-1-wozizhi@huaweicloud.com/
>>
>> Zizhi Wo (6):
>>    md/raid0: don't leave mddev in an inconsistent state when takeover
>>      fails
>>    md/raid10: don't leave mddev in an inconsistent state when takeover
>>      fails
>>    md/raid5: don't leave mddev in an inconsistent state when takeover
>>      fails
>>    md/raid0: reject a takeover whose zones cannot cover the array
>>    md/raid0: factor out raid0_member_sectors()
>>    md/raid0: round member size in raid0_size() with sector_div()
>>
>>   drivers/md/raid0.c  | 84 +++++++++++++++++++++++++++++++++++----------
>>   drivers/md/raid10.c | 11 ++++--
>>   drivers/md/raid5.c  | 13 ++++---
>>   3 files changed, 84 insertions(+), 24 deletions(-)
>>
>> -- 
>> 2.52.0
>>
>>
> 
> 
> 

