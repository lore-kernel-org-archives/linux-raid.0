From: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Subject: Re: How many RAID devices can you define?
Date: Fri, 30 Dec 2005 17:21:56 +0800
Message-ID: <dp2u7h$mhu$1@sea.gmane.org>
References: <loom.20051228T152300-30@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20051228T152300-30@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I did a /dev/MAKEDEV md and it seemed to create lots of /dev/md* devices :

/dev/md0   /dev/md17  /dev/md25  /dev/md5     /dev/mdsp13  /dev/mdsp7
/dev/md1   /dev/md18  /dev/md26  /dev/md6     /dev/mdsp14  /dev/mdsp8
/dev/md10  /dev/md19  /dev/md27  /dev/md7     /dev/mdsp15  /dev/mdsp9
/dev/md11  /dev/md2   /dev/md28  /dev/md8     /dev/mdsp16  /dev/mdspstat
/dev/md12  /dev/md20  /dev/md29  /dev/md9     /dev/mdsp2
/dev/md13  /dev/md21  /dev/md3   /dev/mdsp1   /dev/mdsp3
/dev/md14  /dev/md22  /dev/md30  /dev/mdsp10  /dev/mdsp4
/dev/md15  /dev/md23  /dev/md31  /dev/mdsp11  /dev/mdsp5
/dev/md16  /dev/md24  /dev/md4   /dev/mdsp12  /dev/mdsp6

/dev/md0 was already defined (I'm using it), but I don't have a /dev/md/ 
directory....perhaps that is a difference between Gentoo and FC4 (what 
I'm using)...

hth

Max.

Robert Washburne wrote:
> I am setting up a file server using Gentoo 2005.1, kernel 2.6.14-r2
> 
> The installed system creates eight RAID devices - /dev/md[0-7], /dev/md/[0-7]
> 
> I wish to create nine RAIDs, so I used "mknod /dev/md/8 b 9 8" to create another
> device (and its associated link, /dev/md8).
> 
> The hardware consists of a 650 MHz AMD Duron with 1 GB ram.  Four WD 250 GB IDE
> drives are connected to the four IDE busses of two Promise Technologies IDE
> ATA100 controlers.  The drives are all partitioned the same using partitions
> [1-3, 5-12].
> 
> I used raidtools to define and create the RAIDs.
> 
> The first eight devices created and synced with no problem (seven RAID5 and one
> RAID0).  But when I created the ninth RAID5, it got about 30% through the sync
> and then the system hung.  Keyboard was dead.  I had to power-cycle.
> 
> The the system came back up, it continued to sync, but hung again after a minute
> or two.
> 
> Is there a hard limit of only eight RAID devices?
> 
> If so, can this limit be readily increased?
> 
> If need be, I can repartition my drives and reduce the RAIDs to only eight, but
> I would prefer to keep the nine, if possible.
> 
> Thanks in advance!
> 
> Bob W.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

