From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Shrinking raid array
Date: Wed, 13 Feb 2013 06:17:12 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302130615170.32644@uplift.swm.pp.se>
References: <511A6554.1010100@ubuntu.com> <511A7052.9020802@ubuntu.com> <alpine.DEB.2.00.1302121852000.32644@uplift.swm.pp.se> <511A85D8.5070803@ubuntu.com> <alpine.DEB.2.00.1302121942490.32644@uplift.swm.pp.se> <511A9471.7070405@ubuntu.com>
 <alpine.DEB.2.00.1302130603240.32644@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1302130603240.32644@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 13 Feb 2013, Mikael Abrahamsson wrote:

> Anyhow, I can see that what you're looking for is useful as well but I 
> also believe it should be done through a special option and I imagine it 
> should also output information regarding where the partition should now 
> end (to use in fdisk) so mdadm can find the superblock next time.

Actually, in addition to this, I also believe that there should be some 
kind of superblock at the end of the current partition that points to the 
location of the "new" moved superblock, so that things work even if you do 
not change the partition size.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
