From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID 5: low sequential write performance?
Date: Mon, 17 Jun 2013 09:22:36 -0500
Message-ID: <51BF1BAC.9020701@hardwarefreak.com>
References: <51BCF46B.40704@fatooh.org> <20926.11718.556180.928129@tree.ty.sabi.co.uk> <51BEAF12.10909@fatooh.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51BEAF12.10909@fatooh.org>
Sender: linux-raid-owner@vger.kernel.org
To: Corey Hickey <bugfood-ml@fatooh.org>
Cc: Peter Grandi <pg@lxra2.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 6/17/2013 1:39 AM, Corey Hickey wrote:

> 32768 seems to be the maximum for the stripe cache. I'm quite happy to
> spend 32 MB for this. 256 KB seems quite low, especially since it's only
> half the default chunk size.

FULL STOP.  Your stripe cache is consuming *384MB* of RAM, not 32MB.
Check your actual memory consumption.  The value plugged into
stripe_cache_size is not a byte value.  The value specifies the number
of data elements in the stripe cache array.  Each element is #disks*4KB
in size.  The formula for calculating memory consumed by the stripe
cache is:

(num_of_disks * 4KB) * stripe_cache_size

In your case this would be

(3 * 4KB) * 32768 = 384MB

Test different values until you find the best combo of performance and
lowest RAM usage.  It'll probably be 2048, 4096, or 8192, which will
cost you 24MB, 48MB, or 96MB of RAM.

> mkfs.xfs /dev/m3
> direct: 89.8 MB/s  not direct: 90.0 MB/s

You didn't align XFS.  Though with large streaming writes it won't
matter much as md and the block layer will fill the stripes.  However,
XFS' big advantage is parallel IO and you're testing serial IO.  Fire up
4 O_DIRECT threads/processes and compare to EXT4 w/4 write threads.  The
throughput gap will increase until you run out of hardware.

-- 
Stan

