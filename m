From: Steve Fairbairn <steve@fairbairn-family.com>
Subject: Re: Create software RAID from active partition
Date: Mon, 01 Sep 2008 13:45:14 +0100
Message-ID: <48BBE3DA.30402@fairbairn-family.com>
References: <c8ce53500809010532h5444a8cckcb1d2cb57d3dc281@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c8ce53500809010532h5444a8cckcb1d2cb57d3dc281@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Guyver <michael.guyver@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Guyver wrote:

> I've got a question about creating a RAID-1 array on a remote server -
> ie: if the operation fails, it's going to be very expensive. The
> server has two 200 GB drives and during a hurried re-install of CentOS
> 5.2 the creation of software RAID partitions was omitted. This means
> that the array would include the currently active partition on which
> the kernel is installed. So my first question is as to the feasibility
> of this operation, and its safety: any comments?
> 

That would imply that one of the disks is currently doing nothing, which 
would make it feasible as far as I can see.

> # pvdisplay
>   Found duplicate PV g7ZWtzNQcHx2PMQghP0NBHDXuYcaYqAt: using /dev/sdb2
> not /dev/sda2
> 

This would seem to say to me that it's using sdb for all data currently, 
but...

> 
> Can anyone point me to the way of finding out a file's physical
> location on disc so that I can verify this is the case? So, for
> example, I would like to check that my latest edit to ~/somefile.txt
> is in fact on /dev/sdb1 at location xyz and that can be verified by
> using dd to copy those bytes to a file in /tmp.
> 

I can't help you here as I never bother with LVM, so I've not idea how 
to work out which physical device the mounted LVM is on.

> Having started reading the docs related to creating a RAID device, it
> seems likely that the order of the listed devices is significant when
> the array is initialised. However, I haven't yet been able to confirm
> that were I to write
> 
> mdadm -C /dev/md0 --level raid1 --raid-disks 2 /dev/sdb1 /dev/sda1
> 
> that it would start to copy data from sdb1 to sda1 - or have I
> misunderstood the initialisation process?
>

Please accept my standard disclaimer of 'I'm no expert, and I may be 
wrong.'...

I don't believe you'd want to do this.  What I think you'd want to do 
instead is create a degraded RAID 1 array using just the currently 
unused disk, then install LVM and a filesystem on that array, then copy 
all your data across.

Make sure you install a boot loader in the boot block of the disk you've 
made part of the array, and do whatever else you can to ensure the 
system next boots off the new md device.

Reboot, and then ensure you really are using the md device for your 
mounted filesystems...

Once you are certain, add the now unused drive into your RAID 1 array, 
and the replication should start.

> These questions may not seem very well framed, but some initial
> guidance while I'm still reading into the problem would be
> appreciated.
> 

Others will be able to give you more specific answers.  I unfortunately 
don't have linux in front of me, so can't check out the required mdadm 
incantations.


Hope this helps a little,

Steve.
