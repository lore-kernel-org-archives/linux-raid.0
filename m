From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: sata_nv and RAID1
Date: Tue, 14 Jun 2005 19:07:08 -0400
Message-ID: <42AF631C.1050806@tmr.com>
References: <200506111613.42962.dvadell@lantech.com.ar>	 <20050611192606.GA4055@pentafluge.infradead.org>	 <42AB49BC.50104@tls.msk.ru> <42AD2B85.30303@pobox.com>	 <42AD74BD.8050704@tls.msk.ru>	 <62b0912f05061414116f7afedc@mail.gmail.com>	 <42AF4E17.2040900@tls.msk.ru> <62b0912f0506141526358647d0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0506141526358647d0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Molle Bestefich wrote:

>Michael Tokarev wrote:
>  
>
>>Molle Bestefich wrote:
>>    
>>
>>>Michael Tokarev wrote:
>>>
>>>      
>>>
>>>>Without proper error handling [...]
>>>>linux SATA subsystem isn't ready for production,
>>>>and people should not rely on it *now*.
>>>>        
>>>>
>>Note there was an "if" in that [...] -- "IF I/O errors are
>>*really* not handled properly, linux SATA subsystem isn't
>>ready etc"
>>    
>>
>
>Oh, ok.  Didn't seem relevant.  Sorry.
>
>
>  
>
>>>As long as disks aren't removed, it's OK for production..
>>>
>>>But I'll agree with anyone who says that IDE under Linux just sucks
>>>donkey ass compared to IDE under Windows.  With Windows 2K and later,
>>>unplugging both SATA and PATA devices Just Works (tm).  I'm having a
>>>hard time figuring how this works: there's enough people supporting
>>>Linux to build a complete web-enabled SCM system (git) in a couple of
>>>weeks, but noone has bothered to fix this glaring flaw for the past 5
>>>years?  What gives?
>>>      
>>>
>>Well.. I don't want to start a flamewar, but I tend to disagree.
>>I for one don't care (for now) about SATA and hot[un]plug for
>>harddrives.
>>    
>>
>
>So you don't care that your Linux system will deadlock if a PATA disk
>is removed, for instance?  Just an example, one that I've seen happen
>a couple of times.  Never seen it with Windows, it just tells you that
>the disk is gone.
>

Actually I suspect most Linux users are smart enough not to pull a PATA 
drive out while in use, and it works just fine if you offline the drive 
before removal. I may be wrong recently, it seems that the ability to 
disable the interface was taken out of either hdparm or a recent kernel. 
I read about, exchange comments with Alan Cox, and I don't recall the 
details.

There may have been a step backward, hopefully just a brain fart and not 
a deliberate decision to disable hot swap.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

