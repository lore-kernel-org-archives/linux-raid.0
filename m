From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: recovering after a /dev/sda failure on raid1
Date: Sat, 3 Aug 2002 07:26:29 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15690.63749.164322.929689@notabene.cse.unsw.edu.au>
References: <20020801144922.GA5284@apartia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Louis-David Mitterrand on Thursday August 1
To: Louis-David Mitterrand <vindex@apartia.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday August 1, vindex@apartia.org wrote:
> 
> 
> Hi,
> 
> I have a root raid1 partition on /dev/sda1 & /dev/sdb1 (swap on
> /dev/sda2 & /dev/sdb2). The server boots directly from the raid
> partition. 
> 
> Now /dev/sda1 and /dev/sda2 have both failed and been removed from the
> array and I am getting ready to replace the disk tonight.

Lucky you :-)

> 
> What is the best way to proceed to minimize downtime?
> 
> My concern is that if I power down and replace /dev/sda the machine
> won't be able to reboot without a rescue CD (lilo.conf has root=/dev/md0
> and boot=/dev/md0) or will it? 
> 
> When the bios (Dell Poweredge 1500) will try /dev/sda's mbr and fail,
> will it then automatically try /dev/sdb?

With most bioses I have seen you can explicitly tell it which device
to boot from.  But cannot say for-sure about Dell Poweredge.

> 
> Or should I swap /dev/sdb on the scsi ribbon to have it take the first
> place and thus become /dev/sda or will this just confuse the kernel
> raid driver? (the letter on scsi drives is dependent on their place on
> the ribbon cable, isn't it?)

It isn't the position on the ribbon cable.  It is the position in the
scsi device number ordering.  If  you make sure the new drive has a
larger number than the old drive, the old drive will appear as sda.

> 
> Alternatively I was thinking of booting with a rescue CD (after
> replacing /dev/sda) with the "root=/dev/md0", creating my partitions,
> running lilo and rebooting into production for final reconstruction.
> Would that be the safest bet?

This sounds like the best bet to me.  You do have to boot twice, but
if you try the other, less well understood (by you atleast) approach,
there is an even chance you will need to reboot a couple of times
anyway.

NeilBrown


> 
> Thanks in advance for your insight, cheers,
> 
> -- 
> vindex@apartia.org 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
