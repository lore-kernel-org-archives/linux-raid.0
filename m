From: Luca Berra <bluca@comedia.it>
Subject: Re: Confusion with setting up new RAID6 with mdadm
Date: Mon, 15 Nov 2010 08:41:25 +0100
Message-ID: <20101115074125.GB5490@maude.comedia.it>
References: <4CE00206.4000301@geograph.co.za> <20101114195036.GA23982@maude.comedia.it> <4CE0D8B0.4050603@geograph.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CE0D8B0.4050603@geograph.co.za>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 15, 2010 at 08:52:32AM +0200, Zoltan Szecsei wrote:
> On 2010-11-14 21:50, Luca Berra wrote:
>> On Sun, Nov 14, 2010 at 05:36:38PM +0200, Zoltan Szecsei wrote:
>>>
>>> *Partition alignment?
>>> Is this relevant for modern HDs (I'm using 5900rpm Seagate 2TB drives)
>> for modern hdds with 4k sectors it is
>> new fdisk and/or parted should already know how to align
> fdisk reports 512b sectors:
> root@gs0:/home/geograph# fdisk -lu

i believe your fdisk does not support getting geometry from blkid, but i
am not an ubuntu user
you could try checking with something like 'strings /sbin/fdisk | grep io_size',
but since we are going without partitions you can ignore all this.

btw to check sector size on a disk, on a fairly recent kernel you can
check the files under /sys/block/*/queue,
hw_sector_size
minimum_io_size
optimal_io_size

except for disks that lie about their sector size, but this is a
different story.

>>> *After partitioning the 8 drives, is this the correct sequence?
>>> mdadm --create /dev/md0 --metadata=1.2 --auto=md --chunk=64 --level=raid6
>> why you state the chunk size here, i tought you wanted to stay with the
>> defauklt
> because on my mdadm, 64 is the default - and I was just re-enforcing that 
> for the reader.
> root@gs0:/home/geograph# mdadm -V
> mdadm - v2.6.7.1 - 15th October 2008
this mdadm release is a tad old (about two years), it will work, but
some things may be different than current 3.1.x

> root@gs0:/home/geograph#
>>> *After this, do I mkfs ext4 first, or LVM first?
>> if you want to use lvm it would be lvm first, but... do you want to?
>> there is no point if the aim is allocating the whole space to a single
>> filesystem.
> Because I might want to join this array to another one at a later stage - I 
> would then have 2 boxes each with 8 drives, and each with a SiI3132 card on 
> the same motherboard.
> I might use the second box to mirror the first, or to extend it - not sure 
> of my needs yet.
ok, then you need to align lvm as well
check if you have these parameters in /etc/lvm/lvm.conf
md_chunk_alignment = 1
data_alignment_detection = 1

if you don't have those at all, check if lvm supports them
strings /sbin/lvm|grep io_size

if not, you have to align manually, using the --dataalignment option to
pvcreate, align to a full stripe (chunk_size * 6, see below)


>>> *What stride and stripe values should I use?
stride=chunk_size/fs block size
stripe-width=stride * num_data_disks
num_data disks in your case is 6, 8 total disks - 2 parity disks

on a fairly recent kernel:
/sys/block/md?/queue/minimum_io_size would be the chunk_size of the array
/sys/block/md?/queue/optimal_io_size would be the stripe size

this should be exported on lvm devices also
/sys/block/dm-*/queue/...

so you can check with data in /sys/block at each step which is the value
to feed into tools.

>> new toolstack should already find the correct stripe/stride for you
> How would I check ?
strings /sbin/lvm|grep io_size

-- 
Luca Berra -- bluca@comedia.it
