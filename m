From: thunder7@xs4all.nl
Subject: Re: Can't get md array to shut down cleanly
Date: Thu, 6 Jul 2006 21:29:19 +0200
Message-ID: <20060706192919.GA19446@amd64.of.nowhere>
References: <bb145bd20607060648p3776d335g55e4bdee4ecaf3c4@mail.gmail.com> <20060706154658.GC13285@rigacci.org> <bb145bd20607061018u3bf275ads6b602657867cb07d@mail.gmail.com>
Reply-To: Jurriaan <thunder7@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bb145bd20607061018u3bf275ads6b602657867cb07d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Christian Pernegger <pernegger@gmail.com>
Date: Thu, Jul 06, 2006 at 07:18:06PM +0200
> >May be your shutdown script is doing "halt -h"? Halting the disk
> >immediately without letting the RAID to settle to a clean state
> >can be the cause?
> 
> I'm using Debian as well and my halt script has the fragment you posted.
> Besides, shouldn't the array be marked clean at this point:
> 
> >md: stopping all md devices.
> 
> Apparently it isn't ... :
> 
> >md: md0 still in use.
> 
> If someone thinks it might make a difference I could remove everything
> evms and create a "pure" md array with mdadm. (Directly on the disks
> or on partitions? Which partition type?)
> 
> How does a "normal" shutdown look?
> 
> Will try 2.6.16 and 2.6.15 now ... the boring part is that I have to
> wait for the resync to complete before the next test ...
> 
I get these messages too on Debian Unstable, but since enabling the
bitmaps on my devices, resyncing is so fast that I don't even notice it
on booting. Waiting for resync is not happening here. I'm seeing it on
my raid-1 root partition.

Good luck,
Jurriaan
-- 
Debian (Unstable) GNU/Linux 2.6.17-rc4-mm3 2815 bogomips load 2.02
