From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: The chunk size paradox
Date: Thu, 02 Jan 2014 17:16:05 -0600
Message-ID: <52C5F335.9060909@hardwarefreak.com>
References: <52C1C01A.7010407@ubuntu.com> <52C57C7B.80400@shiftmail.org> <52C588A7.6010207@hardwarefreak.com> <52C59468.6080200@ubuntu.com> <52C5A9AA.9090300@hardwarefreak.com> <52C5B9AE.6050901@ubuntu.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C5B9AE.6050901@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, joystick <joystick@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/2/2014 1:10 PM, Phillip Susi wrote:
> On 1/2/2014 1:02 PM, Stan Hoeppner wrote:
>> There are no native 4K sector drives on the market.  Linux does
>> not support a native 4K sector size, only 512 bytes, unless this
>> has changed in recent kernels and I'm simply not aware of it yet.
> 
> Linux has supported 4k sectors for several years.  You can test it
> with the scsi_debug module and it's sector_size argument.  The parted
> test suite has been doing this for a few years to test that parted
> correctly handles 1k, 2k, and 4k sector sizes.  You can also set up
> qemu to emulate such a drive.

Thank you for this information.  Now, if I actually had a 4K drive in my
hands, and plugged it in, directly formatted it with XFS, no partitions,
would the LBA addressing be 4K or 512B?  Or would I need to tweak kernel
parameters?  Or possibly rebuild my kernel to support 4K sectors?

> While most consumer level sata drives that use 4k hardware sectors
> have 512 byte logical sector emulation, there are at least a few
> drives out there that do not, and are pure 4k sector drives.

I'm still waiting to hear an announcement from a vendor, or see a link
from someone claiming this to be true.

>>> CD-ROM type drives have always used 2k sectors.  Also
>>
>> This is not relevant to this discussion.
> 
> Sure it is; it's a non 512 byte sector that linux has handled for many
> years and so disproves your assertion that a sector is always 512 bytes.

It's not relevant because you don't create an md RAID set from CD-ROM.

>> Yes, they are necessarily 4K in Linux.  Linux only supports page
>> sized BIO for consistency across the memory manager and IO
>> subsystems.  Most architectures which Linux currently supports have
>> hardware page sizes greater than 4K, for instance IA64 supports
>> 4k/8k/16k, even a 4GB page size.  But it was decided long ago to
>> stick with 4K for a number of reasons, one of these is stated
>> above.  For background on this Google is your friend.
> 
> Wrong, wrong wrong.  

If you say it 3 times does that make it 3x more likely to be true? :)

> Linux always has supported ext[234] filesystems
> using 1k, 2k, or 4k filesystem block sizes.  Now basically nobody has
> used the smaller sizes for quite a few years ( they were originally
> useful on 1-100 MB disks ), but it is still supported.  

I'll take your that it is still supported, FSVO 'supported'.

> It can use
> larger sizes than that, if your platform has > 4k page size.  The page

IIRC, there was a lengthy discussion about this on mm back when some
folks wanted to use 16K-4GB pages on Itanium, and later 2M pages on
x86-64, to cut down on the amount of memory required for page tables and
to increase performance for big memory workloads.  As I recall the
arguments for continuing to use 4K pages across the world of Linux,
regardless of architecture capability, and to NOT make it configurable
as in HP-UX, were, paraphrasing:

1.  The kernel manipulates "everything" in pages so we need consistency
2.  While larger pages saves page table space and increases throughput
    for large memory intensive workloads, it causes more waste in other
    structures and increases bandwidth demands for data that are
    smaller than the page size

So, IIRC, it was decided that the page size would remain 4K basically
forever.  So while it is *technically* possible to have a larger page
size in Linux, it is absolutely not supported by the kernel team, nor
any distro kernel, AFAIK.

> Several cpu
> archs give you the option to choose between different page sizes when
> building the kernel, so yes, you can choose to use the larger sizes
> rather than the default 4k.

And I'd guess a whole host of things will likely break as a result if
you don't correctly modify much of the kernel source before running
make.  See above.

-- 
Stan
