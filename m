From: Curt <lightspd@gmail.com>
Subject: Re: hung grow
Date: Wed, 4 Oct 2017 15:09:04 -0400
Message-ID: <CADg2FGaNtjN7=wYe6f07xEZ=mW2QFZdjtBFjQLDthn9w3Jw=NA@mail.gmail.com>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
 <a528459f-8bf5-3e47-9c9a-7c040ad7ab81@youngman.org.uk> <CADg2FGYPENaUb7oDhOUu08VMhzygE365mqw=Lw332jBGbe1dGQ@mail.gmail.com>
 <0001704a-fe2f-e164-7694-f294a427ed83@gmail.com> <CADg2FGYRGYww6fTCYJCYRQvnrW70nZx-tTYpBP1+cyvzvTSpgA@mail.gmail.com>
 <cdf0fd70-ec6d-8e9d-6abd-6d9937b6a709@gmail.com> <d1bd0e82-9415-b6f4-2ffa-6e17bf636f34@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d1bd0e82-9415-b6f4-2ffa-6e17bf636f34@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>
Cc: Joe Landman <joe.landman@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok, thanks.

I'm pretty sure I'll be able to DD from at least one of the failed
drives, as I could still query them before I yanked them.  Assuming I
can DD one of the old drives to one of my new ones.

I'd DDrescue old to new drive. Then do an assemble for force, with a
mix of the dd drives and my old good ones? So if sda/b are new DD'd
drives and sdc/d/e are hosed grow drives, I'd do an assemble force
revert-reshape /dev/md127 sda sdb sdc sdd and sde? Then assemble can
use my info from the DD drives to assemble the array back to 7 drives?
 Did I understand that right?

Oh and how can I tell if I have a timeout mismatch.  They should be raid drives.

Cheers,
Curt

On Wed, Oct 4, 2017 at 3:01 PM, Anthony Youngman
<antlists@youngman.org.uk> wrote:
> On 04/10/17 19:44, Joe Landman wrote:
>>
>> Generally speaking 3 failed drives on a RAID6 is a dead RAID6.  You may
>> get lucky, in that this may have been simply a timeout error (I've seen
>> these on consumer grade drives), or an internal operation on the drive
>> taking longer than normal, and been booted.  In which case, you'll get scary
>> warning messages, but might get your data back.
>>
>> Under no circumstances do anything to change RAID metadata right now
>> (grow, shrink, etc.).  Start with basic assembly.  If you can do that, you
>> are in good shape.  If you can't, recovery is unlikely, even with heroic
>> intervention.
>
>
> No - Curt needs to stop the grow before anything else will work, I think.
> Fortunately, seeing as it's hung at 0% this shouldn't mess about with the
> data at all.
>
> And you NEED to ddrescue that fifth drive. At which point basic assembly
> should hopefully work fine.
>
> (Note that the grow quite likely failed because the fifth drive errored ...
> Oh - and are they raid drives? What are they? You don't have a timeout
> mismatch?)
>
> Cheers,
> Wol
