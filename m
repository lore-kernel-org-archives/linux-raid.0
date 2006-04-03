From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Softraid controllers and Linux
Date: Mon, 03 Apr 2006 06:28:33 -0400
Message-ID: <4430F8D1.6050003@garzik.org>
References: <541048249.20060403093652@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <541048249.20060403093652@2ka.mipt.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Klimov <klimov@2ka.mipt.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jim Klimov wrote:
> Hello linux-raid,
> 
>   I have tried several cheap RAID controllers recently (namely,
>   VIA VT6421, Intel 6300ESB and Adaptec/Marvell 885X6081).
>   
>   VIA one is a PCI card, the second two are built in a Supermicro
>   motherboard (E7520/X6DHT-G).
> 
>   The intent was to let the BIOS of the controllers make a RAID1
>   mirror of two disks independently of an OS to make redundant
>   multi-OS booting transparent. While DOS and Windows saw their
>   mirrors as a singular block device, Linux (FC5) accessed the
>   two drives separately on all adapters.

You did not buy a RAID controller.

http://linux-ata.org/faq-sata-raid.html

If you really want to use proprietary RAID on Linux, you may use dmraid, 
but using MD for software RAID is much more robust.

	Jeff


