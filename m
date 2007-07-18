From: Rui Santos <rsantos@grupopie.com>
Subject: Re: Slow Soft-RAID 5 performance
Date: Wed, 18 Jul 2007 18:13:19 +0100
Message-ID: <469E4A2F.2010807@grupopie.com>
References: <469DE3BB.9070604@grupopie.com> <Pine.LNX.4.64.0707180626481.7659@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707180626481.7659@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Justin Piszcz wrote:
>
>
> On Wed, 18 Jul 2007, Rui Santos wrote:
>
>> Hi,
>>
>> I'm getting a strange slow performance behavior on a recently installed
>> Server. Here are the details:
>>
>> Server: Asus AS-TS500-E4A
>> Board: Asus DSBV-D (
>> http://uk.asus.com/products.aspx?l1=9&l2=39&l3=299&l4=0&model=1210&modelmenu=2
>>
>> )
>> Hard Drives: 3x Seagate ST3400620AS (
>> http://www.seagate.com/ww/v/index.jsp?vgnextoid=8eff99f4fa74c010VgnVCM100000dd04090aRCRD&locale=en-US
>>
>> )
>> I'm using the AHCI driver, although with ata_piix, the behavior is the
>> same. Here's some info about the AHCI controler:
>>
>
> With three disks, if everything was perfect yeah 120MB/s writes.  When
> I had started out with 4 raptors I was getting 164MB/s read and
> write.  By default with no optimizations you will not get good speed.
>
> With no optimizations with 10 raptors I get 180-200MB/s, with
> optimizations, 464MB/s write and 622MB/s read.
>
> 1. Use XFS if you wan't speed.
> 2. Use 128k, 256k or 1MiB chunk size.
> 3. Use 8192k, 16384k stripe_cache_size.
> 4. Use 65536 readahead size.
>
> These are only some of the optimizations I use.
Thank you for your reply.

I've used: 1) xfs, 2) 256k, 3) 16384k and 4) 65536 readahead.

Also tryed ext3 with --stride option. The speed is just a bit slower...

I can get ~100MB/sec.

The hardware is capable of doing better tough...

Thanks for your help.
>
> Justin.
Rui Santos

>
>
>
>

