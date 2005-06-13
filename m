From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: sata_nv and RAID1
Date: Mon, 13 Jun 2005 13:59:40 -0400
Message-ID: <42ADC98C.6060808@pobox.com>
References: <200506111613.42962.dvadell@lantech.com.ar> <200506131140.54982.dvadell@lantech.com.ar> <jin0o2-eg1.ln1@news.it.uc3m.es> <200506131351.50610.dvadell@lantech.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-6; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506131351.50610.dvadell@lantech.com.ar>
Sender: linux-raid-owner@vger.kernel.org
To: "Diego M. Vadell" <dvadell@lantech.com.ar>
Cc: "Peter T. Breuer" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Diego M. Vadell wrote:
> But not as it is today... when you say "Cooperating devices would have to 
> implement the ioctls." means that I have to touch sata_nv's source code to 
> implement those ioctls, am I right?
> If that is all I have to do, I will give it a try (supposing my boss does not 
> make me use the raid in the motherboard) . 


The task is to update sata_nv to notify libata-core that a device has 
disappeared.  libata-core then notifies the SCSI layer of this.  No new 
ioctls need to be supported.

	Jeff


