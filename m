From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Which controller is recommended for a hardware-raid
Date: Tue, 2 Dec 2003 15:24:24 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0312021513580.23341-100000@praktifix.dwd.de>
References: <3FCCA904.5060302@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3FCCA904.5060302@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 2 Dec 2003, Jeff Garzik wrote:

> Holger Kiehl wrote:
> > On Fri, 28 Nov 2003, Jeff Garzik wrote:
> > 
> > 
> >>There is an open source driver for the FastTrak now...
> >>(assuming it's SATA not PATA)
> >>
> > 
> > Where can I find this driver? I have an onboard Promise 378 setup as
> > raid 1 with two SATA disks and with kernel 2.6.0-test9 it only sees the
> > two individual drives, not the raid 1 mirror.
> 
> 
> Right.  My driver presents only the individual drives.
> 
> In 2.4.x, you need the additional "pdcraid" driver to use Promise RAID 
> 0/1.
>
You mean the combination of your libata and pdcraid? Because I tried
pdcraid only with no success.

>  In 2.6.x, you must use md RAID to achieve RAID 0/1/5.
> 
I would like to access the promise raid from both the linux and windows
world. Not that you get me wrong I love md and use it a lot and think
this is the best possible raid solution. Maybe Neil volunteers to port
md to windows ;)

Holger

