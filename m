From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: mdadm raid 5 one disk overwritten file system failed
Date: Thu, 19 Feb 2015 18:15:04 +0100
Message-ID: <20150219171504.GA8567@lazy.lzy>
References: <020601d04c17$08c10290$1a4307b0$@johnandre.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <020601d04c17$08c10290$1a4307b0$@johnandre.net>
Sender: linux-raid-owner@vger.kernel.org
To: John Andre Taule <post@johnandre.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 19, 2015 at 08:38:19AM +0100, John Andre Taule wrote:
> Hi!
> 
> Case: mdadm Raid 5 4 2TB disks. ext4 formatted spanning the raid.
> Attack: dd if=/dev/zero of=/dev/sdb bs=1M
> 
> Expected result would be a raid that could be recovered without data loss.
> 
> Result was that the file system failed and not possible to recover. 
> 
> As I understand it if this was a "hardware type fake" raid controller, the
> outcome would be uncertain. However I'm a bit confused as to why the raid
> (or more specifically the file system) would fail so horrible when losing
> one disk. Is there perhaps critical information written "outside" the raid
> on the physical disk, and this where overwritten in the attack?
> 
> It would be nice to have an exact idea as to why it failed so hard, and how
> obvious it should be that this attack would have more consequence then a
> degraded raid.

In this situation, there is no HDD failure.
The kernel, the md driver, the sata driver and so on,
cannot detect any failure, because there is none.
The HDD is alive and kicking and well writing.

Just to be clear and avoid confusion, the (redundant)
RAID does *not* check, at each read operation, that
the data is consistent. It does only use redundancy
in order to re-generate missing data *after* a failure
is detected.

So, writing to a RAID component does not trigger any
error, hence no failure, hence no reconstruction, but
a corrupted filesystem.

bye,

pg

> 
> //Regards
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
