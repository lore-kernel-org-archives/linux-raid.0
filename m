From: Ramin <ramin.t@gmail.com>
Subject: Re: Cannot sync RAID5 anymore - MCE problem?
Date: Tue, 14 Aug 2007 11:16:52 +0200
Message-ID: <46C17304.5000803@gmail.com>
References: <46C07F41.2080500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46C07F41.2080500@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ramin wrote:
> Hello everybody.
> 
> I have a strange and severe problem with my Raid-Array and I have to
> contact "experts" before I can continue with a clear conscience.
> I wanted to exchange 2 disks in my Raid5 array by two newer ones. So I
> connected the new to my machine partitioned the correct layout added one
> of them as a Spare and "--faild" the partition of the disk I wanted to
> remove first. Rebulding of the array started immediately and finished fine.
> Now I took the two old disks out and put the new ones in. By removing the
> other disk from my array I degraded it. After booting I added the correct
> partition of my new drive to the Raid5 and waited for the syncing to
> finish ...
> but it didn't. Is crashed my whole machine with an MCE:
> CPU 0: Machine check exception: 4 bank 4 b20000000000070f0f
> ...
> Kernel Panic - not synching: machine check
> 
> The reason why I write an MCE problem to the Software-Raid list is that
> this problem is very reproducible and always happens when resyncing of my
> array has finished 24.9%. I tried it about ten times so I am really sure
> that there is some connection to resyncing since this problem does not
> seem to appear under different conditions anymore.
> I tried to do an rsync-backup of my raid-array which lead the the same
> crash. After that I observed that this crash has occured when copying a
> not so important Backup of something else. I deleted that old Backup and
> since that my problem seems to ONLY occur if I try to resync my array.
> 
> I am running Gentoo on an AMD64 3200+ and K8N Neo4 Platinum and my problem
> seems to be similar to the problems of these guys:
> http://kerneltrap.org/node/4993
> but somehow related to resyncing. I have reiserfs on my array and
> successfully completed a "reiserfsck --rebuild-tree".
> I think it is not important but it might be good to mention that I use
> LVM, too.
> 
> I have also tried to resync the array to my old disk (with the second new
> one removed), but that leads to the same problem.
> 
> I have tried several things like removing one RAM module or using
> different RAM-Banks I checked for leaking caps I tried without DMA, tried
> different kernels and played with some kernel options.
> 
> Is there a way to figure out what hardware seems to be the problem?
> My hardware worked flawlessly for over 1.5 years if I did not break
> something while physically mounting the disks or cleaning dust out of the
> case it can only be a problem of the first new harddrive (which is
> unfortunately part of my degraded raid-array already). Is it possible that
> an SATA1 Cable on a SATA2 capable controller connected to a SATA2 capable
> disk leads to such errors?
> 
> Since I was able to copy my data I think it is in perfect condition, but
> there seems to be a problem on the array in the "empty"-part. Does anybody
> know a way how to over- or rewrite the empty blocks of a
> reiserfs-partition? Or some tool to find/correct disk-problems. (I tried
> reiserfsck but that does not find anything)
> 
> What is the smartest way for my to proceed to get my degraded array
> redundant again?
> I could delete the whole array, try set it up identically again and recopy
> the data, but if it is really a hardware problem that would be a waste of
> time.
> 
> Thanks in advance ...
> 	Ramin

Figured out my problem myself ... I did a
dd if=/dev/zero of=/home/file
and waited until the disk was full.
/home is the main lvm volume on my raid. After that i deleted the file
again and re-added the new partition to the disk.
Now everything worked/synced fine.

Maybe one should improve the error messages?
It might be philosophical but I would say it was more of a software rather
that a hardware problem.

Regards
	Ramin
