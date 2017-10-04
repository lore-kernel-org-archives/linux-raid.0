From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: hung grow
Date: Wed, 4 Oct 2017 20:46:22 +0100
Message-ID: <3173c10a-fbd9-f563-4c90-a9f63e020773@youngman.org.uk>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
 <a528459f-8bf5-3e47-9c9a-7c040ad7ab81@youngman.org.uk>
 <CADg2FGYPENaUb7oDhOUu08VMhzygE365mqw=Lw332jBGbe1dGQ@mail.gmail.com>
 <0001704a-fe2f-e164-7694-f294a427ed83@gmail.com>
 <CADg2FGYRGYww6fTCYJCYRQvnrW70nZx-tTYpBP1+cyvzvTSpgA@mail.gmail.com>
 <cdf0fd70-ec6d-8e9d-6abd-6d9937b6a709@gmail.com>
 <d1bd0e82-9415-b6f4-2ffa-6e17bf636f34@youngman.org.uk>
 <CADg2FGaNtjN7=wYe6f07xEZ=mW2QFZdjtBFjQLDthn9w3Jw=NA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADg2FGaNtjN7=wYe6f07xEZ=mW2QFZdjtBFjQLDthn9w3Jw=NA@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Curt <lightspd@gmail.com>
Cc: Joe Landman <joe.landman@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/10/17 20:09, Curt wrote:
> Ok, thanks.
> 
> I'm pretty sure I'll be able to DD from at least one of the failed
> drives, as I could still query them before I yanked them.  Assuming I
> can DD one of the old drives to one of my new ones.
> 
> I'd DDrescue old to new drive. Then do an assemble for force, with a
> mix of the dd drives and my old good ones? So if sda/b are new DD'd
> drives and sdc/d/e are hosed grow drives, I'd do an assemble force
> revert-reshape /dev/md127 sda sdb sdc sdd and sde? Then assemble can
> use my info from the DD drives to assemble the array back to 7 drives?
>   Did I understand that right?

This sounds like you need to take a great big step backwards, and make 
sure you understand EXACTLY what is going on. We have a mix of good 
drives, copies of bad drives, and an array that doesn't know whether it 
is supposed to have 7 or 9 drives. One wrong step and your array will be 
toast.

You want ALL FOUR KNOWN GOOD DRIVES. You want JUST ONE ddrescue'd drive.

But I think the first thing we need to do, is to wait for an expert like 
Phil to chime in and sort out that reshape. Your four good drives all 
think they are part of a 9-drive array. Your first two drives to fail 
think they are part of a 7-drive array. Does the third drive think it's 
part of a 7-drive or 9-drive array?

Can you do a --examine on this drive? I suspect the grow blew up because 
it couldn't access this drive. I this drive thinks it is part of a 
7-drive array, we have a bit of a problem on our hands.

I'm hoping it thinks it's part of a 9-drive array - I think we may be 
able to get out of this ...
> 
> Oh and how can I tell if I have a timeout mismatch.  They should be raid drives.

smartctl -x /dev/sdX

This will give you both the sort of drive you have - yes if it's in a 
datacentre chances are it is a raid drive - and then search the output 
for Error Recovery Control. This is from my hard drive...

SCT capabilities:              (0x003f) SCT Status supported.
                                         SCT Error Recovery Control 
supported.
                                         SCT Feature Control supported.
                                         SCT Data Table supported.

You need error recovery to be supported. If it isn't ...

> 
> Cheers,
> Curt

Cheers,
Wol
