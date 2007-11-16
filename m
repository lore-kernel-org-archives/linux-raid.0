From: Neil Brown <neilb@suse.de>
Subject: Re: Chnaging partition types of RAID array members
Date: Fri, 16 Nov 2007 15:28:07 +1100
Message-ID: <18237.7255.655518.23158@notabene.brown>
References: <433451.11399.qm@web30809.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Myers on Thursday November 15
Sender: linux-raid-owner@vger.kernel.org
To: Mike Myers <mikesm559@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 15, mikesm559@yahoo.com wrote:
> 
> Hi.  I have two RAID5 arrays on an opensuse 10.3 system.  They are used
>  together in a large LVM volume that contains a lot of data I'd rather
>  not have to try and backup/recreate.
> 
> md1 comes up fine and is detected by the OS on boot and assembled
>  automatically.  md0 however, doesn't, and needs to be brought up manually,
>  followed by a manual start of lvm.  This is a real pain of course.  The
>  issue I think is that md0 was created through EVMS, which I have
>  stopped using some time ago since it's support seems to have been deprecated.
>   EVMS created the array fine, but using partitions that were not 0xFD
>  (Linux RAID), but rather 0x83 (linux native).  Since stopping the use
>  of EVMS on boot, the array has not come up automatically.
> 
> I have tried failing one of the array members, recreating the partition
>  as linux RAID though the yast partition manager, and then trying to
>  add it, but I get a "mdadm: Cannot open /dev/sdb1: Device or resource
>  busy" error.  If the partition is type 0x83 (linux native) and formatted
>  with a filesystem first, then re-adding it is no problem at all, and the array rebuilds
>  fine.

You don't need to fail a device just to change the partition type.
Just use "cfdisk" to change all the partition types to 'fd', then
reboot and see what happens.

NeilBrown

> 
> In googling the topic I can't seem to find out why I get the error
>  message, and how to fix this.  I'd really like to get this problem
>  resolved.  Does anyone out there know how to fix this, so I can get partitions
>  correctly flagged as Linux RAID and the array autodetected at start?
> 
> Sorry if I missed something obvious.
> 
> Thanks,
> Mike
> 
> 
> 
> 
> 
> 
>       ____________________________________________________________________________________
> Never miss a thing.  Make Yahoo your home page. 
> http://www.yahoo.com/r/hs
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
