From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: The chunk size paradox
Date: Thu, 02 Jan 2014 14:10:38 -0500
Message-ID: <52C5B9AE.6050901@ubuntu.com>
References: <52C1C01A.7010407@ubuntu.com> <52C57C7B.80400@shiftmail.org> <52C588A7.6010207@hardwarefreak.com> <52C59468.6080200@ubuntu.com> <52C5A9AA.9090300@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C5A9AA.9090300@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, joystick <joystick@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/2/2014 1:02 PM, Stan Hoeppner wrote:
> There are no native 4K sector drives on the market.  Linux does
> not support a native 4K sector size, only 512 bytes, unless this
> has changed in recent kernels and I'm simply not aware of it yet.

Linux has supported 4k sectors for several years.  You can test it
with the scsi_debug module and it's sector_size argument.  The parted
test suite has been doing this for a few years to test that parted
correctly handles 1k, 2k, and 4k sector sizes.  You can also set up
qemu to emulate such a drive.

While most consumer level sata drives that use 4k hardware sectors
have 512 byte logical sector emulation, there are at least a few
drives out there that do not, and are pure 4k sector drives.

>> CD-ROM type drives have always used 2k sectors.  Also
> 
> This is not relevant to this discussion.

Sure it is; it's a non 512 byte sector that linux has handled for many
years and so disproves your assertion that a sector is always 512 bytes.

> Yes, they are necessarily 4K in Linux.  Linux only supports page
> sized BIO for consistency across the memory manager and IO
> subsystems.  Most architectures which Linux currently supports have
> hardware page sizes greater than 4K, for instance IA64 supports
> 4k/8k/16k, even a 4GB page size.  But it was decided long ago to
> stick with 4K for a number of reasons, one of these is stated
> above.  For background on this Google is your friend.

Wrong, wrong wrong.  Linux always has supported ext[234] filesystems
using 1k, 2k, or 4k filesystem block sizes.  Now basically nobody has
used the smaller sizes for quite a few years ( they were originally
useful on 1-100 MB disks ), but it is still supported.  It can use
larger sizes than that, if your platform has > 4k page size.  The page
cache limits the block size to the page size.  I believe it was the
drobo box that uses a larger block size and people often run into the
page cache problem when they try to pull the drive from the drobo and
mount it in their pc, which can't handle > 4k blocks, but the drobo's
cpu uses 32k pages so it could use 32k blocks just fine.  Several cpu
archs give you the option to choose between different page sizes when
building the kernel, so yes, you can choose to use the larger sizes
rather than the default 4k.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSxbmuAAoJEI5FoCIzSKrweyQIAIIJy4WfLpBkKzsallhvbgcn
i3nAkIpZSg1PYqLovYA+4bPjcjt1kDkikW3whl4PVBSE2rzGe9pS6fOtKbldQkZq
4vPVGRPIAP71iyJnA0TXM6NJpzoAVt+GBrY1N0aKFXFcPB5+wphDNWBNDWh8uYNG
mcH3HlQdbZB66yalsaik+w8pU/AItrLniTFvC3dybCVSqMdmghTKzqMjFU0sPmWK
zH9MtsLaTaRrQiYipYe+NbXsf5w8OgAaY1wxruMqW3BnI1cVFscSBXkS64hwYGBz
b5119Z3RgOWc+/BbdpLhNTP1y+qQmme/BVP84se8VRn25Zq/Qg0Jwau9xq4OlWg=
=yt5q
-----END PGP SIGNATURE-----
