From: "Ryan B. Lynch" <rlynch@strozllc.com>
Subject: Re: two-disk-failure question
Date: Wed, 22 Oct 2003 12:55:12 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F96B670.2020802@strozllc.com>
References: <200310172315.56815.maarten@vbvb.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310172315.56815.maarten@vbvb.nl>
To: maarten van den Berg <maarten@vbvb.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey Maarten,

Maarten van den Berg wrote:

>cables and such. So my obvious question is:  Is this step (mkraid --force 
>with one of the offline disks defined as failed-disk) destructive, or could I 
>(theoretically) experiment endlessly with the order in which the disks are 
>defined in /etc/raidtab before I decide to mount it read-write and raidhotadd 
>a fresh disk ?
>
I had to do this about a year ago, on account of a bad IDE controller, 
and was successful on the first try.  I recall from the HOWTO that the 
'mkraid --force' command IS destructive, and it WILL lose the array if 
you get it wrong.

My incident involved data which would have been a bear to restore from 
backup, so I didn't take any chances.  Prior to the 'mkraid --force' 
step, I labelled each physical disk with it's number in the array, and 
then copied each disk to an identical disk using the 'dd' command 
[somthing like 'dd if=/dev/sda of=/dev/sdb bs=8192' where /dev/sda is 
the original and /dev/sdb is a handy blank disk, repeated for each 
original disk in the array].  Of course, this required five extra hard 
disks, but I had them lying around anyway.  And that's the foolproof 
method.  If you're really paranoid (you don't have a backup of the 
failed array), you might want to also do an 'md5sum /dev/sdb; md5sum 
/dev/sda' and compare the two hash values to ensure that each copy is 
faithful--re-do the copy that doesn't pass the hash check.  Since you're 
juggling so many hard drives, make sure you label all the 
disks--scotch-taped sticky notes on the cover, with the array #s written 
in felt pen worked for me.

Then, you can run off and do whatever with the originals, and you'll 
always have something to go back to if you utterly wipe out your array 
while trying to restore it.  If that happens, you just take the 
clobbered disks, and re-do the 'dd' command to write the copy back to 
the originals.  Hash if necessary, and go to town again.  Repeat until 
you either successfully restore the array, or you swear off computers 
and enroll in florists' school.

Keep in mind that this can add a LOT of time to a restore operation.  
With Western Digital WD200 IDE disks (7200 RPM, 18.6 GB), I can move 
about 30-22 MB/sec (beginning-end) on direct disk-to-disk copies like 
this, with an average around 25 MB/sec.  That's ~1.5 GB/min, so you can 
estimate your own ETAs.  Hashing will take a similar amount of time if 
you use 'md5sum' on a reasonably fast machine (P4 1.8+).

-R

