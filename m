From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Shrinking raid array
Date: Wed, 13 Feb 2013 06:12:40 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302130603240.32644@uplift.swm.pp.se>
References: <511A6554.1010100@ubuntu.com> <511A7052.9020802@ubuntu.com> <alpine.DEB.2.00.1302121852000.32644@uplift.swm.pp.se> <511A85D8.5070803@ubuntu.com> <alpine.DEB.2.00.1302121942490.32644@uplift.swm.pp.se> <511A9471.7070405@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511A9471.7070405@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 12 Feb 2013, Phillip Susi wrote:

> Yes, but the way it is now the superblock won't be found if the 
> partition *is* resized.  What is the use of reducing the amount of the 
> partition mdadm is using if you can't then shrink the partition itself?

It makes sense if you for some reason want to use a smaller component 
drive (thinking mostly of older drives where 36 or 73GB didn't mean an 
exact size between manufacturers and you happened to create the array on a 
larger drive than you now have available.

Anyhow, I can see that what you're looking for is useful as well but I 
also believe it should be done through a special option and I imagine it 
should also output information regarding where the partition should now 
end (to use in fdisk) so mdadm can find the superblock next time.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
