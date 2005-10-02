From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: madadm man page ambiguities: '--size' units, superblock affordance
Date: Sun, 02 Oct 2005 12:02:36 -0400
Message-ID: <4340049C.80406@steeleye.com>
References: <433EFDD0.3010307@bitzi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <433EFDD0.3010307@bitzi.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Gordon Mohr (@ Bitzi)" <gojomo@bitzi.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gordon Mohr (@ Bitzi) wrote:
> My 'mdadm' (v1.6.0) man page includes:
> 
> #       -z, --size=
> #              Amount  (in  Kibibytes)  of  space  to  use  from each 
> drive in
> #              RAID1/4/5/6.  This must be a multiple of the  chunk  
> size,  and
> #              must leave about 128Kb of space at the end of the drive 
> for the
> #              RAID superblock.  If this is not specified (as it  
> normally  is
> #              not) the smallest drive (or partition) sets the size, 
> though if
> #              there is a variance among the drives  of  greater  than  
> 1%,  a
> #              warning is issued.
> 
> There are several problems when trying to interpret the phrase "This 
> must be a
> multiple of the chunk  size,  and must leave about 128Kb of space at the 
> end of
> the drive for the RAID superblock."
> 
> (1) Someone resizing an array may not know the chunk size, and it's unclear
> if assuming the default of 64 is OK, or dangerous. (My experiments show 
> that
> 'mdadm' will accept a size value that is not a multiple of 64, and will 
> update
> the array size as shown by --detail to this non-multiple size, at least for
> RAID1. Does this risk disaster?)

RAID1 doesn't use chunk size, so chunk size is completely irrelevant 
here. But, for the RAID levels that use chunk size, things are handled 
correctly -- mdadm will round the size to a chunk multiple.


> (2) "Kb" is technically the abbrieviation of "kilobits", not 
> "kibibytes". I'm
> assuming "128Kb" means "128 kibibytes" from the preceding context. I 
> suggest
> avoiding the abbrieviation entirely to avoid confusion.
> 
> (3) To "leave" space is ambiguous in what it means for the value specified.
> Should the we take the amount of space needed for our filesystem and add 
> 128K
> to get the 'size' value to specify? Or specify exactly what's needed for
> the filesystem, and be aware that RAID will actually use 128K more on
> the consitutent devices than what was specified? (I *think* the second is
> meant, but I'm not sure.)

Yes. You are specifying the "data" size. The superblock will be located 
somewhere in the 128KB past the data.

> (4) The imprecise "about 128Kb" raises the question: is more than 128K
> sometimes needed? If I "leave" exactly 128K, is that a recipe for eventual
> disaster when someday the superblock goes over this allotment?

No. The superblock takes 4K. The thing that makes the 128KB number 
variable is the algorithm used to locate the superblock. The superblock 
is always placed between 64 and 128 KB from the end of the disk:

super_location = disk_size - (disk_size % 64KB) - 64KB

All this being said, you rarely need to actually specify the array size. 
mdadm is smart enough to figure all this out and use all available disk 
capacity, which is almost always what you want.

--
Paul
