From: Solid Computing <solidcomputing@shaw.ca>
Subject: Cheap Motherboards and Linux RAID
Date: Mon, 03 Apr 2006 13:04:27 -0600
Message-ID: <6f809746f8127f.6f8127f6f80974@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-language: en
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jeff@garzik.org
List-Id: linux-raid.ids

If you happen to be unfortunate enough to have also purchased a cheap ASUS K8N VM with the Nforce410 chipset in order to get the software RAID (or anything for that matter) to work you have to disable APIC .  This means APIC modules must not be loaded.

Joe Olstad,
Solid Computing Corp
Edmonton, Canada
780-710-FAST

----- Original Message -----
From: Jeff Garzik <jeff@garzik.org>
Date: Monday, April 3, 2006 4:28 am
Subject: Re: Softraid controllers and Linux

> Jim Klimov wrote:
> > Hello linux-raid,
> > 
> >   I have tried several cheap RAID controllers recently (namely,
> >   VIA VT6421, Intel 6300ESB and Adaptec/Marvell 885X6081).
> >   
> >   VIA one is a PCI card, the second two are built in a Supermicro
> >   motherboard (E7520/X6DHT-G).
> > 
> >   The intent was to let the BIOS of the controllers make a RAID1
> >   mirror of two disks independently of an OS to make redundant
> >   multi-OS booting transparent. While DOS and Windows saw their
> >   mirrors as a singular block device, Linux (FC5) accessed the
> >   two drives separately on all adapters.
> 
> You did not buy a RAID controller.
> 
> http://linux-ata.org/faq-sata-raid.html
> 
> If you really want to use proprietary RAID on Linux, you may use 
> dmraid, 
> but using MD for software RAID is much more robust.
> 
> 	Jeff
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-
> raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

