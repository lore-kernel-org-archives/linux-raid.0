From: "Alex Leach" <beamesleach@gmail.com>
Subject: Re: RAID5 member disks shrunk
Date: Sun, 06 Jan 2013 12:59:07 -0000
Message-ID: <op.wqhqcta58s54ea@metabuntu>
References: <op.wqcditj08s54ea@metabuntu> <50E6FF8E.5040309@mpstor.com>
 <op.wqeiuj0e8s54ea@metabuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.wqeiuj0e8s54ea@metabuntu>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 04 Jan 2013 16:13:02 -0000, Benjamin ESTRABAUD wrote:

> The fact that your ext4 partition "shrunk" (assuming it is the last one)  
> should not (to be tested, simply a hunch out of memory) prevent it from  
> mounting, at least when trying to force it.

How do you force a mount? Just looked through `man mount` and didn't see
anything fitting the description.



I figured some stuff out. Thought I'd detail and plan it here, before I go
ahead and do anything rash (like I haven't already)..

On Fri, 04 Jan 2013 19:24:09 -0000, Alex Leach wrote:

>
>   Current working status
>   ======================

>      $ sudo testdisk /dev/md/RAID5
> # Intel Partition -> Analyse -> Quick Search
> Disk /dev/md/RAID5 - 600 GB / 558 GiB - CHS 146516480 2 4
> Analysing cylinder ...... (57%)
> Warning: Incorrect number of heads/cylinder 255 (NTFS) != 2 (HD)
> Warning: Incorrect number of sectors per track 63 (NTFS) != 4 (HD)
>    HPFS - NTFS            266   0  1 25865   1  4     204800
> Warning: Incorrect number of heads/cylinder 255 (NTFS) != 2 (HD)
> Warning: Incorrect number of sectors per track 63 (NTFS) != 4 (HD)
>    HPFS - NTFS          26816   0  1 83526079   1  4  667994112
>    Linux                83526080   0  1 146517183   1  4  503928832
>
> # Stop (at ~57%)
> The following partition can't be recovered:
>       Partition               Start        End    Size in sectors
>>  Linux                83526080   0  1 146517183   1  4  503928832
>
> # Continue
> Disk /dev/md/RAID5 - 600 GB / 558 GiB - CHS 146516480 2 4
>       Partition               Start        End    Size in sectors
>> * HPFS - NTFS            266   0  1 25865   1  4     204800
>   P HPFS - NTFS          26816   0  1 83526079   1  4  667994112
>

> How is the start sector now 266? Is it something to do with the CHS  
> values? testdisk reports partition boundaries that don't seem to be  
> aligned with the cylinder boundaries, but if I change the Sectors per  
> head to 63, and heads per cylinder to 255, in testdisk options, it then  
> doesn't find these partitions, which are almost definitely my old  
> partitions that I want to recover...


So the testdisk units must be cylinder numbers. Multiplying them by 8 ( =
2 x 4 <-- from CHS values) gives the start sector number. This is the
partition table that testdisk creates:


# partition table of /dev/md/RAID5
unit: sectors

/dev/md/RAID5p1 : start=     2128, size=   204800, Id= 7, bootable
/dev/md/RAID5p2 : start=   214528, size=667994112, Id= 7
/dev/md/RAID5p3 : start=        0, size=        0, Id= 0
/dev/md/RAID5p4 : start=        0, size=        0, Id= 0

NB. There is now a noticeable gap between p1 and p2, of 7,600 sectors. p2
appears to be fine, but p1 doesn't mount:

     $ sudo mount -t ntfs-3g /dev/md/RAID5p1 /mnt
ntfs_mst_post_read_fixup_warn: magic: 0x44524352  size: 1024   usa_ofs:
40  usa_count: 8: Invalid argument
Record 0 has no FILE magic (0x44524352)
Failed to load $MFT: Input/output error
Failed to mount '/dev/md126p1': Input/output error
...


>
>    3. Copy new start and end numbers reported by testdisk into above  
> copy of sfdisk output. Figure out start and end sectors for ext4  
> partition. These will be for the first sector after NTFS partition, and  
> last sector before end of array. Copy that into sfdisk output. I'm quite  
> confused by the numbers testdisk reports, as the start and end numbers  
> reported wouldn't fit the 'size in sectors'..


I'm wary of reducing the size of the partition, as presumably the size of
the inode table would differ and the start location of the data block
would be out.

https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout#Layout

So I loaded in the following partition table, wherein the final partition
extends beyond the end of the array, but it is of the correct size.

     $ sudo sfdisk -f /dev/md/RAID5  -O md126.testdisk.saved <
md126.new
...
Warning: given size (503928824) exceeds max allowable size (503923200)
New situation:
Units: sectors of 512 bytes, counting from 0

                    Device Boot    Start       End   #sectors  Id System
/dev/md/RAID5p1   *      9728    214527     204800   7  HPFS/NTFS/exFAT
/dev/md/RAID5p2        214528 668208639  667994112   7  HPFS/NTFS/exFAT
/dev/md/RAID5p3     668208640 1172137463  503928824  83  Linux
/dev/md/RAID5p4             0         -          0   0  Empty
Warning: partition 3 extends past end of disk
Successfully wrote the new partition table
...
     $ partprobe /dev/md/RAID5
Error: Can't have a partition outside the disk!
     $ ls /dev/md/RAID5*
/dev/md/RAID5 /dev/md/RAID5p1 /dev/md/RAID5p2


Is there a way to force udev to create the p3 /dev entry?

I think my only option is to zero the superblock with mdadm and try to  
recreate the array in Windows, with
whatever version of Intel Matrix Storage Manager was initially installed
on the machine, hoping to God that the array contents don't get
overwritten. Then, hopefully the original array size would be available
again and the ext4 partition would fit within it. Sounds dangerous...

Any alternative solutions?

Kind regards,
Alex
