From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: sata_nv and RAID1
Date: Mon, 13 Jun 2005 17:20:50 -0400
Message-ID: <42ADF8B2.5010501@pobox.com>
References: <200506111613.42962.dvadell@lantech.com.ar> <200506131351.50610.dvadell@lantech.com.ar> <42ADC98C.6060808@pobox.com> <200506131800.31956.dvadell@lantech.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-6; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506131800.31956.dvadell@lantech.com.ar>
Sender: linux-raid-owner@vger.kernel.org
To: "Diego M. Vadell" <dvadell@lantech.com.ar>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Diego M. Vadell wrote:
> On Monday 13 June 2005 14:59, you wrote:
> 
>>The task is to update sata_nv to notify libata-core that a device has
>>disappeared.  libata-core then notifies the SCSI layer of this.  No new
>>ioctls need to be supported.
>>
>>	Jeff
> 
> 
> Hi Jeff,
>    Thank you for your answers. Reading a little of 
> http://www.kernel.org/pub/linux/kernel/people/jgarzik/libata/libata.pdf and 
> drivers/scsi/sata_nv.c , it seems to me that I have to add a call to 
> ata_port_disable() into sata_nv.c:nv_check_hotplug(). 
>    In sata_nv.c , nv_check_hotplug() is called from nv_interrupt() , which 
> seems to be the interrupt handler. I add the call to ata_port_disable(ap) , 
> taking ap from the ata_host_set structure, but that structure seems to be 
> able to have many ap ports (its an array). 
>    Question: is it ok to set ap as host_set->ports[0] or should I have to see 
> what ata_port is the one that has been unplugged?

You need to go into the SCSI layer and figure out how to do it.

Calling scsi_remove_device() in the appropriate place is a good start. 
Add a debounce timer.  Make sure all commands are completed with an 
error (avoids memory leaks and lock-ups).  Other details.

Hot unplug is not just a simple function call...

	Jeff



