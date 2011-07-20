From: "Pol Hallen" <raid1@fuckaround.org>
Subject: Re: standard performance (write speed 20Mb/s)
Date: Wed, 20 Jul 2011 22:02:40 +0200 (CEST)
Message-ID: <c5a1a83b370a0ddb063cfc828f124e6d.squirrel@fuckaround.org>
References: <201107181403.49563.raid1@fuckaround.org>
    <4E26CAA7.8030201@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E26CAA7.8030201@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Pol Hallen <raid1@fuckaround.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> This mishmash combo of drives, including two WD Green Advanced Format
> drives, is likely the cause of the horrible write performance.  You're
> assembling the array from partitions.

first of all: sorry but my english is not good :-(

In many howto I read:

"create a partition of disk and change it to "fd" code: linux raid
autodetect"

Now I re-done whole raid (I already have a backup)

I have to create a partition on sigle disk? or remove any partition and stop?

>  The partitions on the WD20EARS
> drives are undoubtedly not 4KB sector aligned, causing excessive
> read-modify-write cycles.  See:
> http://en.wikipedia.org/wiki/Advanced_Format
> Repartition the Green drives with proper alignment.  If you still have
> issues we'll go from there.  Note:  Having 3 dissimilar drives in an
> array is never going to be an optimally performing solution.

Now I re-create a new raid system with 6 disks (everyone 2Tb wd)

How do about 4Kb sector align?

thanks!

Pol

