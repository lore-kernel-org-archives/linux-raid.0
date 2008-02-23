From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mismatch_cnt != 0
Date: Sat, 23 Feb 2008 10:44:21 -0500 (EST)
Message-ID: <alpine.DEB.1.00.0802231044050.30201@p34.internal.lan>
References: <alpine.DEB.1.00.0802230434100.3809@p34.internal.lan> <47C01D79.4010708@msgid.tls.msk.ru> <alpine.DEB.1.00.0802230904130.15989@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.00.0802230904130.15989@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 23 Feb 2008, Justin Piszcz wrote:

>
>
> On Sat, 23 Feb 2008, Michael Tokarev wrote:
>
>> Justin Piszcz wrote:
>>> Should I be worried?
>>> 
>>> Fri Feb 22 20:00:05 EST 2008: Executing RAID health check for /dev/md3...
>>> Fri Feb 22 21:00:06 EST 2008: cat /sys/block/md3/md/mismatch_cnt
>>> Fri Feb 22 21:00:06 EST 2008: 936
>>> Fri Feb 22 21:00:09 EST 2008: Executing repair on /dev/md3
>>> Fri Feb 22 22:00:10 EST 2008: cat /sys/block/md3/md/mismatch_cnt
>>> Fri Feb 22 22:00:10 EST 2008: 936
>> 
>> Your /dev/md3 is a swap, right?
>> If it's swap, it's quite common to see mismatches here.  I don't know
>> why, and I don't think it's correct (there should be a bug somewhere).
>> If it's not swap, there should be no mismatches, UNLESS you initially
>> built your array with --assume-clean.
>> In any case it's good to understand where those mismatches comes from
>> in the first place.
>> 
>> As of the difference (or, rather, lack thereof) of the mismatched
>> blocks after check and repair - that's exactly what expected.  Check
>> found 936 mismatches, and repair corrected exactly the same amount
>> of them.  I.e., if you run check again after repair, you should see
>> 0 mismatches.
>> 
>> /mjt
>> 
>
> My /dev/md3 is my main RAID 5 partition.  Even after repair, it showed 936, I 
> will re-run repair.  Also, I did not build my array with --assume-clean and I 
> run my check > array once a week.
>
> Justin.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

After a reboot & check, it is back to 0-- interesting..

Justin.
