From: Neil Brown <neilb@suse.de>
Subject: Re: Manually specifying data_offset in component device superblock?
Date: Thu, 9 Jul 2009 11:34:10 +1000
Message-ID: <19029.18706.672808.169640@notabene.brown>
References: <6ad05c580907070354o485818d7w255d75de9101fb39@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mark F on Tuesday July 7
Sender: linux-raid-owner@vger.kernel.org
To: Mark F <gnomeza@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday July 7, gnomeza@gmail.com wrote:
> Hi
> 
> __The Problem__
> 
> I'm attempting to recover a RAID5 (6 disks) with zeroed superblocks.
> 
> mdadm -C --assume-clean -f -e 1.2 -l 5 -p ls -c 128 -n6
> 
> But I'm unable to get the data offsets of some of the disks in the
> array to match what I had before:
> Diff of mdadm --examine /dev/sdb3 (which became /dev/sde3 after reboot)
> 

> 
> - Avail Dev Size : 870353369 (415.02 GiB 445.62 GB)
> + Avail Dev Size : 870353233 (415.02 GiB 445.62 GB)
>       Array Size : 4351765760 (2075.08 GiB 2228.10 GB)
>    Used Dev Size : 870353152 (415.02 GiB 445.62 GB)
> -    Data Offset : 136 sectors
> +    Data Offset : 272 sectors

That is unfortunate, isn't it...

> 
> Data offset for this disk was originally 136, but on recreation, mdadm
> chooses 272...

It must have been created with mdadm-2.5.6 or earlier

> 
> The array started off as RAID5 (5 disks plus a hot spare).
> One disk (array slot 4) failed about a year ago and was replaced.
> The array was grown to RAID5 (6 disks) shortly after.
> 
> __The Question__
> 
> So, is there a way to force a particular data offset? (short of
> recompiling mdadm?)

No.

> 
> __Some things I've tried__
> 
> It seems to be feasible to *manually* tweak data_offset with a hexeditor.
> To test things I've created some sparse loopback devices of the
> correct size (dd seek) with just the first 1MB or so of data in each
> device.
> After updating data_offset and the checksum of the first disk I
> assembled the array and cryptsetup found its header. (Yay!)

You would need to update the data_offset on each device.

> 
> But does anyone know if other parts of the superblock are dependent on
> the data_offset value?
> Am I going to bork things horribly by fiddling with the data_offset?

No, that should be safe (as long as you do it on every device).


> 
> What data is present between the end of the superblock and the
> beginning of data?

That space is used for an internal bitmap.  If you don't have a bitmap
configured, then that space is not used.

NeilBrown
