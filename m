From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: bonnie++ benchmarks for ext2,ext3,ext4,jfs,reiserfs,xfs,zfs on
 software raid 5
Date: Mon, 30 Jul 2007 17:13:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0707301713150.7153@p34.internal.lan>
References: <Pine.LNX.4.64.0707301021090.12456@p34.internal.lan>
 <e9c3a7c20707301128h180956f3p40b998dd63b96ba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20707301128h180956f3p40b998dd63b96ba@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 30 Jul 2007, Dan Williams wrote:

> [trimmed all but linux-raid from the cc]
>
> On 7/30/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> CONFIG:
>>
>> Software RAID 5 (400GB x 6): Default mkfs parameters for all filesystems.
>> Kernel was 2.6.21 or 2.6.22, did these awhile ago.
> Can you give 2.6.22.1-iop1 a try to see what affect it has on
> sequential write performance?
>
> Download:
> http://downloads.sourceforge.net/xscaleiop/patches-2.6.22.1-iop1-x86fix.tar.gz
>
> Unpack into your 2.6.22.1 source tree.  Install the x86 series file
> "cp patches/series.x86 patches/series".  Apply the series with quilt
> "quilt push -a".
>
> I recommend trying the default chunk size and default
> stripe_cache_size as my tests have shown improvement without needing
> to perform any tuning.
>
> Thanks,
> Dan
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Will keep in mind for next test, but like I said these were from a while 
ago.

Justin.
