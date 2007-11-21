From: Mike Myers <mikesm559@yahoo.com>
Subject: Re: Chnaging partition types of RAID array members
Date: Tue, 20 Nov 2007 19:09:19 -0800 (PST)
Message-ID: <534503.19493.qm@web30805.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks.  The issue turned out to be that the device mapper was running and immediately grabbed the disk device when I changed it's partition type.  For others out there that may run into the same problem, I did a dmsetup -C remove <device>.  Then I could add it to the array just fine.

The reshaping of the array worked fine, thought it took about 15 hrs to add 1.5TB of new disk to an existing 2.5 TB array.  Everything was done with the filesystem live though, and worked great.  Neil, your work with mdadm and the associated kernel work is very much appreciated.

I am moving the data from another 1.2 TB array (to the array that I just added 1.5TB to) to make room in the SATA hotswap chasis for 4 1TB drives that will form a new 3 TB RAID5 array.  Before I can take the old array out of service though, I have to move the data in that pv to the other pv I just grew.  

So I am doing a pvmove that is taking forever!  It's been running for about 12 hours now, and only 30% done, and this is just for 1.2TB's of data.  Why is it taking so long?  

Is there anything I can do to speed things up?  Right now, the disks are set for a lot of readahead (16384) because this server primary stores media.  Is pvmove doing very small random reads?  If so, maybe I should drop the readahead down to defaults and change the stripe cache size down?  The tuning of the disks really improved performance in normal operation, but it just seems like the pvmove should be going faster than this.

Any ideas?  

PS This is all under opensuse 10.3.

Thanks,
Mike


----- Original Message ----
From: Neil Brown <neilb@suse.de>
To: Mike Myers <mikesm559@yahoo.com>
Cc: linux-raid@vger.kernel.org
Sent: Thursday, November 15, 2007 8:28:07 PM
Subject: Re: Chnaging partition types of RAID array members


On Thursday November 15, mikesm559@yahoo.com wrote:
> 
> Hi.  I have two RAID5 arrays on an opensuse 10.3 system.  They are
 used
>  together in a large LVM volume that contains a lot of data I'd
 rather
>  not have to try and backup/recreate.
> 
> md1 comes up fine and is detected by the OS on boot and assembled
>  automatically.  md0 however, doesn't, and needs to be brought up
 manually,
>  followed by a manual start of lvm.  This is a real pain of course.
  The
>  issue I think is that md0 was created through EVMS, which I have
>  stopped using some time ago since it's support seems to have been
 deprecated.
>   EVMS created the array fine, but using partitions that were not
 0xFD
>  (Linux RAID), but rather 0x83 (linux native).  Since stopping the
 use
>  of EVMS on boot, the array has not come up automatically.
> 
> I have tried failing one of the array members, recreating the
 partition
>  as linux RAID though the yast partition manager, and then trying to
>  add it, but I get a "mdadm: Cannot open /dev/sdb1: Device or
 resource
>  busy" error.  If the partition is type 0x83 (linux native) and
 formatted
>  with a filesystem first, then re-adding it is no problem at all, and
 the array rebuilds
>  fine.

You don't need to fail a device just to change the partition type.
Just use "cfdisk" to change all the partition types to 'fd', then
reboot and see what happens.

NeilBrown

> 
> In googling the topic I can't seem to find out why I get the error
>  message, and how to fix this.  I'd really like to get this problem
>  resolved.  Does anyone out there know how to fix this, so I can get
 partitions
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
>      
 ____________________________________________________________________________________
> Never miss a thing.  Make Yahoo your home page. 
> http://www.yahoo.com/r/hs
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-raid"
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html





      ____________________________________________________________________________________
Get easy, one-click access to your favorites. 
Make Yahoo! your homepage.
http://www.yahoo.com/r/hs 
