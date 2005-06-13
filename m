From: "Diego M. Vadell" <dvadell@lantech.com.ar>
Subject: Re: sata_nv and RAID1
Date: Mon, 13 Jun 2005 18:00:31 -0300
Message-ID: <200506131800.31956.dvadell@lantech.com.ar>
References: <200506111613.42962.dvadell@lantech.com.ar> <200506131351.50610.dvadell@lantech.com.ar> <42ADC98C.6060808@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42ADC98C.6060808@pobox.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 13 June 2005 14:59, you wrote:
>
> The task is to update sata_nv to notify libata-core that a device has
> disappeared.  libata-core then notifies the SCSI layer of this.  No new
> ioctls need to be supported.
>
> 	Jeff

Hi Jeff,
   Thank you for your answers. Reading a little of 
http://www.kernel.org/pub/linux/kernel/people/jgarzik/libata/libata.pdf and 
drivers/scsi/sata_nv.c , it seems to me that I have to add a call to 
ata_port_disable() into sata_nv.c:nv_check_hotplug(). 
   In sata_nv.c , nv_check_hotplug() is called from nv_interrupt() , which 
seems to be the interrupt handler. I add the call to ata_port_disable(ap) , 
taking ap from the ata_host_set structure, but that structure seems to be 
able to have many ap ports (its an array). 
   Question: is it ok to set ap as host_set->ports[0] or should I have to see 
what ata_port is the one that has been unplugged?

The only change so far looks like this. It does compile cleanly, but I will 
have the hardware to test it tomorrow.

static void nv_check_hotplug(struct ata_host_set *host_set)
{
        u8 intr_status;
	struct ata_port *ap;

	// Get the ATA Port to be disabled if hot-removed
	ap = host_set->ports[0];  

        intr_status = inb(host_set->ports[0]->ioaddr.scr_addr + 
NV_INT_STATUS);

        // Clear interrupt status.
        outb(0xff, host_set->ports[0]->ioaddr.scr_addr + NV_INT_STATUS);

        if (intr_status & NV_INT_STATUS_HOTPLUG) {
                if (intr_status & NV_INT_STATUS_PDEV_ADDED)
                        printk(KERN_WARNING "nv_sata: "
                                "Primary device added\n");

                if (intr_status & NV_INT_STATUS_PDEV_REMOVED) {
                        printk(KERN_WARNING "nv_sata: "
                                "Primary device removed\n");
			ata_port_disable(ap);
		}

                if (intr_status & NV_INT_STATUS_SDEV_ADDED)
                        printk(KERN_WARNING "nv_sata: "
                                "Secondary device added\n");

                if (intr_status & NV_INT_STATUS_SDEV_REMOVED) {
                        printk(KERN_WARNING "nv_sata: "
                                "Secondary device removed\n");
			ata_port_disable(ap);
		}
        }
}

Thanks in advance,
 -- Diego.
