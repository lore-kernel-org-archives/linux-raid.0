From: "Andre' Breiler" <andre.breiler@null-mx.org>
Subject: Re: RAID strangeness
Date: Tue, 27 May 2003 07:23:08 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0305270713440.680-100000@pegasus.teamwerk.com>
References: <3ED3158B.3080200@whack.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3ED3158B.3080200@whack.org>
To: Bruce Pinsky <bep@whack.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Bruce,

On Tue, 27 May 2003, Bruce Pinsky wrote:

> I have a four disk RAID 5 array running on my SPARC 10 running Debian
> 3.0+ (2.4.20 kernel) and RAID raidtools-0.90 with this raidtab:

[snip] as it has nothing to do with raid.

> It was up and running for more than a month until this weekend.  My
> system rebooted unexpectedly (looks like a power failure at this point)
> and when it rebooted I got this message:
>
> raid5: measuring checksumming speed
>     8regs     :    60.000 MB/sec
>     32regs    :    62.400 MB/sec
>     SPARC     :    81.600 MB/sec
> raid5: using function: SPARC (81.600 MB/sec)
> md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
> md: raid5 personality registered as nr 4
> md: could not lock sdc1, zero-size? Marking faulty.
> md: could not import sdc1!
> md: autostart sdc1 failed!
>
> Investigation has led me to think that my partition tables have
> disappeared based on this:

> Disk /dev/sdc: 64 heads, 32 sectors, 8683 cylinders
> Units = cylinders of 2048 * 512 bytes
>
> Disk /dev/sdc doesn't contain a valid partition table

I guess your partitions started from the beginning of the disk.

> Thankfully nothing too important on the array yet, but I'm concerned for
> when I do put stuff on it.  Anyone seen a situation where the array
> craps and the partition tables are missing?   Can it be recovered?
> Something wrong with my RAID setup?

Yes I've seen that before but it isn't a problem with raid but sparc/linux
.

If you start your partition from the beginning of your drive then
the partition table will be overwritten when data is written at the
beginning of the first partition.

You can recover your partition table (guess the bounderies) but make sure
you don't write it to the drive or you will overwrite a bit of the first
partition.

Hope that helps,
 Andre'
-- 

