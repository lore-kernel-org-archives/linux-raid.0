From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: RAID1 Corruption
Date: Mon, 17 Jan 2005 14:14:07 -0500
Message-ID: <41EC0E7F.5090303@steeleye.com>
References: <41EBD827.80701@pipi.ma.cx> <200501171624.47645.andrew@walrond.org> <20050117165133.GC99565@caffreys.strugglers.net> <200501171704.10374.andrew@walrond.org> <41EC0371.9060106@infinia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41EC0371.9060106@infinia.de>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Gehring <markus.gehring@infinia.de>
Cc: linux-raid@vger.kernel.org, anders@anduras.de, nicoya@ubb.ca
List-Id: linux-raid.ids

Hi,

Markus Gehring wrote:

> I have a reproducable problem with corrupted data read from a RAID1-array.
> 
> Setup:
>  HW:
>   2 S-ATA-Disks (160GB each) -> /dev/md4 RAID1
>   Promise S150 TX4 - Controller
>   AMD Sempron 2200+
> 
>  SW:
>   Fedora Core 3
>   Kernel 2.6.10 unpatched
>   Samba (for read/write-accesses)
>   SW-Raid
> 
> Everything works fine with only one drive in the array. If the second is
> synced up read accesses return corrupted data.
> 
> Interesting: If you remove again the second disk. The same files will be
>  read correctly again (no matter if written while only one disk is in
> the array or two are synced!)!

This makes it sound like bad data is getting written to the second disk 
during resync. Could you give more details about your test procedure (a 
script or list of steps that reproduces the problem would be great)?

I don't think samba is the culprit, but just to be sure, is there any 
chance you could reproduce the problem without samba in the equation? 
(From what you say above, I assume all reads and writes are coming from 
a samba client of some sort?)

Thanks,
Paul
