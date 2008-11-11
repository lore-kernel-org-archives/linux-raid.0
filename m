From: Mike Myers <mikesm559@yahoo.com>
Subject: Swapping a disk in a raid5 array
Date: Tue, 11 Nov 2008 10:33:11 -0800 (PST)
Message-ID: <994670.29528.qm@web30807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi.  I have a 6 members raid5 set using software raid under linux.  The array is comprised of 5 1 TB disks and a member that is a raid0 array of 2 500 MB disks.  Use of the nested raid helped me do a transition of the system to this new array since I didn't have enough 1 TB drives.  It has been working very reliably, but performance seems a little lackluster, and I have 2 new 1 TB drives of the same make and model that I would like to substitute.

I have always been taught that if you wanted to replace a disk in a raid5 array, you add the new disk as a member, and the fail the old disk and then remove it, which will cause the array to rebuild around the new disk.  

But since all of the members are healthy, I was wondering if there was a way to replace the disk so I would not be running without redundancy during the rebuild process.  That is, is there a way to swap the disk without failing the old member, but to basically have mdadm shadow the disk about to be replaced onto the new disk and then when it's in sync to remove the old disk.  This seems like a much safer way of doing a swap, and since it takes about 12 hrs to do a resync, it is not a small amount of time where bad things could happen.  I haven't seen anything that leads me to believe there is a way to do this, but thought I would ask here anyway before kicking off the process.

Also, since I have two new disks, I also want to grow the array by 1 TB (1 disk swaps out the old 2 member raid0 member of the raid5 array, and the new disk would expand the array) if there is a way to do the raid5 set rebuild and the grow at the same time?  Since they both take a very long time to complete, and both are reading in the full contents of the all the members of the array, I was hoping to avoid this being done twice and save a lot of time.  :-)

Thanks,
Mike


      
