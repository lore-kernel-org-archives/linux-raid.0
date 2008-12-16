From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [smartmontools-support] Velociraptor biting the dust (9th disk,
 continued to use it, and..)
Date: Tue, 16 Dec 2008 08:07:01 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812160803170.725@p34.internal.lan>
References: <alpine.DEB.1.10.0811221638360.707@p34.internal.lan> <20081122215529.1973f820@lxorguk.ukuu.org.uk> <Pine.LNX.4.64.0812160625150.8812@gc.phys.uwm.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0812160625150.8812@gc.phys.uwm.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Bruce Allen <ballen@gravity.phys.uwm.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, Smartmontools Mailing List <smartmontools-support@lists.sourceforge.net>, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids



On Tue, 16 Dec 2008, Bruce Allen wrote:

> Hi Alan, Hi Justin,
>
> Sorry, following up on old emails... I am behind as usual.
>
>>> [632714.975844] ata1.00: status: { DRDY ERR }
>>> [632714.975847] ata1.00: error: { IDNF }
>
>> IDNF - ID not found, usually these days means 'asked for a sector out of
>> range'
>
> Justin, was this error provoked for example by you using a 'dd' command to 
> try and read stuff past the end of the disk?  Because the md device driver 
> should not try and do something like that.  The md device driver knows how 
> many LBAs are available on the disk and should never issue a read or write 
> past the end of the device.
>
> Justin, I have the impression that this IDNF error was NOT due to you issuing 
> dd commands or similar, but was part of 'normal' md operation.
>
> Alan, am I overlooking something?  (One feature that might provide such 
> errors is the 'host reserved address' set of commands that allow you to 
> 'clip' the disk capacity.)
>
> Cheers,
>    Bruce
>

Bruce,

Most of the errors were during normal md/Linux operation.  However, I will 
also note that with a 16-port 3ware controller, drives were also 
having problems, different errors mind you but they were rather nasty.

The errors occured on RAID-1, RAID-5 and RAID-6 and even on a single disk, 
no md/Linux, I kept running bonnie++ with different filesystems on one 
disk, ext3 and XFS, both of which started erroring out.

I removed all of the Velociraptors and replaced them with good old 
Raptor150s and tested with md/Linux and the 3ware card, no problems with 
either configuration.  I truly believe something is wrong with the 
Velociraptors at this point since both md/Linux and 3ware both had problems
with the drives.

Justin.
