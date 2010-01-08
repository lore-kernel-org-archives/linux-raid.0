From: Brett Russ <bruss@netezza.com>
Subject: Re: bug/race in md causing device to wedge in busy state
Date: Fri, 08 Jan 2010 10:18:50 -0500
Message-ID: <hi7icq$s71$1@ger.gmane.org>
References: <4B2983AE.8020002@netezza.com> <20091224101256.39d2d09a@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091224101256.39d2d09a@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/23/2009 06:12 PM, Neil Brown wrote:
> Can you please see if the following patch fixes the problem.
>
> When an array wants to resync but is waiting for other arrays
> on the same devices to finish their resync, it does not abort the
> resync attempt properly when an error is reported.
> This should fix that.

Neil,

Sorry for the delay--holidays, etc.  I tried the patch and, while the 
newly added code is getting hit, I'm still hitting the issue.  See below:

> mxmx# ./sim_md_busy.sh -dg1 /dev/sdg -dg2 /dev/sdp -df /dev/sdp -dr /dev/sdp -create -m bug3part 2>&1 | tee md_busy_run_bug3part.6
> mdadm --create /dev/md0  --force --run --level=1 --raid-devices=2 /dev/sdg1  /dev/sdp1 --assume-clean
> mdadm: /dev/sdg1 appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Fri Jan  8 10:11:09 2010
> mdadm: /dev/sdp1 appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Fri Jan  8 10:11:09 2010
> mdadm: array /dev/md0 started.
> mdadm --create /dev/md1  --force --run --level=1 --raid-devices=2 /dev/sdg3  /dev/sdp3 --assume-clean
> mdadm: /dev/sdg3 appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Fri Jan  8 10:11:09 2010
> mdadm: /dev/sdp3 appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Fri Jan  8 10:11:09 2010
> mdadm: array /dev/md1 started.
> mdadm --create /dev/md2  --force --run --level=1 --raid-devices=2 /dev/sdg4  /dev/sdp4 --assume-clean
> mdadm: /dev/sdg4 appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Fri Jan  8 10:11:09 2010
> mdadm: /dev/sdp4 appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Fri Jan  8 10:11:09 2010
> mdadm: array /dev/md2 started.
> mdadm --verbose  --manage /dev/md0 --fail   /dev/sdp1
> mdadm: set /dev/sdp1 faulty in /dev/md0
> mdadm --verbose  --manage /dev/md0 --remove   /dev/sdp1
> mdadm: hot removed /dev/sdp1
> mdadm --verbose  --manage /dev/md1 --fail   /dev/sdp3
> mdadm: set /dev/sdp3 faulty in /dev/md1
> mdadm --verbose  --manage /dev/md1 --remove   /dev/sdp3
> mdadm: hot removed /dev/sdp3
> mdadm --verbose  --manage /dev/md2 --fail   /dev/sdp4
> mdadm: set /dev/sdp4 faulty in /dev/md2
> mdadm --verbose  --manage /dev/md2 --remove   /dev/sdp4
> mdadm: hot removed /dev/sdp4
> mdadm --verbose  --manage /dev/md0 --add   /dev/sdp1
> mdadm: added /dev/sdp1
> mdadm --verbose  --manage /dev/md1 --add   /dev/sdp3
> mdadm: added /dev/sdp3
> mdadm --verbose  --manage /dev/md2 --add   /dev/sdp4
> mdadm: added /dev/sdp4
> Personalities : [raid1] [raid10]
> md2 : active raid1 sdp4[2] sdg4[0]
>       4200896 blocks [2/1] [U_]
>         resync=DELAYED
>
> md1 : active raid1 sdp3[2] sdg3[0]
>       4200896 blocks [2/1] [U_]
>         resync=DELAYED
>
> md0 : active raid1 sdp1[2] sdg1[0]
>       4200896 blocks [2/1] [U_]
>       [>....................]  recovery =  1.9% (80256/4200896) finish=0.8min speed=80256K/sec
>
> unused devices: <none>
> mdadm --verbose  --manage /dev/md0 --fail   /dev/sdp1
> mdadm: set /dev/sdp1 faulty in /dev/md0
> mdadm --verbose  --manage /dev/md0 --remove   /dev/sdp1
> mdadm: hot removed /dev/sdp1
> mdadm --verbose  --manage /dev/md1 --fail   /dev/sdp3
> mdadm: set /dev/sdp3 faulty in /dev/md1
> mdadm --verbose  --manage /dev/md1 --remove   /dev/sdp3
> mdadm: hot remove failed for /dev/sdp3: Device or resource busy
> mdadm: hot remove failed for /dev/sdp3: Device or resource busy
> mdadm: hot remove failed for /dev/sdp3: Device or resource busy
> ERROR: Command failed after 3 retries (mdadm --verbose  --manage /dev/md1 --remove   /dev/sdp3)
> mdadm --verbose  --manage /dev/md2 --fail   /dev/sdp4
> mdadm: set /dev/sdp4 faulty in /dev/md2
> mdadm --verbose  --manage /dev/md2 --remove   /dev/sdp4
> mdadm: hot removed /dev/sdp4


And the log from this run:

> Jan  8 10:11:41 mxmx user.notice root: chkpt
> Jan  8 10:11:46 mxmx user.info kernel: md: bind<sdg1>
> Jan  8 10:11:46 mxmx user.info kernel: md: bind<sdp1>
> Jan  8 10:11:46 mxmx user.info kernel: raid1: raid set md0 active with 2 out of 2 mirrors
> Jan  8 10:11:46 mxmx user.info kernel: md0: detected capacity change from 0 to 4301717504
> Jan  8 10:11:46 mxmx user.info kernel: md: bind<sdg3>
> Jan  8 10:11:46 mxmx user.info kernel: md: bind<sdp3>
> Jan  8 10:11:46 mxmx user.info kernel: raid1: raid set md1 active with 2 out of 2 mirrors
> Jan  8 10:11:46 mxmx user.info kernel: md1: detected capacity change from 0 to 4301717504
> Jan  8 10:11:47 mxmx user.info kernel: md: bind<sdg4>
> Jan  8 10:11:47 mxmx user.info kernel: md: bind<sdp4>
> Jan  8 10:11:47 mxmx user.info kernel: raid1: raid set md2 active with 2 out of 2 mirrors
> Jan  8 10:11:47 mxmx user.info kernel: md2: detected capacity change from 0 to 4301717504
> Jan  8 10:11:48 mxmx user.info kernel:  md0:
> Jan  8 10:11:48 mxmx user.info kernel:  unknown partition table
> Jan  8 10:11:48 mxmx user.alert kernel: raid1: Disk failure on sdp1, disabling device.
> Jan  8 10:11:48 mxmx user.alert kernel: raid1: Operation continuing on 1 devices.
> Jan  8 10:11:48 mxmx user.warn kernel: RAID1 conf printout:
> Jan  8 10:11:48 mxmx user.warn kernel:  --- wd:1 rd:2
> Jan  8 10:11:48 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg1
> Jan  8 10:11:48 mxmx user.warn kernel:  disk 1, wo:1, o:0, dev:sdp1
> Jan  8 10:11:48 mxmx user.warn kernel: RAID1 conf printout:
> Jan  8 10:11:48 mxmx user.warn kernel:  --- wd:1 rd:2
> Jan  8 10:11:48 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg1
> Jan  8 10:11:50 mxmx user.info kernel: md: unbind<sdp1>
> Jan  8 10:11:50 mxmx user.info kernel: md: export_rdev(sdp1)
> Jan  8 10:11:50 mxmx user.info kernel:  md1:
> Jan  8 10:11:50 mxmx user.info kernel:  unknown partition table
> Jan  8 10:11:50 mxmx user.alert kernel: raid1: Disk failure on sdp3, disabling device.
> Jan  8 10:11:50 mxmx user.alert kernel: raid1: Operation continuing on 1 devices.
> Jan  8 10:11:50 mxmx user.warn kernel: RAID1 conf printout:
> Jan  8 10:11:50 mxmx user.warn kernel:  --- wd:1 rd:2
> Jan  8 10:11:50 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg3
> Jan  8 10:11:50 mxmx user.warn kernel:  disk 1, wo:1, o:0, dev:sdp3
> Jan  8 10:11:50 mxmx user.warn kernel: RAID1 conf printout:
> Jan  8 10:11:50 mxmx user.warn kernel:  --- wd:1 rd:2
> Jan  8 10:11:50 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg3
> Jan  8 10:11:52 mxmx user.info kernel: md: unbind<sdp3>
> Jan  8 10:11:52 mxmx user.info kernel: md: export_rdev(sdp3)
> Jan  8 10:11:52 mxmx user.info kernel:  md2:
> Jan  8 10:11:52 mxmx user.info kernel:  unknown partition table
> Jan  8 10:11:52 mxmx user.alert kernel: raid1: Disk failure on sdp4, disabling device.
> Jan  8 10:11:52 mxmx user.alert kernel: raid1: Operation continuing on 1 devices.
> Jan  8 10:11:52 mxmx user.warn kernel: RAID1 conf printout:
> Jan  8 10:11:52 mxmx user.warn kernel:  --- wd:1 rd:2
> Jan  8 10:11:52 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg4
> Jan  8 10:11:52 mxmx user.warn kernel:  disk 1, wo:1, o:0, dev:sdp4
> Jan  8 10:11:52 mxmx user.warn kernel: RAID1 conf printout:
> Jan  8 10:11:52 mxmx user.warn kernel:  --- wd:1 rd:2
> Jan  8 10:11:52 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg4
> Jan  8 10:11:54 mxmx user.info kernel: md: unbind<sdp4>
> Jan  8 10:11:54 mxmx user.info kernel: md: export_rdev(sdp4)
> Jan  8 10:11:54 mxmx user.info kernel: md: bind<sdp1>
> Jan  8 10:11:54 mxmx user.warn kernel: RAID1 conf printout:
> Jan  8 10:11:54 mxmx user.warn kernel:  --- wd:1 rd:2
> Jan  8 10:11:54 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg1
> Jan  8 10:11:54 mxmx user.warn kernel:  disk 1, wo:1, o:1, dev:sdp1
> Jan  8 10:11:54 mxmx user.info kernel: md: recovery of RAID array md0
> Jan  8 10:11:54 mxmx user.info kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> Jan  8 10:11:54 mxmx user.info kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
> Jan  8 10:11:54 mxmx user.info kernel: md: using 128k window, over a total of 4200896 blocks.
> Jan  8 10:11:54 mxmx user.info kernel: md: bind<sdp3>
> Jan  8 10:11:54 mxmx user.warn kernel: RAID1 conf printout:
> Jan  8 10:11:54 mxmx user.warn kernel:  --- wd:1 rd:2
> Jan  8 10:11:54 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg3
> Jan  8 10:11:54 mxmx user.warn kernel:  disk 1, wo:1, o:1, dev:sdp3
> Jan  8 10:11:54 mxmx user.info kernel: md: delaying recovery of md1 until md0 has finished (they share one or more physical units)
> Jan  8 10:11:55 mxmx user.info kernel: md: bind<sdp4>
> Jan  8 10:11:55 mxmx user.warn kernel: RAID1 conf printout:
> Jan  8 10:11:55 mxmx user.warn kernel:  --- wd:1 rd:2
> Jan  8 10:11:55 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg4
> Jan  8 10:11:55 mxmx user.warn kernel:  disk 1, wo:1, o:1, dev:sdp4
> Jan  8 10:11:55 mxmx user.info kernel: md: delaying recovery of md2 until md1 has finished (they share one or more physical units)
> Jan  8 10:11:56 mxmx user.alert kernel: raid1: Disk failure on sdp1, disabling device.
> Jan  8 10:11:56 mxmx user.alert kernel: raid1: Operation continuing on 1 devices.
> Jan  8 10:11:56 mxmx user.info kernel: md: md0: recovery done.
> Jan  8 10:11:56 mxmx user.info kernel: md: delaying recovery of md2 until md1 has finished (they share one or more physical units)
> Jan  8 10:11:56 mxmx user.info kernel: md: delaying recovery of md1 until md2 has finished (they share one or more physical units)
> Jan  8 10:11:56 mxmx user.warn kernel: RAID1 conf printout:
> Jan  8 10:11:56 mxmx user.warn kernel:  --- wd:1 rd:2
> Jan  8 10:11:56 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg1
> Jan  8 10:11:56 mxmx user.warn kernel:  disk 1, wo:1, o:0, dev:sdp1
> Jan  8 10:11:56 mxmx user.info kernel: md: recovery of RAID array md2
> Jan  8 10:11:56 mxmx user.info kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> Jan  8 10:11:56 mxmx user.info kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
> Jan  8 10:11:56 mxmx user.info kernel: md: using 128k window, over a total of 4200896 blocks.
> Jan  8 10:11:56 mxmx user.warn kernel: RAID1 conf printout:
> Jan  8 10:11:56 mxmx user.warn kernel:  --- wd:1 rd:2
> Jan  8 10:11:56 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg1
> Jan  8 10:11:58 mxmx user.info kernel: md: unbind<sdp1>
> Jan  8 10:11:58 mxmx user.info kernel: md: export_rdev(sdp1)
> Jan  8 10:11:58 mxmx user.alert kernel: raid1: Disk failure on sdp3, disabling device.
> Jan  8 10:11:58 mxmx user.alert kernel: raid1: Operation continuing on 1 devices.
> Jan  8 10:12:00 mxmx user.warn kernel: md: cannot remove active disk sdp3 from md1 ...
> Jan  8 10:12:01 mxmx user.warn kernel: md: cannot remove active disk sdp3 from md1 ...
> Jan  8 10:12:02 mxmx user.warn kernel: md: cannot remove active disk sdp3 from md1 ...
> Jan  8 10:12:03 mxmx user.alert kernel: raid1: Disk failure on sdp4, disabling device.
> Jan  8 10:12:03 mxmx user.alert kernel: raid1: Operation continuing on 1 devices.
> Jan  8 10:12:03 mxmx user.info kernel: md: md2: recovery done.
> Jan  8 10:12:03 mxmx user.err kernel: md: running bug fix for md1
> Jan  8 10:12:03 mxmx user.warn kernel: RAID1 conf printout:
> Jan  8 10:12:03 mxmx user.warn kernel: RAID1 conf printout:
> Jan  8 10:12:03 mxmx user.warn kernel:  --- wd:1 rd:2
> Jan  8 10:12:03 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg4
> Jan  8 10:12:03 mxmx user.warn kernel:  disk 1, wo:1, o:0, dev:sdp4
> Jan  8 10:12:03 mxmx user.warn kernel:  --- wd:1 rd:2
> Jan  8 10:12:03 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg3
> Jan  8 10:12:03 mxmx user.warn kernel:  disk 1, wo:1, o:0, dev:sdp3
> Jan  8 10:12:03 mxmx user.warn kernel: RAID1 conf printout:
> Jan  8 10:12:03 mxmx user.warn kernel:  --- wd:1 rd:2
> Jan  8 10:12:03 mxmx user.warn kernel: RAID1 conf printout:
> Jan  8 10:12:03 mxmx user.warn kernel:  --- wd:1 rd:2
> Jan  8 10:12:03 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg4
> Jan  8 10:12:03 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg3
> Jan  8 10:12:05 mxmx user.info kernel: md: unbind<sdp4>
> Jan  8 10:12:05 mxmx user.info kernel: md: export_rdev(sdp4)


Note the line "md: running bug fix for md1" at 10:12:03 which I added to 
your patch inside the 'if' before the 'goto'.  Looks like it hit that 
code *after* the busy...

Thanks,
Brett

