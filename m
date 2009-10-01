From: Mikhail Yakshin <greycat@altlinux.org>
Subject: Re: HW Raid Question
Date: Thu, 1 Oct 2009 11:13:20 +0400
Message-ID: <240e377b0910010013jfc2e891r6a461d555f95c79e@mail.gmail.com>
References: <c268e4660909272103r3831e129m68c11899b11be222@mail.gmail.com>
	 <70ed7c3e0909272339j2beb3de1rf3a925d207be1d8c@mail.gmail.com>
	 <c268e4660909280807q1bfb805eu4ec7804901ea1fb6@mail.gmail.com>
	 <240e377b0909290815q67cb2388w788be78adc84b1fe@mail.gmail.com>
	 <c268e4660909290844h6a1c8640yd110b75a9f85d89b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c268e4660909290844h6a1c8640yd110b75a9f85d89b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: "Majed B." <majedb@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

>> Which controller do you use exactly? We planned to add support for
>> growing/shrinking logical volumes to Einarc, but it's not quite ready
>> for prime time yet. It might be supported soon, though.
>
> I have a mix of ServeRAID 6m & 7k controllers, both of which are
> rebranded Adaptec.

Can you post results of lspci -vv for these controllers, please?

>> What exactly do you want to replace? I guess you want to do some
>> procedure to gradually change all discs in the array and then grow a
>> logical disc? Like that:
>>
>> 1. Remove one small disc => array is degraded
>> 2. Add one bigger disc, rebuild array
>> 3. Repeat steps 1-2 for all discs
>> 4. Grow physical extents
>> 5. Grow logical volume
>
> Pretty much. These are typical IBM x236 servers that have all six
> hotswap SCSI slots full of 36GB disks we're wanting to replace with
> 146GB disks we've been given by a sister company. The disks are fine
> having been tested by both myself and my counterpart.

So, I guess you'd generally want to follow an outline I've posted
above. Steps 1-3 are pretty much automated. You just need to do steps
4 and 5. I might be able to answer if particular Adaptec supports this
as soon as we'll understand what controller do you exactly have
(Adaptec XXXX - ?).

-- 
WBR, Mikhail Yakshin
