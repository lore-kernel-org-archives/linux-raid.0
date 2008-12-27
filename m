From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: How do I tell if my partition is aligned for a 64k/RAID-6?
Date: Sat, 27 Dec 2008 08:53:21 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812270850490.15403@p34.internal.lan>
References: <alpine.DEB.1.10.0812250821360.31386@p34.internal.lan> <495410F4.5010508@ziu.info> <alpine.DEB.1.10.0812251846270.32331@p34.internal.lan> <20081227133824.GH6284@josefsipek.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081227133824.GH6284@josefsipek.net>
Sender: linux-raid-owner@vger.kernel.org
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: Michal Soltys <soltys@ziu.info>, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids



On Sat, 27 Dec 2008, Josef 'Jeff' Sipek wrote:

> On Thu, Dec 25, 2008 at 06:46:37PM -0500, Justin Piszcz wrote:
>> On Fri, 26 Dec 2008, Michal Soltys wrote:
>>>> I am not worried about the filesystem as the defaults usually get it right
>>>> but with parted, this is the first time I had to use it for home use and
>>>> with RAID-6 I am noticing slower performance with 15 disks (1 is a spare)
>>>> in RAID-6 (albeit slower 7200 ones, RE3s) than I was getting with 10
>>>> raptor150s in RAID-6 (but I had used fdisk there).
>>>>
>>>> Justin.
>>>>
>>>
>>> For best effect - partition should start at 1920th sector (stripe width
>>> boundary), and su/sw should be appropriately set - su=64k,sw=13 in your
>>> case. Parted shows the values normally - from the beginning of the volume, 0
>>> based.
>>>
>>>
>>> ps.
>>>
>>> I dropped some of CCs.
>>
>> Thanks.
>
> It looks like you made why big partition. Why bother with partitioning at
> all? If you just use the whole device, you _will_ be aligned properly if you
> tell mkfs.xfs about the stripe unit/width.
>
> Josef 'Jeff' Sipek.

Why bother partitioning?  I also run a Linux SW RAID1 on the host, as you 
know the drive letters can change when working on a server.

Example: Before I created the array (RAID-6), my disks were /dev/sda, 
/dev/sdb and /dev/sdc (spare), the RAID-6 was /dev/sdd.  After reboot, 
/dev/sdd became /dev/sda and /dev/sd[a-c] became /dev/sd[b-d].

In lilo.conf I had:
raid-extra-boot="/dev/sda,/dev/sdb"

If I ran LILO and forgot to fix the lilo.conf to reflect the new drive 
mappings:
raid-extra-boot="/dev/sdb,/dev/sdc"

I could be at risk of ruining the partition?

I try to avoid such situations when possible, to be safe.

Justin.


