From: Daniel Sanabria <sanabria.d@gmail.com>
Subject: Re: Inactive arrays
Date: Tue, 13 Sep 2016 21:04:52 +0100
Message-ID: <CAHscji1vy55L_BgH=y4X=FMeEgHyxzckhAgLu=BojtTn_2mPug@mail.gmail.com>
References: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
 <57A07345.4040708@youngman.org.uk> <CAHscji0BQuyKQbLYZ9Ah16hHday_seTaajm8LOn6+HRFqinTyQ@mail.gmail.com>
 <CAHscji3C4Cygs=xh4d4PtREp9mGSBjNS0o7SatW_QotzYShA_Q@mail.gmail.com>
 <CAHscji3HdHaJAvwtYNU=Ykc_qohBkfFfrbP0M=FNhuFMK+d-Jg@mail.gmail.com>
 <CAHscji35kySP4Q8cUpYCXR2P9DBwPcYeWjr_HX==TNX9CPW9NA@mail.gmail.com>
 <CAHscji2k9FyrOs+96XQWEUWU3W0EWxkanaHakjsGhij0hXiVGw@mail.gmail.com>
 <57D72092.20704@youngman.org.uk> <CAHscji3KfFfO8CxZTbLX6u-bfA57pOR5i6qvc0NhNODH5tGeEg@mail.gmail.com>
 <CAJCQCtTzPpt0krPxCZY_TB-Xa6PcG0YsdDPnneq5dEB30wy8hw@mail.gmail.com>
 <CAHscji0H7kEDzhg3KpUYrdk5MA06k-F5Xe95=EL7mo-_mS3y5A@mail.gmail.com> <CAJCQCtS-aYNgy7MM990CTKFqcNk8bf+ggzX3QRrD+yQZfdVxnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtS-aYNgy7MM990CTKFqcNk8bf+ggzX3QRrD+yQZfdVxnA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Yeah that looks like a recent boot; if that's a boot where you'd run
> parted and got those errors on read, then I don't have a good
> explanation why you're getting parted errors that don't have matching
> kernel messages, i.e. something from libata about the drive not liking
> the command or not properly reading from the drive, etc.

let me see if I can find something

> What do you get for gdisk -l <dev> for each of these drives?

[root@lamachine ~]# gdisk -l /dev/sdc
GPT fdisk (gdisk) version 1.0.1

Warning! Disk size is smaller than the main header indicates! Loading
secondary header from the last sector of the disk! You should use 'v' to
verify disk integrity, and perhaps options on the experts' menu to repair
the disk.
Caution: invalid backup GPT header, but valid main header; regenerating
backup header from main header.

Warning! One or more CRCs don't match. You should repair the disk!

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: damaged

****************************************************************************
Caution: Found protective or hybrid MBR and corrupt GPT. Using GPT, but disk
verification and recovery are STRONGLY recommended.
****************************************************************************
Disk /dev/sdc: 5860531055 sectors, 2.7 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): 6DB70F4E-D8ED-4290-AA2E-4E81D8324992
Partition table holds up to 128 entries
First usable sector is 2048, last usable sector is 5860533134
Partitions will be aligned on 2048-sector boundaries
Total free space is 516987791 sectors (246.5 GiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048      4294969343   2.0 TiB     FD00
   2      4294969344      5343545343   500.0 GiB   8300
[root@lamachine ~]# gdisk -l /dev/sdd
GPT fdisk (gdisk) version 1.0.1

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sdd: 5860533168 sectors, 2.7 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): D3233810-F552-4126-8281-7F71A4938DF9
Partition table holds up to 128 entries
First usable sector is 2048, last usable sector is 5860533134
Partitions will be aligned on 2048-sector boundaries
Total free space is 516987791 sectors (246.5 GiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048      4294969343   2.0 TiB     FD00
   2      4294969344      5343545343   500.0 GiB   8300
[root@lamachine ~]# gdisk -l /dev/sde
GPT fdisk (gdisk) version 1.0.1

Warning! Disk size is smaller than the main header indicates! Loading
secondary header from the last sector of the disk! You should use 'v' to
verify disk integrity, and perhaps options on the experts' menu to repair
the disk.
Caution: invalid backup GPT header, but valid main header; regenerating
backup header from main header.

Warning! One or more CRCs don't match. You should repair the disk!

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: damaged

****************************************************************************
Caution: Found protective or hybrid MBR and corrupt GPT. Using GPT, but disk
verification and recovery are STRONGLY recommended.
****************************************************************************
Disk /dev/sde: 5860531055 sectors, 2.7 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): B64DAA7C-E1D8-4E8A-A5C8-76001DAE6B30
Partition table holds up to 128 entries
First usable sector is 2048, last usable sector is 5860533134
Partitions will be aligned on 2048-sector boundaries
Total free space is 516987791 sectors (246.5 GiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048      4294969343   2.0 TiB     FD00
   2      4294969344      5343545343   500.0 GiB   8300
[root@lamachine ~]#

On 13 September 2016 at 20:52, Chris Murphy <lists@colorremedies.com> wrote:
> On Tue, Sep 13, 2016 at 1:43 PM, Daniel Sanabria <sanabria.d@gmail.com> wrote:
>>> This is a problem. What do you get for
>>>
>>> cat /sys/block/sdc/device/timeout
>>
>> [root@lamachine ~]# cat /sys/block/sdc/device/timeout
>> 30
>> [root@lamachine ~]# cat /sys/block/sdd/device/timeout
>> 30
>> [root@lamachine ~]# cat /sys/block/sde/device/timeout
>> 30
>> [root@lamachine ~]#
>
> Common and often fatal misconfiguration. Since the drives don't
> support SCT ERC, the command timer needs to be changed to something
> higher. Without the benefit of historical kernel messages, it's
> unclear if there have been any link resets that'd indicate improper
> correction for bad sectors on the drives.
>
>
>
>
>>
>>> Anyone specifically familiar with WDC Greens, and if the lack of SCT
>>> ERC can be worked around in the usual way by increasing the SCSI
>>> command timer value? Or is there also something else? I vaguely recall
>>> something about drive spin down that can also cause issues, does that
>>> need mitigation? If no one chimes in, this information is in the
>>> archives, just search for 'WDC green' and you'll get an shittonne of
>>> results.
>>
>> In another thread I found Phil Turmel recommending to change the
>> timeout value like this:
>>
>> for x in /sys/block/*/device/timeout ; do echo 180 > $x ; done
>>
>> Is that what you guys are talking about when mentioning the SCT/ERC issues?
>
> Yes. You should do that.
>
>
>
>
>>
>>> OK so the next thing I want to see is why you're getting these
>>> messages from parted when you check sdc and sde for partition maps. At
>>> the time you do this, what do you see in kernel messages? Maybe best
>>> to just stick the entire dmesg for the current boot up somewhere like
>>> fpaste.org or equivalent.
>>
>> https://paste.fedoraproject.org/427719/37952531/
>
> Yeah that looks like a recent boot; if that's a boot where you'd run
> parted and got those errors on read, then I don't have a good
> explanation why you're getting parted errors that don't have matching
> kernel messages, i.e. something from libata about the drive not liking
> the command or not properly reading from the drive, etc.
>
> What do you get for gdisk -l <dev> for each of these drives?
>
>
>
> --
> Chris Murphy
