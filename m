Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C69343D84
	for <linux-raid@vger.kernel.org>; Wed, 17 Dec 2025 07:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765956847; cv=none; b=Fon1xo+gyA28u1TQA35lEoZSvkh3xP3kQepfKr7dkmApIxUJ27KIaRPe1jpsljIfRCsL6BOmoiqn4rmrYvqHB/KRVsUupYJACCWv9BDx+X6uF2nRIi6VxNhEK9FMYJpN3m+n3JFkXj1iejQtAcnS6epaOvItG3WvU8+ckrU4Jng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765956847; c=relaxed/simple;
	bh=FQCskBVk7oikcFZyo9nMkmMKQOPqVZdAtWwErqXLo7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=Le1Adw3cT/LrXmqqx4sTRVaS3xGCyEGDRUJ6EnCCcg8dQvoDmeG/4WVPh/ooxggQK2UfPeBXCaAMiV0cmGGX4EWrFOXbxS54/OnstN0/A/gUVbIGCDY5+dngYGXfToACrgnAYMS9W4hD6xsd8mOtXCkdOboqQIbBfBQkn4rG6s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.192] (ip5f5af75b.dynamic.kabel-deutschland.de [95.90.247.91])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 25C2161E64849;
	Wed, 17 Dec 2025 08:33:26 +0100 (CET)
Message-ID: <7cff4b89-eeff-4048-8af3-ef9d76bdedf8@molgen.mpg.de>
Date: Wed, 17 Dec 2025 08:33:24 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Issues with md raid 1 on kernel 6.18 after booting kernel
 6.19-rc1 once
To: Yu Kuai <yukuai@fnnas.com>
References: <b3e941b0-38d1-4809-a386-34659a20415e@gmail.com>
 <8fd97a33-eb5a-4c88-ac8a-bfa1dd2ced61@fnnas.com>
 <619a9b00-43dd-4897-8bb0-9ff29a760f52@gmail.com>
 <f20c3a92-d562-4ac2-98b6-39ff4f3e3bbf@fnnas.com>
Content-Language: en-US
Cc: bugreports61@gmail.com, linux-raid@vger.kernel.org, linan122@huawei.com,
 xni@redhat.com, regressions@lists.linux.dev,
 Linus Torvalds <torvalds@linux-foundation.org>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <f20c3a92-d562-4ac2-98b6-39ff4f3e3bbf@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Kuai,


Am 17.12.25 um 08:17 schrieb Yu Kuai:

> 在 2025/12/17 15:13, BugReports 写道:
>> 
>> ...
>> 
>> We'll have to backport following patch into old kernels to make
>> new arrays to assemble in old kernels. ....
>> 
>> The md array which i am talking about was not created with kernel 
>> 6.19, it was created sometime in 2024.
>> 
>> It was just used in kernel 6.19 and that broke compatibility with
>> my 6.18 kernel.
> 
> I know, I mean any array that is created or assembled in new kernels
> will now have lsb field stored in metadata. This field is not
> defined in old kernels and that's why array can't assembled in old
> kernels, due to unknown metadata.
> 
> This is what we have to do for new features, and we're planning to
> avoid the forward compatibility issue with the above patch that I
> mentioned.
Is there really no way around it? Just testing a new kernel and being 
able to go back must be supported in my opinion, at least between one or 
two LTS versions.


Kind regards,

Paul
