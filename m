From: Doug Dumitru <doug@easyco.com>
Subject: Re: raid0 vs. mkfs
Date: Sun, 27 Nov 2016 11:25:55 -0800
Message-ID: <CAFx4rwRiTtMdkGLT5y3RkE-zvBjnhvxSgh_2BXxeWCstZ3+8dA@mail.gmail.com>
References: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
 <470ba5d0-e54d-3e5e-c639-4591549b9574@suse.de> <14c4b1d4-2fd3-b97f-934e-414a8d45fb18@scylladb.com>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <14c4b1d4-2fd3-b97f-934e-414a8d45fb18@scylladb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Avi Kivity <avi@scylladb.com>
Cc: Coly Li <colyli@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I recently ran into this issue with a proprietary device mapper target
that supports discard.

mkfs.ext4 looks like it issues 2GB discard requests.  blkdiscard looks
like it issues 4GB-4K discard requests.  Both of these are "way
bigger" than the iolimits for transfers.

At least this is what I see at my device mapper layer.  raid0 might
get some additional filtering by the common raid code.

In the case of my mapper, I actually need to split the bio up and
re-issue the discards at iolimits sizes (this is how my device mapper
expects requests).  Fortunately, my mapper is really fast at discards
even at 1MB each (> 8GB/sec on a single thread), so the performance
issue is not that bad.

It would be an easy patch for raid0 to be "smarter" at splitting the
discard request.  It might not actually help that much.  You should
test your nVME disk to see if the performance of discards is much
different between "chunk size" requests and "big requests".  Using
blkdiscard in a script, fill a drive with real data and test discard
speed first using 256K calls to blkdiscard, and then again using 512MB
calls to blkdiscard.  Do this to a single drive.  I suspect that the
times will not be that far off.

Some drives take a real amount of time to process discards.  Even
though it seems like the operation does nothing, the FTL inside of the
SSD is still is getting hammered pretty hard.

If your drives are a "lot" faster with bigger discard requests, then
maybe it would make sense to optimize raid0.  I suspect the win is not
that big.

In terms of enlarging IO, the iolimits and buffering start to come
into play.  With a discard, the bio only has a size and does not have
any actual buffers.  If you push IO really big, then the size of the
bio starts to grow.  1MB is 256 4K biovecs.  A bio_vec is a pointer
plus two ints, so it is 16 bytes long (on x86_64).  256 of these just
happen to fit into a single page.  This is a linear array, so making
this bigger is hard.  Remember that much of the kernel lives inside of
pages and pages (usually 4K) are somewhat of a deity over the entire
kernel.

Then again, you have another option to format your array that will be
very fast and even more effective:

a) secure erase the drives
b) create your raid0 array
c) create your file system with -o nodiscard

Doug Dumitru

On Sun, Nov 27, 2016 at 9:25 AM, Avi Kivity <avi@scylladb.com> wrote:
> On 11/27/2016 07:09 PM, Coly Li wrote:
>>
>> On 2016/11/27 =E4=B8=8B=E5=8D=8811:24, Avi Kivity wrote:
>>>
>>> mkfs /dev/md0 can take a very long time, if /dev/md0 is a very large
>>> disk that supports TRIM/DISCARD (erase whichever is inappropriate).
>>> That is because mkfs issues a TRIM/DISCARD (erase whichever is
>>> inappropriate) for the entire partition. As far as I can tell, md
>>> converts the large TRIM/DISCARD (erase whichever is inappropriate) into
>>> a large number of TRIM/DISCARD (erase whichever is inappropriate)
>>> requests, one per chunk-size worth of disk, and issues them to the RAID
>>> components individually.
>>>
>>>
>>> It seems to me that md can convert the large TRIM/DISCARD (erase
>>> whichever is inappropriate) request it gets into one TRIM/DISCARD (eras=
e
>>> whichever is inappropriate) per RAID component, converting an O(disk
>>> size / chunk size) operation into an O(number of RAID components)
>>> operation, which is much faster.
>>>
>>>
>>> I observed this with mkfs.xfs on a RAID0 of four 3TB NVMe devices, with
>>> the operation taking about a quarter of an hour, continuously pushing
>>> half-megabyte TRIM/DISCARD (erase whichever is inappropriate) requests
>>> to the disk. Linux 4.1.12.
>>
>> It might be possible to improve a bit for DISCARD performance, by your
>> suggestion. The implementation might be tricky, but it is worthy to try.
>>
>> Indeed, it is not only for DISCARD, for read or write, it might be
>> helpful for better performance as well. We can check the bio size, if,
>>         bio_sectors(bio)/conf->nr_strip_zones >=3D SOMETHRESHOLD
>> it means on each underlying device, we have more then SOMETHRESHOLD
>> continuous chunks to issue, and they can be merged into a larger bio.
>
>
> It's true that this does not strictly apply to TRIM/DISCARD (erase whiche=
ver
> is inappropriate), but to see any gain for READ/WRITE, you need a request
> that is larger than (chunk size) * (raid elements), which is unlikely for
> reasonable values of those parameters.  But a common implementation can o=
f
> course work for multiple request types.
>
>> IMHO it's interesting, good suggestion!
>
>
> Looking forward to seeing an implementation!
>
>
>>
>> Coly
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Doug Dumitru
EasyCo LLC
