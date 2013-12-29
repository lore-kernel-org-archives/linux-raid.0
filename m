From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Can raid1-resync cause a corruption?
Date: Sun, 29 Dec 2013 13:27:35 +0200
Message-ID: <CAGRgLy6qoYFW0BabE4qUT2kc61MEjpCS7x_PnxW+iCRUPzB6AA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
Cc: yair@zadarastorage.com
List-Id: linux-raid.ids

Hi Neil,
I see in the code, that read_balance is careful not to do
read-balancing, if the area in question is under resync:
    if (conf->mddev->recovery_cp < MaxSector &&
        (this_sector + sectors >= conf->next_resync)) {
        choose_first = 1;
        start_disk = 0;
    } else {
        choose_first = 0;
        start_disk = conf->last_used;
    }

However, I see that next_resync is updated in sync_request:
conf->next_resync = sector_nr;
before actually completing the resync of that area, before even
submitting the read-bios. Is this correct? Should we perhaps update
next_sync at the point where we update curr_resync_completed in
md_do_sync?
Kernel that I am looking at is Ubuntu-Precise 3.2.0-29.46.

Below is a sequence of event that lead us to this question.

We have a 3-disk RADI1, with ext4 mounted on top and mysql running,
whose files are on that ext4.
# 3-disk RAID1 was recovering from an unclean shutdown (crash) of the
machine, it started resync:

Dec 26 08:05:42 vc kernel: [11576870.520393] md: md1 stopped.
Dec 26 08:05:42 vc kernel: [11576870.526898] md: bind<dm-2>
Dec 26 08:05:42 vc kernel: [11576870.534819] md: bind<dm-3>
Dec 26 08:05:42 vc kernel: [11576870.535908] md: bind<dm-1>
Dec 26 08:05:42 vc kernel: [11576870.580730] md/raid1:md1: not clean
-- starting background reconstruction
Dec 26 08:05:42 vc kernel: [11576870.580735] md/raid1:md1: active with
3 out of 3 mirrors
Dec 26 08:05:42 vc kernel: [11576870.581399] created bitmap (1 pages)
for device md1
Dec 26 08:05:42 vc kernel: [11576870.582386] md1: bitmap initialized
from disk: read 1/1 pages, set 5 of 5 bits
Dec 26 08:05:42 vc kernel: [11576870.583335] md1: detected capacity
change from 0 to 320773120
Dec 26 08:05:42 vc kernel: [11576870.585593] md: resync of RAID array md1
Dec 26 08:05:42 vc kernel: [11576870.585597] md: minimum _guaranteed_
speed: 10000 KB/sec/disk.
Dec 26 08:05:42 vc kernel: [11576870.585601] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
resync.
Dec 26 08:05:42 vc kernel: [11576870.585617] md: using 128k window,
over a total of 313255k.
Dec 26 08:05:42 vc kernel: [11576870.687868]  md1: unknown partition table

# meanwhile, ext4 was mounted on top of it (dm-4 is a devicemapper
target on top of MD1, which collects some stats, but otherwise does
not interfere with bios in any way). ext4 also realized the unclean
shutdown:
Dec 26 08:05:42 vc kernel: [11576870.936166] [14831]dm_iostat
[dm_iostat_ctr] Successfully set up dm (252:4) iostats on top of
/dev/md1 (9:1), flags=0x80
Dec 26 08:05:43 vc kernel: [11576871.159955] [EXT4 FS bs=1024, gc=39,
bpg=8192, ipg=2016, mo=9c02c818, mo2=0000]
Dec 26 08:05:43 vc kernel: [11576871.160092] EXT4-fs (dm-4): recovery complete
Dec 26 08:05:43 vc kernel: [11576871.161099] EXT4-fs (dm-4): mounted
filesystem with ordered data mode. Opts: debug,data_err=abort

# mysql was started on top of ext4, and also realized the unclean shutdown:
InnoDB: Log scan progressed past the checkpoint lsn 18148639
131226  8:05:44  InnoDB: Database was not shut down normally!
InnoDB: Starting crash recovery.
InnoDB: Reading tablespace information from the .ibd files...
InnoDB: Restoring possible half-written data pages from the doublewrite
InnoDB: buffer...
InnoDB: Doing recovery: scanned up to log sequence number 18154016
131226  8:05:44  InnoDB: Starting an apply batch of log records to the
database...
InnoDB: Progress in percents: 11 12 13 14 15 16 17 18 19 20 21 22 23
24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46
47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69
70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92
93 94 95 96 97 98 99
InnoDB: Apply batch completed
131226  8:05:44  InnoDB: Waiting for the background threads to start

8 seconds later, raid1-resync completed:
Dec 26 08:05:52 vc kernel: [11576880.161306] md: md1: resync done.
Dec 26 08:05:52 vc kernel: [11576880.221701] RAID1 conf printout:
Dec 26 08:05:52 vc kernel: [11576880.221705]  --- wd:3 rd:3
Dec 26 08:05:52 vc kernel: [11576880.221709]  disk 0, wo:0, o:1, dev:dm-1
Dec 26 08:05:52 vc kernel: [11576880.221712]  disk 1, wo:0, o:1, dev:dm-2
Dec 26 08:05:52 vc kernel: [11576880.221714]  disk 2, wo:0, o:1, dev:dm-3

# The system ran normally for about 5 minutes, and then was shutdown cleanly:
# mysql was stopped cleanly
131226  8:11:28 [Note] /usr/sbin/mysqld: Normal shutdown
131226  8:11:28 [Note] Event Scheduler: Purging the queue. 0 events
131226  8:11:30 [Warning] /usr/sbin/mysqld: Forcing close of thread 68
 user: 'change_vsa_user'
131226  8:11:30 [Warning] /usr/sbin/mysqld: Forcing close of thread 59
 user: 'standbyVc0'
131226  8:11:30  InnoDB: Starting shutdown...
131226  8:11:31  InnoDB: Waiting for 3 pages to be flushed
131226  8:11:31  InnoDB: Shutdown completed; log sequence number 18626878
131226  8:11:31 [Note] /usr/sbin/mysqld: Shutdown complete

# ext4 was cleanly unmounted (no print in the kernel for that)
# md1 was stopped cleanly
Dec 26 08:11:31 vc kernel: [11577219.716151] md1: detected capacity
change from 320773120 to 0
Dec 26 08:11:31 vc kernel: [11577219.716158] md: md1 stopped.
Dec 26 08:11:31 vc kernel: [11577219.716167] md: unbind<dm-1>
Dec 26 08:11:31 vc kernel: [11577219.740152] md: export_rdev(dm-1)
Dec 26 08:11:31 vc kernel: [11577219.740174] md: unbind<dm-3>
Dec 26 08:11:31 vc kernel: [11577219.772137] md: export_rdev(dm-3)
Dec 26 08:11:31 vc kernel: [11577219.772158] md: unbind<dm-2>
Dec 26 08:11:31 vc kernel: [11577219.810269] md: export_rdev(dm-2)

# Then the system was brought up again
# md1 was assembled with a clean bitmap
Dec 26 08:11:40 vc kernel: [  337.918676] md: md1 stopped.
Dec 26 08:11:40 vc kernel: [  337.923588] md: bind<dm-2>
Dec 26 08:11:40 vc kernel: [  337.924085] md: bind<dm-3>
Dec 26 08:11:40 vc kernel: [  337.924511] md: bind<dm-1>
Dec 26 08:11:40 vc kernel: [  337.927127] md: raid1 personality
registered for level 1
Dec 26 08:11:40 vc kernel: [  337.927264] bio: create slab <bio-1> at 1
Dec 26 08:11:40 vc kernel: [  337.927435] md/raid1:md1: active with 3
out of 3 mirrors
Dec 26 08:11:40 vc kernel: [  337.927826] created bitmap (1 pages) for
device md1
Dec 26 08:11:40 vc kernel: [  337.928341] md1: bitmap initialized from
disk: read 1/1 pages, set 0 of 5 bits
Dec 26 08:11:40 vc kernel: [  337.929316] md1: detected capacity
change from 0 to 320773120
Dec 26 08:11:40 vc kernel: [  337.934610]  md1: unknown partition table

# ext4 was mounted cleanly
Dec 26 08:11:40 vc kernel: [  338.036300] [6536]dm_iostat
[dm_iostat_ctr] Successfully set up dm (252:4) iostats on top of
/dev/md1 (9:1), flags=0x80
Dec 26 08:11:40 vc kernel: [  338.063921] [EXT4 FS bs=1024, gc=39,
bpg=8192, ipg=2016, mo=9c02c818, mo2=0000]
Dec 26 08:11:40 vc kernel: [  338.064104] EXT4-fs (dm-4): mounted
filesystem with ordered data mode. Opts: debug,data_err=abort

# but then mysql detected a corruption
131226 8:11:40 InnoDB: Error: space id and page n:o stored in the page
InnoDB: read in are 543256175:543236195, should be 0:595!
InnoDB: Database page corruption on disk or a failed
InnoDB: file read of page 595.
InnoDB: You may have to recover from a backup.
131226 8:11:40 InnoDB: Page dump in ascii and hex (16384 bytes):

It happened only once, and we do a lot of testing of such unclean
shutdowns.The only theory that we have is that raid1 resync somehow
changed the underlying data of mysql/ext4.

Thanks,
Alex.
