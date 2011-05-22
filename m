From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: HBA Adaptor advice
Date: Sun, 22 May 2011 12:03:54 +0200
Message-ID: <4DD8DF8A.30304@grumpydevil.homelinux.org>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com> <4DD79F4E.7000509@wildgooses.com> <4DD7A205.8070106@grumpydevil.homelinux.org> <4DD7A80C.8050808@wildgooses.com> <4DD8DA31.7030608@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD8DA31.7030608@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/22/2011 11:41 AM, Stan Hoeppner wrote:
> On 5/21/2011 6:54 AM, Ed W wrote:
>
>    
>> In fact if you go back to my question, the *entire* point is that I
>> don't want the choice of card to be a point of failure, ie it's my
>> specific point to purchase a card such that it can be swapped out for
>> near any other card in the event of failure.
>>      
> You're given about 3 or 4 conflicting requirement now WRT your 'perfect'
> HBA.
>
> What HBAs are you currently using?  How many of your stated requirements
> over the past few days do your current HBAs fulfill?
>
> Do you have a tape or D2D backup system in place?
>
> There is no guarantee that you can swap one dead HBA for another brand
> with a different chipset on board and have it work without issue.  If
> you are that concerned you need to buy two identical cheap HBAs so you
> have a spare.  But wait!  You must have hardware write cache for md RAID
> as well.  But if you do that, you're locked into that vendor's cards.
> And on, and on...
>
> I've never seen nor heard of a real SA in a business environment
> vacillate like this over a simple RAID/HBA acquisition, as if the
> company's entire 1st quarter net profit was being wrapped up in this HBA
> purchase.  And I've never head of an SA being concerned about cable
> tripping of all damn things taking down a server.
>
> Something in this whole thread just doesn't jibe...
>
>    
The amount of money that his time has cost discussing this & thinking 
about it, is most likely already noticeably more then the cost of a 
mid-range RAID card.

My approach (and i have my own small company):
- use HW RAID on the system disks (RAID5) (and have a spare controller 
of same type ready)
- use MD RAID on big storage with cheap disks (and have spare disks 
lying ready)
- have a nightly automated backup to different system, with versioning 
and ability to recover state of half year ago

That other system is in different building.

As i do not upgrade the servers that often, this ensures:
- i do not need to spend a long time on getting the system back up, if a 
system disk goes bye-bye
- no need to think long on how grub/lilo was supposed to be working for 
multiple disks
- no need to remember to re-install bootloader on all related disks (so 
i safe-guard against my own mistakes. Takes some money, yes, but i am 
willing to pay that part of insurance quit willingly. I am aware i make 
mistakes, especially when time pressure is high)

- backup in place for the usual stupid mistaken deletes.


yes, i keep spare controllers. Do i need them? not really... so far i 
have had only 1 raid card die on me... in 10+ years i am using them.
I've had many disks go to bit hell, and some mobo. Not raid cards though.

My main issues with this discussion, is that it assumes:
- no time pressure when the shit hits the fan
- the system maintainer does not make mistakes

Both of them fail in real-life, especially with the small businesses 
where this discussion is relevant for cost reasons. Thus my stated 
feeling of "penny wise, pound foolish". Murphy being what it is, things 
usually fail when you need to have your attention on something else. 
That means there is great opportunity at such a time to make mistakes. 
Thus the setup of such systems needs to take the human aspect into 
account. As far as i can see the setup he is defining is simply too 
complex for the situation.

I've had things fail on me when i needed to leave in 2 hour, as i had a 
flight to catch. I also needed that server to be running...


Cheers,


Rudy
