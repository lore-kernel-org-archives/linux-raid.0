From: Neil Brown <neilb@suse.de>
Subject: Re: Data loss on MD RAID5 reshape?
Date: Tue, 16 Dec 2008 09:11:21 +1100
Message-ID: <18758.54793.5172.117590@notabene.brown>
References: <20081205222131.GD8219@newbie.thebellsplace.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bob Bell on Friday December 5
Sender: linux-raid-owner@vger.kernel.org
To: Bob Bell <b_linuxraid@thebellsplace.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday December 5, b_linuxraid@thebellsplace.com wrote:
> I've experienced apparent data loss, and hoping someone out there can 
> help rescue my data, or at least tell me what went wrong so that I don't 
> have a repeat event.  I first asked this question on linux-lvm, but the 
> folks there seemed to think it pertained more to RAID than to LVM.

I probably pertains to both.
However I suspect someone who knows a lot about LVM would be most
likely to be able to help you.

Presumably the LVM metadata at the start of the raid5 has been
corrupted someone.  Restoring that is needed, and an LVM expert would
be in the best position.

Of course it may not be possible, depending on the exact nature of the
corruption. 

If it were me, I would hunt around at the start of the raid5 too see
if anything looked recognisable.  To do that, you would need to know
what LVM metadata and filesystem metadata looked like, and that would
not be easy.

I wish I could help, but I really don't know the insides of LVM well
enough to try to stitch something like that together by remote control

NeilBrown


> 
> I was setting up a new server running Ubuntu's Hardy Heron release.  
> `uname -a` reports:
>   Linux sherwood 2.6.24-16-server #1 SMP Thu Apr 10 13:58:00 UTC 2008 i686 GNU/Linux
> 
> I initially created an md RAID5 device with only two components 
> (matching 320 GB SATA HDDs).  I created a single LVM Physical Volume 
> using the entirety of that md device (320 GB), and then created several 
> LVM Logical Volumes for different filesystems (all ext3).  This was done 
> using the Ubuntu installer.  After installing I used lvresize to 
> increase the size of a few of the Logical Volumes.  These filesystems 
> hold data that is not a critical part of the system (mail, music, video, 
> etc.), but still important to me.
> 
> I then copied data onto one of those filesystems (the original source of 
> the data is no longer available).  I then added a third drive to the md 
> device, which brought the total to 2 active devices and 1 spare device.  
> I then grew the number of devices to 3 and waited for the reshape to 
> finish (increasing the capacity to 640 GB).  I bumped the values in 
> /proc/sys/dev/raid/ so that I wouldn't have to wait as long.
> 
> Now that the reshaping has completed, LVM can't find the physical volume 
> on that device anymore.  I tried rebooting the system, but the problem 
> remained.  Checking /proc/mdstat shows that the md device is up and 
> healthy.  The pvdisplay command only shows my other Physical Volume (for 
> the IDE drives).  I found the pvck command and ran that on the md 
> device, and it states that there is no LVM label on the device.
> 
> It is my understanding that the steps I outlined should have worked.  
> I planned to follow them with pvresize, then lvresize, then umount, 
> resize2fs, and mount again.  I've seen this procedure outlined a few 
> different places, including at 
> http://gentoo-wiki.info/Resize_LVM2_on_RAID5.
> 
> Did I do something wrong?  Is there anyway to rescue my data?  If 
> there's no way of saving the data, I'd at least like to figure out what 
> happened in the first place.
> 
> Thank you.  Your thoughtfulness and help is appreciated.
> 
> -- 
> Bob Bell
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
