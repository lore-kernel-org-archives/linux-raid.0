From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Tue, 6 Feb 2018 21:03:12 +0100
Message-ID: <20180206200312.GA20708@metamorpher.de>
References: <20180206181416.amo6geclrvc6ylrf@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180206181416.amo6geclrvc6ylrf@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 06, 2018 at 10:14:16AM -0800, Marc MERLIN wrote:
> echo check > /sys/block/md7/md/sync_action 
> md7 : active raid5 sdf1[0] sdg1[5] sdd1[3] sdh1[2] sde1[1]
>       23441561600 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
>       [==>..................]  check = 10.5% (615972996/5860390400) finish=4822.1min speed=18125K/sec
>       bitmap: 3/44 pages [12KB], 65536KB chunk
> 
> My understanding is that eventually it will find the bad sectors that can't be read
> and rewrite new ones (block remapping) after reading the remaining 4 drives.

You can do selective area checks, with /sys/block/mdX/md/sync_{min,max}.

Documented here:

https://www.kernel.org/doc/html/latest/admin-guide/md.html#md-devices-in-sysfs

Also see if increasing the stripe cache size helps with speeds.

> Should I stick this data into a 512 byte file and write it back with dd in the right place?

Most hard drives have 4K sectors these days. Writing 512 byte into a bad 
physical 4K sector is probably not a good idea. So at minimum, write 4K 
(aligned). If in doubt, write more...

However, leaving it to the md check should be the much safer option. 
Easy to make mistakes when messing with drives directly.

> Does that sound like a good plan, or is there another better way to fix my issue?

mdadm --replace the drive entirely with a new one is not an option?

Then you could do a full badblocks write test on the removed/faulty drive 
and make a more informed decision as to whether it can be trusted at all.

Regards
Andreas Klauer
