From: Phil Turmel <philip@turmel.org>
Subject: Re: [BUG?] RAID not properly assembled w/ kernel 2.6.39.x
Date: Thu, 09 Jun 2011 10:25:39 -0400
Message-ID: <4DF0D7E3.1050501@turmel.org>
References: <201106091521.54769.ml_linux_raid@mortal-soul.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201106091521.54769.ml_linux_raid@mortal-soul.de>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Dahl <ml_linux_raid@mortal-soul.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Matthias,

On 06/09/2011 09:21 AM, Matthias Dahl wrote:
> Hi all.
> 
> I tried updating to 2.6.39.1 from 2.6.38.2 and failed due to some md raid
> issues I wasn't able to solve even after hours.   I hope someone can help
> me out- I'd really appreciate it.

[...]

> I'm sorry for this chaotic explanation but as you can see it's quite hard
> to explain. :-(

Well, you are swimming against the tide:  the kernel has been steadily losing consistent device names, for what the kernel devs feel are good and proper reasons.  The recommended alternative is to use filesystem labels, or even better, UUIDs in your fstab.  Then you can go back to no mdadm.conf file in your initramfs, and carry on.

(*I'm* not going to command the tide to stop.)

> Again, this works fine with any kernel prior to 2.6.39 and adding a  conf
> to the initramfs fixes  mostly anything but the additional partition prob
> which has me worrying that something else might be wrong.
> 
> Like said earlier, I'd really appreciate anyone shedding  some  light  on
> this. Thanks a lot in advance...

HTH,

Phil
