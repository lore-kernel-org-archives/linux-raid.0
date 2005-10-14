From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: All disks in the array suddenly non-fresh??
Date: Fri, 14 Oct 2005 12:40:40 -0500
Message-ID: <1129311640.2609.27.camel@miketran.austin.ibm.com>
References: <434F04EB.5070308@ca.istop.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <434F04EB.5070308@ca.istop.com>
Sender: linux-raid-owner@vger.kernel.org
To: Boris Shingarov <shingarov@ca.istop.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Boris,

This kind of problem is a result of unclean shutdown.  There are 2
problems here...

On Thu, 2005-10-13 at 21:07 -0400, Boris Shingarov wrote:
> Hi,
> 
> I'm very new to raid so my question is probably very basic.
> 
> This machine I have, is set up with three partitions on
> three different disks (/dev/hda3, /dev/hde1, /dev/hdg1)
> forming a raid-5 array, /dev/md0.
> At some point, the machine became unresponsive, and on a reboot,
> I get the following:
> 
> ...
> md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
> ...
> md: Autodetecting RAID arrays.
> md: autorun ...
> md: considering hdg1 ...
> md:  adding hdg1 ...
> md:  adding hde1 ...
> md:  adding hda3 ...
> md: created md0
> md: bind<hda3>
> md: bind<hde1>
> md: bind<hdg1>
> md: running: <hdg1><hde1><hda3>
> md: kicking non-fresh hdg1 from array!
> md: unbind<hdg1>
> md: export_rdev(hdg1)
> md: kicking non-fresh hde1 from array!
> md: unbind<hde1>
> md: export_rdev(hde1)

(1) MD superblock on hdg1 and hde1 are out-of-date.

> md: personality 4 is not loaded!
> md :do_md_run() returned -22

(2) raid5 module is not loaded.  Make sure that raid5 module is loaded.

I recommend that you install and use mdadm to fix this problem.

* Examine md superblock:
  mdadm --examine /dev/hda3
  to record Layout, Chunk Size, disks order (disk0, disk1, disk2)
* Recreate the raid5 array with 1 "missing" disk: 
  mdadm -C /dev/md0 -l 5 -c [ChunkSize] -p [Layout] -n 3 [disk0] [disk1]
missing
* mount (readonly) /dev/md0
* verify the filesystem
* if everything looks good:
  mdadm --add /dev/md0 [disk2]
* umount and mount /dev/md0

If you cannot boot to a console to do the above, you can boot from
Ubuntu or gentoo livecd.

--
Regards,
Mike T.


