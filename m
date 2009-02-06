From: Igor Podlesny <for.poige+linux@gmail.com>
Subject: Re: HugePages for MD's caches -- can this be done in modern kernel?
Date: Sat, 7 Feb 2009 02:27:43 +0700
Message-ID: <43d009740902061127p1a8073ax231877c8ed3eeda9@mail.gmail.com>
References: <43d009740902061008p968268bj30a03c6f97139bbe@mail.gmail.com>
	 <c39d1fabb5aef8e2ed5158ad59802cf1.squirrel@neil.brown.name>
Reply-To: for.poige+linux@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c39d1fabb5aef8e2ed5158ad59802cf1.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2009/2/7 NeilBrown <neilb@suse.de>:
> On Sat, February 7, 2009 5:08 am, Igor Podlesny wrote:
>>    Hi!
>>
>>    $(Subj). :-)
>>
>>    P. S. Also, I deem there lots of structures in kernel that could
>> benefit
>> from using HugePages. But this probably a q-n for another kernel list.
>
> I have only a vague idea what HugePages are and it is not at all clear to
> me why you would want to use them for the MD cache.   I assume you are
>
	HugePages requires less TBL entries so they better fit for large
buffers, as far as I understand.

	http://unixfoo.blogspot.com/2007/10/hugepages.html
	http://linux-mm.org/HugePagesArticles

> talking about MD/RAID456 as that is the only place we use a cache.
>
	Yeah, "stripe_cache_size" setting.
>
> Maybe if you could explain what you are thinking....
>
	Yeah, hope this would suffice.

-- 
End of message. Next message?
