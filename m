From: Gordon Henderson <gordon@drogon.net>
Subject: Re: IDE performance question
Date: Sun, 8 Aug 2004 17:10:11 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0408081708410.805@lion.drogon.net>
References: <200408081649.03249.andrew@walrond.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408081649.03249.andrew@walrond.org>
To: Andrew Walrond <andrew@walrond.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 8 Aug 2004, Andrew Walrond wrote:

> I've got two 120Gb ide drives which I want to raid0 for performance, and
> my m/b has two IDE buses built in.
>
> The linux-raid howto suggests putting one drive on each bus, because
> slave disks spoil performance.

>
> Thats fine, I've got the usual two buses, but my question is:
>
> 	Where should I put the CDROM drive?

Just make it a slave on one of the buses.

> Is the very existence of a slave device the source of the performance
> degredation, or just that the bandwidth has to be shared between the devices
> (so not a problem unless the cdrom is being accessed)?

It won't be a problem uless you access it, and even then, as it's so slow
compared to the IDE drive (assumimng everything is DMA then it'll be just
fine)

> Also, I remember from years ago that the cdrom could pull the whole bus
> down to some lower performance level (even if still using and 80wire
> cable?). Is this still the case? (The hardware in question is recent).

It shouldn't be a problem with modern hardware.

Gordon
Ps. Familiar name ...
