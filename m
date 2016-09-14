From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Inactive arrays
Date: Wed, 14 Sep 2016 10:10:47 -0600
Message-ID: <CAJCQCtQ3kAKd4U=MgVawU9D6QKuxC+XjLYR6EyL87wuyBvvmtg@mail.gmail.com>
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
 <CAHscji1vy55L_BgH=y4X=FMeEgHyxzckhAgLu=BojtTn_2mPug@mail.gmail.com>
 <CAJCQCtRdbWg7HgX=wghd8OBUcauiVfES6NSOKOZj38HMWVg65A@mail.gmail.com>
 <CAHscji1fgVrKwOwf+sCfOrg-MNz0MwRzXAJswKcP=vP2x0PVug@mail.gmail.com>
 <CAJCQCtSTaByUR_2dnGrA0y0dtTaS_sweLKn19QD1=wv+2mnvHg@mail.gmail.com>
 <CAHscji2dhdE7mL-4i8mE6sShQtGCB6v1K02TBQQD4-6R-ZtoZw@mail.gmail.com>
 <CAJCQCtQXd6GgXhu-7h9nNjA1zfdoH_TAEkeQajYv5vsmuG2Vpw@mail.gmail.com> <CAHscji1wVYzpzu8X+GYuuxZPdLzY-f+8oogyH7ttqVwMJe2=iQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji1wVYzpzu8X+GYuuxZPdLzY-f+8oogyH7ttqVwMJe2=iQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Sanabria <sanabria.d@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Sep 14, 2016 at 9:47 AM, Daniel Sanabria <sanabria.d@gmail.com> wrote:
> [root@lamachine ~]# gdisk /dev/sdc
>
> GPT fdisk (gdisk) version 1.0.1
>
> Warning! Disk size is smaller than the main header indicates! Loading
> secondary header from the last sector of the disk! You should use 'v' to
> verify disk integrity, and perhaps options on the experts' menu to repair
> the disk.
>
> Caution: invalid backup GPT header, but valid main header; regenerating
> backup header from main header.
>
> Warning! One or more CRCs don't match. You should repair the disk!
>
> Partition table scan:
>   MBR: not present
>   BSD: not present
>   APM: not present
>   GPT: damaged
>
> Found invalid MBR and corrupt GPT. What do you want to do? (Using the
> GPT MAY permit recovery of GPT data.)
>  1 - Use current GPT
>  2 - Create blank GPT
>
> Your answer: 1
>
> Command (? for help): x
>
> Expert command (? for help): v
>
> Caution: The CRC for the backup partition table is invalid. This table may
> be corrupt. This program will automatically create a new backup partition
> table when you save your partitions.
>
> Problem: The secondary header's self-pointer indicates that it doesn't reside
> at the end of the disk. If you've added a disk to a RAID array, use the 'e'
> option on the experts' menu to adjust the secondary header's and partition
> table's locations.
>
> Problem: Disk is too small to hold all the data!
> (Disk size is 5860531055 sectors, needs to be 5860533168 sectors.)
>
> The 'e' option on the experts' menu may fix this problem.
>
> Problem: GPT claims the disk is larger than it is! (Claimed last usable
> sector is 5860533134, but backup header is at
> 5860533167 and disk size is 5860531055 sectors.
> The 'e' option on the experts' menu will probably fix this problem
>
> Identified 4 problems!
>
> Expert command (? for help): p
> Disk /dev/sdc: 5860531055 sectors, 2.7 TiB
> Logical sector size: 512 bytes
> Disk identifier (GUID): 6DB70F4E-D8ED-4290-AA2E-4E81D8324992
> Partition table holds up to 128 entries
> First usable sector is 2048, last usable sector is 5860533134
> Partitions will be aligned on 2048-sector boundaries
> Total free space is 516987791 sectors (246.5 GiB)
>
> Number  Start (sector)    End (sector)  Size       Code  Name
>    1            2048      4294969343   2.0 TiB     FD00
>    2      4294969344      5343545343   500.0 GiB   8300
>
> Expert command (? for help):

Use the e command. That should fix the 3 main problems, and then a new
CRC is automatically computed for the two headers and two tables at
write time.


-- 
Chris Murphy
