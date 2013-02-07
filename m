From: Dave Cundiff <syshackmin@gmail.com>
Subject: Re: RAID performance
Date: Thu, 7 Feb 2013 06:07:27 -0500
Message-ID: <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com>
References: <51134E43.7090508@websitemanagers.com.au>
	<CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com>
	<51137FB8.6060003@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51137FB8.6060003@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 7, 2013 at 5:19 AM, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:
> On 07/02/13 20:07, Dave Cundiff wrote:
>> On Thu, Feb 7, 2013 at 1:48 AM, Adam Goryachev
>> <mailinglists@websitemanagers.com.au> wrote:
>> Why would you plug thousands of dollars of SSD into an onboard
>> controller? It's probably running off a 1x PCIE shared with every
>> other onboard device. An LSI 8x 8 port HBA will run you a few
>> hundred(less than 1 SSD) and let you melt your northbridge. At least
>> on my Supermicro X8DTL boards I had to add active cooling to it or it
>> would overheat and crash at sustained IO. I can hit 2 - 2.5GB a second
>> doing large sequential IO with Samsung 840 Pros on a RAID10.
>
> Because originally I was just using 4 x 2TB 7200 rpm disks in RAID10, I
> upgraded to SSD to improve performance (which it did), but hadn't (yet)
> upgraded the SATA controller because I didn't know if it would help.
>
> I'm seeing conflicting information here (buy SATA card or not)...

Its not going to help your remote access any. From your configuration
it looks like you are limited to 4 gigabits. At least as long as your
NICs are not in the slot shared with the disks. If they are you might
get some contention.

http://download.intel.com/support/motherboards/server/sb/g13326004_s1200bt_tps_r2_0.pdf

See page 17 for a block diagram of your motherboard. You have a 4x DMI
connection that PCI slot 3, your disks, and every other onboard device
share. That should be about 1.2GB(10Gigabits) of bandwidth. Your SSDs
alone could saturate that if you performed a local operation. Get your
NIC's going at 4Gig and all of it a sudden you'll really want that
SATA card in slot 4 or 5.

>
>>> 2) Move from a 5 disk RAID5 to a 8 disk RAID10, giving better data
>>> protection (can lose up to four drives) and hopefully better performance
>>> (main concern right now), and same capacity as current.
>>
>> I've had strange issues with anything other than RAID1 or 10 with SSD.
>> Even with the high IO and IOP rates of SSDs the parity calcs and extra
>> writes still seem to penalize you greatly.
>
> Maybe this is the single threaded nature of RAID5 (and RAID10) ?

I definitely see that. See below for a FIO run I just did on one of my RAID10s

md2 : active raid10 sdb3[1] sdf3[5] sde3[4] sdc3[2] sdd3[3] sda3[0]
      742343232 blocks super 1.2 32K chunks 2 near-copies [6/6] [UUUUUU]

seq-read: (g=0): rw=read, bs=64K-64K/64K-64K/64K-64K, ioengine=libaio,
iodepth=32
seq-write: (g=2): rw=write, bs=64K-64K/64K-64K/64K-64K,
ioengine=libaio, iodepth=32

Run status group 0 (all jobs):
   READ: io=4096.0MB, aggrb=2149.3MB/s, minb=2149.3MB/s,
maxb=2149.3MB/s, mint=1906msec, maxt=1906msec

Run status group 2 (all jobs):
  WRITE: io=4096.0MB, aggrb=1168.7MB/s, minb=1168.7MB/s,
maxb=1168.7MB/s, mint=3505msec, maxt=3505msec

These drives are pretty fresh and my writes are a whole gig less than
my read. Its not for lack of bandwidth either.

>
>> Also if your kernel does not have md TRIM support you risk taking a
>> SEVERE performance hit on writes. Once you complete a full write pass
>> on your NAND the SSD controller will require extra time to complete a
>> write. if your IO is mostly small and random this can cause your NAND
>> to become fragmented. If the fragmentation becomes bad enough you'll
>> be lucky to get 1 spinning disk worth of write IO out of all 5
>> combined.
>
> This was the reason I made the partition (for raid) smaller than the
> disk, and left the rest un-partitioned. However, as you said, once I've
> fully written enough data to fill the raw disk capacity, I still have a
> problem. Is there some way to instruct the disk (overnight) to TRIM the
> extra blank space, and do whatever it needs to tidy things up? Perhaps
> this would help, at least first thing in the morning if it isn't enough
> to get through the day. Potentially I could add a 6th SSD, reduce the
> partition size across all of them, just so there is more blank space to
> get through a full day worth of writes?

There was a script called mdtrim that would use hdparm to manually
send the proper TRIM commands to the drives. I didn't bother looking
for a link because it scares me to death and you probably shouldn't
use it. If it gets the math wrong random data will disappear from your
disks.

As for changing partition sizes you really have to know what kinds of
IO you're doing. If all you're doing is hammering these things with
tiny IOs 24x7 its gonna end up with terrible write IO. At least my
SSDs do. If you have a decent mix of small and large it may not
fragment as badly. I ran random 4k against mine for 2 days before it
got miserably slow. Reading will always be fine.


--
Dave Cundiff
System Administrator
A2Hosting, Inc
http://www.a2hosting.com
