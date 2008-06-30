From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Whole drives or Only partitions for mdadm software RAIDs?
Date: Mon, 30 Jun 2008 15:50:25 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0806301549580.4791@p34.internal.lan>
References: <8CAA8FD62E1D4D0-594-672@webmail-nb10.sysops.aol.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8CAA8FD62E1D4D0-594-672@webmail-nb10.sysops.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 30 Jun 2008, thomas62186218@aol.com wrote:

> Hi all,
>
> I have a simple question:
>
> Is there any problem using the full hard drive (/dev/sdb, /dev/sdc, etc) as 
> opposed to partitions (/dev/sdb1, /dev/sdc1, etc) when creating software 
> RAIDs? I'd rather commit the full device to the RAID since I am certain I 
> won't use it for anything else, and I am scripting this so I don't want to 
> have to fdisk every drive before creating a RAID...that would take far too 
> much time. Most mdadm documentation always refers to partitions rather than 
> full devices, so I wanted to make sure it was indeed OK to use full devices.
>
> Please let me know. Thank you all!
>
> Thanks!
> Thomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Best to use partitions, so if you over-write the MBR  of the drive it 
won't mess up the RAID (e.g., run LILO on a raid volume => oops! but if 
its a partition, no problems)..

Justin.
