From: Louis-David Mitterrand <vindex@apartia.org>
Subject: recovering after a /dev/sda failure on raid1
Date: Thu, 1 Aug 2002 16:49:22 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020801144922.GA5284@apartia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Hi,

I have a root raid1 partition on /dev/sda1 & /dev/sdb1 (swap on
/dev/sda2 & /dev/sdb2). The server boots directly from the raid
partition. 

Now /dev/sda1 and /dev/sda2 have both failed and been removed from the
array and I am getting ready to replace the disk tonight.

What is the best way to proceed to minimize downtime?

My concern is that if I power down and replace /dev/sda the machine
won't be able to reboot without a rescue CD (lilo.conf has root=/dev/md0
and boot=/dev/md0) or will it? 

When the bios (Dell Poweredge 1500) will try /dev/sda's mbr and fail,
will it then automatically try /dev/sdb?

Or should I swap /dev/sdb on the scsi ribbon to have it take the first
place and thus become /dev/sda or will this just confuse the kernel
raid driver? (the letter on scsi drives is dependent on their place on
the ribbon cable, isn't it?)

Alternatively I was thinking of booting with a rescue CD (after
replacing /dev/sda) with the "root=/dev/md0", creating my partitions,
running lilo and rebooting into production for final reconstruction.
Would that be the safest bet?

Thanks in advance for your insight, cheers,

-- 
vindex@apartia.org 
