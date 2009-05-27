From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Subject: [001/002 ] raid0 reshape
Date: Wed, 27 May 2009 17:55:09 -0400
Message-ID: <4A1DB6BD.50000@tmr.com>
References: <1241300764.5607.36.camel@raz> <e9c3a7c20905191109s92db696ue31a20b0816a4aed@mail.gmail.com> 	<18965.16276.485692.812516@notabene.brown> <87f94c370905211220n4e686a30ke452a56a2690d22b@mail.gmail.com> 	<87r5ydqsrd.fsf@frosties.localdomain> <5d96567b0905251306v4b1b2ef5p9268063ad81eacd8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0905251306v4b1b2ef5p9268063ad81eacd8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Raz <raziebe@gmail.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Raz wrote:
> It is not clear to me why Linux has both LVM and md,waste of
> development effort to my opinion. Adding to that brtfs/zfs reaching
> mainline, Linux will have 3-4 volume managers to maintain.
> why not join hands  and come up with a single unify system?
>   

Linux is about choice? One size doesn't fit all?

I see no reason for raid anything in LVM, it's a duplication of effort. 
By the same token, I think building everything into the file system, 
while it seems nice, means that you lose the flexibility of being able 
to control the devices, the raid behavior, and the allocation, each 
independently. I'll be the first to admit that I occasionally abuse that 
flexibility (story coming one of these days), but it's there.

As long as there's a tool to help the novice put the pieces together 
without in-depth technical expertise, I don't think limiting options to 
just one is desirable at all.

> On Mon, May 25, 2009 at 3:19 PM, Goswin von Brederlow <goswin-v-b@web.de> wrote:
>   
>> Greg Freemyer <greg.freemyer@gmail.com> writes:
>>
>>     
>>> ==> What I mean by raid equivalent levels
>>>
>>> More and more arrays allow the user to simply say "give me a 100 GB
>>> logical volume with Raid 5 equivalent protection.  The array then
>>> looks at the drives it has available and puts together the necessary
>>> pieces.  As drives are added, removed it moves the data around under
>>> its own control, but maintains the raid equivalent protection.
>>>
>>> Especially when working with dozens of drives and lots of logical
>>> volumes it makes life much easier.  Admittedly it may come at a cost
>>> of not being able to specify raid levels with the specificity that
>>> mdraid currently allows.
>>>
>>> ==>
>>>
>>> The reason I ask if this is the goal is that doing so may factor into
>>> decisions about how reshaping is implemented.
>>>
>>> Greg
>>>       
>> That really seems to scream for LVM to support more raid levels. It
>> already has linear, raid0 and raid1 support (although I have no idea
>> how device mapper raid1 compares to md raid1).
>>
>> Those should be fleshed out more and also support raid 4/5/6 for what
>> you ask.
>>     


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


