From: pg@mdraid.list.sabi.co.UK (Peter Grandi)
Subject: Re: mdcheck: slow system issues
Date: Tue, 31 Mar 2020 11:53:07 +0100
Message-ID: <24195.8467.378436.7747@base.ty.sabi.co.uk>
References: <2933dddc-8728-51ac-1c60-8a47874966e4@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2933dddc-8728-51ac-1c60-8a47874966e4@molgen.mpg.de>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Dear Linux folks, When `mdcheck` runs on two 100 TB software
> RAIDs our users complain about being unable to open files in a
> reasonable time. [...]
>       109394518016 blocks super 1.2 level 6, 512k chunk,
> algorithm 2 [16/16] [UUUUUUUUUUUUUUUU]

Unsurprisingly it is a 16-wide RAID6 of 8TB HDDs.

> [...] The article *Software RAID check - slow system issues*
> [1] recommends to lower `dev.raid.speed_limit_max`, but the
> RAID should easily be able to do 200 MB/s as our tests show
> over 600 MB/s during some benchmarks.

Many people have to find out the hard way that on HDDs
sequential and random IO rates differ by "up to" two orders of
magnitude, and that RAID6 gives an "interesting" tradeoff
between read and write speed with random vs. sequential access.

> How do you run `mdcheck` in production without noticeably
> affecting the system?

Fortunately the only solution that works well is quite simple:
replace the storage system with one with much increased
IOPS-per-TB (that is SSDs or much smaller HDDs, 1TB or less)
*and* switch from RAID6 to RAID10.
