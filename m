From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Slow Soft-RAID 5 performance
Date: Thu, 19 Jul 2007 12:03:46 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0707191203110.13957@p34.internal.lan>
References: <469DE3BB.9070604@grupopie.com> <Pine.LNX.4.64.0707180626481.7659@p34.internal.lan>
 <469F59E6.3050105@cgv.tugraz.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <469F59E6.3050105@cgv.tugraz.at>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Schimmer <l.schimmer@cgv.tugraz.at>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Thu, 19 Jul 2007, Lars Schimmer wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Justin Piszcz wrote:
>>
>>
>> On Wed, 18 Jul 2007, Rui Santos wrote:
>>
>>> Hi,
>>>
>>> I'm getting a strange slow performance behavior on a recently installed
>>> Server. Here are the details:
>>>
>>> Server: Asus AS-TS500-E4A
>>> Board: Asus DSBV-D (
>>> http://uk.asus.com/products.aspx?l1=9&l2=39&l3=299&l4=0&model=1210&modelmenu=2
>>>
>>> )
>>> Hard Drives: 3x Seagate ST3400620AS (
>>> http://www.seagate.com/ww/v/index.jsp?vgnextoid=8eff99f4fa74c010VgnVCM100000dd04090aRCRD&locale=en-US
>>>
>>> )
>>> I'm using the AHCI driver, although with ata_piix, the behavior is the
>>> same. Here's some info about the AHCI controler:
>>>
>>
>> With three disks, if everything was perfect yeah 120MB/s writes.  When I
>> had started out with 4 raptors I was getting 164MB/s read and write.  By
>> default with no optimizations you will not get good speed.
>>
>> With no optimizations with 10 raptors I get 180-200MB/s, with
>> optimizations, 464MB/s write and 622MB/s read.
>>
>> 1. Use XFS if you wan't speed.
>> 2. Use 128k, 256k or 1MiB chunk size.
>> 3. Use 8192k, 16384k stripe_cache_size.
>> 4. Use 65536 readahead size.
>>
>> These are only some of the optimizations I use.
>
> One question in between, which option of these I can set after RAID5 is
> filled with data?
> E.G. I setup a 9 disk SOFT-RAID5 with XFS and 3125669888 blocks level 5,
> 128k chunk, algorithm 2 [9/9] [UUUUUUUUU].
> Speed is not really fast, I assume it could be faster.

You can experiment with the stripe_cache_size and readahead size to
start with.

Justin.

