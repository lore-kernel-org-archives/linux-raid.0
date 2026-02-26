Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4772394465
	for <linux-raid@vger.kernel.org>; Thu, 26 Feb 2026 08:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772094575; cv=none; b=BvSmzRnLm/h0WcwupRSQ2BIOJSuvonw8FDATc1nvRDrvttqTYdcUv2vaUNIcsfGCrQbUgodiKl+bht+SQgotA6hwmL1MYIdZt0n/BocBOgEVY0FIds1PQdo3zdBEIbHzhY+8u7WEZgmlY9EiM8vhuUx3a0+x/1smiRU9x8bLMW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772094575; c=relaxed/simple;
	bh=AZGo8cVLQF/Yav2a+sLc/9/2wYdsV39QtKvGE7ALfo0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ISZsAJdF03qRjb57yebjMn2ecjMufnETGa9N2oY3peKfg3sKgVj3XdM25iE8p4ceKAOiUAHhcJjx46SiyF3UKiojeeunnGclT9Wt448Ezn5Kx6mK3u0N6fJ3YlpV3SDNX+tMBoY40LhXldgTO/Rv4Pu80EZlJjenoEOy0z2WOFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=frCFe2oE; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="frCFe2oE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=KQ
	4psOCvPiUoGjJqOS+GvB9gGSMdcEQiIfi+nDTpXas=; b=frCFe2oEJqQiTA+y3m
	cAKeayh1BhT3jpHTVfhhccgxzoHhYSquaKfhIguuo8EZIGG7MDsNHqkbeVLIpVXo
	PQAASGu3n3L27W3q5HNlZHzisZDhie1kAhER4IO38np7ST2Np65Kh+cAlY/oi8qP
	nNrVKERk+CpFvNPaGzOKnrgUM=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgA3U5JJBKBp_+tHQQ--.33S2;
	Thu, 26 Feb 2026 16:29:01 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: Yu Kuai <yukuai@fnnas.com>
Cc: song@kernel.org,
	snitzer@kernel.org,
	xni@redhat.com,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/1] md/raid5: don't set bi_status for requeued IO in STRIPE_WAIT_RESHAPE
Date: Thu, 26 Feb 2026 16:28:56 +0800
Message-Id: <20260226082856.610621-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <71e50b0e-0669-4a40-84d5-3c3061dfb229@fnnas.com>
References: <20260203095156.2349174-1-yangxiuwei@kylinos.cn> <71e50b0e-0669-4a40-84d5-3c3061dfb229@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgA3U5JJBKBp_+tHQQ--.33S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF13Cw1fJF1rJrW3KF1Utrb_yoW8AF13p3
	ykCFZIya1kZ392krsrZFWjq3W5Z3y5KFW5G3yktw18ZF45Xr1Uur13J34DuF1UCrZxG3yj
	q3y0v3s7C3Z0qa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRveHgUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6Q2WJ2mgBE3C3QAA3K

Hi,

On 2026/2/3 17:51, Yang Xiuwei wrote:
>> When reshape is interrupted, IO that needs to be requeued incorrectly
>> sets bi->bi_status to BLK_STS_RESOURCE. This causes md_free_cloned_bio()
>> to copy the error status to the original bio, which is wrong because
>> requeued IO should be retried, not failed.
>>
>> This was found during LVM testing where reshape operations under I/O
>> load would cause I/O errors and filesystem corruption.
>>
>> Remove the bi_status assignment to prevent incorrect error marking.
>>
>> Fixes: 41425f96d7aa ("dm-raid456, md/raid456: fix a deadlock for dm-raid456 while io concurrent with reshape")
>>
>> Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
>> ---
>>   drivers/md/raid5.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 8dc98f545969..128c0b7e9f54 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -6038,7 +6038,6 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
>>       raid5_release_stripe(sh);
>>   out:
>>       if (ret == STRIPE_SCHEDULE_AND_RETRY && reshape_interrupted(mddev)) {
>> -        bi->bi_status = BLK_STS_RESOURCE;

On 2026/2/26 13:44, Yu Kuai wrote:
> This will make the problem much worse, you should notice this bio is returned directly
> to user, because reshape is interrupted and nothing can be read or write, and you're
> returning wrong data to user.

Thanks for your review and feedback.

I will carefully re-read the relevant code logic, especially:
- The complete flow of DM layer requeue mechanism
- The bio handling path in the reshape flow
- Verify whether the bio will be requeued rather than directly returned to the user

Best regards,
Yang Xiuwei

