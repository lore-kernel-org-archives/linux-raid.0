From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: naming of md devices
Date: Thu, 23 Mar 2006 13:37:26 +1100
Message-ID: <87r74tx4wp.fsf@rimspace.net>
References: <87slpav0p6.fsf@uwo.ca> <87ek0uc595.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nix <nix@esperi.org.uk> writes:
> On 22 Mar 2006, Dan Christensen prattled cheerily:

[...]

> Last I heard the Debian initramfs constructs RAID arrays by explicitly
> specifying the devices that make them up. This is, um, a bad idea: the
> first time a disk fails or your kernel renumbers them you're in
> *trouble*.

The initrd tool, which was the default option, does this, and it is a
bad idea.

The initramfs tool, which is mostly shared with Ubuntu, is less stupid.
It uses mdadm and a loop to scan through the devices found on the
machine and find what RAID levels are required, then builds the RAID
arrays with mdrun.

Unfortunately, it still doesn't transfer /etc/mdadm.conf to the
initramfs, resulting in arrays changing position when constructed, to my
annoyance.   So, stupid, but not as stupid as the oldest tools.

	Daniel
-- 
Digital Infrastructure Solutions -- making IT simple, stable and secure
Phone: 0401 155 707	   email: contact@digital-infrastructure.com.au

