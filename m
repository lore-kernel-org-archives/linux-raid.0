From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID1 always resyncs at boot???
Date: Fri, 28 Nov 2003 11:00:24 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16326.36888.900928.183987@notabene.cse.unsw.edu.au>
References: <hp0nmt.3pm23q@mail.drtebi.com>
	<16326.34106.78894.57151@notabene.cse.unsw.edu.au>
	<hp1alh.rftuxt@mail.drtebi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from drtebi@drtebi.com on Thursday November 27
To: drtebi@drtebi.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 27, drtebi@drtebi.com wrote:
> Well,
> no, I do a regular shutdown with shutdown -h now, or reboot for rebooting.
> I have it working now however.
> I think what was wrong is that I had my /etc/fstab like this:
> # <fs>               <mountpoint>   <type>      <opts>            <dump/pass>
> /dev/sda1            /boot          ext2        noauto,noatime    1 1
> /dev/sda5            /              xfs         noatime           0 0
> /dev/dsa2            none           swap        sw                0 0
> /dev/md0             /raid          xfs         noatime           0 0
> /dev/cdroms/cdrom0   /mnt/cdrom     iso9660     noauto,ro         0 0
> proc                 /proc          proc        defaults          0 0
> tmpfs                /dev/shm       tmpfs       defaults          0 0
> 
> I did not have the fschk option (the last one) set to 1 on /dev/md0. At least
> someone advised me to do so, so I set it to 1, tried to reboot and it works
> just fine now ;)
> (here is the thread of this help:
> http://forums.devshed.com/t101414/sd5d6d3f616a474180753071f3ce364ef.html )
> 
> I still would like to understand WHY this helped, could you explain?

There is no reason that this change would help.  I am quite sure it is
pure coincidence that is seems to make a difference.

> 
> Another question: How do I restart "from scratch", reformatting the drives
> does not earase the persistent-superblock etc....

Try the "--zero-superblock" option to mdadm (check the man page for
correct spelling).

> 
> And last one: Now that the RAID is setup (which is not holding the OS, it's
> purely used for storage), I would like to use another disk for the OS. So
> after I install Linux on another disk, can I just mount the RAID
> afterwards?

I suspect so, though without precise details I cannot be sure of
exactly what you are asking.

NeilBrown
