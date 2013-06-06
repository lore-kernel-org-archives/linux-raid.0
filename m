From: Nicolas Michel <be.nicolas.michel@gmail.com>
Subject: Re: Import data from an array coming from another computer
Date: Thu, 6 Jun 2013 17:28:23 +0200
Message-ID: <CAO5znavf677nWNVuUJVRN_dEZH3QM1A1Lj8Oob1QdUwT2G3wsA@mail.gmail.com>
References: <CAO5znavAuteVhzarkVEDHPOxs4RFx9j0tB51QXj5LUcREJbn=A@mail.gmail.com>
	<20130606145400.GA15336@sam-solutions.com>
	<CAO5znavkSqxqkSjmYtbTmuW7OkEkHexaX8vfohfaVp0asU+8ig@mail.gmail.com>
	<20130606151345.GA15605@sam-solutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130606151345.GA15605@sam-solutions.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aleh Suprunovich <a.suprunovich@sam-solutions.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I didn't saw it. It is a possibility that the disk was configured as
spare in the IOMEGA device. The second disque have its GPT table
corrupt.

So it would mean that the data are lost since the first disk is
corrupted and the second, as a spare device, have no data on it.

(I'm not the one that configured in first place the IOMEGA device. The
guys that are using it came to me to see if I can recover their data)

2013/6/6 Aleh Suprunovich <a.suprunovich@sam-solutions.com>:
> On Thu, Jun 06, 2013 at 06:00:44PM +0300, Nicolas Michel wrote:
>> It is better but it still doesn't work:
>> $ mdadm --assemble /dev/md1 --run /dev/sdc1
>> mdadm: failed to RUN_ARRAY /dev/md1: Input/output error
>> mdadm: Not enough devices to start the array.
>>
>
> One device should be enough to start RAID1 array. But here is something I missed
> in your first message:
>
> On Thu, Jun 06, 2013 at 05:47:33PM +0300, Nicolas Michel wrote:
>> ############################################################
>> # $ mdadm --examine /dev/sdc1
>> # /dev/sdc1:
>> #           Magic : a92b4efc
>> #         Version : 0.90.00
>> #            UUID : 76fc436c:be43bed5:f0f41dd6:3e9e1b96
>> #   Creation Time : Fri Jun  8 04:21:19 2012
>> #     Raid Level : raid1
>> #   Used Dev Size : 20980800 (20.01 GiB 21.48 GB)
>> #     Array Size : 20980800 (20.01 GiB 21.48 GB)
>> #   Raid Devices : 2
>> #   Total Devices : 2
>> #  Preferred Minor : 0
>> #
>> #    Update Time : Thu May 23 14:55:13 2013
>> #          State : clean
>> #  Active Devices : 1
>> #  Working Devices : 2
>> #  Failed Devices : 0
>> #   Spare Devices : 1
>> #        Checksum : b0ae04f1 - correct
>> #          Events : 28935
>> #
>> #
>> #       Number   Major   Minor   RaidDevice State
>> # this     2       8        1        2      spare   /dev/sda1
>> #
>> #    0     0       0        0        0      removed
>> #    1     1       8       17        1      active sync   /dev/sdb1
>> #    2     2       8        1        2      spare   /dev/sda1
>> ############################################################
>
> Line starting from 'this' indicate that device you have was spare component of
> array, so no information restore is possible with this disk. Do you have acess
> to other drive, named /dev/sdb1 in your mdadm --examine output?



-- 
Nicolas MICHEL
