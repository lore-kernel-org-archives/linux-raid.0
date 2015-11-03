From: Phil Turmel <philip@turmel.org>
Subject: Re: Advice requested
Date: Tue, 3 Nov 2015 08:09:28 -0500
Message-ID: <5638B208.1050502@turmel.org>
References: <CAPpdf58rFk95KYGc3WkOQGg+ytJ3rcmWtu23ZU3-ss=vx_GfhQ@mail.gmail.com>
 <56367C33.6060703@turmel.org>
 <CAPpdf5_PUpR7GhBHUaQfWb8Q+7FZenxXgFqbaN3f3r0r6NQNDA@mail.gmail.com>
 <5637842D.1070000@turmel.org>
 <CAPpdf59MFX1oVwLC-bmQBaQp9K_9-+h0v64OGMnV1-k=eCzO0w@mail.gmail.com>
 <5637BCE4.8000006@turmel.org>
 <CAPpdf58En1ARr9YiFSgvPN5Ke_t7=EfxiaN9cZtGVtvR4NUdmA@mail.gmail.com>
 <5637FBAC.8000900@turmel.org>
 <CAPpdf59mkRiyNYF1dT6Xp9tcofTU8hOdih+tz+i=wPJfRQrTnQ@mail.gmail.com>
 <56380690.5030600@turmel.org>
 <CAPpdf5-HbrFESY_zhfkZ4=2CtYjgO4bA4LmA+1AHkT+Gv9iY2w@mail.gmail.com>
 <56381406.7070608@turmel.org>
 <CAPpdf59EV2TfpHUiZghAfWW6qy5je686Hg_qAs4xLchrUa=G7w@mail.gmail.com>
 <5638336E.4030400@turmel.org>
 <CAPpdf5-DMFrKRiBXjstJkvqQU1KzqJoL=hfNVqTGjy2HfMcALQ@mail.gmail.com>
 <56383C64.2070807@turmel.org>
 <CAPpdf58=f7YVej5MEFgaw6KvCgn+WBcm=JSrTNbM8AixWdpa1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf58=f7YVej5MEFgaw6KvCgn+WBcm=JSrTNbM8AixWdpa1g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/03/2015 07:45 AM, o1bigtenor wrote:

> Command (? for help): p
> Disk /dev/md0: 3907037184 sectors, 1.8 TiB
> Logical sector size: 512 bytes
> Disk identifier (GUID): 1EB47793-0CDF-4E16-AE84-33EC825AC448
> Partition table holds up to 128 entries
> First usable sector is 34, last usable sector is 3907037150
> Partitions will be aligned on 2048-sector boundaries
> Total free space is 2014 sectors (1007.0 KiB)
> 
> Number  Start (sector)    End (sector)  Size       Code  Name
>    1            2048      3907037150   1.8 TiB     8300  Linux filesystem
> 
> Command (? for help): w
> 
> Final checks complete. About to write GPT data. THIS WILL OVERWRITE EXISTING
> PARTITIONS!!
> 
> Do you want to proceed? (Y/N): Y
> OK; writing new GUID partition table (GPT) to /dev/md0.
> The operation has completed successfully.
> root@debianbase:/# dmesg |tail
> [35958.237305] JBD2: Error -5 detected when updating journal
> superblock for sdh1-8.
> [35958.265302] sd 16:0:0:1: [sdh] Synchronize Cache(10) failed:
> Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
> [42828.763827] md: md0 stopped.
> [42828.764985] md: bind<sdb1>
> [42828.765270] md: bind<sdf1>
> [42828.786394] md: raid10 personality registered for level 10
> [42828.787258] md/raid10:md0: active with 2 out of 4 devices
> [42828.787316] md0: detected capacity change from 0 to 2000403038208
> [42828.859574]  md0:
> [84855.526621]  md0: p1
> root@debianbase:/# blkid

> /dev/md0: PTUUID="1eb47793-0cdf-4e16-ae84-33ec825ac448" PTTYPE="gpt"
> /dev/md0p1: UUID="49552036-b46f-4956-ade9-3541a3dd7f0a" TYPE="ext4"
> PARTLABEL="Linux filesystem"
> PARTUUID="2d6ef378-b27a-4de6-a42f-9c0a7e191a00"

> root@debianbase:/# fsck -n /dev/md0p1
> fsck from util-linux 2.26.2
> e2fsck 1.42.13 (17-May-2015)
> The filesystem size (according to the superblock) is 488379392 blocks
> The physical size of the device is 488379387 blocks
> Either the superblock or the partition table is likely to be corrupt!
> Abort? no

You are five sectors short.

> /dev/md0p1 contains a file system with errors, check forced.
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> /dev/md0p1: 618365/122101760 files (0.2% non-contiguous),
> 78222096/488379392 blocks

You will need to convert the partition table to dos -- gpt stores a
backup partition table at the end, occupying space that the ext4
filesystem is claiming.

Use gdisk to do this:

gdisk /dev/md0

select 'r' for recovery options, the 'g' for MBR conversion.  Then w to
write and exit.

Then use fdisk to fix the partition:

fdisk /dev/md0

select 'd' then '1' to delete the partition.

select 'n' then 'p' for primary, then '1', then 2048, then accept the
suggested end sector (should be larger than in gdisk).

'w' to write and exit

probably need "partprobe /dev/md0" for the kernel to get the new size.

Then do a real fsck (without -n):

fsck -y /dev/md0p1

Then mount and backup.

> I think that I am right close to being able to backup the files.

Yes.

> Any suggestions for what to do after the files are backed up - - -
> 
> Should I (after making backup copies) rebuild the array
> 
> 1. just treat the disks as if they were empty
> 2. some other process

Just add the other drives back into the array in one step, then let them
recover.

mdadm /dev/md0 --add /dev/sdc1 --add /dev/sde1

{Use the current names if those aren't correct at this time.}

Although I wouldn't set up a new system quite like this, there's nothing
wrong with this layout.  It'll be fine like this until the day you want
more space.  A new bigger array would be an appropriate time to redesign.

Phil

