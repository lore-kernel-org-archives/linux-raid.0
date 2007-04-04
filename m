From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid1 does not seem faster
Date: Wed, 04 Apr 2007 19:11:50 -0400
Message-ID: <461430B6.9060703@tmr.com>
References: <Pine.LNX.4.61.0704011417470.8018@yvahk01.tjqt.qr> <200704011558.31670.a1426z@gawab.com> <46118473.10205@tmr.com> <200704031642.27701.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200704031642.27701.a1426z@gawab.com>
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Al Boldi wrote:
> Bill Davidsen wrote:
>   
>> Al Boldi wrote:
>>     
>>> The problem is that raid1 one doesn't do striped reads, but rather uses
>>> read-balancing per proc.  Try your test with parallel reads; it should
>>> be faster.
>>>       
> :
> :
>   
>> It would be nice if reads larger than some size were considered as
>> candidates for multiple devices. By setting the readahead larger than
>> that value speed increases would be noted for sequential access.
>>     
>
> Actually, that's what I thought for a long time too, but as Neil once pointed 
> out, for striped reads to be efficient, each chunk should be located 
> sequentially, as to avoid any seeks.  This is only possible by introducing 
> some offset layout, as in raid10, which infers a loss of raid1's 
> single-disk-image compatibility.
>   
I can't imaging that the offset needs to be physical, there's a 
translation done from the chunk address on the array to the physical 
address on the drive, and beyond that usually a translation from the 
logical position in a partition to a physical LBA location on the drive 
as a whole.
> What could be feasible, is some kind of an initial burst striped readahead, 
> which could possibly improve small reads < (readahead * nr_of_disks).
You are correct, but I think if an optimization were to be done, some balance between the read time, seek time, and read size could be done. Using more than one drive only makes sense when the read transfer time is significantly longer than the seek time. With an aggressive readahead set for the array that would happen regularly.

It's possible, it just takes the time to do it, like many other "nice" things.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

