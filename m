From: Neil Brown <neilb@suse.de>
Subject: Re: Question about preferred minor.
Date: Thu, 3 Jun 2010 11:13:16 +1000
Message-ID: <20100603111316.74d96d1f@notabene.brown>
References: <AANLkTimbMat99Su8F4FauQIa8mpeZJk6syJ0oXjHyygG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimbMat99Su8F4FauQIa8mpeZJk6syJ0oXjHyygG@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Dunn <andrew.g.dunn.dod@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2 Jun 2010 20:53:28 -0400
Andrew Dunn <andrew.g.dunn.dod@gmail.com> wrote:

> I have never noticed this, my apologies for not being able to resolve
> this independently.
> 
> I have this array that I am using for the primary bulk of my data and
> today was the first day that I noticed this designator in the detailed
> output:
> 
> storrgie@MINERVA:~$ sudo mdadm -D /dev/md2
> /dev/md2:
>         Version : 00.90
>   Creation Time : Fri Apr 30 21:13:28 2010
>      Raid Level : raid6
>      Array Size : 11721071616 (11178.09 GiB 12002.38 GB)
>   Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
>    Raid Devices : 8
>   Total Devices : 8
> Preferred Minor : 2
>     Persistence : Superblock is persistent
snip
> 
> What is the meaning of Preferred Minor : 2 ?

It means that if the array is auto-assembled, whether by the kernel with
auto-detect or by mdadm with --incremental or '-As', it will be assembled
as /dev/md2 - i.e. the device file will have a major number of 9 (meaning
an md raid array) and the minor number will be 2.

NeilBrown


> 
> Thank you all.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

