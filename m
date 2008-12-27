From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: How do I tell if my partition is aligned for a 64k/RAID-6?
Date: Sat, 27 Dec 2008 09:05:23 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812270904370.15403@p34.internal.lan>
References: <alpine.DEB.1.10.0812250821360.31386@p34.internal.lan> <495410F4.5010508@ziu.info> <alpine.DEB.1.10.0812251846270.32331@p34.internal.lan> <20081227133824.GH6284@josefsipek.net> <alpine.DEB.1.10.0812270850490.15403@p34.internal.lan>
 <20081227135822.GI6284@josefsipek.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081227135822.GI6284@josefsipek.net>
Sender: linux-raid-owner@vger.kernel.org
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: Michal Soltys <soltys@ziu.info>, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids



On Sat, 27 Dec 2008, Josef 'Jeff' Sipek wrote:

> On Sat, Dec 27, 2008 at 08:53:21AM -0500, Justin Piszcz wrote:
>> Why bother partitioning?  I also run a Linux SW RAID1 on the host, as you
>> know the drive letters can change when working on a server.
>>
>> Example: Before I created the array (RAID-6), my disks were /dev/sda,
>> /dev/sdb and /dev/sdc (spare), the RAID-6 was /dev/sdd.  After reboot,
>> /dev/sdd became /dev/sda and /dev/sd[a-c] became /dev/sd[b-d].
>>
>> In lilo.conf I had:
>> raid-extra-boot="/dev/sda,/dev/sdb"
>>
>> If I ran LILO and forgot to fix the lilo.conf to reflect the new drive
>> mappings:
>> raid-extra-boot="/dev/sdb,/dev/sdc"
>>
>> I could be at risk of ruining the partition?
>
> Hrm...interesting point. LILO could mess up the superblock in sector 0.
>
>> I try to avoid such situations when possible, to be safe.
>
> :)
>
> I don't know how LILO would handle it, but I would try to use
> /dev/disk/by-*/* instead of the rather unstable /dev/sd* names.
>
> Just my 0.02 cents.
>
> Jeff.

Excellent idea.

# lilo
Added 2.6.27.9-1
Added 2.6.27.10-1
Added 2.6.27.10-2 *
The boot record of  /dev/md1  has been updated.
The boot record of  /dev/disk/by-id/scsi-SATA_WDC_WD1500ADFS-_WD-SN#######  has been updated.
Warning: /dev/disk/by-id/scsi-SATA_WDC_WD1500ADFD-_WD-SN######## is not on the first disk
The boot record of  /dev/disk/by-id/scsi-SATA_WDC_WD1500ADFD-_WD-SN########  has been updated.

Thanks!

Justin.

