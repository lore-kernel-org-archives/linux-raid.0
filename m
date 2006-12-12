From: dean gaudet <dean@arctic.org>
Subject: Re: Shrinking a RAID1--superblock problems
Date: Tue, 12 Dec 2006 10:18:47 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0612121005010.28457@twinlark.arctic.org>
References: <a45f4c9c0612120953k1d527734u921a5ce4db3db43f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a45f4c9c0612120953k1d527734u921a5ce4db3db43f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Terhorst <terhorst@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 12 Dec 2006, Jonathan Terhorst wrote:

> I need to shrink a RAID1 array and am having trouble with the
> persistent superblock; namely, mdadm --grow doesn't seem to relocate
> it. If I downsize the array and then shrink the corresponding
> partitions, the array fails since the superblock (which is normally
> located near the end of the device) now lays outside of the
> partitions. Is there any easier way to deal with this than digging
> into the mdadm source, manually calculating the superblock offset and
> dd'ing it to the right spot?

i'd think it'd be easier to recreate the array using --assume-clean after 
the shrink.  for raid1 it's extra easy because you don't need to get the 
disk ordering correct.

in fact with raid1 you don't even need to use mdadm --grow... you could do 
something like the following (assuming you've already shrunk the 
filesystem):

mdadm --stop /dev/md0
mdadm --zero-superblock /dev/sda1
mdadm --zero-superblock /dev/sdb1
fdisk /dev/sda  ... shrink partition
fdisk /dev/sdb  ... shrink partition
mdadm --create --assume-clean --level=1 -n2 /dev/md0 /dev/sd[ab]1

heck that same technique works for raid0/4/5/6 and raid10 "near" and 
"offset" layouts as well, doesn't it?  raid10 "far" layout definitely 
needs blocks rearranged to shrink.  in these other modes you'd need to be 
careful about recreating the array with the correct ordering of disks.

the zero-superblock step is an important defense against future problems 
with "assemble every array i find"-types of initrds that are unfortunately 
becomming common (i.e. debian and ubuntu).

-dean
