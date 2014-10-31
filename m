From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: question about MD raid rebuild performance degradation even with speed_limit_min/speed_limit_max set.
Date: Fri, 31 Oct 2014 19:44:00 +0000
Message-ID: <21587.59008.692520.808080@tree.ty.sabi.co.uk>
References: <5445332B.9060009@cse.yorku.ca>
	<5445361E.3010503@cse.yorku.ca>
	<5445799A.8020205@cse.yorku.ca>
	<20141029093822.79242658@notabene.brown>
	<5450521F.8060309@cse.yorku.ca>
	<20141029135749.241f9e50@notabene.brown>
	<54515493.4070402@cse.yorku.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54515493.4070402@cse.yorku.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>>> If, for example, I set speed_limit_min AND speed_limit_max to
>>>>>> 80000 then fail a disk when there is no other disk activity, the=
n
>>>>>> I do get a rebuild rate of around 80 MB/s. However, if I then
>>>>>> start up a write intensive operation on the MD array (eg. a dd,
>>>>>> or a mkfs on an LVM logical volume that is created on that MD),
>>>>>> then, my write operation seems to get "full power", and my
>>>>>> rebuild drops to around 25 MB/s.

Linux MD RAID is fundamentally an IO address remapper, and actual IO is
scheduled and executed by the Linux block (page) IO subsystem. This
separation is beneficial in many ways.

Also the bandwidth delivered by a storage device is not a single
number. Disk drives transfer rate depend a lot on degree of randomness
of access, and outer vs. inner regions. Common disks can therefore
deliver bandwidth between 150MB/s and 0.5MB/s depending on the overall
traffic investing them.

Therefore in order to deliver a consistent transfer rate to the MD
resync kernel process the Linux block (page) IO subsystem would have to
be quite clever in controlling the rates of usage of all the processes
using a disk.

>>> I'm coming from using a 3Ware hardware RAID cotntroller where I
>>> could configure how much of the disk bandwidth is to be used for a
>>> rebuild versus I/O.

That (usually) works because the disk is completely dedicated to the
RAID card and the RAID card can schedule all IO to it.

>>> From what I understand, you're saying that MD [ ... ] and other
>>> system I/O needs that disk bandwidth, then there's nothing it can d=
o
>>> about it. I guess I just don't understand why. Why can't md be give=
n
>>> a priority in the kernel to allow the admin to decide how much
>>> bandwidth goes to system I/O versus rebuild I/O.

There is something you can do about it: rewrite the block IO subsystem
in the Linux kernel so that it can be configured to allocate IOPS and/o=
r
bandwidth quotas to different processes, among them the MD resync kerne=
l
process (extra awesome if that is also isochronous).

Because as well summarized below that process is just one of many
possible users of a given disk in a Linux based system:

>> There are difficulties in guaranteeing a minimum when the array uses
>> partitions from devices on which other partitions are used for other
>> things.

Put another way, designing MD RAID as fundamentally an IO address
remapper, and letting the MD resync kernel process run as "just another
process", has some big advantages and gives a lot of flexibility, but
means relying on the kernel block subsystem to do actual IO, and
accepting its current limitations. That is a free choice.

> The truth is, as people start to combine larger and larger
> disks, and rebuild times go up and up and up, this type of
> request will become more common....

Request of the type "I decided to use a physical storage design that
behaves in a way that I don't like so MD should do magic and work aroun=
d
my decision" are already common. :-).

Using =ABlarger and larger disks=BB is a *choice people make* and if th=
ey
don't like the obvious consequences they should then not make that
choice; they can instead choose to use smaller disks, or just the outer
part of larger disks (which can` be cheaper).

A critical metric for physical storage is IOPS/GB ratios (and their
variability dependent on workload) and ooking at those ratios I
personally think that common disks larger than 1TB are not suitable for
many cases of "typical" live data usage, and in the day job we sometime=
s
build MD RAID sets made of 146GB 15k disks, because fortunately my
colleagues understand the relevant tradeoffs too.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
