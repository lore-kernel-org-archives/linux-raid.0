From: Mike Myers <mikesm559@yahoo.com>
Subject: Re: Need urgent help in fixing raid5 array
Date: Fri, 5 Dec 2008 16:18:55 -0800 (PST)
Message-ID: <447802.83994.qm@web30807.mail.mud.yahoo.com>
References: <936691.74609.qm@web30806.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Myers <mikesm559@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Anyone?  What am I missing here?

thx
mike




----- Original Message ----
From: Mike Myers <mikesm559@yahoo.com>
To: linux-raid@vger.kernel.org
Sent: Friday, December 5, 2008 9:03:22 AM
Subject: Need urgent help in fixing raid5 array

I have a problem with repairing a raid5 array I really need some help with.  I must be missing something here.

I have 2 raid5 arrays combined with LVM into a common logical volume and then running XFS on top of that.  Both arrays have 7 1 TB disks in them.  I moved a controller card around so that I could install a new Intel GB ethernet card in one of the PCI-E slots.  That went fine except one of the SATA cables got knocked loose so one of the disks in /dev/md2 wen't offline.  Linux booted fine, started the md2 with 6 elements in it and everything was fine with md2 in a degraded state.  I fixed the cable problem and hot added that drive to the array, but since it was now out of sync, md began a rebuild.  No problem.

Around 60% through the resync, smartd started reporting problems with one of the other drives in the array.  Then that drive ejected from the degraded array, caused the raid to stop and the LVm volume to go offline.  Ugh...

Ok, so it looks from the smart data that that disk had been having a lot of problems and was failing.  As it happens, I had a new 1 TB disk arrive the same day, and I pressed it to service here.  I used sfdisk -d olddisk | sfdisk newdisk to copy the partition table from the old drive to the new one, and then used ddrescue to copy the data from the old partition (/dev/sdo1) to the new one (/dev/sdp1). That worked pretty well, just 12kB couldn't be recovered.

So I remove the old disk,  re-add the new disk, and attempt to start the array with new (cloned) 1 Tb disk in the old disks stead.  Even though the UUID's, magic numbers and events fields are all the same, md thinks the cloned disk is a spare, and doesn't start the array.  What am I missing here?  Why doesn't it view it as the old disk as a member and just start it?

thx
mike


      
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



      
