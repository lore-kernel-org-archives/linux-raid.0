From: Neil Brown <neilb@suse.de>
Subject: Re: raid-0 to raid-5 ?
Date: Wed, 1 Aug 2007 06:35:25 +1000
Message-ID: <18095.40205.999832.811532@notabene.brown>
References: <46AF2690.3000802@bigfoot.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from DrYak on Tuesday July 31
Sender: linux-raid-owner@vger.kernel.org
To: DrYak <blackkitty@bigfoot.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday July 31, blackkitty@bigfoot.com wrote:
> 
> II. *MDADM --GROW*
> - The current total of critical data happen to fit within 300GB.
> What do you think if I :
> - copy all the critical data to the newer 320GB drive.
> - create a new RAID-5 set with the original 300GB drives (the set will
> have somewhere around 300GB free, I think)
> - LVM partition of the raid set
> - copy the data back from the 320GB drive
> - make a 300GB on the new drive, and add it to the RAID as a third drive
> in the set using the new --GROW option of MDADM
> Is it possible ? Will LVM correctly survive being on a device that
> suddenly increases in size ?

This would probably work, but I'm not sure why you want to involve
LVM.

Other options:

1/ Just make the array into a raid4.  This has slightly poorer
random-write performance than raid5 but may still suit your needs.
If you want to try this:
  1/ Keep a safe record of the current configuration:
        mdadm -Es > /file/on/some/safe/storage
     you probably wont need this, but it is always best to be safe
 
  2/ Create a raid4 using the two drives.  Use exactly the same
     layout.  This only works if they are currently exactly the same
     size (rounded to 64K).
     Supposing they are 'sda1' and 'sdb1', 
        mdadm -C /dev/md0 -l4 -n3 -c CHUNKSIZE  /dev/sda1 /dev/sdb1 missing
     Note that 'missing' must be last.  The last drive of a RAID4 is
     the parity drive, and that is currently missing.

   3/ Check that you can still access your data (there is no risk that
     it is corrupt, but if you got the chunksize wrong, it may not be
     visible).  If not, review the current config and the old stored
     config and figure out what went wrong. Ask for help if needed.

   4/ If all is well, add the new drive as the parity drive
           mdadm /dev/md0 --add /dev/sdc1

all done.

2/ If you decide that you really want raid5, not raid4, then:

   1/ copy the important data onto a new filesystem on the new drive.
   2/ double check that you really have all the files that you want,
      as you will very soon destroy the other copy.
   3/ create a degraded array with the first two drives:
           mdadm -C /dev/md0 -l5 -n3 /dev/sda1 /dev/sdb1 missing

   4/ create a filesystem on /dev/md0.  This step will destroy old
       data.
   5/ copy the data from the new drive back on to the new 600GB
       filesystem.
   6/ Make sure the new copy is really good, as you are about to
       destroy the copy you made
   7/ Add the third drive to the raid5:
        mdadm /dev/md0 -a /dev/sdc1

all done.

As you can see, there is no need to grow the array at any step if you
take either of these approaches.

I hope that one day you will be able to use mdadm to turn a raid0 into
a degraded raid4, or to convert a raid4 to raid5 or raid5 to raid6,
but that hasn't happened yet...

NeilBrown

