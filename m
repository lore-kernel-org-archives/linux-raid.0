From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: grub2/grub-pc install not possible on mdadm
Date: Thu, 01 Mar 2012 11:10:37 +0100
Message-ID: <4F4F4B1D.4050000@redhat.com>
References: <4F4C9A11.9060302@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F4C9A11.9060302@profihost.ag>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/28/12 10:10, Stefan Priebe - Profihost AG wrote:
> Hi list,
> 
> i've configured a raid1 and i'm trying to install grub on it. But it
> doesn't work.
> 
> ~# grub-mkdevicemap -n
> ~# cat /boot/grub/device.map
> (hd0)   /dev/disk/by-id/ata-INTEL_SSDSA2CW160G3_CVPR14530C6J160DGN
> (hd1)   /dev/disk/by-id/ata-INTEL_SSDSA2CW160G3_CVPR145101F9160DGN
> 
> ~# grub-install /dev/md127
> error: found two disks with the index 0 for RAID md/raidone.
> error: superfluous RAID member (2 found).
> error: found two disks with the index 0 for RAID md/raidone.
> error: superfluous RAID member (2 found).
> error: found two disks with the index 0 for RAID md/raidone.
> error: superfluous RAID member (2 found).
> error: found two disks with the index 0 for RAID md/raidone.
> error: superfluous RAID member (2 found).
> error: found two disks with the index 0 for RAID md/raidone.
> error: superfluous RAID member (2 found).
> /usr/sbin/grub-install: line 661: 20158 Segmentation fault
> "$grub_setup" ${allow_floppy} ${setup_verbose} ${setup_force}
> --directory="${grubdir}" --device-map="${device_map}" "${install_device}"
> 
> When i then add /dev/md127 to my device.map i got this:
> 
> ~# grub-install /dev/md127
> error: found two disks with the index 0 for RAID md/raidone.
> error: superfluous RAID member (2 found).
> error: found two disks with the index 0 for RAID md/raidone.
> error: superfluous RAID member (2 found).
> error: found two disks with the index 0 for RAID md/raidone.
> error: superfluous RAID member (2 found).
> error: found two disks with the index 0 for RAID md/raidone.
> error: superfluous RAID member (2 found).
> error: found two disks with the index 0 for RAID md/raidone.
> error: superfluous RAID member (2 found).
> error: found two disks with the index 0 for RAID md/raidone.
> error: superfluous RAID member (2 found).
> Installation finished. No error reported.
> 
> But the device still does not boot. Installing grub to sda / sdb does
> not work either as they do not contain any partition table. What's wrong
> here?
> 
> Greets
> Stefan
> 
> Raid details:
> ~# parted
> Model: Linux Software RAID Array (md)
> Disk /dev/md127: 160GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
> 
> Number  Start   End     Size    File system     Name       Flags
>  1      1049kB  2097kB  1049kB                  GRUB_BOOT  bios_grub
>  2      2097kB  99,6MB  97,5MB  ext2            BOOT
>  3      99,6MB  157GB   157GB   xfs             ROOT
>  4      157GB   160GB   3056MB  linux-swap(v1)  SWAP

I am not sure whether this is the reason, but you have disks with gpt
partition tables, while it looks like you are still using grub1? I
didn't think grub1 was able to handle gpt.

Cheers,
Jes
