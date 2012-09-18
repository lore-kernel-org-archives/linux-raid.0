From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Serious performance issues with mdadm RAID-5 partition
 exported through LIO (iSCSI)
Date: Tue, 18 Sep 2012 12:49:20 -0700
Message-ID: <1347997760.25356.16.camel@haakon2.linux-iscsi.org>
References: <50588731.5050502@bananateam.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <50588731.5050502@bananateam.nl>
Sender: target-devel-owner@vger.kernel.org
To: Ferry <iscsitmp@bananateam.nl>
Cc: linux-raid@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2012-09-18 at 16:37 +0200, Ferry wrote:
> Hi there,
> 

Hi Ferry,

> we're having serious performance issues with the LIO iSCSI target on a 7
> disk RAID-5 set + hotspare (mdadm). As I'm not sure where to go, I've
> sent this to both linux-raid and target-devel lists.
> 
> We're seeing write performance in the order of, don't fall of your
> chair, 3MB/s. This is once the buffers are full. Before the buffers are
> full we're near wirespeed (gigabit). We're running blockio in buffered
> mode with LIO. The machine is running Ubuntu 12.04 LTS Server (64 bit).
> Next to the (ubuntu) stock kernels I have tried several 3.5 versions
> from Ubuntu's mainline repository, which seem somewhat faster (up to
> 6-15MiB/s), however, at least 3.5.2 and 3.5.3 were unstable and made the
> machine crash after ~1 day.
> 
> As the machine is running production for a backup solution I'm severely
> limited in my windows for testing.
> 
> Whilst writing, copying a DVD from the Windows 2008 R2 initiator to the
> target - no other I/O was active, I noticed in iostat something I
> personally find very weird. All the disks in the RAID set (minus the
> spare) seem to read 6-7 times as much as they write. Since there is no
> other I/O (so there aren't really any reads issued besides some very
> occasional overhead for NTFS perhaps once in a while) I find this really
> weird. Note also that iostat doesn't show the reads in iostat on the md
> device (which is the case if the initiator issues reads) but only on the
> active disks in the RAID set, which to me (unknowingly as I am :))
> indicates mdadm in the kernel is issuing those reads.
> 
> So for example I see disk <sdX> do 600-700kB/s reading in I/O stat
> whilst it's writing about 100kB/s.
> 
> I think the majority of the issue comes from that.
> 
> I've switched back to IETD now. With IETD I can copy with 55MiB/s to the
> device *whilst* reading from the same device (copy an ISO onto it, then
> copy the ISO from the disk back to the disk, then copy all copies couple
> of times - so both read/write). Iostat with IETD whilst writing shows
> say 110-120% read per write, however, in this case we were also actually
> reading. So to keep it simple, it read 110-120kB/s whilst writing
> 100kB/s per disk. This is a very serious difference. IETD is running in
> fileio mode (write-back), so it buffers too. So if we substract the
> actual reading it's IETD 10-20% read on 100% write, vs LIO 600-700% read
> on 100% write. That's quite upsetting.
> 

Are you enabling emulate_write_cache=1 with your iblock backends..? This
can have a gigantic effect on initiator performance for both MSFT +
Linux SCSI clients.

Also, you'll want to double check
your /sys/block/sdd/queue/max*sectors_kb for the MD RAID to make sure
the WRITEs are striped aligned to get best performance with software MD
raid.

> It seems to me the issue exists between LIO's buffers and mdadm. Why it
> writes so horribly inefficiently is beyond me though. I've invested
> quite some time in this already - however due to the way I've tested
> (huge intervals / different kernels, some disks have been swapped, etc)
> and my lack of in-depth kernel knowledge I don't think much of it is
> accurate enough to post here.
> 
> Can someone advise me how to proceed? I was hoping to switch to LIO and
> see a slight improvement in performance (besides more/better
> functionality as error correction and hopefully better stability). This
> has turned out quite differently unfortunately.
> 
> Do note - I'm running somewhat unorthodox. I've created a RAID-5 of 7
> disks + hotspare (it was originally a RAID-6 w/o hotspare but converted
> it to RAID-5 in hopes of improving performance). This disk is about
> 12TB. It's partitioned with GPT in ~9TB and ~2.5TB (there's huge
> rounding differences at these sizes 1000 vs 1024 et al :)). The 2.5TB
> currently isn't used. I've exported /dev/md4p1 thus. This in turn is
> partitioned (GPT - msdos isn't usable) in windows and used as a disk.
> 
> In order to do this I had to modify rtslib as it didn't recognize the
> md4p1 as a block device. I've added the major device numbers to the list
> there and could export it just 'fine' then. The issues might be related
> to this.
> 

There in lies the problem causing your OOPs.  IBLOCK is *not* intended
to export partitions from a block device.  There is a reason why rtslib
is preventing that from occuring.  ;)

Please use FILEIO with this reporting emulate_write_cache=1 (WCE=1) to
the SCSI clients.  Note that by default in the last kernel releases
we've change FILEIO backends to only always use O_SYNC to ensure data
consistency during a hard power failure, regardless of the
emulate_write_cache=1 setting.

Also note that by default it's my understanding that IETD uses buffered
FILEIO for performance, so in your particular type of setup you'd still
see better performance with buffered FILEIO, but would still have the
potential risk of silent data corruption with buffered FILEIO.

> If anyone is willing to help me modify the partition table so I can just
> export /dev/md4 I can test it.

Please use FILEIO for exporting partitions from block devices.  If you
still need the extra performance of buffered FILEIO for your seutp, +
understand the possible data integrity risks associated with using
buffered FILEIO during a hard power failure, I'm fine with re-adding
this back into target_core_file for v3.7 code for people who really know
what they are doing.

--nab
