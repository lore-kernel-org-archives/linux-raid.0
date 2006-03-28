From: Ken Swarthout <Ken@4dcsi.com>
Subject: Re: software raid to Hardware raid
Date: Mon, 27 Mar 2006 21:12:07 -0500
Message-ID: <44289B77.80700@4dcsi.com>
References: <4428073C.50007@4dcsi.com> <44281791.7060105@4dcsi.com> <44287528.8040003@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44287528.8040003@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you for your reply.   It is a little more than a terabyte worth of 
information.   And although we have everything backed up on tape, it 
will take a very long time to restore it.  The reason we need to do this 
is because when it was converted to software RAID, we lost a lot of 
performance.  There are about twenty 80 gig hard drives hooked to two 
promise RAID controllers.   Can I just run raidstop /dev/md0 and not 
loose the data and still have the original hardware RAID still there?  
Thanks.

--Ken

Bill Davidsen wrote:

> Ken wrote:
>
>> Hello,
>>   We have a Red Hat 7.1 box running kernel 2.4.17-SMP.   We have 
>> raidtools installed.   We had a hardware RAID that got converted to a 
>> software raid by mistake.   Is there any way to go back without 
>> loosing the data?   the device is showing up as /dev/md0.  Thank you. 
>
>
> 1 - back up your data
> 2 - convert to hw raid
> 3 - test carefully to be sure it works
> 4 - reload your data
>
> And left out, step zero, consider why you want to do this if what you 
> have is working reliably
> also, between 2 and 3 consider upgrading to a distribution and kernel 
> written this millenium.
>
> Given the state of hardware raid when that kernel was new, and the 
> state of the drivers, I would be very sure I had a GOOD reason to 
> change anything.
>


