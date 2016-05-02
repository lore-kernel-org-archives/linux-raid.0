From: Joey Liao <joeyliao@qnap.com>
Subject: Re: Write to the degraded raid5 will trigger the call trace dump when
 skip_copy is enabled
Date: Mon, 2 May 2016 22:45:49 +0800
Message-ID: <CAHvN=imVJgEtMmO6XtLCdQKCPiuVT2sCqpq_0qoMR-3aJ+ZzPw@mail.gmail.com>
References: <CAHvN=inPP5ubYK1YkNW_B1b9ouhqBo8qMMfVcGSjddMYekDEng@mail.gmail.com>
	<20160429211719.GA104659@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160429211719.GA104659@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Shaohua,

Many thanks for your reply.

How about the following WARN_ON() in handle_stripe_clean_event()???

if (test_and_clear_bit(R5_SkipCopy, &dev->flags)) {
    WARN_ON(test_bit(R5_UPTODATE, &dev->flags));
}

Sometimes it will be triggered as well but I can't find the exactly
way to reproduce it.
I would like to know if it is suitable to remove it as well or not.


2016-04-30 5:17 GMT+08:00 Shaohua Li <shli@kernel.org>:
> On Fri, Apr 29, 2016 at 06:54:10PM +0800, Joey Liao wrote:
>> Hi all,
>>
>> For improving the I/O performance, we try to enable the raid 5
>> skip_copy feature by default. It indeed has some benefit, however, it
>> will always (not a random issue) dump the following call trace
>> repeatedly when we try to write the raid 5 block device. It is related
>> to the following codes in handle_stripe_clean_event() in raid5.c.
>>
>> WARN_ON(test_bit(R5_SkipCopy, &dev->flags));
>> WARN_ON(dev->page != dev->orig_page);
>>
>> Is it a known bug for skip_copy feature?
>> Does it do harm to the data integrity?
>> If we would like to prevent this call trace, for your suggestion how
>> should we do to modify the source code?
>
> Looks the two WARN_ON should be deleted. if the dev has R5_LOCKED, it's legit
> the dev has SkipCopy set and page != orig_page. I'll delete the code. This will
> not harm to data integrity.
>
> Thanks,
> Shaohua
