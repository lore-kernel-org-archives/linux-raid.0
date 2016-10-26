From: Shaohua Li <shli@kernel.org>
Subject: Re: data loss+inode recovery using RAID6 write journal
Date: Wed, 26 Oct 2016 11:43:59 -0700
Message-ID: <20161026184359.u7pwbxzz7i5mcbfm@kernel.org>
References: <20161024235505.rb4fucq24ybbn5aq@schwarzgerat.orthanc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161024235505.rb4fucq24ybbn5aq@schwarzgerat.orthanc>
Sender: linux-raid-owner@vger.kernel.org
To: Nick Black <dankamongmen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 24, 2016 at 07:55:05PM -0400, Nick Black wrote:
> Hey there, everyone! I've been using and admiring mdadm for over a decade;
> thanks for all the awesome work.
> 
> I recently put together a new build, and wanted to try out the
> --write-journal capability of recent Linux md. My write journal is a
> Samsung SSD 840 PRO SSD, atop a RAID6 of 8 4TB spinning disks. All 9 SATA3
> devices are plugged into the onboard SATA3 ports of my ASUS X-99 Deluxe II
> motherboard. Summary description:
> 
> md126 : active raid6 sde1[4] sdg1[6] sdd1[3] sdc1[2] sdf1[5] sdi1[8] sdh1[7] sdb1[1] sda1[0](J)
>       23441316864 blocks super 1.2 level 6, 512k chunk, algorithm 2 [8/8] [UUUUUUUU]
>       bitmap: 0/30 pages [0KB], 65536KB chunk
> 
> All filesystems are ext4. ~14TB of ~22TB are in use on the filesystem built
> directly atop md126:
> 
>  /dev/md126       22T   14T  7.4T  65% /media/trap
> 
> Kernel version is 4.8.3 (the array was built under 4.7.5), and mdadm reports
> v3.4. Distro is debian unstable, running a custom (but fairly orthodox)
> kernel.
> 
> I moved a ~20GB tarball from my home directory (located on another device, a
> NVMe md RAID1) to /media/trap/backups. The mv completed successfully. A
> short time after that, I hard rebooted the machine due to X lockup (I'm
> experimenting with compiz). By "short time", I mean "possibly within the
> time window before 20GB could be written out to the backing store, but I'm
> unsure about that". Upon restart, the machine engaged in minutes of disk
> activity, spat out some fsck inode recovery messages (I'm trying to find
> these in my logs), and finally mounted the filesystem. The moved file is
> nowhere to be found.
> 
> It's no big loss to me -- I can recreate that data -- but I thought I'd
> report this. As said, I'm looking for logs or other hard details, but not
> seeing them in journalctl output. I can probably reproduce the problem if
> someone needs me to, though otherwise I will likely disable the write
> journal for now (I've not yet done so). Please let me know how I might help
> you track this problem down, if a problem does indeed exist. Thanks!

Thanks for the testing. We can't improve the quality of the new feature if
nobody tests it. Yep, the write journal isn't mature yet, but I can't imagine
the data loss. With write journal, data is written to the ssd first, then to
raid disks and IO is finished at that time. So if IO is finished, the data
should be in raid disks. The only possible way to data loss is the recovery.
But it's also possible filesystem/writeback hasn't flushed data to disk yet.
I'm wondering if you can reproduce it with/without journal, so we can narrow
down it a bit.

Thanks,
Shaohua
