From: Yann Ormanns <yann-ormanns@web.de>
Subject: Re: Do I understand my RAID6 correctly?
Date: Tue, 12 Apr 2011 11:23:36 +0200
Message-ID: <4DA41A18.9030602@web.de>
References: <4DA40FA4.80605@xunil.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DA40FA4.80605@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Subject: Do I understand my RAID6 correctly?
From: Stefan G. Weichinger <lists@xunil.at>
To: Yann Ormanns <yann-ormanns@web.de>
Date: 2011-04-12 11:11 (+0200)

>      Array Size : 4391334912 (4187.90 GiB 4496.73 GB)
>   Used Dev Size : 731889152 (697.98 GiB 749.45 GB)
>    Raid Devices : 8
>   Total Devices : 9
> Preferred Minor : 3
>     Persistence : Superblock is persistent
> 
>  Active Devices : 8
> Working Devices : 8
>  Failed Devices : 1

You now have 9 devices in this Array (750GB*8 = 6 TB, 6 TB - (2*750GB) =
4.5 TB). One of them is the failed spare disk. That means, that this
array can "lose" two disks without losing data, as you already wrote.

Of course you can re-use /dev/sdk as a spare disk, but before, you
should check, why it failed (SMART data for example).

You should also have a look at the used drive models. E.g. if this array
uses 9x model XYZ from manucaturer ABC, perhaps more drives will fail in
the next time.
If the array uses mixed models, it should not be THAT urgent - but that
depends on the importance of the data...
I've read several times of people losing their RAID6, because they did
not mix the hard drive models. Then, a manufacturing fault have very bad
consequences.

Best regards,
Yann
