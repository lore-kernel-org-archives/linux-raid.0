From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
Date: Tue, 10 Nov 2009 09:25:34 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0911100920510.22728@uplift.swm.pp.se>
References: <19187.50708.551325.297625@notabene.brown> <4AF829B2.5090001@redhat.com>  <4AF836F8.5040903@panix.com> <cccedfc60911090742x5ac85a5axcf93d5cb9f6f6539@mail.gmail.com> <alpine.DEB.1.10.0911091749320.22728@uplift.swm.pp.se>
 <4AF8847D.8030303@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF8847D.8030303@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 9 Nov 2009, Doug Ledford wrote:

> Of course, I recently had a bug report that I ended closing out as 
> NOTABUG because of this very ability.  The person had arrays with 1.2 
> superblocks, and they went to add a new disk, and all the existing disks 
> had a specific partition layout, so he copied that to the new disk, then 
> tried to add the partition to the raid array.  It kept returning "device 
> too small for array".  Then, upon inspection, we come to see he has a 
> 1.2 superblock on the *entire* drive, which left the partition table 
> intact, but the partition table is *pointless* because the array is on 
> the whole disk devices.  This sort of confusion is bad.  So, while I 
> could see making it 1.2 for partitions (so that boot sectors won't 
> overwrite the superblock), I wouldn't make it 1.2 for whole disk 
> devices, and in fact it might be wise to refuse to create 1.2 
> superblocks on whole disk devices.  Just a thought.

Well, same thing there, if you create a partition table you don't break 
the superblock. Perhaps something needs to be able to discern between the 
superblock being "whole disk" and on a partition? Personally I put 1.2 on 
"whole disk" (no partition table at all), and I would really HATE this 
possibility going away. I like it the way it is and feel comfortable with 
it and I don't want 1.0 or 1.1 superblocks in my setup.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
