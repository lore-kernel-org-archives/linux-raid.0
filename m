From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID10 with 2 drives auto-assembled as RAID1
Date: Sat, 5 Nov 2016 18:54:21 -0400
Message-ID: <e23d3b3a-c357-bd74-6bc5-f2e04255c96d@turmel.org>
References: <0487f9a4-c04a-8a4d-78ad-0191995d4be9@luketic.de>
 <57ce55da-fadc-db02-289e-db44bf6fb7d7@turmel.org>
 <fdfd254f-bdcf-80a7-2265-893c8ee781fc@luketic.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fdfd254f-bdcf-80a7-2265-893c8ee781fc@luketic.de>
Sender: linux-raid-owner@vger.kernel.org
To: Darko Luketic <darko@luketic.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

{ Convention on kernel.org lists is reply-to-all, interleave or bottom
post, and trim replies. Please do. }

On 11/05/2016 05:10 PM, Darko Luketic wrote:
> Ok Phil,
> 
> sorry for that.

NP.

> In the meantime I tried to use mdadm with the --build option.
> mdadm --build --level=10 --raid-devices=2 --chunk=64 /dev/md0 /dev/sde1
> /dev/sde2

Ew.  Not a good idea.

> after about 1% I stopped it and did the same with just /dev/sde and
> /dev/sdf because I remembered I had used the whole drives previously but
> that wasn't that case here -> stopped quickly.

I can't remember any case where "stopping quickly" was helpful. )-:
Critical structures are at the beginnings of disks and partitions and
are always written over first.

[trim ]

> # mdadm -E /dev/sde1
> /dev/sde1:

>   Creation Time : Sat Nov  5 17:58:30 2016

> # mdadm -E /dev/sdf1
> /dev/sdf1:

>   Creation Time : Sat Nov  5 17:58:30 2016

You might be toast.  The creation timestamps are today, meaning there's
no usable clues to your old setup.  Next step would be to try to figure
out the data offset by hunting for filesystem superblock signatures.
The saving grace in your case is that raid10,n2 on two devices is laid
out the same as raid1 on two devices.  That is, each device is a mirror.
 Assuming you had an ext2/3/4 filesystem in the array, try this one-liner:

for x in /dev/sd[ef]1; do echo -e "\nDevice $x"; dd if=$x bs=1M
count=16k |hexdump -C |egrep '^[0-9a-f]+30  .+  53 ef'; done

Cross your fingers.

Phil
