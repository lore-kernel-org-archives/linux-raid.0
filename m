From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Intel IMSM RAID 5 won't start
Date: Mon, 4 Jan 2016 15:36:36 +0000
Message-ID: <568A9184.1060000@youngman.org.uk>
References: <CAEUPnrygMz5qs=Saw4maWOriS7bb72-+RO_CSGd_+neQPhp49g@mail.gmail.com>
 <568A8C65.3010103@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <568A8C65.3010103@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Guido D'Arezzo <gdarrezzo@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/01/16 15:14, Artur Paszkiewicz wrote:
> It looks like the metadata on the drives got messed up for some reason.
> If you believe the drives are good, you can try recreating the arrays
> with the same layout to write fresh metadata to the drives, without
> overwriting the actual data. In this case it can be done like this (make
> a backup of the drives using dd before trying it):
> 
> # mdadm -Ss
> # mdadm -C /dev/md/imsm0 -eimsm -n4 /dev/sdd /dev/sda /dev/sdc /dev/sdb -R
> # mdadm -C /dev/md/md0 -l5 -n4 /dev/sdd /dev/sda /dev/sdc /dev/sdb --size=900G
> --chunk=128 --assume-clean -R
> # mdadm -C /dev/md/md1 -l5 -n4 /dev/sdd /dev/sda /dev/sdc /dev/sdb --chunk=128
> --assume-clean -R
> 
> Drives should be listed in the order as they appear in the output from
> mdadm -E. Look at the "DiskXX Serial" lines.
> 
> Then you can run fsck on the filesystems. Finally, repair any mismatched
> parity blocks:

That sounds like it'll write to the superblock. Okay - I guess needs must.

BUT!!! Once you've done that, create the array using loopback/overlays
or whatever (I hope someone else chimes in here :-) Whatever, the disks
themselves will be read-only, so you can run fsck, check that your
re-assemble really did work properly - if it did fsck won't find much
wrong - and if it worked right then you can do it for real.

Thing is, this means that if you do go wrong, you haven't actually done
anything to the data on the disk itself, so you can throw the overlay
away and try afresh, without having to restore your backup.

Cheers,
Wol
