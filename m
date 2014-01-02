From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: The chunk size paradox
Date: Thu, 2 Jan 2014 22:49:01 +0000
Message-ID: <21189.60637.335108.860116@tree.ty.sabi.co.uk>
References: <52C1C01A.7010407@ubuntu.com>
	<52C57C7B.80400@shiftmail.org>
	<52C588A7.6010207@hardwarefreak.com>
	<52C59468.6080200@ubuntu.com>
	<52C5A9AA.9090300@hardwarefreak.com>
	<52C5B9AE.6050901@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C5B9AE.6050901@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ .... ]

>> There are no native 4K sector drives on the market. Linux
>> does not support a native 4K sector size, only 512 bytes,
>> unless this has changed in recent kernels and I'm simply not
>> aware of it yet.

> Linux has supported 4k sectors for several years. You can test
> it with the scsi_debug module and it's sector_size argument.
> The parted test suite has been doing this for a few years to
> test that parted correctly handles 1k, 2k, and 4k sector
> sizes.

Indeed, but 2KiB is a bit theoretical that I don't think any
hard disks have 2KiB sectors. The 4KiB sector size transition
has been a problem for a 2-3 years after 2009, so that 4KiB
hardware sector support is now approximately 5 years old:

  http://lwn.net/Articles/322777/

    =ABLinux and 4K disk sectors March 11, 2009

    [ ... ] Matthew Wilcox recently posted a patch to support 4K
    sectors according to the ATA-8 standard (PDF). [ ... ]=BB

as the kernel and tools got updated slowly, and it is one reason
of the new partition alignment default to 1MB.

In the MS-Windows world it is better know as "Advanced Format":

  http://en.wikipedia.org/wiki/Advanced_Format

One of the annoying consequences is that parity-RAID (when not
using MD) of with less than 8 data drives would have stripe-let
sizes under the common 4KiB filesystem block size, which was
exploited cleverly by DDN with their standard 8+2 RAID3 (sort of
RAID3...) products. They have switched to another arrangement
now that 4KiB drives are fairly common.

=46or MD RAID this did not matter because MD RAID does IO in page
cache units, that is base VM pages which on IA32/AMD64 CPUs is
4KiB anyhow, regardless of a smaller physical sector size.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
