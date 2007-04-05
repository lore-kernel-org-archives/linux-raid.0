From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: raid1 does not seem faster
Date: Thu, 5 Apr 2007 11:57:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0704051156480.23524@p34.internal.lan>
References: <Pine.LNX.4.61.0704011417470.8018@yvahk01.tjqt.qr>
 <200704011558.31670.a1426z@gawab.com> <46118473.10205@tmr.com>
 <200704031642.27701.a1426z@gawab.com> <461430B6.9060703@tmr.com>
 <20070405045819.GA5525@teal.hq.k1024.org> <Pine.LNX.4.64.0704050410290.12619@p34.internal.lan>
 <20070405153138.GA12661@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070405153138.GA12661@teal.hq.k1024.org>
Sender: linux-raid-owner@vger.kernel.org
To: Iustin Pop <iusty@k1024.org>
Cc: Bill Davidsen <davidsen@tmr.com>, Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 5 Apr 2007, Iustin Pop wrote:

> On Thu, Apr 05, 2007 at 04:11:35AM -0400, Justin Piszcz wrote:
>>
>>
>> On Thu, 5 Apr 2007, Iustin Pop wrote:
>>
>>> On Wed, Apr 04, 2007 at 07:11:50PM -0400, Bill Davidsen wrote:
>>>> You are correct, but I think if an optimization were to be done, some
>>>> balance between the read time, seek time, and read size could be done.
>>>> Using more than one drive only makes sense when the read transfer time is
>>>> significantly longer than the seek time. With an aggressive readahead set
>>>> for the array that would happen regularly.
>>>>
>>>> It's possible, it just takes the time to do it, like many other "nice"
>>>> things.
>>>
>>> Maybe yes, but why optimise the single-reader case? raid1 already can
>>> read in parallel from the drives when multiple processes read from the
>>> raid1. Optimising the single reader can help in hdparm or other
>>> benchmark cases, but in real life I see very often the total throughput
>>> of a (two drive) raid1 being around two times the throughput of a single
>>> drive.
>>>
>>> regards,
>>> iustin
>>> -
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> Really? I have copied a file from a SW RAID1 (5GB) and I only saw
>> 60MB/s not the 120MB/s the (RAID1) is capable of to the
>> destination (which can easily do > 160MB/s sustained read/write).
>
> Did you copy it multi-threaded? I said "*multiple-readers* show improved
> speed" and you said "I copied *one* file". Try copying two files in
> parallel.
>
> I'm doing in two xterms "cat file1 >/dev/null", "cat file2 >/dev/null"
> and my raid1 shows ~110 MB/s, each drive doing about half.  On file only
> does about 60 MB/s (this is over a PCI raid controller so the max 110
> MB/s is a PCI bus limitation).
>
> Iustin
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Ah, nope, I only did a single copy, I did not parallelize the operations.

Justin.
