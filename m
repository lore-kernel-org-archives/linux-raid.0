From: "David Lethe" <david@santools.com>
Subject: Re: Booting off of RAID10 versus RAID1
Date: Thu, 8 May 2008 11:25:00 -0500
Message-ID: <06c201c8b128$1c4bf045$5209f40a@exchange.rackspace.com>
Reply-To: <David@santools.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>, Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I know of several vendors that have linux-based NAS appliance vendors who do this. It is rock solid, as long as you don't use consumer-quality usb flash.  Check specs on flash memory for throughput and write cycles and ECC and choose accordingly. Also look into IDE mounted flash. It directly plugs into IDE plug on mobo, so it will be internal, and emulates an ide disk.  

-----Original Message-----

From:  "David Greaves" <david@dgreaves.com>
Subj:  Re: Booting off of RAID10 versus RAID1
Date:  Thu May 8, 2008 10:31 am
Size:  556 bytes
To:  "Maurice Hilarius" <maurice@harddata.com>
cc:  "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>

Maurice Hilarius wrote: 
> After recent issues discovered with RAID1 and failing disks, I am 
> contemplating alternatives to ensure more reliability. 
>  
> The question that arises: Is there any way to boot a system from a 
> RAID10 md? 
 
I've been wondering about booting grub/initrd from a flash USB stick (industrial 
quality if needed). 
 
David 
 
-- 
To unsubscribe from this list: send the line "unsubscribe linux-raid" in 
the body of a message to majordomo@vger.kernel.org 
More majordomo info at  http://vger.kernel.org/majordomo-info.html 
 


