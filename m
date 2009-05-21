From: Nix <nix@esperi.org.uk>
Subject: Re: How to un-degrade an array after a totally spurious failure?
Date: Thu, 21 May 2009 08:32:23 +0100
Message-ID: <87my96ews8.fsf@hades.wkstn.nix>
References: <87skiztloo.fsf@hades.wkstn.nix>
	<97f847c1f487636ed40b8c1db1b98105.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <97f847c1f487636ed40b8c1db1b98105.squirrel@neil.brown.name> (NeilBrown's message of "Thu, 21 May 2009 12:49:04 +1000 (EST)")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21 May 2009, NeilBrown outgrape:

> On Thu, May 21, 2009 9:10 am, Nix wrote:
>
>> So, anyone got a command that would help? I'm not even sure if this is
>> assembly or growth: it doesn't quite fit into either of those
>> categories. There must be a way to do this, surely?
>
> It is neither.  It is management.

And it says as much in the manpage quite clearly now I look specifically
for it. Maybe trying to fix things at 11pm isn't the best idea.

It's reconstructing now (*slowly*: this ancient Symbios SCSI card goes
into a sort of ultra-sluggish mode when it loses parity --- I think it
stops doing DMA --- so we're seeing astounding 1Mb/s transfer rates.)

But it should be finished by, oh, tomorrow, and the annealing jobs can
keep running, as long as they're not too discomfited by their filesystem
suddenly deciding to imitate a slow tape drive. :)

>  mdadm --manage /dev/mdX --remove /dev/sdb6
>  mdadm --manage /dev/mdX --add /dev/sdb6
>
> (The --manage is not actually needed, but it doesn't hurt).

Thanks!
