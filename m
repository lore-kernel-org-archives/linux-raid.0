From: "Gordon Mohr (@ Bitzi)" <gojomo@bitzi.com>
Subject: Re: madadm man page ambiguities: '--size' units, superblock affordance
Date: Sun, 02 Oct 2005 13:52:00 -0700
Message-ID: <43404870.90305@bitzi.com>
References: <433EFDD0.3010307@bitzi.com> <4340049C.80406@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4340049C.80406@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the clarifications!

The precision is important in my case, because I'm trying to
shrink an existing array -- first the filesystem, then the RAID
array, then the constituent partitions. I fear if I specify
any new sizes incorrectly, the next thing on disk (superblock
or future new subsequent partition) could be overwritten and
corrupted.

There are still two areas where additional details about the
mdadm behavior would help (see below)...

Paul Clements wrote:
> Gordon Mohr (@ Bitzi) wrote:
> 
>> My 'mdadm' (v1.6.0) man page includes:
>>
>> #       -z, --size=
>> #              Amount  (in  Kibibytes)  of  space  to  use  from each drive in
>> #              RAID1/4/5/6.  This must be a multiple of the  chunk  size,  and
>> #              must leave about 128Kb of space at the end of the drive  for the
>> #              RAID superblock.  If this is not specified (as it  normally  is
>> #              not) the smallest drive (or partition) sets the size, though if
>> #              there is a variance among the drives  of  greater  than  1%,  a
>> #              warning is issued.
>>
>> There are several problems when trying to interpret the phrase "This must be a
>> multiple of the chunk  size,  and must leave about 128Kb of space at the end of
>> the drive for the RAID superblock."
>>
>> (1) Someone resizing an array may not know the chunk size, and it's unclear
>> if assuming the default of 64 is OK, or dangerous. (My experiments show that
>> 'mdadm' will accept a size value that is not a multiple of 64, and will update
>> the array size as shown by --detail to this non-multiple size, at least for
>> RAID1. Does this risk disaster?)
> 
> 
> RAID1 doesn't use chunk size, so chunk size is completely irrelevant 
> here. But, for the RAID levels that use chunk size, things are handled 
> correctly -- mdadm will round the size to a chunk multiple.

OK. Does it round to nearest, or consistently up or down? (This
isn't relevant for my RAID1 case, but if it were rounding up
without the user realizing it, wouldn't a following partition on
disk be at risk?)

>> (2) "Kb" is technically the abbrieviation of "kilobits", not "kibibytes". I'm
>> assuming "128Kb" means "128 kibibytes" from the preceding context. I suggest
>> avoiding the abbrieviation entirely to avoid confusion.
>>
>> (3) To "leave" space is ambiguous in what it means for the value specified.
>> Should the we take the amount of space needed for our filesystem and add 128K
>> to get the 'size' value to specify? Or specify exactly what's needed for
>> the filesystem, and be aware that RAID will actually use 128K more on
>> the consitutent devices than what was specified? (I *think* the second is
>> meant, but I'm not sure.)
> 
> 
> Yes. You are specifying the "data" size. The superblock will be located 
> somewhere in the 128KB past the data.

OK.

>> (4) The imprecise "about 128Kb" raises the question: is more than 128K
>> sometimes needed? If I "leave" exactly 128K, is that a recipe for 
>> eventual disaster when someday the superblock goes over this allotment?
> 
> 
> No. The superblock takes 4K. The thing that makes the 128KB number 
> variable is the algorithm used to locate the superblock. The superblock 
> is always placed between 64 and 128 KB from the end of the disk:
> 
> super_location = disk_size - (disk_size % 64KB) - 64KB
> 
> All this being said, you rarely need to actually specify the array size. 
> mdadm is smart enough to figure all this out and use all available disk 
> capacity, which is almost always what you want.

For the case where I'm intentionally creating a smaller
array, which does not use all of the underlying partition
capacity, does this mean I should do things in the order...
   (1) shrink filesystem
   (2) shrink consituent partition(s)
   (3) shrink RAID
...so the 'disk_size' (really, partition_size) can be
consulted to determine the new superblock location? Or,
does the formula actually work forward from the data_size
rather than back from the disk_size when specifying a
smaller-than-default array?

Finally, once this is all clear to me, I could write up
a new suggested  wording for the man page that removes the
ambiguities. Would posting that here give it a chance to
be integrated into a future man page revision?

Thanks,

- Gordon @ Bitzi
