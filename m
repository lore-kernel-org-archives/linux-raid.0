From: Tim Small <tim@buttersideup.com>
Subject: Re: Q: RAID-1 w/2x160GB, ReiserFS, Debian "woody", homebrew 2.4.25
 kernel
Date: Wed, 04 Aug 2004 11:28:53 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4110BA65.60801@buttersideup.com>
References: <ceq7ij$vj7$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ceq7ij$vj7$1@sea.gmane.org>
To: Jens Benecke <jens@spamfreemail.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'll just deal with the MD solution, since it's a while since I played 
with LVM...

Jens Benecke wrote:

>How about RAIDing the root partition? If one drive fails will the other be
>able to boot via LILO? How about GRUB? Which do you prefer?
>
>  
>
Yes you can do this - see last post, I prefer Grub, see the thread with 
the subject "GRUB + RAID howto" in the page linked below - I suggest 
trying both methods stated there, and testing which one works for you...

http://www.linuxsa.org.au/mailing-list/2003-07/thread.html

>How about (/var)/tmp? I (suppose I'll) need it on both disks, does it make
>sense to mirror it as well?
>  
>
I would think so..

>Can I mirror the whole disk? Or do I need to mirror each partition
>seperately?
>  
>
Each partition.

>Does MD or LVM2 do hot sync, i.e. if one drive fails will I be able to stick
>in a replacement, and stop worrying? Or do I need to repartition the new
>disk exactly as the old one, before being able to sync?
>
>  
>
You will need to partition it, and use mdadm to add the new partitions 
to the array.  But you can simply do something like this:

dd if=/dev/hda of=/dev/hdc ; echo w | fdisk /dev/hdc

>How does LVM2/MD deal with failing harddisks, which is why I do the mirror
>at all? I've heard about MD not detecting read errors because the "other"
>disk was reading fine, and crashing completely when one disk was finally
>replaced because the data on the other disk was also corrupt. Is that still
>the current case?
>  
>
You need to arrange to read check the drive (you probably want to do 
this on single drive systems as well) I would advise using 
smartmontools, (e.g. from Sarge), with these lines like these in 
/etc/smartd.conf (also comment out the DEVICESCAN line):

/dev/hda -a -s L/../../6/01 -m root
/dev/hdc -a -s L/../../6/02 -m root

This way you stand a better chance of catching blocks which are going 
bad before they become unreadable - it will ask the drives to carry out 
an extended self test (e.g. surface scan etc.) at 1am/2am on Saturday.  
Note that this will work with SCSI disks, PATA disks, and SATA disks 
which use the old IDE driver, but not yet with SATA disks using libata 
(you could make do with a "dd if=/dev/sda of=/dev/null" in a cron job 
instead).

>The goal is to have as "stress free" a system as possible - i.e. with as
>little manual configuration, and in event of emergencies, as little work to
>do, as possible.
>
>  
>
On Debian, you should install the raidtools2 package, this will install 
a cron job which will email you on degraded array events (the smartd 
lines will email root on SMART errors as well) - but you should also 
install mdadm to use the new "mdadm" management tools.  I would advise 
using Sarge, instead of Woody, unless you have a good reason not too...

Tim.

