From: Chris Murphy <lists@colorremedies.com>
Subject: Re: problems with dm-raid 6
Date: Mon, 21 Mar 2016 15:46:49 -0600
Message-ID: <CAJCQCtQvXHrNmq1WnAhE7v=7Hnv12h_NFs8sc+y0Pn38ejMX5Q@mail.gmail.com>
References: <trinity-235b76ed-571d-4615-b6f7-b4d5ed6a116d-1458509365312@3capp-gmx-bs09>
	<trinity-dd5fc296-8c28-4b99-85de-889a495e6956-1458510296940@3capp-gmx-bs09>
	<20160320223727.GA29895@EIS>
	<56EFEC28.7020207@turmel.org>
	<CAJCQCtQDWdZPBvB1Q2Mh_AOBZpWSPoqK42meWvARhQi3hE5uzw@mail.gmail.com>
	<20160321213829.GA16677@EIS>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160321213829.GA16677@EIS>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Chris Murphy <lists@colorremedies.com>, Phil Turmel <philip@turmel.org>, Patrick Tschackert <Killing-Time@gmx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 21, 2016 at 3:38 PM, Andreas Klauer
<Andreas.Klauer@metamorpher.de> wrote:
> On Mon, Mar 21, 2016 at 03:26:30PM -0600, Chris Murphy wrote:
>> At this point I'm skeptical this will work. Also, I'm not familiar
>> with this overlay technique. I did look at the URL provided by
>> Andreas, my concern is whether it's possible for the volume UUID to
>> appear more than once to the kernel?
>
> Thanks for pointing out this issue, I'm not familiar with btrfs at all.
>
> Normally this would be a problem and you'd have to find some way
> to change the UUID in the overlay or whatever, but if it's LUKS
> encrypted that should solve the problem nicely, you just have to
> stop the original RAID and close the original LUKS container
> and then only open the one of the overlay.

Yes hiding it with LUKS is the way to go here. There's no practical
way to change the volume UUID as it's pervasive throughout the fs
metadata, it's used everywhere. Changing it with btrfstune means
completely rewriting out the entire fs metadata. It's the same now for
XFS v5 which similarly uses fs volume UUID everywhere as a part of
consistency checking, along with metadata checksumming. I'm not sure
about the optional ext4 checksumming but I think it too is making wide
use of fs volume UUID throughout metadata.

So I think we have to be careful with multiple instances of UUID
appearing and probably there need to be better checks in kernel code
to avoid confusion. Btrfs is harder because it explicitly supports
multiple devices, and the volume UUID correctly appears on all devices
(as well as a unique device specific UUID). So it's used to seeing
multiple instances of a volume UUID. But anyway, this is a side track
topic.

>
> You should not assemble the original RAID anymore anyhow, anything
> you write to the array at this point will likely only increase
> damages. The overlay allows you to experiment in read-"write"
> mode without actually changing anything on your disks.

Agreed. If it turns out there are some repairs needed within Btrfs
it's better with the overlay because it's unclear based on the errors
thus far what repair step to use next, and some of these repair
attempts can still sometimes make things worse (which are of course
bugs, but nevertheless...)


-- 
Chris Murphy
