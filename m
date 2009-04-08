From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm udev rules change
Date: Wed, 8 Apr 2009 17:31:10 +1000
Message-ID: <18908.21182.706667.310243@notabene.brown>
References: <3B6F676A-5ADD-4741-8269-D7D655C4E21E@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Monday April 6
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: LinuxRaid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday April 6, dledford@redhat.com wrote:
> I'm not attaching a patch for this because it's so simple.  Long story  
> short, watching both add and change events in udev rules is bad for md  
> devices.  Specifically, the kernel will generate a change event on  
> things like array stop, and on things like fdisk close.  In the case  
> of array stop, it can result in the array being assembled again  
> immediately.  In the case of fdisk close, the situation is worse.   
> Let's say you stop all the md devices on some block device in order to  
> repartition.  You run fdisk, change the partition table, then issue a  
> write of the table.  The write of the table triggers the change event  
> *before* the kernel updates the partition table in memory for the  
> block device, causing udev to rerun the incremental rules on the old  
> partition table and restart all the arrays you just stopped with the  
> old partition table layout, at which point the kernel is unable to  
> reread the partition table.  So, once you've enable incremental  
> assembly, it becomes apparent that what we really want is to only  
> start devices on add, not on add|change.

So you aren't really talking about events on md devices, but rather on
events that might become components of md devices - correct?
So in udev-md-raid.rules we currently have

....
ACTION!="add|change", GOTO="md_end"

# import data from a raid member and activate it
#ENV{ID_FS_TYPE}=="linux_raid_member", IMPORT{program}="/sbin/mdadm --examine --export $tempnode", RUN+="/sbin/mdadm --incremental $env{DEVNAME}"
# import data from a raid set
KERNEL!="md*", GOTO="md_end"
......

And you are saying that if we uncomment the "#ENV{...." line, then we
only want it to fire on add devices.  So something like:

....
 ACTION!="add|change", GOTO="md_end"
+ACTION=="change", GOTO="no_incr"
 
 # import data from a raid member and activate it
 #ENV{ID_FS_TYPE}=="linux_raid_member", IMPORT{program}="/sbin/mdadm --examine --export $tempnode", RUN+="/sbin/mdadm --incremental $env{DEVNAME}"
 # import data from a raid set
+LABEL="no_incr"
 KERNEL!="md*", GOTO="md_end"
......

Is that correct?

Your explanation certainly seems reasonable.

Thanks.
NeilBrown
