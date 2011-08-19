From: Iwan Zarembo <iwan@zarembo.de>
Subject: Re: IMSM Raid 5 always read only and gone after reboot
Date: Fri, 19 Aug 2011 21:46:47 +0200
Message-ID: <4E4EBDA7.9090905@zarembo.de>
References: <CAOTVL7JLxjHgyaz0s3Ua9gsgUYHP_2b1DONzk3YNaCLfgxMBpA@mail.gmail.com> <4E4B4075.2060400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E4B4075.2060400@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Frey <djqfrey@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Daniel,
Thank you for your fast reply, but it still does not work.
=46irtly, about how to access linux (ext2,3,4) partitions on Windows. I=
 am=20
using ext2fsd manager for that. It works perfectly if you want to acces=
s=20
the drives read only. But it makes a bit trouble accessing them in=20
write-enabled mode. Just give it a try :)

I understand how it works with the partitions. I also created a=20
partition table with windows and it is accessible from windows. Now if =
I=20
try to work with parted I get the following output (it is in German, I=20
added my translation in brackets):
# parted /dev/md126
GNU Parted 2.3
Verwende /dev/md126
Willkommen zu GNU Parted! Geben Sie 'help' ein, um eine Liste der=20
verf=C3=BCgbaren
Kommados zu erhalten.
(parted) print
Modell: Linux Software RAID Array (md)
=46estplatte (Hard drive) /dev/md126:  3001GB
Sektorgr=C3=B6=C3=9Fe (Sector size) (logisch/physisch): 512B/512B
Partitionstabelle (Partition table): gpt

Number  Start  End   Size  Filesystem  Name                          Fl=
ags
  1      17,4kB  134MB  134MB               Microsoft reserved=20
partition  msftres

(parted) rm 1
=46ehler: Die Operation ist nicht erlaubt, w=C3=A4hrend auf /dev/md126 =
geschrieben
wurde
Error: The operation is not allowed while writing on /dev/md126.

Wiederholen/Retry/Ignorieren/Ignore/Abbrechen/Cancel?

So what I tried it to mark the partition as read write by using
# mdadm --readwrite /dev/md126p1

Then I started parted again and tried the same, but the deletion never=20
comes back.
When I open the app palimpsest then I see the status of the raid md126=20
write-pending.

After a while I also checked Syslog, it has the following entries:
md: md126 switched to read-write mode.
md: resync of RAID array md126
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000=
=20
KB/sec) for resync.
md: using 128k window, over a total of 976760320 blocks.
md: resuming resync of md126 from checkpoint.
INFO: task parted:23009 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
parted          D 0000000000000000     0 23009   2390 0x00000000
  ffff88040c431908 0000000000000086 ffff88040c431fd8 ffff88040c430000
  0000000000013d00 ffff8803d40d03b8 ffff88040c431fd8 0000000000013d00
  ffffffff81a0b020 ffff8803d40d0000 0000000000000286 ffff880432edd278
Call Trace:
  [<ffffffff8147d215>] md_write_start+0xa5/0x1c0
  [<ffffffff81087fb0>] ? autoremove_wake_function+0x0/0x40
  [<ffffffffa0111234>] make_request+0x44/0x3f0 [raid456]
  [<ffffffff8113a6dd>] ? page_add_new_anon_rmap+0x8d/0xa0
  [<ffffffff81038c79>] ? default_spin_lock_flags+0x9/0x10
  [<ffffffff812cf5c1>] ? blkiocg_update_dispatch_stats+0x91/0xb0
  [<ffffffff8147924e>] md_make_request+0xce/0x210
  [<ffffffff8107502b>] ? lock_timer_base.clone.20+0x3b/0x70
  [<ffffffff81113442>] ? prep_new_page+0x142/0x1b0
  [<ffffffff812c11c8>] generic_make_request+0x2d8/0x5c0
  [<ffffffff8110e7c5>] ? mempool_alloc_slab+0x15/0x20
  [<ffffffff8110eb09>] ? mempool_alloc+0x59/0x140
  [<ffffffff812c1539>] submit_bio+0x89/0x120
  [<ffffffff8119773b>] ? bio_alloc_bioset+0x5b/0xf0
  [<ffffffff8119192b>] submit_bh+0xeb/0x120
  [<ffffffff81193670>] __block_write_full_page+0x210/0x3a0
  [<ffffffff81192760>] ? end_buffer_async_write+0x0/0x170
  [<ffffffff81197f90>] ? blkdev_get_block+0x0/0x70
  [<ffffffff81197f90>] ? blkdev_get_block+0x0/0x70
  [<ffffffff81194513>] block_write_full_page_endio+0xe3/0x120
  [<ffffffff8110c6b0>] ? find_get_pages_tag+0x40/0x120
  [<ffffffff81194565>] block_write_full_page+0x15/0x20
  [<ffffffff81198b18>] blkdev_writepage+0x18/0x20
  [<ffffffff811158a7>] __writepage+0x17/0x40
  [<ffffffff81115f2d>] write_cache_pages+0x1ed/0x470
  [<ffffffff81115890>] ? __writepage+0x0/0x40
  [<ffffffff811161d4>] generic_writepages+0x24/0x30
  [<ffffffff81117191>] do_writepages+0x21/0x40
  [<ffffffff8110d5bb>] __filemap_fdatawrite_range+0x5b/0x60
  [<ffffffff8110d61a>] filemap_write_and_wait_range+0x5a/0x80
  [<ffffffff8118fc7a>] vfs_fsync_range+0x5a/0x90
  [<ffffffff8118fd1c>] vfs_fsync+0x1c/0x20
  [<ffffffff8118fd5a>] do_fsync+0x3a/0x60
  [<ffffffff8118ffd0>] sys_fsync+0x10/0x20
  [<ffffffff8100c002>] system_call_fastpath+0x16/0x1b
INFO: task flush-9:126:23013 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
flush-9:126     D 0000000000000005     0 23013      2 0x00000000
  ffff880427bff690 0000000000000046 ffff880427bfffd8 ffff880427bfe000
  0000000000013d00 ffff880432ea03b8 ffff880427bfffd8 0000000000013d00
  ffff88045c6d5b80 ffff880432ea0000 0000000000000bb8 ffff880432edd278

The call trace entries are reoccur after 120 seconds.
I am not sure, but it looks like mdadm or something what mdadm is using=
=20
has a bug. :S

I would like to focus on this error. It is not a big problem that the=20
array is not displayed after reboot.
@HTH: I used dpkg-reconfigure mdadm and enabled to autostart the daemon=
,=20
but I assume it does not work due the error above. Syslog has the entry=
:
kernel: [  151.885406] md: md127 stopped.
kernel: [  151.895662] md: bind<sdd>
kernel: [  151.895788] md: bind<sdc>
kernel: [  151.895892] md: bind<sdb>
kernel: [  151.895984] md: bind<sde>
kernel: [  154.085294] md: bind<sde>
kernel: [  154.085448] md: bind<sdb>
kernel: [  154.085553] md: bind<sdc>
kernel: [  154.085654] md: bind<sdd>
kernel: [  154.144676] bio: create slab <bio-1> at 1
kernel: [  154.144689] md/raid:md126: not clean -- starting background=20
reconstruction
kernel: [  154.144700] md/raid:md126: device sdd operational as raid di=
sk 0
kernel: [  154.144702] md/raid:md126: device sdc operational as raid di=
sk 1
kernel: [  154.144705] md/raid:md126: device sdb operational as raid di=
sk 2
kernel: [  154.144707] md/raid:md126: device sde operational as raid di=
sk 3
kernel: [  154.145224] md/raid:md126: allocated 4282kB
kernel: [  154.145320] md/raid:md126: raid level 5 active with 4 out of=
=20
4 devices, algorithm 0
kernel: [  154.145324] RAID conf printout:
kernel: [  154.145326]  --- level:5 rd:4 wd:4
kernel: [  154.145328]  disk 0, o:1, dev:sdd
kernel: [  154.145330]  disk 1, o:1, dev:sdc
kernel: [  154.145332]  disk 2, o:1, dev:sdb
kernel: [  154.145334]  disk 3, o:1, dev:sde
kernel: [  154.145367] md126: detected capacity change from 0 to=20
3000607178752
mdadm[1188]: NewArray event detected on md device /dev/md126
kernel: [  154.174753]  md126: p1
mdadm[1188]: RebuildStarted event detected on md device /dev/md126


Kind Regards,

Iwan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
