From: "NeilBrown" <neilb@suse.de>
Subject: Re: md data-check causes soft lockup
Date: Fri, 25 Sep 2009 21:23:10 +1000
Message-ID: <58eb1b01027841a2130122f3ea718946.squirrel@neil.brown.name>
References: <4AB7C11E.60801@howardsilvan.com>
    <19132.26898.341533.52076@notabene.brown>
    <4ABCA31E.7070303@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ABCA31E.7070303@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: kwick <kwick@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, September 25, 2009 9:01 pm, kwick wrote:
> Neil Brown wrote:
>> On Monday September 21, faxguy@howardsilvan.com wrote:
>>> http://lkml.org/lkml/2009/8/6/387
>>>
>>
>> Thanks for the report.
>>
>> This patch...
> Dear Neil,
>
> as you can see I reported a similar problem for raid-6 in this thread.
> Your patch apparently covers raid-1. Is it because this other patch
> http://osdir.com/ml/linux-raid/2009-09/msg00371.html
> covers my case? it's all fixed then?
>

Yes and yes .... unless there is a similar problem with raid10...
OK, I just added the same fix for RAID10 so it should all be fixed
(once these patches get upstream).

Thanks,
NeilBrown


> Thank you
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

