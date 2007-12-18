From: Neil Brown <neilb@suse.de>
Subject: Re: Cannot re-assemble Degraded RAID6 after crash
Date: Tue, 18 Dec 2007 14:09:32 +1100
Message-ID: <18279.14828.345584.52508@notabene.brown>
References: <d39ad6430712171840t554927dat8df327531348d6b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Erich Newell on Monday December 17
Sender: linux-raid-owner@vger.kernel.org
To: Erich Newell <erich.newell@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday December 17, erich.newell@gmail.com wrote:
> My system has crashed a couple of times, each time the two drives have
> dropped off of the RAID.
> 
> Previously I simply did the following, which would take all night:
> 
> mdadm -a --re-add /dev/md2 /dev/sde3
> mdadm -a --re-add /dev/md2 /dev/sdf3
> mdadm -a --re-add /dev/md3 /dev/sde5
> mdadm -a --re-add /dev/md3 /dev/sde5
> 
> When I woke up in the morning, everything was happy...until it crashed
> again yesterday. This time, I get a message: "/dev/md3 assembled from
> 4 drives - not enough to start the array while not clean - consider
> --force."
> 
> I can re-assemble /dev/md3 (sda5, sdb5, sdc5, sdd5, sde5 and sdf5) if
> I use -f, although all the other sets seem fine. I cannot "--re-add"
> the other partitions. 

What happens when you try to re-add those devices?
How about just "--add".  --re-add is only need for arrays without
metadata, in your case it should behave the same as --add.

NeilBrown
