From: PFC <lists@peufeu.com>
Subject: Re: Cheap Motherboards and Linux RAID
Date: Mon, 03 Apr 2006 21:24:39 +0200
Message-ID: <op.s7f5jdn6cigqcu@apollo13>
References: <6f809746f8127f.6f8127f6f80974@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6f809746f8127f.6f8127f6f80974@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Solid Computing <solidcomputing@shaw.ca>, linux-raid@vger.kernel.org
Cc: jeff@garzik.org
List-Id: linux-raid.ids


> If you happen to be unfortunate enough to have also purchased a cheap  
> ASUS K8N VM with the Nforce410 chipset in order to get the software RAID

	And if you are also unfortunate enough to have bought some newer Maxtor  
SATA harddrives, use the jumper on the drive to revert to SATA150 instead  
of SATA300 ; this will prevent your drives from randomly failing (and  
losing all data) every 2-5 days. If your drive has no jumper, you (should)  
be safe (hopefully). This bug is agnostic and hits windows and linux, with  
nforce 3 and 4 chipsets. On the SATA150 position, the machine has been  
running smoothly for a few months with no problem whatsoever.

> (or anything for that matter) to work you have to disable APIC .  This  
> means APIC modules must not be loaded.
