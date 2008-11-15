From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.27.6 question: ata_sff_hsm_move: ata15 (why always ata15)?
Date: Fri, 14 Nov 2008 19:12:45 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811141912190.6297@p34.internal.lan>
References: <alpine.DEB.1.10.0811141850590.6217@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811141850590.6217@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Fri, 14 Nov 2008, Justin Piszcz wrote:

> I am trying to find out what the root cause of this error/problem is:
> https://bugzilla.redhat.com/show_bug.cgi?id=462425
>
> It seems like every week or other week someone else reports this on the 
> linux-raid mailing list.
>
> I have enabled debugging in the libata.h file and I find that ata15 is 
> constantly being accessed for some reason, why is this?
>
> The first two disks are md/RAID1, the other volume is not being written to or 
> read:
>

In messages:

Nov 14 19:12:01 p34 kernel: [ 2485.558898] ata15: ata_dev_select: ENTER, device 0, wait 1
Nov 14 19:12:01 p34 kernel: [ 2485.559318] ata15: ata_dev_select: ENTER, device 0, wait 1
Nov 14 19:12:03 p34 kernel: [ 2487.554449] ata15: ata_dev_select: ENTER, device 0, wait 1
Nov 14 19:12:03 p34 kernel: [ 2487.554725] ata15: ata_dev_select: ENTER, device 0, wait 1
Nov 14 19:12:03 p34 kernel: [ 2487.555399] ata15: ata_dev_select: ENTER, device 0, wait 1
Nov 14 19:12:03 p34 kernel: [ 2487.555746] ata15: ata_dev_select: ENTER, device 0, wait 1
Nov 14 19:12:03 p34 kernel: [ 2487.556194] ata15: ata_dev_select: ENTER, device 0, wait 1
Nov 14 19:12:03 p34 kernel: [ 2487.556449] ata15: ata_dev_select: ENTER, device 0, wait 1

