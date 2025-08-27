Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB5130497A;
	Wed, 27 Aug 2025 06:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756275206; cv=none; b=ZbFWTpyHTo6bWThctmPdZ0MAJ8Cvmgo2Af01MxTi8w9+7AsDzfsh5piKRax3KZ4f5lShQ2W5nOCNPLoSNQRJOrTfyvBMVa6Pua3ulgu7lpW1/i57q6iC4B1m9oEgRjLVyN5QkukAj54+G1ZQQA3J+IPdLzZXksX0iIxjyxdUEGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756275206; c=relaxed/simple;
	bh=91tVU5F0tEc7JZvf3kwYGWtwJ1JUBwQZgsQsmk7OKkY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L8NqyPKsmVBXUFddVa6n0qQAc1vwvRDd+HABFOWnuJBlUny7e9p0LTVIJn6/pNRTosMV5Ucfqj6a7mI27KPFkq/uJ7ydvxuT0PCkEIzCzjrmwriQ4W1pYT5bjwsYQuUNRVhzIGSLrIOHFzEFi9sqM10L2Z9c8e5emzpIHT/dUOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.2.202] (p5b13a549.dip0.t-ipconnect.de [91.19.165.73])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 55D1960213B1D;
	Wed, 27 Aug 2025 08:07:26 +0200 (CEST)
Message-ID: <8eb5acff-4c21-4be8-8d3c-b98bd258ef99@molgen.mpg.de>
Date: Wed, 27 Aug 2025 08:07:25 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 md-6.18 11/11] md/md-llbitmap: introduce new lockless
 bitmap
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, corbet@lwn.net, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, xni@redhat.com, hare@suse.de,
 linan122@huawei.com, colyli@kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250826085205.1061353-1-yukuai1@huaweicloud.com>
 <20250826085205.1061353-12-yukuai1@huaweicloud.com>
 <4d21e669-f989-4bbc-8c38-ac1b311e8d01@molgen.mpg.de>
 <65a2856a-7e2f-111a-c92e-7941206ad006@huaweicloud.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <65a2856a-7e2f-111a-c92e-7941206ad006@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Kuai,


Thank you for your reply.

Am 27.08.25 um 05:44 schrieb Yu Kuai:

> 在 2025/08/26 17:52, Paul Menzel 写道:
>> It’d be great if you could motivate, why a lockless bitmap is needed  
>> > compared to the current implemention.
> 
> Se the performance test, old bitmap have global spinlock and is bad with
> fast disk.

Yes, but it’s at the end, and not explicitly stated. Should you resend, 
it’d be great if you could add that.

> [snip the typo part]
> 
>> How can/should this patch be tested/benchmarked?
> 
> There is pending mdadm patch, rfc verion can be used. Will work on
> formal version after this set is applied.

Understood. Maybe add an URL to the mdadm patch. (Sorry, should I have 
missed it.)

>> --- a/drivers/md/md-bitmap.h
>> +++ b/drivers/md/md-bitmap.h
>> @@ -9,10 +9,26 @@
>>    #define BITMAP_MAGIC 0x6d746962
>> +/*
>> + * version 3 is host-endian order, this is deprecated and not used for new
>> + * array
>> + */
>> +#define BITMAP_MAJOR_LO        3
>> +#define BITMAP_MAJOR_HOSTENDIAN    3
>> +/* version 4 is little-endian order, the default value */
>> +#define BITMAP_MAJOR_HI        4
>> +/* version 5 is only used for cluster */
>> +#define BITMAP_MAJOR_CLUSTERED    5

>> Move this to the header in a separate patch?
> 
> I prefer not, old bitmap use this as well.
Hmm, I do not understand the answer, as it’s moved in this patch, why 
can’t it be moved in another? But it’s not that important.


Kind regards,

Paul
