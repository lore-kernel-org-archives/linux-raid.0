From: "Michael Schwarz" <mschwarz@multitool.net>
Subject: Re: Failed reads from RAID-0 array; still no joy in Mudville.
Date: Sun, 18 Mar 2007 11:39:11 -0600 (CST)
Message-ID: <3666.72.21.237.163.1174239551.squirrel@www.multitool.net>
References: <1536.72.21.237.163.1174098031.squirrel@www.multitool.net>      
    <17915.32057.221461.617241@notabene.brown> <45FC33A4.2090408@tmr.com>  
     <2745.72.21.237.163.1174158791.squirrel@www.multitool.net>
    <2760.72.21.237.163.1174159273.squirrel@www.multitool.net>
    <45FD753F.6050804@tmr.com>
Reply-To: mschwarz@multitool.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45FD753F.6050804@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org, linux-usb-users@lists.sourceforge.net
List-Id: linux-raid.ids

I've tried both single and multiple files. The files are not sparse. They
are highly compressed files (mpeg files) that would, to the filesystem, be
nearly random with no repeated patterns or voids.

-- 
Michael Schwarz

> Michael Schwarz wrote:
>> Update:
>>
>> (For those who've been waiting breathlessly). It hangs at a particular
>> point in a particular file. In other words, it doesn't depend on the
>> total
>> number of bytes transfered. Rather, when it reaches a particular point
>> in
>> a particular file (12267520 bytes into a file that is 1073709056 bytes
>> long) it hangs.
>>
>
> I have an odd thought, have you tried copying that same file to
> /dev/null or similar? The reason I ask is that if it were by any chance
> a sparse file, while the program is reading all those unwritten bytes
> odd things may happen. Sorry, I haven't seen this is years, but I do
> remember seeing a filesystem on the destination end running out of space
> because all those unwritten pages were now being "really written" as
> zeros.
>
> Use of cp with the --sparse= flag may change the behavior if this is the
> case.
>> I begin to suspect that I have a "dead spot" in my USB hub. But what
>> gets
>> me if that is true is why does the write work? Do cp and dd not check to
>> see if writes succeed?
>>
>> I know it isn't a particular flash drive because I've used two different
>> sets of 7 USB drives and it seems to fail consistently no matter which.
>>
>> Nonetheless, I'm beginning to think I'm dealing with a hardware issue,
>> not
>> a kernel issue, just because it is so consistent.
>>
>> Thanks again for all the help.
>>
>>
>>
>
>
> --
> bill davidsen <davidsen@tmr.com>
>   CTO TMR Associates, Inc
>   Doing interesting things with small computers since 1979
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

