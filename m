From: Mitchell Laks <mlaks@verizon.net>
Subject: Re: Silent Corruption on RAID5
Date: Sun, 22 Jan 2006 13:42:15 -0500
Message-ID: <200601221342.15264.mlaks@verizon.net>
References: <43D3B675.20804@xterminate.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <43D3B675.20804@xterminate.me.uk>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 22 January 2006 11:44 am, Michael Barnwell wrote:
> Hi,
>
> I'm experiencing silent data corruption on my RAID 5 set of four 400GB
> SATA disks.

> dd bs=1024 count=10000k if=/dev/zero of=./10GB.tst
> od -t x1 s0/10GB.tst
>
> These commands give me one row of zeros on my other RAID 5 set on the

> I'm running Debian sarge with a 2.6.15-1 kernel, it has an Athlon
> XP2200, 1GB of RAM, Asus A7N8X-Deluxe motherboard, 2 Maxtor IDE
> controllers, one Silicon Image 3114 PCI adapter, along with the on-board
> Silicon Image 3112 controller - 2x 10GB IDE disks and a DVD ROM drive on
> the on-board IDE controller, 3x 120GB Seagate hard disks on the PCI IDE
> adapters, 2x 80GB Seagate disks on the on-board SilImg 3112 controller
> and finally 4x 400GB disks on the SilImg 3114 PCI adapter.
>

Dear Michael,

If you look at  my recent post and the response from David Greaves, I suspect 
it is because  of the presence of multiple diffferent SATA controllers. 

Could you make a try of running  your test with ONLY the SilImg 3114 adapter 
populated with disks. Also I am not aware if the 3112 and 3114 use different 
kernel modules, make sure the  other one is not loaded. 

I ran your test on my raid1 system with the debian SID 2.6.15 kernel and ran 
the test on both motherboard sata_via and pci card sata_promise controlled 
raid devices (i have raid1 though) and had no problem.

I could only run od -t x1 10GB.tst.
 what is the "s0 " for? 
I tried s0 or -s0 and the machine didnt accept that switch for od.

od -t x1 -s0 10GB.tst 
"od: no type may be specified when dumping strings"

For what its worth, on my system the Promise controller wipes out the 
via VT8237 onboard controller. You seem to have the opposite problem.

I am afraid that SATA controllers may  not yet be stable enough for 
production.

Mitchell Laks

> So, does anyone have any suggestions or tests I could perform to narrow
> down where my problem is?
>
> Regards,
>
> Michael Barnwell.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
