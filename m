From: "Alex Leach" <beamesleach@gmail.com>
Subject: Re: RAID5 member disks shrunk
Date: Mon, 14 Jan 2013 13:50:41 -0000
Message-ID: <op.wqwl2rjt8s54ea@metabuntu>
References: <op.wqcditj08s54ea@metabuntu> <50E6FF8E.5040309@mpstor.com>
 <op.wqeiuj0e8s54ea@metabuntu> <op.wqhqcta58s54ea@metabuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.wqhqcta58s54ea@metabuntu>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dear all,

Sorry about the break; I've been away and doing other things...


On Sun, 06 Jan 2013 12:59:07 -0000, Alex Leach <beamesleach@gmail.com>  
wrote:

> I think my only option is to zero the superblock with mdadm and try to  
> recreate the array in Windows, with
> whatever version of Intel Matrix Storage Manager was initially installed
> on the machine, hoping to God that the array contents don't get
> overwritten. Then, hopefully the original array size would be available
> again and the ext4 partition would fit within it. Sounds dangerous...


So, that is what I did. Specifically:-

0. Used serial numbers from /dev/disk/by-id to figure out the original  
order that the member disks were plugged into the motherboard. Swapped  
/dev/sdg and /dev/sdb, so that they were plugged into the motherboard  
ports in the same order as when I first created the array.

1. mdadm --zero-superblock /dev/sd[abg]

2. Re-create RAID5 array in Intel Matrix Storage Manager 8.9.

    This just initialised the container and member array i.e. wrote the  
imsm container superblock. The re-sync was pending.

3. Reboot into Arch linux.

    mdadm started re-sync'ing the array. I let it finish...

4. mdadm -D /dev/md/RAID5 | grep Size

      Array Size : 586066944 (558.92 GiB 600.13 GB)
   Used Dev Size : 293033600 (279.46 GiB 300.07 GB)
      Chunk Size : 64K

Assuming the above units are in Kibibytes, I figure multiplying the Array  
Size by 2 should give the usable number of sectors: 1,172,133,888.

The array size and used dev size is now as it was before everything went  
tits up. That's good, but testdisk still finds that the partitions have  
moved up the disk. The discovered ext4 partition now extends 3,576 sectors  
beyond the end of the array.


In sectors, these are the partitions testdisk finds:

Partition     Start            End  (Diff.)          Size
1             2,128        206,920     +73        204,800
2           214,528    668,208,632  +7,673    667,994,112
3       668,208,640  1,172,137,464  +7,680    503,928,832

where Diff is the number of sectors the partition seems to have moved, cf.  
the original partition table.

---------------------


Partition 2 is still recoverable. I can browse the array contents using  
testdisk and can see that the Windows directory structure is still there.  
Partition 1 seems corrupted. I can't browse the contents in testdisk and  
was unable to mount the partition, even before this last array re-creation.

Partition 3 is still a problem. testdisk refuses to recover it and I can't  
browse its contents.

I seem to have a new problem, too. I am now unable to write a partition  
table to the disk! I've tried using sfdisk, parted and testdisk. Each of  
these programs hangs indefinitely and the process is invincible to kill  
commands. The machine needs to be hard-rebooted in order to kill the  
hanging process.

Two minutes after trying to write a partition table, dmesg reports the  
following traceback each and every 2 minutes:

[  479.779519] INFO: task sfdisk:1020 blocked for more than 120 seconds.
[  479.779522] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables  
this message.
[  479.779525] sfdisk          D 0000000000000001     0  1020   1019  
0x00000000
[  479.779529]  ffff8805e9cb3978 0000000000000086 ffff8805e9cb3801  
ffff8805e9cb3fd8
[  479.779534]  ffff8805e9cb3948 ffff8805e9cb3fd8 ffff8805e9cb3fd8  
ffff8805e9cb3fd8
[  479.779538]  ffff88061e0c5040 ffff8805e9e76450 ffff8805e9cb3908  
ffff8805edd86200
[  479.779542] Call Trace:
[  479.779551]  [<ffffffff81164024>] ?  
__mem_cgroup_commit_charge+0xd4/0x350
[  479.779558]  [<ffffffff8107b79b>] ? prepare_to_wait+0x5b/0x90
[  479.779569]  [<ffffffffa03efc55>] md_write_start+0xb5/0x1a0 [md_mod]
[  479.779573]  [<ffffffff8107b9a0>] ? abort_exclusive_wait+0xb0/0xb0
[  479.779577]  [<ffffffffa02bad0b>] make_request+0x3b/0x6c0 [raid456]
[  479.779582]  [<ffffffff81067e68>] ? lock_timer_base.isra.38+0x38/0x70
[  479.779585]  [<ffffffff81067400>] ? internal_add_timer+0x20/0x50
[  479.779591]  [<ffffffffa03eac6c>] md_make_request+0xfc/0x240 [md_mod]
[  479.779595]  [<ffffffff81113075>] ? mempool_alloc_slab+0x15/0x20
[  479.779601]  [<ffffffff8122a9c2>] generic_make_request+0xc2/0x110
[  479.779604]  [<ffffffff8122aa89>] submit_bio+0x79/0x160
[  479.779609]  [<ffffffff811a2c15>] ? bio_alloc_bioset+0x65/0x120
[  479.779612]  [<ffffffff8119d1e5>] submit_bh+0x125/0x210
[  479.779616]  [<ffffffff811a0210>] __block_write_full_page+0x1f0/0x360
[  479.779620]  [<ffffffff8119e0b0>] ? end_buffer_async_read+0x200/0x200
[  479.779623]  [<ffffffff811a3df0>] ? I_BDEV+0x10/0x10
[  479.779627]  [<ffffffff811a3df0>] ? I_BDEV+0x10/0x10
[  479.779630]  [<ffffffff8119e0b0>] ? end_buffer_async_read+0x200/0x200
[  479.779633]  [<ffffffff811a0466>] block_write_full_page_endio+0xe6/0x130
[  479.779637]  [<ffffffff811a04c5>] block_write_full_page+0x15/0x20
[  479.779641]  [<ffffffff811a4478>] blkdev_writepage+0x18/0x20
[  479.779644]  [<ffffffff81119ac7>] __writepage+0x17/0x50
[  479.779647]  [<ffffffff81119f92>] write_cache_pages+0x1f2/0x4e0
[  479.779650]  [<ffffffff81119ab0>] ? global_dirtyable_memory+0x40/0x40
[  479.779655]  [<ffffffff8116c047>] ? do_sync_write+0xa7/0xe0
[  479.779658]  [<ffffffff8111a2ca>] generic_writepages+0x4a/0x70
[  479.779662]  [<ffffffff8111bace>] do_writepages+0x1e/0x40
[  479.779666]  [<ffffffff81111a49>] __filemap_fdatawrite_range+0x59/0x60
[  479.779669]  [<ffffffff81111b50>] filemap_write_and_wait_range+0x50/0x70
[  479.779673]  [<ffffffff811a4744>] blkdev_fsync+0x24/0x50
[  479.779676]  [<ffffffff8119b6dd>] do_fsync+0x5d/0x90
[  479.779680]  [<ffffffff8116ca62>] ? sys_write+0x52/0xa0
[  479.779683]  [<ffffffff8119ba90>] sys_fsync+0x10/0x20
[  479.779688]  [<ffffffff81495edd>] system_call_fastpath+0x1a/0x1f

Apologies for not having all the debug symbols installed. I've been unable  
to locate the necessary package/s on Arch that contain them.

This is with mdadm-3.2.6. I think I'll try again with an old version of  
dmraid on recovabuntu, one released around the time I first created the  
ext4 partition, which was in Ubuntu.

As to why I get this traceback, no idea.

---------------------------

I'd really appreciate some suggestions on how to recover the ext4  
partition. My current idea is this:

1. Use ddrescue to copy the hard disk from sector 668,208,640 (location  
testdisk found) up to the end.

     $ ddrescue obs=512 seek=668208640 bs=64 if=/dev/md/RAID5  
of=/media/bigdisk/kubuntu.ext4

2. Probably get a new HDD, create an MBR in Windows 7, and make a new  
partition exactly the same size as before.

     $ [cs]?fdisk ...

Not exactly sure what information I'd need to specify here, other than  
size, primary and partition Id (83). Use whichever program allows all the  
necessary options.
Assume, just created partition /dev/sdXx.

3. Copy the backed up image on to the raw device / partition file.

     $ dd bs=64 if=/media/bigdisk/kubuntu.ext4 of=/dev/sdXx

4. Hope fsck works...

     $ fsck.ext4 -f -p /dev/sdXx

5. Hopefully mount the partition and browse data.

6. Re-create and re-format partitions on the RAID array and copy stuff  
back.

7. Get an incremental back-up system running.

Does anyone know if there is even a remote possibility this could work?  
I've read through some of the kernel wiki on ext4 partitions  
(https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout), but doubt my  
ability to use any of that information effectively.

[Question - any ext4 gurus here who would know?]

Could I increase the size of the output file of step 1, so that it appears  
to be the same size as the original partition? i.e. If I were to pad it  
with zeros, could I attempt to mount the file as an ext4 partition?  
Something like:

    $ dd if=/dev/zeros bs=512 count=3576 >> /media/bigdisk/kubuntu.ext4
    $ e2fsck /media/bigdisk/kubuntu.ext4
    $ mount -t ext4 /media/bigdisk/kubuntu.ext4 /mnt



Any comments, suggestions or insults completely welcome.

Kind regards,
Alex

P.S. Sorry that I've been unable to report any hexdump results. Basically,  
I don't (yet) have a clue how I'd locate the ext3 file headers, or what to  
expect them to look like. Over the course of this week, I'll try and make  
my way through this ext3 recovery tutorial:  
http://carlo17.home.xs4all.nl/howto/undelete_ext3.html

-- 
Using Opera's mail client: http://www.opera.com/mail/
