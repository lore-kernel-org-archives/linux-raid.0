From: David Greaves <david@dgreaves.com>
Subject: Re: readahead (blockdev --setra) with sw raid(5)?
Date: Sat, 27 Nov 2004 23:52:29 +0000
Message-ID: <41A9133D.5000809@dgreaves.com>
References: <Pine.LNX.4.61.0411272328270.16979@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0411272328270.16979@adsl.a2000.nu>
Sender: linux-raid-owner@vger.kernel.org
To: Stephan van Hienen <raid@a2000.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I routinely use --setra 4096 on the underlying devices, the md array 
devices and the lvm devices
I am generally reading 1-2 gigabyte files.

I use XFS and it is often suggested as a good fs (though I think there 
may be some XFS/nfs issues with 2.6 at the moment - see lkml)

David

Stephan van Hienen wrote:

> Hi,
>
> just saw a 3ware document with some hints for hardware raid5
> they advice to use blockdev --setra 16384
>
> since i'm not using 3ware hardware raid
> (i'm using 2*7500 3ware's with sw raid5 over 14 disks)
> i'm wondering if --setra can still improve my raid performance
>
> any hints about this ?
> or some other hints, improvements on filesystem ?
> i'm currently using blocksize 128, maybe switching to 256 helps ? 
> (with large files)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

