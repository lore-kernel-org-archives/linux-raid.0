From: David Greaves <david@dgreaves.com>
Subject: Re: Partitioned arrays initially missing from /proc/partitions
Date: Tue, 24 Apr 2007 13:32:49 +0100
Message-ID: <462DF8F1.3000306@dgreaves.com>
References: <462CC91B.8030008@dgreaves.com>	<16046.1177356707@mdt.dhcp.pit.laurelnetworks.com>	<17965.18112.135843.417561@notabene.brown>	<462DE0A2.6000701@dgreaves.com> <17965.60458.702567.463105@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17965.60458.702567.463105@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday April 24, david@dgreaves.com wrote:
>> Neil, isn't it easy to just do this after an assemble?
> 
> Yes, but it should not be needed, and I'd like to understand why it
> is.
> One of the last things do_md_run does is
>    mddev->changed = 1;
> 
> When you next open /dev/md_d0, md_open is called which calls
> check_disk_change().
> This will call into md_fops->md_media_changed which will return the
> value of mddev->changed, which will be '1'.
> So check_disk_change will then call md_fops->revalidate_disk which
> will set mddev->changed to 0, and will then set bd_invalidated to 1
> (as bd_disk->minors > 1 (being 64)).
> 
> md_open will then return into do_open (in fs/block_dev.c) and because
> bd_invalidated is true, it will call rescan_partitions and the
> partitions will appear.
> 
> Hmmm... there is room for a race there.  If some other process opens
> /dev/md_d0 before mdadm gets to close it, it will call
> rescan_partitions before first calling  bd_set_size to update the size
> of the bdev.  So when we try to read the partition table, it will
> appear to be reading past the EOF, and will not actually read
> anything..
> 
> I guess udev must be opening the block device at exactly the wrong
> time. 
> 
> I can simulate this by holding /dev/md_d0 open while assembling the
> array.  If I do that, the partitions don't get created.
> Yuck.
> 
> Maybe I could call bd_set_size in md_open before calling
> check_disk_change..
> 
> Yep, this patch seems to fix it.  Could you confirm?
almost...

teak:~# mdadm --assemble /dev/md_d0 --auto=parts /dev/sd[bcdef]1
mdadm: /dev/md_d0 has been started with 5 drives.
teak:~# mount /media
teak:~# umount /media
teak:~# mdadm --stop /dev/md_d0
mdadm: stopped /dev/md_d0
teak:~# mdadm --assemble /dev/md_d0 --auto=parts /dev/sd[bcdef]1
mdadm: /dev/md_d0 has been started with 5 drives.
teak:~# mount /media
mount: No such file or directory
teak:~# mount /media
teak:~#
(second mount succeeds second time around)



md: md_d0 stopped.
md: bind<sdc1>
md: bind<sdd1>
md: bind<sdb1>
md: bind<sdf1>
md: bind<sde1>
raid5: device sde1 operational as raid disk 0
raid5: device sdf1 operational as raid disk 4
raid5: device sdb1 operational as raid disk 3
raid5: device sdd1 operational as raid disk 2
raid5: device sdc1 operational as raid disk 1
raid5: allocated 5236kB for md_d0
raid5: raid level 5 set md_d0 active with 5 out of 5 devices, algorithm 2
RAID5 conf printout:
 --- rd:5 wd:5
 disk 0, o:1, dev:sde1
 disk 1, o:1, dev:sdc1
 disk 2, o:1, dev:sdd1
 disk 3, o:1, dev:sdb1
 disk 4, o:1, dev:sdf1
md_d0: bitmap initialized from disk: read 1/1 pages, set 0 bits, status: 0
created bitmap (10 pages) for device md_d0
 md_d0: p1 p2
Filesystem "md_d0p1": Disabling barriers, not supported with external log device
XFS mounting filesystem md_d0p1
Ending clean XFS mount for filesystem: md_d0p1
md: md_d0 stopped.
md: unbind<sde1>
md: export_rdev(sde1)
md: unbind<sdf1>
md: export_rdev(sdf1)
md: unbind<sdb1>
md: export_rdev(sdb1)
md: unbind<sdd1>
md: export_rdev(sdd1)
md: unbind<sdc1>
md: export_rdev(sdc1)
md: md_d0 stopped.
md: bind<sdc1>
md: bind<sdd1>
md: bind<sdb1>
md: bind<sdf1>
md: bind<sde1>
raid5: device sde1 operational as raid disk 0
raid5: device sdf1 operational as raid disk 4
raid5: device sdb1 operational as raid disk 3
raid5: device sdd1 operational as raid disk 2
raid5: device sdc1 operational as raid disk 1
raid5: allocated 5236kB for md_d0
raid5: raid level 5 set md_d0 active with 5 out of 5 devices, algorithm 2
RAID5 conf printout:
 --- rd:5 wd:5
 disk 0, o:1, dev:sde1
 disk 1, o:1, dev:sdc1
 disk 2, o:1, dev:sdd1
 disk 3, o:1, dev:sdb1
 disk 4, o:1, dev:sdf1
md_d0: bitmap initialized from disk: read 1/1 pages, set 0 bits, status: 0
created bitmap (10 pages) for device md_d0
 md_d0: p1 p2
XFS: Invalid device [/dev/md_d0p2], error=-2
Filesystem "md_d0p1": Disabling barriers, not supported with external log device
XFS mounting filesystem md_d0p1
Ending clean XFS mount for filesystem: md_d0p1


