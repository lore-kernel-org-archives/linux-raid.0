From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm help and howto for newbies?
Date: Sat, 20 Apr 2002 07:41:38 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15552.36626.935374.992494@notabene.cse.unsw.edu.au>
References: <1019248512.10455.1408.camel@ralph.plexio.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stephen Lee on  April 19
To: Stephen Lee <splee@plexio.com>
Cc: Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On  April 19, splee@plexio.com wrote:
> Hi,
> 
> Is there a Howto for mdadm newbies? The Software raid Howto is too old

I don't know of any.

> to reference mdadm. I have some questions on how to proceed:
> 
> 1. Do I need to mark my raid1 partitions with the type fd?

Only if you want to use autodetect.  I don't.

> 2. I tried:  
>    mdadm -C /dev/md0 --level raid1 --raid-disks 2 /dev/hda1 missing 
>    and got the message:
>    md: can not import hda1, has active inodes!
>    md: error, md_import_device() returned -16
>    Does this mean that the partitions to be added to /dev/md0 must be
>    unmounted?

Yes, definately.  Once a partition has beein included into an md
array, md *must* be the only thing accessing that partition, otherwise
confusion can result.

> 3. If #2 is yes then how do I convert my partitions to raid1? In using 
>    raidtools, I simply copied the live drive contents to a spare drive 
>    with "fd" type partitions and followed the instructions in the
>    Boot+Root+Raid+LILO Howto.

Support /dev/hda1 was your live boot drive, and /dev/hdc1 was second
partition that you eventually wanted to raid1 together with /dev/hda1.
Then
  1/ create a degraded raid1 using /dev/hdc1 only:
     mdadm -C /dev/md0 --level raid1 --raid-disks 2 missing /dev/hdc1
  2/ create a filesystem on /dev/md0 and mount it:
     mkfs /dev/md0
     mount /dev/md0 /mnt
  3/ copy everything from / to /mnt
      cp -ax / /mnt
    could do it.
  4/ modify /mnt/etc/fstab to think that / is on /dev/md0
  5/ reboot with a kernel-parameter of:
        md=0,/dev/hdc1 root=/dev/md0
  6/ If this all seems to work properly, then add /dev/hda1 to the
     raid1 array:
       mdadm /dev/md0 -a /dev/hda1
     and change the kernel-paramter line to
        md=0,/dev/hda1,/dev/hdc1 root=/dev/md0

> 4. Is it possible to boot root raid1 with mdadm and no autodetect?

See above.

NeilBrown
