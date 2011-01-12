From: NeilBrown <neilb@suse.de>
Subject: Re: advanced data recovery project for the wife - need help with
 raid6 layout P&Q ordering
Date: Wed, 12 Jan 2011 17:34:27 +1100
Message-ID: <20110112173427.17e84e2f@notabene.brown>
References: <AANLkTiknO4kvOU7JRY_EzFx1=bb7yGm8Yi5BNuLqE-q1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTiknO4kvOU7JRY_EzFx1=bb7yGm8Yi5BNuLqE-q1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brian Wolfe <brianw@terrabox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 11 Jan 2011 23:47:12 -0600 Brian Wolfe <brianw@terrabox.com> wrote:

> For a period of a year I've had power loss to more than one drive on
> more than one ocasion (y cables SUCK). a month ago I had power loss
> after I dist-upgrade my debian server with a raid6 array of 8 drives.
> I then proceeded to re-create the raid array only to discover to my
> horror that 2 things were seriously wrong. #1 The 2.6.32 kernel
> discovered the sata HDDs in a different order than the 2.6.26 kernel.
> So /dev/sdc was now /dev/sdg  type scenario.  Horror #2 was that I
> forgot to specify --assume-clean on the re-creation. Horror #3 is that
> I discovered that the dist-upgrade had also updated mdadm so that it
> used superblock version 1.2 when the raid array had been created with
> superblock version 0.9.

ouch.


> 
> Now I'm in the process of writing a C app that is assisting me to
> identify which chunks in each stripe of the raid array is data and
> which is parity. I was successful at discovering the original ordering
> of the drives using my app and have recreated the array with
> --assume-clean under 2.6.26 with superblock ver 0.9. So far so good. I
> now find the ReIsEr2Fs and ReIsErLB tags at the proper offsets based
> on the LVM2 metadata that I had a backup of. However I'm still seeing
> data corruption in chunks that appears to be semi-random.
> 
> so, assuming the following parameters used to run mdadm with the
> proper flags for chunk size, pairity, etc, what should the ordering of
> the data, P and Q chunks be on the stripes?  I attempted to work this
> out by reading wikipedia's raid6, and the kernel code and various
> pages on the net, but none of them seem to agree. 8-(

The kernel code is of course authoritative.  Ignore everything else.

You have an 8-drive left-symmetric RAID6 so the first 16 stripes should
be:

Q   D0  D1  D2  D3  D4  D5  P 
D6  D7  D8  D9  D10 D11 P   Q
D13 D14 D15 D16 D17 P   Q   D12
D20 D21 D22 D23 P   Q   D18 D19
D27 D28 D29 P   Q   D24 D25 D26
D34 D35 P   Q   D30 D31 D32 D33
D41 P   Q   D36 D37 D38 D39 D40
P   Q   D42 D43 D44 D45 D46 D47
Q   D48 D49 D50 D51 D52 D53 P

... and so forth.

good luck.

NeilBrown


> 
> Can anyone tell me what that ordering or chunks should be for the
> first 16 stripes so that I can finally work out the bad ordering under
> 2.6.32 and rebuild my raid array "by hand"?
> 
> Yes, I permanently "fixed" the Y cable problem by manufacturing a
> power backplane for the 12 drives in the system. :)
> 
> Thanks!
> 
> 
> #mdadm --examine /dev/sdc
> 
> /dev/sdc:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 5108f419:93f471c4:36668fe2:a3f57f0d (local to host iscsi1)
>   Creation Time : Tue Dec 21 00:55:29 2010
>      Raid Level : raid6
>   Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
>      Array Size : 5860574976 (5589.08 GiB 6001.23 GB)
>    Raid Devices : 8
>   Total Devices : 8
> Preferred Minor : 0
> 
>     Update Time : Tue Dec 21 00:55:29 2010
>           State : clean
>  Active Devices : 8
> Working Devices : 8
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 3cdf9d27 - correct
>          Events : 1
> 
>          Layout : left-symmetric
>      Chunk Size : 128K
> 
>       Number   Major   Minor   RaidDevice State
> this     0       8       32        0      active sync   /dev/sdc
>    0     0       8       32        0      active sync   /dev/sdc
>    1     1       8       96        1      active sync   /dev/sdg
>    2     2       8      128        2      active sync   /dev/sdi
>    3     3       8      144        3      active sync   /dev/sdj
>    4     4       8       64        4      active sync   /dev/sde
>    5     5       8       80        5      active sync   /dev/sdf
>    6     6       8       48        6      active sync   /dev/sdd
>    7     7       8      112        7      active sync   /dev/sdh
> i
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

