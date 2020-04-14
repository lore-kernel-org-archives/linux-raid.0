From: G <garboge@shaw.ca>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Tue, 14 Apr 2020 10:00:10 -0600
Message-ID: <f9f2f479-2899-6774-eb20-bf81ed24bc7b@shaw.ca>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2020-04-14 7:02 a.m., Stefanie Leisestreichler wrote:
> Hi List.
> I want to set up a new server. Data should be redundant that is why I 
> want to use RAID level 1 using 2 HDs, each having 1TB. Like suggested 
> in the wiki, I want to have the RAID running on a partition which has 
> TOTAL_SIZE - 100M allocated for smoother replacement of an array-disk 
> in case of failure.
>
> The firmware is UEFI, Partitioning will be made using GPT/gdisk.
>
> Boot manager should be GRUB (not legacy).
>
> To be safe on system updates I want to use LVM snapshots. I like to 
> make a LVM-based snapshot when the system comes up, do the system 
> updates, perform the test and dicide either to go with the updates 
> made or revert to the original state.
>
> I have read that - when using UEFI - the EFI-System-Partition (ESP) 
> has to reside in a own native partition, not in a RAID nor LVM block 
> device.
>
> Also I read a recommendation to put SWAP in a seperate native 
> partition and raid it in case you want to avoid a software crash when 
> 1 disk fails.
>
> I wonder, how I should build up this construct. I thought I could 
> build one partition with TOTAL_SIZE - 100M, Type FD00, on each device, 
> take these two (sda1 + sdb1) and build a RAID 1 array named md0. Next 
> make md0 the physical volume of my LVM (pvcreate /dev/md0) and after 
> that add a volume group in which I put my logical volumes:
> - swap - type EF00
> - /boot - with filesystem fat32 for uefi
> - /home - ext4
> - /tmp - ext4
> - / - ext4
> - /var/lib/mysql - ext4 with special mount options
> - /var/lib/vmimages - ext4 with special mount options
>
> Is this doable or is it not working since UEFI will not find my 
> bootimage, because in this config it is sitting not in an own native 
> partition?
>
> If it is not doable, do you see any suitable setup to archive my 
> goals? I do not want to use btrfs.
>
> Thanks,
> Steffi
>
>
Hi Stefanie

I don't quite understand your portioning requirements; 100M raid for 
what? Is the remaining larger partition on each disk just LVM'd without 
redundancy. If so 100M is probably minimum for a 'boot' partition with 
the OS residing on the non-redundant lvm.

Since you are running disks less than 2TB I would suggest a more 
rudimentary setup using legacy bios booting. This setup will not allow 
disks greater than 2TB because they would not be partitioned GPT. There 
would still be an ability to increase total storage using more disks. 
There would be raid redundancy with the ability for grub to boot off 
either disk.

Two identical partitions on each disk using mbr partition tables.

200-250M 'boot' partition raid1 metadata 0.9 formatted ext2 (holds linux 
images)

remainder 'root' (and data and possibly 'swapfile' (with ability to 
shrink and grow to a max size)) partition raid1 metadata 1.2 formatted 
ext4 (for mirrored redundancy or no raid for non-raid BOD)

Create raids and filesystems before install using live cd from command 
line. Use -m 1 option in mkfs for reduced 1% system reserved space 
instead of the default 5%.

Of course there could be different partitioning layouts (eg separate 
'home partition')

Install OS using manual partitioner to be able to use partitions as 
required. Install grub to both disks.

Hope this may help
