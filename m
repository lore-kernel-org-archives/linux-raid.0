From: drtebi@drtebi.com
Subject: Re: RAID1 always resyncs at boot???
Date: Thu, 27 Nov 2003 15:29:41 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <hp1alh.rftuxt@mail.drtebi.com>
References: <hp0nmt.3pm23q@mail.drtebi.com> <16326.34106.78894.57151@notabene.cse.unsw.edu.au>
Reply-To: drtebi@drtebi.com
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16326.34106.78894.57151@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well,
no, I do a regular shutdown with shutdown -h now, or reboot for rebooting.
I have it working now however.
I think what was wrong is that I had my /etc/fstab like this:
# <fs>               <mountpoint>   <type>      <opts>            <dump/pass>
/dev/sda1            /boot          ext2        noauto,noatime    1 1
/dev/sda5            /              xfs         noatime           0 0
/dev/dsa2            none           swap        sw                0 0
/dev/md0             /raid          xfs         noatime           0 0
/dev/cdroms/cdrom0   /mnt/cdrom     iso9660     noauto,ro         0 0
proc                 /proc          proc        defaults          0 0
tmpfs                /dev/shm       tmpfs       defaults          0 0

I did not have the fschk option (the last one) set to 1 on /dev/md0. At least
someone advised me to do so, so I set it to 1, tried to reboot and it works
just fine now ;)
(here is the thread of this help:
http://forums.devshed.com/t101414/sd5d6d3f616a474180753071f3ce364ef.html )

I still would like to understand WHY this helped, could you explain?

Another question: How do I restart "from scratch", reformatting the drives
does not earase the persistent-superblock etc....

And last one: Now that the RAID is setup (which is not holding the OS, it's
purely used for storage), I would like to use another disk for the OS. So
after I install Linux on another disk, can I just mount the RAID afterwards?

Thanks!



