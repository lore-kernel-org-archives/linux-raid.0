From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] Skip bio copy in full-stripe write ops
Date: Sat, 24 Nov 2007 06:58:54 +1100
Message-ID: <18247.12542.178576.949603@notabene.brown>
References: <200711231514.28584.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Yuri Tikhonov on Friday November 23
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur@emcraft.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday November 23, yur@emcraft.com wrote:
> 
>  Hello all,
> 
>  Here is a patch which allows to skip intermediate data copying between the bio
> requested to write and the disk cache in <sh> if the full-stripe write operation is
> on the way.
> 
>  This improves the performance of write operations for some dedicated cases
> when big chunks of data are being sequentially written to RAID array, but in
> general eliminating disk cache slows the performance down.

There is a subtlety here that we need to be careful not to miss. 
The stripe cache has an import 'correctness' aspect that you might be
losing.

When a write request is passed to generic_make_request, it is entirely
possible for the data in the buffer to be changing while the write is
being processed.  This can happen particularly with memory mapped
files, but also in other cases.
If we perform the XOR operation against the data in the buffer, and
then later DMA that data out to the storage device, the data could
have changed in the mean time.  The net result will be that the that
parity block is wrong.
That is one reason why we currently copy the data before doing the XOR
(though copying at the same time as doing the XOR would be a suitable
alternative).

I can see two possible approaches where it could be safe to XOR out of
the provided buffer.

 1/ If we can be certain that the data in the buffer will not change
    until the write completes.  I think this would require the
    filesystem to explicitly promise not to change the data, possibly by
    setting some flag in the BIO.  The filesystem would then need its
    own internal interlock mechanisms to be able to keep the promise,
    and we would only be able to convince filesystems to do this if
    there were significant performance gains.

 2/ We allow the parity to be wrong for a little while (it happens
    anyway) but make sure that:
    a/ future writes to the same stripe use reconstruct_write, not
      read_modify_write, as the parity block might be wrong.
    b/ We don't mark the array or (with bitmaps) region 'clean' until
      we have good reason to believe that it is.  i.e. somehow we
      would need to check that the last page written to each device
      were still clean when the write completed.

I think '2' is probably too complex.  Part 'a' makes it particularly
difficult to achieve efficiently.

I think that '1' might be possible for some limited cases, and it
could be that those limited cases form 99% for all potential
stripe-wide writes.
e.g. If someone was building a dedicated NAS device and wanted this
performance improvement, they could work with the particular
filesystem that they choose, and ensure that - for the applications
that they use on top of it - the filesystem does not update in-flight
data.


But without the above issues being considered and addressed, we cannot
proceed with this patch......
  

> 
>  The performance results obtained on the ppc440spe-based board using the
> PPC440SPE ADMA driver, Xdd benchmark, and the RAID-5 of 4 disks are as
> follows:
> 
>  SKIP_BIO_SET = 'N': 40 MBps;
>  SKIP_BIO_SET = 'Y': 70 MBps.


.....which is a shame because that is a very significant performance
increase.... I wonder if that comes from simply avoiding the copy, or
whether there are some scheduling improvements that account for some
of it.... After all a CPU can copy data around at much more that
30MBps.

Thanks,
NeilBrown
