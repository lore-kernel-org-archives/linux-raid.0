From: Phil Turmel <philip@turmel.org>
Subject: Re: How to recover after md crash during reshape?
Date: Sun, 25 Oct 2015 19:02:41 -0400
Message-ID: <562D5F91.5040300@turmel.org>
References: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
 <5626464D.9000502@turmel.org>
 <3baf849321d819483c5d20c005a31844@tantosonline.com>
 <562660EE.9020504@turmel.org>
 <72dc24dd30c19517d19887d794fd341b@tantosonline.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dc24dd30c19517d19887d794fd341b@tantosonline.com>
Sender: linux-raid-owner@vger.kernel.org
To: andras@tantosonline.com
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/25/2015 10:15 AM, andras@tantosonline.com wrote:
> Phil,
> 
> Thanks for all the help. I finally have some progress (and new problems).

>     [ 5859.527778] EXT4-fs (md1): bad geometry: block count 1831419920
> exceeds size of device (1831419760 blocks)

> So, I thought of three ways of fixing it:
> 1. Re-create the array again, but this time force the array size to the
> one reported by the filesystem, using -size. What is the unit for -size?
> Is that bytes?

Yep. You'll need to use the --size option on a create. Note that it
specifies the amount of each device to use, not the overall array size.
According to "man mdadm", its units is k == 1024 bytes.  Use the exact
size from your original => --size=1465135936

> 2. Re-create the array again, but this time use the original
> super-blocks version (0.91 I think). Could that make a difference in the
> size of the array?

v0.91 really is just a flag that means v0.90 w/ a reshape in progress.
But yes, the size used would be somewhat different.  With the override
above, it won't matter.  v1.x metadata has more features, and modern
mdadm normally reserves enough room to support them.

> 3. Instead of DD-ing whole drives, dd just the raid6 partitions so the
> partition table is correct for the drives. Maybe the misalignment trips
> mdadm off and makes it to create the array in the incorrect size?

Yes, dd just the partition contents, so the final array is aligned.
This is *really* important for drives that have logical 512-byte sectors
but physical 4k-sectors.  When you put your repaired array back in
service, keep this alignment.

Phil

