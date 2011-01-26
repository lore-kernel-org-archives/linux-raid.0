From: CoolCold <coolthecold@gmail.com>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Wed, 26 Jan 2011 12:41:12 +0300
Message-ID: <AANLkTi=D14yTMXdPktCcE+-XBM7U=MXjYHq=BuBnJ10r@mail.gmail.com>
References: <20110118210112.D13A236C@gemini.denx.de>
	<20110125171017.GA24921@infradead.org>
	<20110125184115.1119FB187@gemini.denx.de>
	<20110125213523.GA14375@infradead.org>
	<20110126071616.824BEBB0B9@gemini.denx.de>
	<20110126093854.GA17538@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110126093854.GA17538@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 26, 2011 at 12:38 PM, Christoph Hellwig <hch@infradead.org>=
 wrote:
> On Wed, Jan 26, 2011 at 08:16:16AM +0100, Wolfgang Denk wrote:
>> I will not have a single file system, but several, so I'd probably g=
o
>> with LVM. But - when I then create a LV, eventually smaller than any
>> of the disks, will the data (and thus the traffic) be really distri-
>> buted over all drives, or will I not basicly see the same results as
>> when using a single drive?
>
> Think about it: =A0if you're doing small IOPs, they usually are small=
er
> than the stripe size and you will hit only one disk anyway. =A0But wi=
th
> a raid0 which disk you hit is relatively unpredictable. =A0With a
> concatentation aligned to the AGs XFS will distribute processes writi=
ng
> data to the different AGs and thus the different disks, and you can
> reliably get performance out of them.
>
> If you have multiple filesystems the setup depends a lot on the
> workloads you plan to put on the filesystems. =A0If all of the filesy=
stems
> on it are busy at the same time just assigning disks to filesystems
> probably gives you the best performace. =A0If they are busy at differ=
ent
> times, or some are not busy at all you first want to partition the di=
sk
> into areas for each filesystem and then concatenate them into volumes
> for each filesystem.
>
>
>> [[Note: Block write: drop to 60%, Block read drops to <50%]]
>
> How is the cpu load? =A0delaylog trades I/O operations for cpu
> utilization. =A0Together with a raid6, which apparently is the system=
 you
> use here i might overload your system.
>
> And btw, in future please state you have numbers for a totally differ=
ent
> setup then the one you're asking questions for. =A0Comparing a raid6 =
setup
> to striping/concatenation is completely irrelevant.
>
>>
>> [[Add nobarriers]]
>>
>> # mount -o remount,nobarriers /mnt/tmp
>> # mount | grep /mnt/tmp
>> /dev/mapper/castor0-test on /mnt/tmp type xfs (rw,noatime,delaylog,l=
ogbsize=3D262144,nobarriers)
>
> =A0a) the option is called nobarrier
> =A0b) it looks like your mount implementation is really buggy as it s=
hows
> =A0 =A0random options that weren't actually parsed and accepted by th=
e
> =A0 =A0filesystem.
cat /proc/mounts may help i guess

>
>> [[Again, degradation of about 10% for block read; with only minod
>> advantages for seq. delete and random create]]
>
> I really don't trust the numbers. =A0nobarrier sends down less I/O
> requests, and avoids all kinds of queue stalls. =A0How repetable are =
these
> benchmarks? =A0Do you also see it using a less hacky benchmark than
> bonnier++?
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
