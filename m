From: Karel Walters <karel.walters@gmail.com>
Subject: Re: [Recovery] RAID10 hdd failureS help requested
Date: Tue, 24 Sep 2013 21:14:39 +0200
Message-ID: <CAB4fJqfezFNN_C_RaETT2pqO==NQC+H1FKnwvk5FkyJs9cV3Rg@mail.gmail.com>
References: <CAB4fJqfd1zrw_AS89ufysfyCoKNf6VYj81xov0=7y0aXoYtjxw@mail.gmail.com>
	<5241A06F.10704@turmel.org>
	<CAB4fJqezb0sWcUUgRPd4BXoWr3hNBp725gv8xnMOPmcqU8RiRw@mail.gmail.com>
	<5241B4B7.1010305@turmel.org>
	<CAB4fJqerQy7PJzK4+WSNAh7YCcHmwoAqB5vMrXeSYqzWawAS+A@mail.gmail.com>
	<5241C763.6040306@turmel.org>
	<CAB4fJqeoK-o+xvAc0vnp=ika6=vTV0d6wrJhjwg43c0f7O+K_g@mail.gmail.com>
	<5241E295.6040105@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5241E295.6040105@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Phil,
> Ok, so your create operation will be:
>
> mdadm --create /dev/md1 --level=10 -n 6 --layout=f2 --chunk=64
> --data-offset=variable /dev/sdd1:2048 /dev/sdg1:4096 /dev/sdf1:2048
> /dev/sdb1:2048 /dev/sdc1:2048 /dev/sde1:2048

No --assume-clean?

> I'm actually guessing that /dev/sdb1 and /dev/sdc1 need offset 2048 like
> the original devices, not the 4096 of a device added later (newer
> mdadm).  With the mixed offsets, you need mdadm version 3.3.

I created and used it this with mdadm 3.2.5, do I really need to get 3.3?

> Use "fsck -n" to verify the array before mounting anything, just in case
> one or both of those drives really does need :4096.

Great!
