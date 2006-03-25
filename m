From: Nix <nix@esperi.org.uk>
Subject: Re: naming of md devices
Date: Sat, 25 Mar 2006 01:53:25 +0000
Message-ID: <87d5gbnvca.fsf@hades.wkstn.nix>
References: <87slpav0p6.fsf@uwo.ca> <87ek0uc595.fsf@hades.wkstn.nix>
	<87r74tx4wp.fsf@rimspace.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r74tx4wp.fsf@rimspace.net> (Daniel Pittman's message of "23
 Mar 2006 03:01:54 -0000")
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Pittman <daniel@rimspace.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23 Mar 2006, Daniel Pittman uttered the following:
> The initramfs tool, which is mostly shared with Ubuntu, is less stupid.
> It uses mdadm and a loop to scan through the devices found on the
> machine and find what RAID levels are required, then builds the RAID
> arrays with mdrun.

That's much nicer.

> Unfortunately, it still doesn't transfer /etc/mdadm.conf to the
> initramfs, resulting in arrays changing position when constructed, to my
> annoyance.   So, stupid, but not as stupid as the oldest tools.

That surely can't be hard to fix, can it?

-- 
`Come now, you should know that whenever you plan the duration of your
 unplanned downtime, you should add in padding for random management
 freakouts.'
