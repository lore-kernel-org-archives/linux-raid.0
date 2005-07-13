From: berk walker <berk@panix.com>
Subject: Re: RAID-5 streaming read performance
Date: Tue, 12 Jul 2005 23:15:53 -0400
Message-ID: <42D48769.2080705@panix.com>
References: <874qb14btr.fsf@uwo.ca> <1121220487.5552.34.camel@localhost.localdomain> <87mzorfmdx.fsf@uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87mzorfmdx.fsf@uwo.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Christensen <jdc@uwo.ca>
Cc: mingz@ele.uri.edu, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Dan Christensen wrote:

>Ming Zhang <mingz@ele.uri.edu> writes:
>
>  
>
>>On Mon, 2005-07-11 at 11:11 -0400, Dan Christensen wrote:
>>    
>>
>>>I was wondering what I should expect in terms of streaming read
>>>performance when using (software) RAID-5 with four SATA drives.  I
>>>thought I would get a noticeable improvement compared to reads from a
>>>single device, but that's not the case.  I tested this by using dd to
>>>read 300MB directly from disk partitions /dev/sda7, etc, and also using
>>>dd to read 300MB directly from the raid device (/dev/md2 in this case).
>>>I get around 57MB/s from each of the disk partitions that make up the
>>>raid device, and about 58MB/s from the raid device.  On the other
>>>hand, if I run parallel reads from the component partitions, I get
>>>25 to 30MB/s each, so the bus can clearly achieve more than 100MB/s.
>>>
>>>[...]
>>>
>>>System:
>>>- Athlon 2500+
>>>- kernel 2.6.12.2 (also tried 2.6.11.11)
>>>- four SATA drives (3 160G, 1 200G); Samsung Spinpoint
>>>- SiI3114 controller (latency_timer=32 by default; tried 128 too)
>>>      
>>>
>>only 1 card? 4 port? try some other brand card and try to use several
>>cards at the same time. i met some poor cards before.
>>    
>>
>
>Yes, one 4-port controller.  It's on the motherboard.
>
>I thought that since I get good throughput doing parallel reads from
>the four drives (see above) that would eliminate the controller as the
>bottleneck.  Am I wrong?
>
>Dan
>  
>
Slavery was abolished in the 1800's.
b-

>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>.
>
>  
>
