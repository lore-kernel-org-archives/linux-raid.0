From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: problems with dm-raid 6
Date: Mon, 21 Mar 2016 22:38:29 +0100
Message-ID: <20160321213829.GA16677@EIS>
References: <trinity-235b76ed-571d-4615-b6f7-b4d5ed6a116d-1458509365312@3capp-gmx-bs09>
 <trinity-dd5fc296-8c28-4b99-85de-889a495e6956-1458510296940@3capp-gmx-bs09>
 <20160320223727.GA29895@EIS>
 <56EFEC28.7020207@turmel.org>
 <CAJCQCtQDWdZPBvB1Q2Mh_AOBZpWSPoqK42meWvARhQi3hE5uzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJCQCtQDWdZPBvB1Q2Mh_AOBZpWSPoqK42meWvARhQi3hE5uzw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Phil Turmel <philip@turmel.org>, Patrick Tschackert <Killing-Time@gmx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 21, 2016 at 03:26:30PM -0600, Chris Murphy wrote:
> At this point I'm skeptical this will work. Also, I'm not familiar
> with this overlay technique. I did look at the URL provided by
> Andreas, my concern is whether it's possible for the volume UUID to
> appear more than once to the kernel?

Thanks for pointing out this issue, I'm not familiar with btrfs at all.

Normally this would be a problem and you'd have to find some way 
to change the UUID in the overlay or whatever, but if it's LUKS 
encrypted that should solve the problem nicely, you just have to 
stop the original RAID and close the original LUKS container 
and then only open the one of the overlay.

You should not assemble the original RAID anymore anyhow, anything 
you write to the array at this point will likely only increase 
damages. The overlay allows you to experiment in read-"write" 
mode without actually changing anything on your disks.

> The issue is raid6 assembly somehow being wonky.
> But at this point we need to hear back from Patrick.

Yes, it's quite a mystery, I hope the OP can shed some light on 
what might have caused this.

Regards
Andreas Klauer
