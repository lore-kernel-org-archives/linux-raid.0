From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Triple-parity raid6
Date: Fri, 10 Jun 2011 09:56:02 -0400
Message-ID: <4DF22272.6080307@tmr.com>
References: <isp2g2$rf$1@dough.gmane.org>	<20110609114954.243e9e22@notabene.brown>	<isqb2o$g0s$1@dough.gmane.org> <20110609220438.26336b27@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110609220438.26336b27@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
> On Thu, 09 Jun 2011 13:32:59 +0200 David Brown<david@westcontrol.com>  wrote:
>
>    
>> On 09/06/2011 03:49, NeilBrown wrote:
>>      
>>>
>>>    -ENOPATCH  :-)
>>>
>>> I have a series of patches nearly ready which removes a lot of the remaining
>>> duplication in raid5.c between raid5 and raid6 paths.  So there will be
>>> relative few places where RAID5 and RAID6 do different things - only the
>>> places where they *must* do different things.
>>>        
>>> After that, adding a new level or layout which has 'max_degraded == 3' would
>>> be quite easy.
>>> The most difficult part would be the enhancements to libraid6 to generate the
>>> new 'syndrome', and to handle the different recovery possibilities.
>>>
>>> So if you're not otherwise busy this weekend, a patch would be nice :-)
>>>
>>>        
>> I'm not going to promise any patches, but maybe I can help with the
>> maths.  You say the difficult part is the syndrome calculations and
>> recovery - I've got these bits figured out on paper and some
>> quick-and-dirty python test code.  On the other hand, I don't really
>> want to get into the md kernel code, or the mdadm code - I haven't done
>> Linux kernel development before (I mostly program 8-bit microcontrollers
>> - when I code on Linux, I use Python), and I fear it would take me a
>> long time to get up to speed.
>>
>> However, if the parity generation and recovery is neatly separated into
>> a libraid6 library, the whole thing becomes much more tractable from my
>> viewpoint.  Since I am new to this, can you tell me where I should get
>> the current libraid6 code?  I'm sure google will find some sources for
>> me, but I'd like to make sure I start with whatever version /you/ have.
>>      
> You can see the current kernel code at:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=tree;f=lib/raid6;h=970c541a452d3b9983223d74b10866902f1a47c7;hb=HEAD
>
>
> int.uc is the generic C code which 'unroll.awk' processes to make various
> versions that unroll the loops different amounts to work with CPUs with
> different numbers of registers.
> Then there is sse1, sse2, altivec which provide the same functionality in
> assembler which is optimised for various processors.
>
>    
And at some point I'm sure one of the video card vendors will provide a 
hack to do it in
the GPU in massively parallel fashion.

> And 'recov' has the smarts for doing the reverse calculation when 2 data
> blocks, or 1 data and P are missing.
>
> Even if you don't feel up to implementing everything, a start might be
> useful.  You never know when someone might jump up and offer to help.
>
>
>    


-- 
Bill Davidsen<davidsen@tmr.com>
   We are not out of the woods yet, but we know the direction and have
taken the first step. The steps are many, but finite in number, and if
we persevere we will reach our destination.  -me, 2010



