From: Stephen Lee <splee@plexio.com>
Subject: Re: Creating Raid10 with mdadm
Date: 12 Oct 2002 09:29:31 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1034440172.22477.259.camel@ralph.plexio.private>
References: <20021010190054.A89173B808@jaded.cynicism.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20021010190054.A89173B808@jaded.cynicism.com>
To: Derek Vadala <derek@cynicism.com>
Cc: Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 2002-10-10 at 12:00, Derek Vadala wrote:
> On 10 Oct 2002, Stephen Lee wrote:
> 
> > Can anyone point me to an example of how to create a raid10 with 4 scsi
> > drives using mdadm? I have created raid1 and raid5 using mdadm so it's a
> > matter of getting the md device naming and grouping correct. This is for
> > a Redhat7.3 box.
> 
> First create each of the mirrors:
> (dont forget to susbstitute the proper SCSI devices for your system)
> 
> mdadm -Cv /dev/md0 -l1 -n2 /dev/sda1 /dev/sdb1
> mdadm -Cv /dev/md1 -l1 -n2 /dev/sdc1 /dev/sdd1
> 
> Now create a RAID-0 that uses /dev/md0 and /dev/md1 as its component
> disks:
> 
> mdadm -Cv /dev/md2 -l0 -n2 /dev/md0 /dev/md1
> 
> So your RAID-10 is at /dev/md2 and it contains the mirror member arrays
> /dev/md0 and /dev/md1.
> 
> Don't forget that you need to start /dev/md0 and /dev/md1 before you can
> start /dev/md2.
>
Thanks Derek. Couple of questions.
First, do I specify the assembly of the devices in the kernel parameters
as follows (using Grub)?

kernel /vmlinuz ro md=0,/dev/sda1,/dev/sdb1 md=1,/dev/sdc1,/dev/sdd1 \
                   md=3,/dev/md0,/dev/md1 root=/dev/md3

Does the above line satisfy the requirement for md0 and md1 be started
before md3?

Second, could I do a non-raid install on /dev/sda first and then build
the raid10 array with /dev/sda failed and then adding it back in later?
I only have 4 drives.

Thanks again for your help,
Stephen


