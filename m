Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999602DFA38
	for <linux-raid@vger.kernel.org>; Tue,  9 Sep 2025 17:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757438300; cv=none; b=EIwWV/tOkbXjiI0XQ9tIyShj28Wai8ac/QJJx6wiEFE2zqD49m0n9MDwnNfKrl12t0B/79OfNuRYmOWVIfDz5MgyWtTX4G00LUJaia1LfJeW70UFNZjhjr2lsO2kpsxDaL/H7MIdWx+qOgHxfuWCYf4Yd9qFI+T9JrdyzLkMKhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757438300; c=relaxed/simple;
	bh=jFtg9uvtWBlgiSq5qvFKzkSfdyQ+8wkH/QQBmofULvo=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hkpIAjovSUdPbxAIKlU76jIGaXCEGWmSyQdPT0InjgdX2PUPV0EugobgSbsyLbvQGFcVfSjr0I6mmypnwR9QFBPoeBaGMbTIYVntgKBWLvr6R102ORy5/+zNKxNRITGSXBRY+KZqovs1gEAfu0Fw/BdXLqtrtFSc9UzM2Wm6GtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=oyh1kGKe; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="oyh1kGKe"
Received: from NEET (p4487057-ipxg00s01tokaisakaetozai.aichi.ocn.ne.jp [114.153.80.57])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 589H7asc079535
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 10 Sep 2025 02:07:36 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=C53fLZHIuuoTre7z9U9FNaSy3t4lJL6yHv3NiirB8u0=;
        c=relaxed/relaxed; d=mgml.me;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250315; t=1757437656; v=1;
        b=oyh1kGKeUEdDlyAiFnk79pZYHyNGruQGkHO+wlUFEfyrod9F5Xso6KBCcqcs+Alj
         lI87WgoWAKaybwcZh+nMycSqF6zHEsEO4IjjEJzjch05iLuc6zJqxUbFi8NJXriw
         ZpS8LPjQoE2yR3bmZyR3qJSQSFJSwhtihbCzha8M3CwzO6w1UGhBnZ+jae3eim9H
         sKjxbG2/feQEgMgnoDfHs41aTnSFfvxBSyzUBiHzjkRtHDtR0F0fRiVaIVUXzIsO
         RkG7RJVcQNQ5uZFaiZ1PZOOeLmkofxNVASkOy1Beoz7e2F+nPJj4lE2VZgPyFnDE
         3u1CI+qEe2l06fgkSHpNDg==
Message-ID: <2a949451-23d0-44ef-94fb-46b40c98957b@mgml.me>
Date: Wed, 10 Sep 2025 02:07:36 +0900
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
 <7072d96b-c2d4-4225-ad4f-1cba8f683985@mgml.me>
 <62365ca9-3cdb-c213-b0d4-5480ad734dd6@huaweicloud.com>
Content-Language: en-US
From: Kenta Akagi <k@mgml.me>
In-Reply-To: <62365ca9-3cdb-c213-b0d4-5480ad734dd6@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2025/09/09 10:02, Yu Kuai wrote:
> Hi,
> 
> 在 2025/09/09 1:29, Kenta Akagi 写道:
>> On 2025/09/08 10:20, Yu Kuai wrote:
>>>
>>>
>>> 在 2025/09/02 0:48, Kenta Akagi 写道:
>>>> In the current raid1_end_write_request implementation,
>>>> - md_error is called only in the Failfast case.
>>>> - Afterwards, if the rdev is not Faulty (that is, not Failfast,
>>>>     or Failfast but the last rdev — which originally was not expected
>>>>     MD_BROKEN in RAID1), R1BIO_WriteError is set.
>>>> In the suggested implementation, it seems that a non-Failfast write
>>>> failure will immediately mark the rdev as Faulty, without retries.
>>>
>>> I still prefer a common helper to unify the code, not sure if I still
>>> missing something ...
>>>
>>> In general, if bio failed, for read/write/metadata/resync should be the
>>> same:
>>>
>>> 1) failfast is set, and not last rdev, md_error();
>>> 2) otherwise, we should always retry;
>>>
>>> And I do believe it's the best to unify this by a common helper.
>>
>> Yes, I realized that my idea is bad. Your idea is best,
>> especially considering the error handling in super_written.
>> I'll implement a common helper.
>>
>> By the way, I think md_error should only be serialized on RAID1 and 10
>> for now. Serializing unnecessary personalities is inefficient and can
>> lead to unfavorable results. What do you think?
> 
> Just make code cleaner and I don't have preference here, md_error is
> super cold path I think.

Thank you for your advice.
Understood.

Thanks,
Akagi

> Thanks,
> Kuai
> 
>>
>> Thanks,
>> Akagi
>>
>>> Thanks,
>>> Kuai
>>>
>>>
>>
>> .
>>
> 
> 

