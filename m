From: "Sean Kormilo" <skormilo@nortelnetworks.com>
Subject: Re: Expanding size of existing raid1 md device
Date: 24 Apr 2003 16:47:07 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1051217226.2856.77.camel@pcary03q.ca.nortel.com>
References: <1051210082.2852.65.camel@pcary03q.ca.nortel.com>
	 <05bf01c30a93$5cd3a3b0$f6de11cc@black>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <05bf01c30a93$5cd3a3b0$f6de11cc@black>
To: Mike Black <mblack@csi-inc.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mike,

One thing I forgot to mention is that I want to be able to do this
without taking the system down at all.

I'm not sure I quite understand the process... I'd already have an
existing /dev/md0 and /dev/md1. Is "mdadm --create" supposed to allow me
to basically re-create the array? When I try this I get the following.
In this case, I removed /dev/sdb2 from /dev/md1 prior to attempting the
re-creation of the array. If I try to do it with both disks already
there I get the same error:

/usr/share/scsirastools/mdadm --create /dev/md1 -l1 -n2 /dev/sda2 missing
mdadm: /dev/sda2 appear to be part of a raid array:
    level=1 devices=2 ctime=Thu Apr 24 07:23:43 2003
Continue creating array? y
mdadm: SET_ARRAY_INFO failed for /dev/md1: File exists

Sean.

> I've done this with a single partition but it should work for multiple also.
> 
> Sounds like you already partioned the new 36G correctly.
> Before you insert the new 36G disk you need to re-create the raid array and resize the file system:
> Let's assume you've already sync'd hda to the 36G hdc and replaced hda with a brand-new 36G
> mdadm --create /dev/md0 -l1 -n2 /dev/hdc1 missing
> resize2fs -p -f /dev/md0
> e2fsck -C 0 /dev/md0
> mdadm --add /dev/md0 /dev/hda1
> 
> And repeat for md1
> 
> ----- Original Message ----- 
> From: "Sean Kormilo" <skormilo@nortelnetworks.com>
> To: "linux-raid" <linux-raid@vger.kernel.org>
> Sent: Thursday, April 24, 2003 2:48 PM
> Subject: Expanding size of existing raid1 md device
> 
> 
> > Hi,
> > 
> > I'm wondering if there is any way to do the following...
> > 
> > Assume I've got a system with 2 18GB disks. Each disk has 2 partitons
> > which are then setup as mirrored md devices.
> > /dev/md0 uses small 100MB partitions on each drive
> > /dev/md1 uses the rest of each disk (ie: ~17.9GB)
> > 
> > I'd like to be able to upgrade the system to use 36GB disks, such that
> > the /dev/md1 partition expands to take up the rest of the additional
> > space provided by the 36GB disk.
> > 
> > So, the process might look something like:
> > - fail and remove the partition for both md arrays
> > - remove 1 of the 18GB disks
> > - insert new 36GB disk
> > - partition 36GB disk with 100MB partition for /dev/md0
> > - partition 36GB disk with 35.9GB partition for /dev/md1
> > - hotadd the 36GB disk partitions so that it syncs with 18GB disk
> > - wait for sync to complete
> > - fail and remove the partitions on both md arrays on the 18GB disk
> > - remove the 18GB disk
> > - insert new 36GB disk
> > - partition 36GB disk with 100MB partition for /dev/md0
> > - partition 36GB disk with 35.9GB partition for /dev/md1
> > - hotadd the 36GB disk partitions so that it syncs with the other 36GB
> > disk
> > 
> > Having tried this, it works except that /dev/md1 does not make use of
> > the additional space provided by the 36GB disks even though the
> > partitions on both disks are larger. It appears to me that it is using
> > the value from the superblock when the array was created (which makes
> > sense).
> > 
> > Is there some way to force the md driver to expand to use the maximum
> > size available based on the disks/partitions in the array? Perhaps from
> > mdadm? Or is some kind of patch to the kernel required to make this
> > work? If so, any pointers as to where I'd look?
> > 
> > Thanks!
> > 
> > Sean.
> > 
> > 
> > 
> > 
> > -- 
> > 
> > Sean C. Kormilo, STORM Software Architect, Nortel Networks
> >               email: skormilo@nortelnetworks.com
> >   
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 

Sean C. Kormilo, STORM Software Architect, Nortel Networks
              email: skormilo@nortelnetworks.com
  

