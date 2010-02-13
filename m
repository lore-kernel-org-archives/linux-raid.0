From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: Linux mdadm superblock question.
Date: Sat, 13 Feb 2010 09:37:00 +0100
Message-ID: <4B7664AC.4080504@texsoft.it>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> I may be converting a host to ext4 and was curious, is 0.90 still the 
> only superblock version for mdadm/raid-1 that you can boot from 
> without having to create an initrd/etc?
>
> Are there any benefits to using a superblock > 0.90 for a raid-1 boot 
> volume < 2TB?

I recently reinstalled my systems, and I had to use superblock 0.9 to be 
able to boot ext4 from raid-1 (kernel 2.6.31 - grub2 1.97-beta4).
I didn't go deep with it as I was quite in hurry, so I'm not sure if it 
depends by grub2 or by kernel's md autodetection at boot.
I used superblock 1.1 for the others md devices.

The advantage of superblocks >= 1.0 that I prefere is that they persist 
the number of recovered read errors; this allow to monitor (at the 
moment manually via /sys/block/mdXX/devYY/errors) across system restarts 
the health of devices into the array, useful for raid-5 and 2-disks raid-1.

Regards

-- 
Cordiali saluti.
Yours faithfully.

Giovanni Tessore


