From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid resync speed
Date: Thu, 20 Mar 2014 09:35:52 -0500
Message-ID: <532AFCC8.6080902@hardwarefreak.com>
References: <CAPrpM6wLpRhMqqsXQ8Baqz4axxj6cvoB2Z1HAOiNm7gPv1FT=w@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPrpM6wLpRhMqqsXQ8Baqz4axxj6cvoB2Z1HAOiNm7gPv1FT=w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Allison <jeff.allison@allygray.2y.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/19/2014 8:12 PM, Jeff Allison wrote:
...
> In this box I have a 3x2TB disk raid 5 array, which I am in the
> process of extending to a 4x2TB raid 5 array.
> 
> I've added the new disk --> mdadm --add /dev/md0 /dev/sdb
> 
> And grown the array --> mdadm --grow /dev/md0 --raid-devices=4
> 
> Now the problem the resync speed is v slow, it refuses to rise above
> 5MB, in general it sits at 4M.
...
> Model: ATA ST2000DM001-1E61 (scsi)
> Disk /dev/sdb: 2000GB
> Sector size (logical/physical): 512B/4096B
> Partition Table: msdos

Seagate Advanced Format 512e disk drive

> Number Start End Size Type File system Flags
> 1 1049kB 2000GB 2000GB primary ntfs raid

Offset is 262 physical sectors, strange value, but won't incur RMW
internally.  So no performance hit here.

...
> I've followed the article here -->
> http://www.cyberciti.biz/tips/linux-raid-increase-resync-rebuild-speed.html
> to attempt to speed it up but no joy.
> 
> Any Ideas what I've done wrong?

Yes.  The article gives 16384 and 32768 as examples for
stripe_cache_size.  Such high values tend to reduce throughput instead
of increasing it.  Never use a value above 2048 with rust, and 1024 is
usually optimal for 7.2K drives.  Only go 4096 or higher with SSDs.  In
addition, high values eat huge amounts of memory.  The formula is:

stripe_cache_size * 4096 bytes * drive_count = RAM usage

(32768*4096) * 4 = 512MB of RAM consumed by the stripe cache
(16384*4096) * 4 = 256MB of RAM consumed by the stripe cache

 (2048*4096) * 4 =  32MB of RAM consumed by the stripe cache
 (1024*4096) * 4 =  16MB of RAM consumed by the stripe cache


Cheers,

-- 
Stan
