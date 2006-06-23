From: Neil Brown <neilb@suse.de>
Subject: Re: Curious code in autostart_array
Date: Fri, 23 Jun 2006 14:46:13 +1000
Message-ID: <17563.29205.266098.447047@cse.unsw.edu.au>
References: <20060622210521.0aa68ec6.zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Pete Zaitcev on Thursday June 22
Sender: linux-raid-owner@vger.kernel.org
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-raid@vger.kernel.org, mingo@redhat.com, dledford@redhat.com
List-Id: linux-raid.ids

On Thursday June 22, zaitcev@redhat.com wrote:
> Hi, guys:
> 
> My copy of 2.6.17-rc5 has the following code in autostart_array():
> 		mdp_disk_t *desc = sb->disks + i;
> 		dev_t dev = MKDEV(desc->major, desc->minor);
> 
> 		if (!dev)
> 			continue;
> 		if (dev == startdev)
> 			continue;
> 		if (MAJOR(dev) != desc->major || MINOR(dev) != desc->minor)
> 			continue;
> 
> Under what conditions do you think the last if() statement can fire?
> What is its purpose? This looks like an attempt to detect bit clipping.
> But what exactly?

First, be aware that this code (which is only available from the
START_ARRAY ioctl) is scheduled to be removed from the kernel next
month.

Second, the code substantially predates my involvement in md, but I
suspect it is simple caution.  desc->major and desc->minor have been
read of the disk, so their values cannot be trusted.
They are both 32 bit and so could easily not be valid major/minor
numbers.  The test slightly reduces the number of silly thing that can
go wrong if the data is bad (though the fact that the superblock is
checksumed makes that fairly unlikely).
(or to put it another way: I don't know either :-)

NeilBrown
