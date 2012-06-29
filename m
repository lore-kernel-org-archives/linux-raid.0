From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 0/3 v3] MD: improve raid1/10 write performance for fast storage
Date: Fri, 29 Jun 2012 14:10:30 +0800
Message-ID: <CANejiEWfR1S+F5GT7Bxhi2ig8ef7ZziAbVebM_DT3-_3hftYUw@mail.gmail.com>
References: <20120613091143.508417333@kernel.org>
	<20120628190352.4dc1dd76@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120628190352.4dc1dd76@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

2012/6/28 NeilBrown <neilb@suse.de>:
> On Wed, 13 Jun 2012 17:11:43 +0800 Shaohua Li <shli@kernel.org> wrote=
:
>
>> In raid1/10, all write requests are dispatched in a single thread. I=
n fast
>> storage, the thread is a bottleneck, because it dispatches request t=
oo slow.
>> Also the thread migrates freely, which makes request completion cpu =
not match
>> with submission cpu even driver/block layer has such capability. Thi=
s will
>> cause bad cache issue. Both these are not a big deal for slow storag=
e.
>>
>> Switching the dispatching to percpu/perthread based dramatically inc=
reases
>> performance. =A0The more raid disk number is, the more performance b=
oosts. In a
>> 4-disk raid10 setup, this can double the throughput.
>>
>> percpu/perthread based dispatch doesn't harm slow storage. This is t=
he way how
>> raw device is accessed, and there is correct block plug set which ca=
n help do
>> request merge and reduce lock contention.
>>
>> V2->V3:
>> rebase to latest tree and fix cpuhotplug issue
>>
>> V1->V2:
>> 1. droped direct dispatch patches. That has better performance impor=
vement, but
>> is hopelessly made correct.
>> 2. Add a MD specific workqueue to do percpu dispatch.
>
>
> Hi.
>
> I still don't like the per-cpu allocations and the extra work queues.
>
> The following patch demonstrates how I would like to address this iss=
ue. =A0It
> should submit requests from the same thread that initially made the r=
equest -
> at least in most cases.
>
> It leverages the plugging code and pushed everything out on the unplu=
g,
> unless that comes from a scheduler call (which should be uncommon). =A0=
In that
> case it falls back on passing all the requests to the md thread.
>
> Obviously if we proceed with this I'll split this up into neat review=
able
> patches. =A0However before that it would help to know if it really he=
lps as I
> think it should.
>
> So would you be able to test it on your SSD hardware and see how it c=
ompares
> the current code, and to you code? =A0Thanks.
>
> I have only tested it lightly myself so there could still be bugs, bu=
t
> hopefully not obvious ones.
>
> A simple "time mkfs" test on very modest hardware show as 25% reducti=
on in
> total time (168s -> 127s). =A0I guess that's a 33% increase in speed?
> However sequential writes with 'dd' seem a little slower (14MB/s -> 1=
3.6MB/s)
>
> There are some hacks in there that need to be cleaned up, but I think=
 the
> general structure looks good.

Thought I consider this approach before, and schedule from the unplug
callback is an issue. Maybe I overlooked it at that time, the from_sche=
dule
check looks promising.

Thanks,
Shaohua
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
