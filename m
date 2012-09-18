From: Ferry <iscsitmp@bananateam.nl>
Subject: Serious performance issues with mdadm RAID-5 partition exported through
 LIO (iSCSI)
Date: Tue, 18 Sep 2012 16:37:37 +0200
Message-ID: <50588731.5050502@bananateam.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-raid.ids

Hi there,

we're having serious performance issues with the LIO iSCSI target on a 7
disk RAID-5 set + hotspare (mdadm). As I'm not sure where to go, I've
sent this to both linux-raid and target-devel lists.

We're seeing write performance in the order of, don't fall of your
chair, 3MB/s. This is once the buffers are full. Before the buffers are
full we're near wirespeed (gigabit). We're running blockio in buffered
mode with LIO. The machine is running Ubuntu 12.04 LTS Server (64 bit).
Next to the (ubuntu) stock kernels I have tried several 3.5 versions
from Ubuntu's mainline repository, which seem somewhat faster (up to
6-15MiB/s), however, at least 3.5.2 and 3.5.3 were unstable and made the
machine crash after ~1 day.

As the machine is running production for a backup solution I'm severely
limited in my windows for testing.

Whilst writing, copying a DVD from the Windows 2008 R2 initiator to the
target - no other I/O was active, I noticed in iostat something I
personally find very weird. All the disks in the RAID set (minus the
spare) seem to read 6-7 times as much as they write. Since there is no
other I/O (so there aren't really any reads issued besides some very
occasional overhead for NTFS perhaps once in a while) I find this really
weird. Note also that iostat doesn't show the reads in iostat on the md
device (which is the case if the initiator issues reads) but only on the
active disks in the RAID set, which to me (unknowingly as I am :))
indicates mdadm in the kernel is issuing those reads.

So for example I see disk <sdX> do 600-700kB/s reading in I/O stat
whilst it's writing about 100kB/s.

I think the majority of the issue comes from that.

I've switched back to IETD now. With IETD I can copy with 55MiB/s to the
device *whilst* reading from the same device (copy an ISO onto it, then
copy the ISO from the disk back to the disk, then copy all copies couple
of times - so both read/write). Iostat with IETD whilst writing shows
say 110-120% read per write, however, in this case we were also actually
reading. So to keep it simple, it read 110-120kB/s whilst writing
100kB/s per disk. This is a very serious difference. IETD is running in
fileio mode (write-back), so it buffers too. So if we substract the
actual reading it's IETD 10-20% read on 100% write, vs LIO 600-700% read
on 100% write. That's quite upsetting.

It seems to me the issue exists between LIO's buffers and mdadm. Why it
writes so horribly inefficiently is beyond me though. I've invested
quite some time in this already - however due to the way I've tested
(huge intervals / different kernels, some disks have been swapped, etc)
and my lack of in-depth kernel knowledge I don't think much of it is
accurate enough to post here.

Can someone advise me how to proceed? I was hoping to switch to LIO and
see a slight improvement in performance (besides more/better
functionality as error correction and hopefully better stability). This
has turned out quite differently unfortunately.

Do note - I'm running somewhat unorthodox. I've created a RAID-5 of 7
disks + hotspare (it was originally a RAID-6 w/o hotspare but converted
it to RAID-5 in hopes of improving performance). This disk is about
12TB. It's partitioned with GPT in ~9TB and ~2.5TB (there's huge
rounding differences at these sizes 1000 vs 1024 et al :)). The 2.5TB
currently isn't used. I've exported /dev/md4p1 thus. This in turn is
partitioned (GPT - msdos isn't usable) in windows and used as a disk.

In order to do this I had to modify rtslib as it didn't recognize the
md4p1 as a block device. I've added the major device numbers to the list
there and could export it just 'fine' then. The issues might be related
to this.

If anyone is willing to help me modify the partition table so I can just
export /dev/md4 I can test it. I'm not sure on the offsets (0 included
or not for example) and I don't really want to mess up ~7TiB of data ;).
Don't really have another set of disks this large nor the time to copy
it back and forth. Just adjusting the partition table should work - if
proper values are used. The partition on /dev/md4 should then point the
current /dev/md4p1p2 if you will (/dev/md4p1 is exported and is thus
seen as disk - this in turn is partitioned by windows, for some odd
reason it created a system partition too (afaik it usually only does
this on the install disk, this is just a data disk, so there's a ~128MiB
partition and then the data partition)).

With msdos partitions I could easily mess with it myself. GPT however
also has mirror headers and those might actually overwrite my data if
done incorrectly. At least - that's what I'm worried about, not sure if
that theory is solid. Also, with msdos I could easily make backups with
dd or sfdisk (of the partition table). Not aware of such a tool for gpt.
Parted doesn't seem to be able to dump them.

Kind regards,
