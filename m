Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333BC13F01A
	for <linux-raid@vger.kernel.org>; Fri, 26 Apr 2024 09:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714125161; cv=none; b=nIbOsQSIfj2et6ucYyXNp2s9vtR8G2g3Vixg34jI3VznIHR5u8ZOwk+Vr+7oAQPpBkeSDwvEJ4Bw4d4C+2AjKf3KfY/XXaV06herTSWnKaqCbHLp/5xaylqbpTfx+UjWcq68JR7Voj3ed8z8JHov0wjyqT6ySPsx7HPhveGE0oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714125161; c=relaxed/simple;
	bh=qEBOlNVwah3bfsKZmVTNF99sc3268zRE2UmMSGBCwmc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oFlmC34fgQg3NFtLs4pKGIVDAAifXposDGwDGf7UB8yDTN86nRdy+sRUS3TTah73GzeYO0Hse3geILfuWjYktZUw268/FTmkGijanASdNmgJZD3pWs/Zwey+sqB2MDBG4iw1OsqOTjZiaEJYmLCUowNU4GTMG9iLJAw2P8PFWGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.220.34] (g34.guest.molgen.mpg.de [141.14.220.34])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 53ED861E5FE07;
	Fri, 26 Apr 2024 11:52:07 +0200 (CEST)
Message-ID: <8cb179cf-3c11-4ef0-99ad-a704d856283e@molgen.mpg.de>
Date: Fri, 26 Apr 2024 11:52:05 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/1] Move mdadm development to Github
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: Paul E Luse <paul.e.luse@linux.intel.com>, Song Liu <song@kernel.org>,
 Kinga Tanska <kinga.tanska@linux.intel.com>,
 Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org
References: <20240419014839.8986-1-mariusz.tkaczyk@linux.intel.com>
 <f8044311-765d-4743-8b20-0d68a56044ec@molgen.mpg.de>
 <20240426103640.0000549e@linux.intel.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20240426103640.0000549e@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Mariusz,


Thank you for your quick reply.

Am 26.04.24 um 10:36 schrieb Mariusz Tkaczyk:
> On Fri, 26 Apr 2024 08:46:18 +0200 Paul Menzel wrote:

>> Thank for bringing this topic up for discussion. Unfortunately, I have
>> to reply with negative comments.
>>
>> Am 19.04.24 um 03:48 schrieb Mariusz Tkaczyk:
>>> Thanks to Song and Paul, we created organization for md-raid on Github.
>>> This is a perfect place to maintain mdadm. I would like announce moving
>>> mdadm development to Github.
>>>
>>> It is already forked, feel free to explore:
>>> https://github.com/md-raid-utilities/mdadm
>>>
>>> Github is powerful and it has well integrated CI. On the repo, you can
>>> already find a pull request which will add compilation and code style
>>> tests (Thanks to Kinga!).
>>> This is MORE than we have now so I believe that with the change mdadm
>>> stability and code quality will be increased. The participating method
>>> will be simplified, it is really easy to create pull request. Also,
>>> anyone can fork repo with base tests included and properly configured.
>>>
>>> Note that Song and Paul are working on a per patch CI system using GitHub
>>> Actions and a dedicated rack of servers to enable fast container, VM and
>>> bare metal testing for both mdraid and mdadm. Having mdadm on GitHub will
>>> help with that integration.
>>
>> Improved testing sounds good. Thank you. I do not think though, that
>> using GitHub is a requirement for that, and there are a lot of bots on
>> the Linux kernel mailing list doing this without GitHub.

> At some point Paul Luse and Song Liu decided that they will choose Github for MD
> CI and Paul is busy working on creating dedicated Github runners for MD CI.
> Moving mdadm development then is a logical next step as I want to reuse the
> prepared hardware resources simple way.
> 
>>> As a result of moving to GitHub, we will no longer be using mailing list
>>> to propose patches, we will be using GitHub Pull Requests (PRs). As the
>>> community adjusts to using PRs I will be setting up auto-notification
>>> for those who attempt to use email for patches to let them know that we
>>> now use PRs.  I will also setup GitHub to send email to the mailing list
>>> on each new PR so that everyone is still aware of pending patches via
>>> the mailing list.
>>
>> In my experience, using GitHub for code review is far inferior to using
>> mailing lists or Gerrit. First, you cannot comment on the commit
>> message. As a result, projects using GitHub have a really low-quality
>> git history. Also, you only cannot comment single parts of a line in the
>> diff.
> 
> These are known limitations. I understand your objections here.

It would be nice, if you listed them in your proposal with solutions how 
to address them. That would have avoided them.

> We have to accept them.

I do not think so. Why?

> Commits will be as good as maintainers cares about them. Please keep
> in mind that except Intel, the activity around mdadm is low. I'm
> receiving 1 patchset within 2 weeks. I can deal with those
> limitations and I don't need customized and advanced solution with
> huge maintenance cost (at least for now). If that will be changed- we
> will propose something else.
If it is that low, then I do not understand, why the infrastructure 
needs to be changed at all.

> There are many Github actions we can setup to help us with review.

Can you please give example projects, that have implemented that on GitHub?

>> The “one thread” discussion model is also a pain, as most people using
>> Web forms do not correctly cite and quote, and with more than three
>> answers you loose the overview. For some reason people think more about
>> their reply, using mailing lists than Web forms.
> 
> We cannot ban less experienced users from participating. I want to make mdadm
> development more attractive. I know that generally folks here are well
> experienced in Linux netiquette, having github will change that.

Has this claim ever been proven, now that a lot of projects made the 
switch. Did participation actually increase?

> It is another trade-off I agree to take.
> 
>> Using different forums for discussions should also not be allowed.
>> People should just subscribe and monitor one forum.
> 
> For young developers Github is natural work environment. If they want
> to to file issue (as they do for thousand other projects) - they can.
> If github mdadm maintainers cannot support them, we will redirect
> them to mailing list for wider audience.
As written, I do not think splitting forums (for a small project) is a 
good idea.

>> So, I strongly oppose this move, but I am also aware, that I am not
>> doing a lot of development contribution.
> 
> The truth is that mdadm is a small and "simple" userspace project.
> There is not a tons of development around it. Please help me keep
> simple things simple.
As written above, if that is true, I do not understand the effort put 
into changing the infrastructure. The effort could have gone into 
writing the CI infrastructure for a mailing list process. Other Intel 
departments seem to do it already, so work would not need to be reinvented?

> We can achieve CI, (probably) "sufficient" review system and
> simplified well known on market participating process in few clicks.
> Maintenance of review solution will not belong to us (expect custom
> GH runners).

Sorry, I do not understand.

> For these reasons, I see it a natural next step to grow but I'm also
> familiar with Github limitations. I have to deal with them in other
> projects I'm maintaining or participating.

I am not convinced the theoretical more participants are outweighing the 
cost for the existing folks being happy with the current infrastructure.

> I also know that I can count of support from Linux Foundation in case
> of special needs (like additional resources). That is also great.

Sorry, I also do not understand this statement. Is the Linux Foundation 
only supporting projects using a GitHub based workflow?


Kind regards,

Paul
