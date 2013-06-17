From: Corey Hickey <bugfood-ml@fatooh.org>
Subject: Re: RAID 5: low sequential write performance?
Date: Mon, 17 Jun 2013 10:14:14 -0700
Message-ID: <51BF43E6.4000900@fatooh.org>
References: <51BCF46B.40704@fatooh.org> <20926.11718.556180.928129@tree.ty.sabi.co.uk> <51BEAF12.10909@fatooh.org> <51BF1BAC.9020701@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51BF1BAC.9020701@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Peter Grandi <pg@lxra2.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2013-06-17 07:22, Stan Hoeppner wrote:
> On 6/17/2013 1:39 AM, Corey Hickey wrote:
> 
>> 32768 seems to be the maximum for the stripe cache. I'm quite happy to
>> spend 32 MB for this. 256 KB seems quite low, especially since it's only
>> half the default chunk size.
> 
> FULL STOP.  Your stripe cache is consuming *384MB* of RAM, not 32MB.
> Check your actual memory consumption.  The value plugged into
> stripe_cache_size is not a byte value.  The value specifies the number
> of data elements in the stripe cache array.  Each element is #disks*4KB
> in size.  The formula for calculating memory consumed by the stripe
> cache is:
> 
> (num_of_disks * 4KB) * stripe_cache_size
> 
> In your case this would be
> 
> (3 * 4KB) * 32768 = 384MB

I'm actually seeing a bit more memory difference: 401-402 MB when going
from 256 to to 32768, on a mostly idle system, so maybe there's
something else coming into play.

Still your formula does make more sense. Apparently the idea of the
value being KB is a common misconception, possibly perpetuated by this:

https://raid.wiki.kernel.org/index.php/Performance
---
# Set stripe-cache_size for RAID5.
echo "Setting stripe_cache_size to 16 MiB for /dev/md3"
echo 16384 > /sys/block/md3/md/stripe_cache_size
---

Is 256 really a reasonable default? Given what I've been seeing, it
appears that 256 is either unreasonably low or I have something else wrong.

>> mkfs.xfs /dev/m3
>> direct: 89.8 MB/s  not direct: 90.0 MB/s
> 
> You didn't align XFS.  Though with large streaming writes it won't
> matter much as md and the block layer will fill the stripes.  However,
> XFS' big advantage is parallel IO and you're testing serial IO.  Fire up
> 4 O_DIRECT threads/processes and compare to EXT4 w/4 write threads.  The
> throughput gap will increase until you run out of hardware.

This will be something to test next time I rebuild my "real" array.

Thanks,
Corey
