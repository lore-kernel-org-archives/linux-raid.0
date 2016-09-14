From: Daniel Sanabria <sanabria.d@gmail.com>
Subject: Re: Inactive arrays
Date: Wed, 14 Sep 2016 11:36:48 +0100
Message-ID: <CAHscji1fgVrKwOwf+sCfOrg-MNz0MwRzXAJswKcP=vP2x0PVug@mail.gmail.com>
References: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
 <57A07345.4040708@youngman.org.uk> <CAHscji0BQuyKQbLYZ9Ah16hHday_seTaajm8LOn6+HRFqinTyQ@mail.gmail.com>
 <CAHscji3C4Cygs=xh4d4PtREp9mGSBjNS0o7SatW_QotzYShA_Q@mail.gmail.com>
 <CAHscji3HdHaJAvwtYNU=Ykc_qohBkfFfrbP0M=FNhuFMK+d-Jg@mail.gmail.com>
 <CAHscji35kySP4Q8cUpYCXR2P9DBwPcYeWjr_HX==TNX9CPW9NA@mail.gmail.com>
 <CAHscji2k9FyrOs+96XQWEUWU3W0EWxkanaHakjsGhij0hXiVGw@mail.gmail.com>
 <57D72092.20704@youngman.org.uk> <CAHscji3KfFfO8CxZTbLX6u-bfA57pOR5i6qvc0NhNODH5tGeEg@mail.gmail.com>
 <CAJCQCtTzPpt0krPxCZY_TB-Xa6PcG0YsdDPnneq5dEB30wy8hw@mail.gmail.com>
 <CAHscji0H7kEDzhg3KpUYrdk5MA06k-F5Xe95=EL7mo-_mS3y5A@mail.gmail.com>
 <CAJCQCtS-aYNgy7MM990CTKFqcNk8bf+ggzX3QRrD+yQZfdVxnA@mail.gmail.com>
 <CAHscji1vy55L_BgH=y4X=FMeEgHyxzckhAgLu=BojtTn_2mPug@mail.gmail.com> <CAJCQCtRdbWg7HgX=wghd8OBUcauiVfES6NSOKOZj38HMWVg65A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtRdbWg7HgX=wghd8OBUcauiVfES6NSOKOZj38HMWVg65A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Pretty weird.  Any ideas how that happened? My guess is sdd was
> partitioned first, and its partition was copied to sdc and sde, and
> the tool blindly did not recompute the last usable sector LBA, it used
> the value from sdd.

I have no solid idea but my money is on a human screwing up. While
trying to boot the server after the move I have no clear record of
what actions were taken, however I think it was during this time when
the disks were probably messed.

> sdd1 is 2TB
> sdd2 is 500MB
>
> And it looks like sdc and sde, if we believe the backup GPT, have the
> same exact partition scheme.

yes from the original build that was the idea

> wipefs -a -n /dev/sdc
> wipefs -a -n /dev/sde
>
> So what do you get for that?

[root@lamachine ~]# wipefs -a -n /dev/sdc
/dev/sdc: 2 bytes were erased at offset 0x000001fe (PMBR): 55 aa
/dev/sdc: calling ioctl to re-read partition table: Success

[root@lamachine ~]# wipefs -a -n /dev/sde
/dev/sde: 2 bytes were erased at offset 0x000001fe (PMBR): 55 aa
/dev/sde: calling ioctl to re-read partition table: Success

it didn't give me any indication that it was in no-act mode but I
decided to carry on with the backup flag and got this:

[root@lamachine ~]# wipefs -a -b /dev/sdc

wipefs: invalid option -- 'b'

Usage:

 wipefs [options] <device>

Wipe signatures from a device.

Options:

 -a, --all           wipe all magic strings (BE CAREFUL!)
 -b, --backup        create a signature backup in $HOME
 -f, --force         force erasure
 -h, --help          show this help text
 -n, --no-act        do everything except the actual write() call
 -o, --offset <num>  offset to erase, in bytes
 -p, --parsable      print out in parsable instead of printable format
 -q, --quiet         suppress output messages
 -t, --types <list>  limit the set of filesystem, RAIDs or partition tables
 -V, --version       output version information and exit


For more details see wipefs(8).

[root@lamachine ~]# wipefs -V
wipefs from util-linux 2.27.1

[root@lamachine ~]# wipefs -a --backup /dev/sdc
/dev/sdc: 2 bytes were erased at offset 0x000001fe (PMBR): 55 aa
/dev/sdc: calling ioctl to re-read partition table: Success

[root@lamachine ~]# wipefs -a --backup /dev/sde
/dev/sde: 2 bytes were erased at offset 0x000001fe (PMBR): 55 aa
/dev/sde: calling ioctl to re-read partition table: Success

[root@lamachine ~]#

before proceeding with manually creating both partitions could you
confirm the above is kind of expected?

> Chances are you could just use gdisk to verify and fix the primary and
> backup GPTs on sdc and sde

Will the fix be offered as part of the verify command in gdisk (command: v)?

> When it's all done and working with the new MBR you can either leave
> it alone, or you can run gdisk on it and it will immediately convert
> it (in memory) and you can commit it to disk with the w command to go
> back to GPT

so just running the w command after running the verify command while
on the same session ?
