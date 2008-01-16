From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Linux Software RAID 5 + XFS Multi-Benchmarks / 10 Raptors
 Again
Date: Wed, 16 Jan 2008 17:53:05 -0500 (EST)
Message-ID: <alpine.DEB.0.999999.0801161752420.4552@p34.internal.lan>
References: <alpine.DEB.0.999999.0801161105510.16168@p34.internal.lan> <200801162027.00791.a1426z@gawab.com> <alpine.DEB.0.999999.0801161243380.1151@p34.internal.lan> <200801170019.04836.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200801170019.04836.a1426z@gawab.com>
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: xfs@oss.sgi.com, linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids



On Thu, 17 Jan 2008, Al Boldi wrote:

> Justin Piszcz wrote:
>> On Wed, 16 Jan 2008, Al Boldi wrote:
>>>> Also, can you retest using dd with different block-sizes?
>>
>> I can do this, moment..
>>
>>
>> I know about oflag=direct but I choose to use dd with sync and measure the
>> total time it takes.
>> /usr/bin/time -f %E -o ~/$i=chunk.txt bash -c 'dd if=/dev/zero
>> of=/r1/bigfile bs=1M count=10240; sync'
>>
>> So I was asked on the mailing list to test dd with various chunk sizes,
>> here is the length of time it took
>> to write 10 GiB and sync per each chunk size:
>>
>> 4=chunk.txt:0:25.46
>> 8=chunk.txt:0:25.63
>> 16=chunk.txt:0:25.26
>> 32=chunk.txt:0:25.08
>> 64=chunk.txt:0:25.55
>> 128=chunk.txt:0:25.26
>> 256=chunk.txt:0:24.72
>> 512=chunk.txt:0:24.71
>> 1024=chunk.txt:0:25.40
>> 2048=chunk.txt:0:25.71
>> 4096=chunk.txt:0:27.18
>> 8192=chunk.txt:0:29.00
>> 16384=chunk.txt:0:31.43
>> 32768=chunk.txt:0:50.11
>> 65536=chunk.txt:2:20.80
>
> What do you get with bs=512,1k,2k,4k,8k,16k...
>
>
> Thanks!
>
> --
> Al
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Done testing for now, but I did test with 256k with a 256k chunk and 
obviously that got good results, just like 1m with a 1mb chunk, 460-480 
MiB/s.

Justin.
