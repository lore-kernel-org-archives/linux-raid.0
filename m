From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Disks with 4k sectors
Date: Sun, 27 Mar 2011 10:22:55 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1103271021191.4842@uplift.swm.pp.se>
References: <4D8EF209.60707@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D8EF209.60707@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Albert Pauw <albert.pauw@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 27 Mar 2011, Albert Pauw wrote:

> When I would use  new disks with 4kB sectors (3 TB disks e.g.) instead of 
> 512B with mdadm to create a RAID 1/5/6 set, are there any special things to 
> look out for?
>
> I would assume choosing chunk sizes of multiples of 4kB.

If you use partitions, make sure you align correctly to 4kB.

This has been discussed extensively (look in the archives), all md 
structures are 4k aligned so if you create the raid directly on the 
device, you get proper alignment.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
