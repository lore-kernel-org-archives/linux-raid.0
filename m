From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: MD devices renaming or re-ordering question
Date: Thu, 13 Sep 2007 22:25:16 +0200
Message-ID: <87odg61ff7.fsf@informatik.uni-tuebingen.de>
References: <46E984E7.1080903@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46E984E7.1080903@harddata.com> (Maurice Hilarius's message of
	"Thu, 13 Sep 2007 12:43:51 -0600")
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maurice Hilarius <maurice@harddata.com> writes:

> Hi to all.
>
> I wonder if somebody would care to help me to solve a problem?
>
> I have some servers.
> They are running CentOS5
> This OS has a limitation where the maximum filesystem size is 8TB.
>
> Each server curr3ently has a  AMCC/3WARE 16 port SATA controllers. Total
> of 16 ports / drives
> I am using 750GB drives.
>
> I am exporting the drives as single, NOT as hardware RAID
> That is due to the filesystem and controller limitations, among other
> reasons.
>
> Each server currently has 16 disks attached to the one controller
>
> I want to add a 2nd controller, and, for now, 4 more disks on it.
>
> I want to have the boot disk as a plain disk, as presently configured as
> sda1,2,3
>
> The remaining 15 disks are configured as :
> sdb1 through sde1 as md0 ( 4 devices/partitions)
> sdf1 through sdp1 as md1 (10 devices/partitions)
> I want to add a 2nd controller, and 4 more drives, to the md0 device.
>
> But, I do not want md0 to be "split" across the 2 controllers this way.
> I prefer to do the split on md1
>
> Other than starting from scratch, the best solution would be to add the
> disks to md0, then to "magically" turn md0 into md1, and md1 into md0
>
> So, the question:
> How does one make md1 into md0, and vice versa?
> Without losing the data on these md's ?
>
> Thanks in advance for any suggestions.

The simplest is to pull the disks from md1 from the first controler
and put them into the 2nd controler and then add the new disks to the
first controler.

Actually I would pull the 4 disks from md0 and put them on the second
controler. Have no split at all.

Or alternatively split both raids evenly to balance loads between the
controlers. Might be faster.

MfG
        Goswin
