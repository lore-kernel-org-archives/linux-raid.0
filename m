Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C0D2877E9
	for <linux-raid@vger.kernel.org>; Mon, 18 Aug 2025 15:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755532649; cv=none; b=PMvpIKbvaWmDOCdGo1Rwc5elVWLEApG9QSJBbhtHE2zmP2N3H/1xeStfgcUu6Wrh53JB6KY8GhvZ9N5CJNr4iZ/+1rO3jhGapLNxW4IuQuxkFqcOLItfpjsQnBp40gNUQCfDN4klHjG+9vS/hGlTg91l43RixUp4s17Thizj74I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755532649; c=relaxed/simple;
	bh=kxxTidQuZzoO8cx+6TrLRPuNnVifMeVR4NnxKnzUmiE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z+Rw+zoVA9FlyCwZFLTXLpUPNQUuTCRe0nsKPuKMc2OFgmKVMDbnfOxqby3aqLN0aXQJcL0pAx9/E8T5xjhPAYD2aa7GCjcQoW+ySvIVCq+QszZtqQ7IsHT/O7qMzf62gA709ZZmxw+cyzFAJy7vcWVtBGFauEJGxHRkfAbV5hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iIYsWjmL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iIYsWjmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFC1C4CEEB;
	Mon, 18 Aug 2025 15:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755532648;
	bh=kxxTidQuZzoO8cx+6TrLRPuNnVifMeVR4NnxKnzUmiE=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iIYsWjmLZ8zT+Nfz8Uj5YmzCeNkX4YgLFm36nX2QWnhrZHvPbIrvNdsgCVIat+lnv
	 qkEiPLdTG24TbVgn2OWB7MKcYqNbSAl/LQWYSSP6DfABTj4ZYEqNtoohccIhO6Gs5E
	 QxxnhHOUONzXAdjwN7xlRWm8Ibjh5otG7SO6+KegdsS+RZfqqUdEx6GQLKf8YIOXb2
	 JIFrp16Y+y7DEtw1YF3bg7AyFWlTlYo6wcZiGphHb/DWowz1tO09Pi6xztvQdUuF7f
	 qIVvu3Kj1qEYgjYjUQtddcsd7urhRkGegAPEdE1tg/B46uVbIQj/DAe+CbeN9MyLk+
	 fgFei/adAj6rQ==
Message-ID: <c488819f-c8b1-42fe-8557-1336fb713db1@kernel.org>
Date: Mon, 18 Aug 2025 23:57:26 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@kernel.org
Subject: Re: [PATCH v4 1/1] md: add legacy_async_del_gendisk mode
To: Luca Boccassi <luca.boccassi@gmail.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org,
 mpatocka@redhat.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250813032929.54978-1-xni@redhat.com>
 <e193fc4b-994f-8261-a7de-8fd8008a9bae@huaweicloud.com>
 <CAMw=ZnR0HyaeG279BZybnJ9zYD5LbnjKS=U4Gc0w5bBs=i38BA@mail.gmail.com>
Content-Language: en-US
From: Yu Kuai <yukuai@kernel.org>
In-Reply-To: <CAMw=ZnR0HyaeG279BZybnJ9zYD5LbnjKS=U4Gc0w5bBs=i38BA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

在 2025/8/18 17:33, Luca Boccassi 写道:
> On Thu, 14 Aug 2025 at 01:54, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> 在 2025/08/13 11:29, Xiao Ni 写道:
>>> commit 9e59d609763f ("md: call del_gendisk in control path") changes the
>>> async way to sync way of calling del_gendisk. But it breaks mdadm
>>> --assemble command. The assemble command runs like this:
>>> 1. create the array
>>> 2. stop the array
>>> 3. access the sysfs files after stopping
>>>
>>> The sync way calls del_gendisk in step 2, so all sysfs files are removed.
>>> Now to avoid breaking mdadm assemble command, this patch adds the parameter
>>> legacy_async_del_gendisk that can be used to choose which way. The default
>>> is async way. In future, we plan to change default to sync way in kernel
>>> 7.0. Then users need to upgrade to mdadm 4.5+ which removes step 2.
>>>
>>> Fixes: 9e59d609763f ("md: call del_gendisk in control path")
>>> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
>>> Closes: https://lore.kernel.org/linux-raid/CAMw=ZnQ=ET2St-+hnhsuq34rRPnebqcXqP1QqaHW5Bh4aaaZ4g@mail.gmail.com/T/#t
>>> Suggested-and-reviewed-by: Yu Kuai <yukuai3@huawei.com>
>>> Signed-off-by: Xiao Ni <xni@redhat.com>
>>> ---
>>> v2: minor changes on format and log content
>>> v3: changes in commit message and log content
>>> v4: choose to change to sync way as default first in commit message
>>>    drivers/md/md.c | 56 ++++++++++++++++++++++++++++++++++++-------------
>>>    1 file changed, 42 insertions(+), 14 deletions(-)
>>>
>> Aplied to md-6.17
>> Thanks
> Hi,
>
> I noticed this bugfix is not in 6.17~rc2 released yesterday, will it
> be in rc3? Thanks

Yes. You should see this in linux-next soon, and later in rc3.

Thanks,
Kuai

