From: "David Lethe" <david@santools.com>
Subject: Re: status of raid 4/5 disk reduce
Date: Fri, 12 Dec 2008 9:38:00 -0600
Message-ID: <0b1d01c95c6f$c1fb5606$0501a8c0@exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Brancato <mike@mikebrancato.com>, Alex Lilley <alex@redwax.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



-----Original Message-----

From:  "Michael Brancato" <mike@mikebrancato.com>
Subj:  Re: status of raid 4/5 disk reduce
Date:  Wed Dec 10, 2008 6:07 pm
Size:  3K
To:  "Alex Lilley" <alex@redwax.co.uk>
cc:  "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>

 
> There is the very obvious use to reduce the number of drives but 
> ultimately have a larger array if the drives are all larger. And there 
> should be no issue with file system/lvm resizing as these can generally 
> grow on-line anyway. 
>  
> I appreciate that shrinking the size of the array and doing so onto less 
> disks is both an unlikely requirement and fraught with danger.   Growing 
> the size of the array but to less disks is very useful indeed, which is 
> what I was getting at. 
 
Hardware limitations is a good use case.  When I say reduce, I mean  
--grow -nX and not necessarily reducing the size of the array in the end. 
 
>>>> This is a lot to ask for in terms of development, and creates extreme 
>>>> risk of data loss. 
>>>> First, you degrade /dev/md0, so any bad blocks or drive failures will 
>>>> cause catastrophic 
>>>> data loss, unless /dev/disk4 is used for mirroring in the interim. 
 
This is a standard fact of RAID45.  Any RAID45 with a failed drive is  
subject to these same concerns.  Isn't this true today with grow if  
replacing a 4x100GB array with 4x200GB by replacing one drive at a time? 
 
>>>> Secondly, by removing that disk (for sake of argument, say each disk is 
>>>> 1TB. You go from 3TB usable data 
>>>> to 2TB.  Most likely, you need to resize the file system in place so it 
>>>> fits into 2TB.  You're probably booted 
>>>> onto md0 also, which makes it difficult.  Resizing a hot filesystem 
>>>> without scratch space??  If your file system 
>>>> can't be dynamically reduced, then no point worrying about md raid. 
 
There are a lot of assumptions here about how the array is used,  
filesystem support, etc.  I'm not saying that in every situation this is  
ideal.  There are many situations where md0 is not the boot device, md0  
is not the device to be contracted, and the filesystem supports either  
online or offline resizing.  Concerns about filesystem expansion or  
contraction (online or not) and array shrinking are mutually exclusive  
of one another and shrinking the size of the array is already possible. 
 
Neil Brown has previously responded to a comment on the topic at  
http://neil.brown.name/blog/20050727143147 in regards to a --shrink option. 
 
Here are a few use cases: 
 
Hardware limitations - Replacing 4x120GB size drives with 3x500GB  
drives.  This would involve replacing each 120GB disk with a 500GB one  
at a time and rebuilding each before reshaping the array to 3 drives and  
growing to use all space on the new drives.  This is especially useful  
on a system which cannot increase the number if drives it has (4 max),  
only capacity. 
 
Drive failure - A developer, home user or SMB has a drive failure in an  
array.  Due to money, time, shipping delays, etc, the user cannot  
replace the drive immediately and the drive is in a degraded state.  The  
user shrinks the filesystem by 1 drive amount and shrinks the array to  
return to a optimal state in the array.  The array would return to a  
protected state in hours not days if waiting on a drive. 
 
Flexibility - A user wishes to free a disk in an array which is  
oversized to use that disk elsewhere. 
 
I hope this give a better understanding of the usefulness of reducing  
the amount of disks in a RAID45 array. 
-- 
Mike Brancato, CISSP 
-- 
To unsubscribe from this list: send the line "unsubscribe linux-raid" in 
the body of a message to majordomo@vger.kernel.org 
More majordomo info at  http://vger.kernel.org/majordomo-info.html 
 
statistically speaking, if you are in a degraded mode, the Worst thing to do would be a resize.  It would take 3x -14X longer then a rebuild as every block of every n drive will have to be read, and you will have multiple writes to all n-1 disks. Do the math.
The nature of the I/O means you won't get a lot of help from cache either.

If you are degraded, last thing you want to do is pound surviving drives this way.  An experienced admin would spend the time doing an incremental backup, or at least turn off the computer if they didn't have a spare disk.  Granted there are some usable scenarios for resizing, but doing so with degraded md is just not a smart idea.   
