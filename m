From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: badblock handling
Date: Fri, 6 Feb 2004 08:54:33 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0402060844320.24445-100000@praktifix.dwd.de>
References: <001601c3eba2$e6110410$df01010a@moon>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <001601c3eba2$e6110410$df01010a@moon>
To: Donghui Wen <dhwen@protegonetworks.com>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

On Wed, 4 Feb 2004, Donghui Wen wrote:

> Hi,
>      I am running a server with Linux software-raid (3ware controller). But
> from time to time,
> a disk is kicked out by md. This will happen when 3ware card reports a
> unrecovered read error
> for a sector. But when I run raidhotadd, the disk can added back to raid
> with no problem.
>      So my questions are:
>         (1) Will md  kick out one disk if it find out ONE bad block?
>         (2) Is it possible to set up a threshold, only the amount of bad
> blocks pass this threshold,
>             the disk will be kicked out.
>         (3) Is it possible to remap the bad blocks to some spare blocks
> automatically on the fly?
> 
I am not an expert on this and I am only guessing, so please someone
correct me if I say something wrong.

The md block device gets an error from the underneath scsi/ide/usb/firewire/
network layer. It does not tell exactly what type of error has occured,
the best thing for md to do is to kick out this device.

Holger

