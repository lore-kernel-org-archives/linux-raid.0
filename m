From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: Bisected: Kernel 4.14 + has 3 times higher write IO latency than
 Kernel 4.4 with raid1
Date: Tue, 6 Aug 2019 13:57:53 +0200
Message-ID: <CAMGffEkfs0KsuWX8vGY==1dym78d6wsao_otSjzBAPzwGtoQcw@mail.gmail.com>
References: <CAMGffEkotpvVz8FA78vNFh0qZv3kEMNrXXfVPEUC=MhH0pMCZA@mail.gmail.com>
 <0a83fde3-1a74-684c-0d70-fb44b9021f96@molgen.mpg.de> <CAMGffE=_kPoBmSwbxvrqdqbhpR5Cu2Vbe4ArGqm9ns9+iVEH_g@mail.gmail.com>
 <CAMGffEkcXcQC+kjwdH0iVSrFDk-o+dp+b3Q1qz4z=R=6D+QqLQ@mail.gmail.com>
 <87h86vjhv0.fsf@notabene.neil.brown.name> <CAMGffEnKXQJBbDS8Yi0S5ZKEMHVJ2_SKVPHeb9Rcd6oT_8eTuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMGffEnKXQJBbDS8Yi0S5ZKEMHVJ2_SKVPHeb9Rcd6oT_8eTuw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Alexandr Iarygin <alexandr.iarygin@cloud.ionos.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Paul Menzel <pmenzel@molgen.mpg.de>, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Aug 6, 2019 at 9:54 AM Jinpu Wang <jinpu.wang@cloud.ionos.com> wrote:
>
> On Tue, Aug 6, 2019 at 1:46 AM NeilBrown <neilb@suse.com> wrote:
> >
> > On Mon, Aug 05 2019, Jinpu Wang wrote:
> >
> > > Hi Neil,
> > >
> > > For the md higher write IO latency problem, I bisected it to these commits:
> > >
> > > 4ad23a97 MD: use per-cpu counter for writes_pending
> > > 210f7cd percpu-refcount: support synchronous switch to atomic mode.
> > >
> > > Do you maybe have an idea? How can we fix it?
> >
> > Hmmm.... not sure.
> Hi Neil,
>
> Thanks for reply, detailed result in line.
> >
> > My guess is that the set_in_sync() call from md_check_recovery()
> > is taking a long time, and is being called too often.
> >
> > Could you try two experiments please.
> >
> Baseline on 5.3-rc3:
> root@ib2:/home/jwang# cat md_lat_ib2_5.3.0-rc3-1-storage_2019_0806_092003.log
> write-test: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
> fio-2.2.10
> Starting 1 process
>
> write-test: (groupid=0, jobs=1): err= 0: pid=2621: Tue Aug  6 09:20:44 2019
>   write: io=800004KB, bw=20000KB/s, iops=4999, runt= 40001msec
>     slat (usec): min=2, max=69992, avg= 5.37, stdev=374.95
>     clat (usec): min=0, max=147, avg= 2.42, stdev=13.57
>      lat (usec): min=2, max=70079, avg= 7.84, stdev=376.07
>     clat percentiles (usec):
>      |  1.00th=[    0],  5.00th=[    0], 10.00th=[    0], 20.00th=[    1],
>      | 30.00th=[    1], 40.00th=[    1], 50.00th=[    1], 60.00th=[    1],
>      | 70.00th=[    1], 80.00th=[    1], 90.00th=[    1], 95.00th=[    1],
>      | 99.00th=[   96], 99.50th=[  125], 99.90th=[  137], 99.95th=[  139],
>      | 99.99th=[  141]
>     bw (KB  /s): min=18454, max=21608, per=100.00%, avg=20005.15, stdev=352.24
>     lat (usec) : 2=98.52%, 4=0.01%, 10=0.01%, 20=0.02%, 50=0.06%
>     lat (usec) : 100=0.46%, 250=0.94%
>   cpu          : usr=4.64%, sys=0.00%, ctx=197118, majf=0, minf=11
>   IO depths    : 1=98.5%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=1.3%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=0/w=200001/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=32
>
> Run status group 0 (all jobs):
>   WRITE: io=800004KB, aggrb=19999KB/s, minb=19999KB/s, maxb=19999KB/s,
> mint=40001msec, maxt=40001msec
>
> Disk stats (read/write):
>     md0: ios=60/199436, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
> aggrios=0/0, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0,
> aggrutil=0.00%
>   ram0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
>   ram1: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
>
>
> > 1/ set  /sys/block/md0/md/safe_mode_delay
> >    to 20 or more.  It defaults to about 0.2.
> only set 20 to safe_mode_delay,  give a nice improvement.
> root@ib2:/home/jwang# cat md_lat_ib2_5.3.0-rc3-1-storage_2019_0806_092144.log
> write-test: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
> fio-2.2.10
> Starting 1 process
>
> write-test: (groupid=0, jobs=1): err= 0: pid=2676: Tue Aug  6 09:22:25 2019
>   write: io=800004KB, bw=20000KB/s, iops=4999, runt= 40001msec
>     slat (usec): min=2, max=99490, avg= 2.98, stdev=222.46
>     clat (usec): min=0, max=103, avg= 0.96, stdev= 4.51
>      lat (usec): min=2, max=99581, avg= 3.99, stdev=222.71
>     clat percentiles (usec):
>      |  1.00th=[    0],  5.00th=[    0], 10.00th=[    0], 20.00th=[    0],
>      | 30.00th=[    1], 40.00th=[    1], 50.00th=[    1], 60.00th=[    1],
>      | 70.00th=[    1], 80.00th=[    1], 90.00th=[    1], 95.00th=[    1],
>      | 99.00th=[    1], 99.50th=[    1], 99.90th=[   90], 99.95th=[   91],
>      | 99.99th=[   95]
>     bw (KB  /s): min=20000, max=20008, per=100.00%, avg=20001.82, stdev= 3.38
>     lat (usec) : 2=99.72%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
>     lat (usec) : 100=0.25%, 250=0.01%
>   cpu          : usr=3.17%, sys=1.48%, ctx=199470, majf=0, minf=11
>   IO depths    : 1=99.7%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.2%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=0/w=200001/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=32
>
> Run status group 0 (all jobs):
>   WRITE: io=800004KB, aggrb=19999KB/s, minb=19999KB/s, maxb=19999KB/s,
> mint=40001msec, maxt=40001msec
>
> Disk stats (read/write):
>     md0: ios=60/199461, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
> aggrios=0/0, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0,
> aggrutil=0.00%
>   ram0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
>   ram1: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
>
>
> >
> > 2/ comment out the call the set_in_sync() in md_check_recovery().
> Only commented out set_in_sync get a better improvement
> root@ib2:/home/jwang# cat md_lat_ib2_5.3.0-rc3-1-storage+_2019_0806_093340.log
> write-test: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
> fio-2.2.10
> Starting 1 process
>
> write-test: (groupid=0, jobs=1): err= 0: pid=2626: Tue Aug  6 09:34:20 2019
>   write: io=800004KB, bw=20000KB/s, iops=4999, runt= 40001msec
>     slat (usec): min=2, max=29, avg= 2.49, stdev= 0.72
>     clat (usec): min=0, max=101, avg= 0.78, stdev= 1.17
>      lat (usec): min=2, max=117, avg= 3.34, stdev= 1.25
>     clat percentiles (usec):
>      |  1.00th=[    0],  5.00th=[    0], 10.00th=[    0], 20.00th=[    0],
>      | 30.00th=[    1], 40.00th=[    1], 50.00th=[    1], 60.00th=[    1],
>      | 70.00th=[    1], 80.00th=[    1], 90.00th=[    1], 95.00th=[    1],
>      | 99.00th=[    1], 99.50th=[    1], 99.90th=[    1], 99.95th=[    1],
>      | 99.99th=[   72]
>     bw (KB  /s): min=20000, max=20008, per=100.00%, avg=20002.03, stdev= 3.50
>     lat (usec) : 2=99.96%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
>     lat (usec) : 100=0.02%, 250=0.01%
>   cpu          : usr=4.17%, sys=0.00%, ctx=199951, majf=0, minf=12
>   IO depths    : 1=100.0%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=0/w=200001/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=32
>
> Run status group 0 (all jobs):
>   WRITE: io=800004KB, aggrb=19999KB/s, minb=19999KB/s, maxb=19999KB/s,
> mint=40001msec, maxt=40001msec
>
> Disk stats (read/write):
>     md0: ios=60/199435, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
> aggrios=0/0, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0,
> aggrutil=0.00%
>   ram0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
>   ram1: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
>
> With both applied
> root@ib2:/home/jwang# cat md_lat_ib2_5.3.0-rc3-1-storage+_2019_0806_093916.log
> write-test: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
> fio-2.2.10
> Starting 1 process
>
> write-test: (groupid=0, jobs=1): err= 0: pid=2709: Tue Aug  6 09:39:57 2019
>   write: io=800004KB, bw=20000KB/s, iops=4999, runt= 40001msec
>     slat (usec): min=2, max=16, avg= 2.46, stdev= 0.69
>     clat (usec): min=0, max=100, avg= 0.61, stdev= 1.18
>      lat (usec): min=2, max=104, avg= 3.12, stdev= 1.33
>     clat percentiles (usec):
>      |  1.00th=[    0],  5.00th=[    0], 10.00th=[    0], 20.00th=[    0],
>      | 30.00th=[    0], 40.00th=[    0], 50.00th=[    1], 60.00th=[    1],
>      | 70.00th=[    1], 80.00th=[    1], 90.00th=[    1], 95.00th=[    1],
>      | 99.00th=[    1], 99.50th=[    1], 99.90th=[    1], 99.95th=[    1],
>      | 99.99th=[   70]
>     bw (KB  /s): min=20000, max=20008, per=100.00%, avg=20002.73, stdev= 3.82
>     lat (usec) : 2=99.96%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
>     lat (usec) : 100=0.02%, 250=0.01%
>   cpu          : usr=3.33%, sys=1.31%, ctx=199941, majf=0, minf=12
>   IO depths    : 1=100.0%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=0/w=200001/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=32
>
> Run status group 0 (all jobs):
>   WRITE: io=800004KB, aggrb=19999KB/s, minb=19999KB/s, maxb=19999KB/s,
> mint=40001msec, maxt=40001msec
>
> Disk stats (read/write):
>     md0: ios=60/199460, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
> aggrios=0/0, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0,
> aggrutil=0.00%
>   ram0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
>   ram1: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
>
> >
> > Then run the least separately after each of these changes.
> >
>
>
> > I the second one makes a difference, I'd like to know how often it gets
> > called - and why.  The test
> >         if ( ! (
> >                 (mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
> >                 test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
> >                 test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
> >                 (mddev->external == 0 && mddev->safemode == 1) ||
> >                 (mddev->safemode == 2
> >                  && !mddev->in_sync && mddev->recovery_cp == MaxSector)
> >                 ))
> >                 return;
> >
I added following debug message:
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2404,6 +2404,8 @@ static void export_array(struct mddev *mddev)
 static bool set_in_sync(struct mddev *mddev)
 {
        lockdep_assert_held(&mddev->lock);
+       pr_info("md %s in_sync is %d, sb_flags %ld, recovery %ld,
external %d, safemode %d, recovery_cp %llu\n",mdname(mddev),
mddev->in_sync, mddev->sb_flags, mddev->recovery, mddev->external,
mddev->safemode, (unsigned long long)mddev->recovery_cp);
+
        if (!mddev->in_sync) {
                mddev->sync_checkers++;
                spin_unlock(&mddev->lock);
@@ -2411,6 +2413,7 @@ static bool set_in_sync(struct mddev *mddev)
                spin_lock(&mddev->lock);
                if (!mddev->in_sync &&
                    percpu_ref_is_zero(&mddev->writes_pending)) {
+            pr_info("set_in_sync\n");
                        mddev->in_sync = 1;
                        /*
                         * Ensure ->in_sync is visible before we clear

The relevant dmesg:
[  103.976374] md/raid1:md0: not clean -- starting background reconstruction
[  103.976479] md/raid1:md0: active with 2 out of 2 mirrors
[  103.976597] md0: detected capacity change from 0 to 535822336
[  103.976721] md: resync of RAID array md0
[  104.427369] md md0 in_sync is 0, sb_flags 6, recovery 3, external
0, safemode 0, recovery_cp 393216
[  105.052186] md md0 in_sync is 0, sb_flags 2, recovery 3, external
0, safemode 0, recovery_cp 458752
[  105.127718] set_in_sync
[  105.133299] md md0 in_sync is 0, sb_flags 2, recovery 3, external
0, safemode 0, recovery_cp 524288
[  105.207723] set_in_sync
[  105.213318] md md0 in_sync is 0, sb_flags 2, recovery 3, external
0, safemode 0, recovery_cp 589824
[  105.287717] set_in_sync
[  105.293299] md md0 in_sync is 0, sb_flags 2, recovery 3, external
0, safemode 0, recovery_cp 655360
[  105.347718] set_in_sync
[  105.353267] md md0 in_sync is 0, sb_flags 2, recovery 3, external
0, safemode 0, recovery_cp 720896
[  105.397717] set_in_sync
[  105.403367] md md0 in_sync is 0, sb_flags 2, recovery 3, external
0, safemode 0, recovery_cp 786432
[  105.457718] set_in_sync
[  105.981324] md md0 in_sync is 0, sb_flags 2, recovery 3, external
0, safemode 0, recovery_cp 851968
[  106.017718] set_in_sync
[  106.022784] md md0 in_sync is 0, sb_flags 2, recovery 3, external
0, safemode 0, recovery_cp 917504
[  106.057718] set_in_sync
[  106.063357] md md0 in_sync is 0, sb_flags 2, recovery 3, external
0, safemode 0, recovery_cp 983040
[  106.117718] set_in_sync
[  106.122851] md: md0: resync done.
[  106.123261] md md0 in_sync is 0, sb_flags 5, recovery 19, external
0, safemode 0, recovery_cp 18446744073709551615
[  106.157741] md md0 in_sync is 0, sb_flags 0, recovery 32, external
0, safemode 0, recovery_cp 18446744073709551615
[  106.217718] set_in_sync
[  144.707722] md md0 in_sync is 0, sb_flags 0, recovery 0, external
0, safemode 0, recovery_cp 18446744073709551615
[  144.767720] set_in_sync

Please let me know if you need further information, I can also test
any draft patch if needed.

Thanks,
Jack Wang




> > should normally return when doing lots of IO - I'd like to know
> > which condition causes it to not return.
> I will check, and report later today.
> Thanks again!
>
> Jack Wang
> >
> > Thanks,
> > NeilBrown
