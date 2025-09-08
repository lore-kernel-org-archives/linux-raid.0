Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D6330F939
	for <linux-raid@vger.kernel.org>; Mon,  8 Sep 2025 17:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757352595; cv=none; b=Zns/hSml3CU1n63pordQNd7zHdaFc9X9qvSS8mrl3XV+dfdjLVhsePYSjCpbCHBCEXs2eVLf/66L9936CL8t27NeR4pBIvbJC70Fk7bo1b9zOkSoDrJBoxrV41CwyPKf+EwBb0J5TVyvjZXglVfpsjB9q9HLmOxpt2eH0rCoN9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757352595; c=relaxed/simple;
	bh=GKT+GbiVon4VPPhVVO/6LtO71Jyr95oN/MaAkNUZFcc=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BcboNL/k2N+dLcsFG8AnKAc3nCCVWiaJ6iazKCFNszcTGAFxRNpeZBViPsnc3XsAAzJCrKb2TpM6wu2KwTvDQE1YVuAyzdepV68pwrBHR/m9tXQRW+OA9PxaDPKpaLH54rnPJybAiF7vm878d53gkAPrpSpnZ8qua0wzgNWTAzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=ZX1JGizt; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="ZX1JGizt"
Received: from NEET (p4528006-ipxg00s01tokaisakaetozai.aichi.ocn.ne.jp [153.219.73.6])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 588HT8OM005680
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 9 Sep 2025 02:29:08 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=HF9UkWsa8U+w0B6h/60UAV0P0s0sJtzgd1dSgvgkBl8=;
        c=relaxed/relaxed; d=mgml.me;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250315; t=1757352548; v=1;
        b=ZX1JGiztS05V8tcXtLSZEDfH/vPxKko7rBdH3DQlCaw6Df5j8Picg1j3/Ct99RA5
         +R1oCNIOAmrtEkyUvPj46nEA1AzPbb3RSMtPaTx7GEi9GB2VT0rnAu1kOo3Dg2Ev
         i5w2E1B6RYs2XChhFrZ1t6hiBc6KKkC5vagKOLA6R6YfPcoDC1elS2Nd07LoGwyN
         45BR29KVt8zOK96XIuUxt4ewmwNiyslRP0s1ZE7qKEdAcd7pXLObT1WThPBqeHgW
         xDKMB2b9Xmtxvytmu2F/RHlWSIjoSMtA9xpPWPDbfNUYOL7UjgzGsFc2pfngpsYv
         Qf9UzwUUX8BQV9iyuDJyEw==
Message-ID: <7072d96b-c2d4-4225-ad4f-1cba8f683985@mgml.me>
Date: Tue, 9 Sep 2025 02:29:08 +0900
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>, Kenta Akagi <k@mgml.me>
Subject: Re: [PATCH v3 1/3] md/raid1,raid10: Do not set MD_BROKEN on failfast
 io failure
To: Yu Kuai <yukuai1@huaweicloud.com>, Li Nan <linan666@huaweicloud.com>,
        Song Liu <song@kernel.org>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
References: <20250828163216.4225-1-k@mgml.me>
 <20250828163216.4225-2-k@mgml.me>
 <dcb72e23-d0ea-c8b3-24db-5dd515f619a8@huaweicloud.com>
 <6b3119f1-486e-4361-b04d-5e3c67a52a91@mgml.me>
 <3ea67e48-ce8a-9d70-a128-edf5eddf15f0@huaweicloud.com>
 <29e337bc-9eee-4794-ae1e-184ef91b9d24@mgml.me>
 <6edb5e2c-3f36-dc2c-3b41-9bf0e8ebb263@huaweicloud.com>
 <7e268dff-4f29-4155-8644-45be74d4c465@mgml.me>
 <48902d38-c2a1-b74d-d5fb-3d1cdc0b05dc@huaweicloud.com>
 <34ebcc5b-db67-49e0-a304-4882fa82e830@mgml.me>
 <ae39d3a6-86a2-b90d-b5d6-887b7fc28106@huaweicloud.com>
Content-Language: en-US
From: Kenta Akagi <k@mgml.me>
In-Reply-To: <ae39d3a6-86a2-b90d-b5d6-887b7fc28106@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2025/09/08 10:20, Yu Kuai wrote:
> 
> 
> 在 2025/09/02 0:48, Kenta Akagi 写道:
>> In the current raid1_end_write_request implementation,
>> - md_error is called only in the Failfast case.
>> - Afterwards, if the rdev is not Faulty (that is, not Failfast,
>>    or Failfast but the last rdev — which originally was not expected
>>    MD_BROKEN in RAID1), R1BIO_WriteError is set.
>> In the suggested implementation, it seems that a non-Failfast write
>> failure will immediately mark the rdev as Faulty, without retries.
> 
> I still prefer a common helper to unify the code, not sure if I still
> missing something ...
> 
> In general, if bio failed, for read/write/metadata/resync should be the
> same:
> 
> 1) failfast is set, and not last rdev, md_error();
> 2) otherwise, we should always retry;
> 
> And I do believe it's the best to unify this by a common helper.

Yes, I realized that my idea is bad. Your idea is best,
especially considering the error handling in super_written.
I'll implement a common helper.

By the way, I think md_error should only be serialized on RAID1 and 10
for now. Serializing unnecessary personalities is inefficient and can
lead to unfavorable results. What do you think?

Thanks,
Akagi

> Thanks,
> Kuai
> 
> 

