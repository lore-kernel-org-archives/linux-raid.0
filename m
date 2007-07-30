From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: bonnie++ benchmarks for ext2,ext3,ext4,jfs,reiserfs,xfs,zfs on software raid 5
Date: Mon, 30 Jul 2007 11:28:26 -0700
Message-ID: <e9c3a7c20707301128h180956f3p40b998dd63b96ba@mail.gmail.com>
References: <Pine.LNX.4.64.0707301021090.12456@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707301021090.12456@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[trimmed all but linux-raid from the cc]

On 7/30/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> CONFIG:
>
> Software RAID 5 (400GB x 6): Default mkfs parameters for all filesystems.
> Kernel was 2.6.21 or 2.6.22, did these awhile ago.
Can you give 2.6.22.1-iop1 a try to see what affect it has on
sequential write performance?

Download:
http://downloads.sourceforge.net/xscaleiop/patches-2.6.22.1-iop1-x86fix.tar.gz

Unpack into your 2.6.22.1 source tree.  Install the x86 series file
"cp patches/series.x86 patches/series".  Apply the series with quilt
"quilt push -a".

I recommend trying the default chunk size and default
stripe_cache_size as my tests have shown improvement without needing
to perform any tuning.

Thanks,
Dan
