From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Where is the performance bottleneck?
Date: Thu, 06 Oct 2005 17:15:56 -0400
Message-ID: <4345940C.1080307@tmr.com>
References: <200509300452.j8U4qKw17804@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751371AbVJFVM5@vger.kernel.org>
In-Reply-To: <200509300452.j8U4qKw17804@www.watkins-home.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Holger Kiehl' <Holger.Kiehl@dwd.de>, 'Mark Hahn' <hahn@physics.mcmaster.ca>, 'linux-raid' <linux-raid@vger.kernel.org>, 'linux-kernel' <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Guy wrote:

>  
>
>>-----Original Message-----
>>From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>>owner@vger.kernel.org] On Behalf Of Bill Davidsen
>>Sent: Wednesday, September 28, 2005 4:05 PM
>>To: Guy
>>Cc: 'Holger Kiehl'; 'Mark Hahn'; 'linux-raid'; 'linux-kernel'
>>Subject: Re: Where is the performance bottleneck?
>>
>>Guy wrote:
>>
>>    
>>
>>>In most of your results, your CPU usage is very high.  Once you get to
>>>      
>>>
>>about
>>    
>>
>>>90% usage, you really can't do much else, unless you can improve the CPU
>>>usage.
>>>
>>>      
>>>
>>That seems one of the problems with software RAID, the calculations are
>>done in the CPU and not dedicated hardware. As you move to the top end
>>drive hardware the CPU gets to be a limit. I don't remember off the top
>>of my head how threaded this code is, and if more CPUs will help.
>>    
>>
>
>My old 500MHz P3 can xor at 1GB/sec.  I don't think the RAID5 logic is the
>issue!  Also, I have not seen hardware that fast!  Or even half as fast.
>But I must admit, I have not seen a hardware RAID5 in a few years.  :(
>
>   8regs     :   918.000 MB/sec
>   32regs    :   469.600 MB/sec
>   pIII_sse  :   994.800 MB/sec
>   pII_mmx   :  1102.400 MB/sec
>   p5_mmx    :  1152.800 MB/sec
>raid5: using function: pIII_sse (994.800 MB/sec)
>
>Humm..  It did not select the fastest?
>
Maybe. There was discussion on this previously, but the decision was 
made to us sse when available because it is nicer to cache, or uses 
fewer registers, or similar. In any case fewer undesirable side effects.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979
