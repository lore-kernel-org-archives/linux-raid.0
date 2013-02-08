From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance
Date: Thu, 07 Feb 2013 21:32:58 -0600
Message-ID: <511471EA.2000605@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Cundiff <syshackmin@gmail.com>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/7/2013 5:07 AM, Dave Cundiff wrote:

> Its not going to help your remote access any. From your configuration
> it looks like you are limited to 4 gigabits. At least as long as your
> NICs are not in the slot shared with the disks. If they are you might
> get some contention.
> 
> http://download.intel.com/support/motherboards/server/sb/g13326004_s1200bt_tps_r2_0.pdf
> 
> See page 17 for a block diagram of your motherboard. You have a 4x DMI
> connection that PCI slot 3, your disks, and every other onboard device
> share. That should be about 1.2GB(10Gigabits) of bandwidth. 

This is not an issue.  The C204 to LGA1155 connection is 4 lane DMI 2.0,
not 1.0, so that's 40Gb/s and 5GB/s duplex, 2.5GB/s each way, which is
more than sufficient for his devices.

> Your SSDs
> alone could saturate that if you performed a local operation. 

See above.  However, using an LSI  9211-8i, or better yet a 9207-8i, in
SLOT6 would be more optimal:

1.  These board's ASICs are capable of 320K and 700K IOPS respectively.
 As good as it may be, the Intel C204 Southbridge SATA IO processor is
simply not in this league.  Whether it is a bottleneck in this case is
unknown at this time, but it's a possibility, as the C204 wasn't
designed with SSDs in mind.

2.  SLOT6 is PCIe x8 with 8GB/s bandwidth, 4GB/s each way, which can
handle the full bandwidth of 8 of these Intel 480GB SSDs.

> Get your
> NIC's going at 4Gig and all of it a sudden you'll really want that
> SATA card in slot 4 or 5.

Which brings me to the issue of the W2K DC that seems to be at the root
of the performance problems.  Adam mentioned one scenario, where a user
was copying a 50GB file from "one drive to another" through the Windows
DC.  That's a big load on any network, and would tie up both bonded GbE
links for quite a while.  All of these Windows machines are VM guests
whose local disks are apparently iSCSI targets on the server holding the
SSD md/RAID5 array.  This suggests a few possible causes:

1.  Ethernet interface saturation on Xen host under this W2K file server
2.  Ethernet bonding isn't configured properly and all iSCSI traffic
    for this W2K DC is over a single GbE link, limiting throughput to
    less than 100MB/s.
3.  All traffic, user and iSCSI, traversing a single link.
4.  A deficiency in the iSCSI configuration yielding significantly less
    than 100MB/s throughput.
5.  A deficiency in IO traffic between the W2K guest and the Xen host.
6.  And number of kernel tuning issues on the W2K DC guest causing
    network and/or iSCSI IO issues, memory allocation problems, pagefile
    problems, etc.
7.  A problem with the 16 port GbE switch, bonding or other.  It would
    be very worthwhile to gather metrics from the switch for the ports
    connected to the Xen host with the W2K DC, and the storage server.
    This could prove to be enlightening.

-- 
Stan




