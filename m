From: Andrei Borzenkov <arvidjaar@gmail.com>
Subject: Re: [systemd-devel] Errorneous detection of degraded array
Date: Sat, 28 Jan 2017 20:34:26 +0300
Message-ID: <4504399b-4d6f-a18a-d64a-e46ecd8efa46@gmail.com>
References: <96A26C8C6786C341B83BC4F2BC5419E4795DE9A6@SRF-EXCH1.corp.sunrisefutures.com>
 <b842c2ce-7d32-a392-e9d9-9f330fa6a7cf@gmail.com>
 <96A26C8C6786C341B83BC4F2BC5419E4795DF1D8@SRF-EXCH1.corp.sunrisefutures.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <96A26C8C6786C341B83BC4F2BC5419E4795DF1D8@SRF-EXCH1.corp.sunrisefutures.com>
Sender: linux-raid-owner@vger.kernel.org
To: Luke Pyzowski <Luke@sunrisefutures.com>, "'systemd-devel@lists.freedesktop.org'" <systemd-devel@lists.freedesktop.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

27.01.2017 22:44, Luke Pyzowski пишет:
...
> Jan 27 11:33:14 lnxnfs01 kernel: md/raid:md0: raid level 6 active with 24 out of 24 devices, algorithm 2
...
> Jan 27 11:33:14 lnxnfs01 kernel: md0: detected capacity change from 0 to 45062020923392
> Jan 27 11:33:14 lnxnfs01 systemd[1]: Found device /dev/disk/by-uuid/2b9114be-3d5a-41d7-8d4b-e5047d223129.
> Jan 27 11:33:14 lnxnfs01 systemd[1]: Started udev Wait for Complete Device Initialization.
> Jan 27 11:33:14 lnxnfs01 systemd[1]: Started Timer to wait for more drives before activating degraded array..
> Jan 27 11:33:14 lnxnfs01 systemd[1]: Starting Timer to wait for more drives before activating degraded array..
...
> 
> ... + 31 seconds from disk initialization, expiration of 30 second timer from mdadm-last-resort@.timer
> 
> Jan 27 11:33:45 lnxnfs01 systemd[1]: Created slice system-mdadm\x2dlast\x2dresort.slice.
> Jan 27 11:33:45 lnxnfs01 systemd[1]: Starting system-mdadm\x2dlast\x2dresort.slice.
> Jan 27 11:33:45 lnxnfs01 systemd[1]: Stopped target Local File Systems.
> Jan 27 11:33:45 lnxnfs01 systemd[1]: Stopping Local File Systems.
> Jan 27 11:33:45 lnxnfs01 systemd[1]: Unmounting Mount /share RAID partition explicitly...
> Jan 27 11:33:45 lnxnfs01 systemd[1]: Starting Activate md array even though degraded...
> Jan 27 11:33:45 lnxnfs01 systemd[1]: Stopped (with error) /dev/md0.
> Jan 27 11:33:45 lnxnfs01 systemd[1]: Started Activate md array even though degraded.
> Jan 27 11:33:45 lnxnfs01 systemd[1]: Unmounted Mount /share RAID partition explicitly.
> 

Here is my educated guess.

Both mdadm-last-resort@.timer and mdadm-last-resort@.service conflict
with MD device:

bor@bor-Latitude-E5450:~/src/systemd$ cat ../mdadm/systemd/
mdadm-grow-continue@.service  mdadm.shutdown
SUSE-mdadm_env.sh
mdadm-last-resort@.service    mdmonitor.service
mdadm-last-resort@.timer      mdmon@.service
bor@bor-Latitude-E5450:~/src/systemd$ cat
../mdadm/systemd/mdadm-last-resort@.timer
[Unit]
Description=Timer to wait for more drives before activating degraded array.
DefaultDependencies=no
Conflicts=sys-devices-virtual-block-%i.device

[Timer]
OnActiveSec=30
bor@bor-Latitude-E5450:~/src/systemd$ cat
../mdadm/systemd/mdadm-last-resort@.service
[Unit]
Description=Activate md array even though degraded
DefaultDependencies=no
Conflicts=sys-devices-virtual-block-%i.device

[Service]
Type=oneshot
ExecStart=BINDIR/mdadm --run /dev/%i

I presume intention is to stop these units when MD device is finally
assembled as complete. This is indeed what happens on my (test) system:

Jan 28 14:18:04 linux-ffk5 kernel: md: bind<vda1>
Jan 28 14:18:04 linux-ffk5 kernel: md: bind<vdb1>
Jan 28 14:18:05 linux-ffk5 kernel: md/raid1:md0: active with 2 out of 2
mirrors
Jan 28 14:18:05 linux-ffk5 kernel: md0: detected capacity change from 0
to 5363466240
Jan 28 14:18:06 linux-ffk5 systemd[1]: mdadm-last-resort@md0.timer:
Installed new job mdadm-last-resort@md0.timer/start as 287
Jan 28 14:18:06 linux-ffk5 systemd[1]: mdadm-last-resort@md0.timer:
Enqueued job mdadm-last-resort@md0.timer/start as 287
Jan 28 14:18:06 linux-ffk5 systemd[1]: dev-ttyS9.device: Changed dead ->
plugged
Jan 28 14:18:07 linux-ffk5 systemd[1]: mdadm-last-resort@md0.timer:
Changed dead -> waiting
Jan 28 14:18:12 linux-ffk5 systemd[1]:
sys-devices-virtual-block-md0.device: Changed dead -> plugged
Jan 28 14:18:12 linux-ffk5 systemd[1]: mdadm-last-resort@md0.timer:
Trying to enqueue job mdadm-last-resort@md0.timer/stop/replace
Jan 28 14:18:12 linux-ffk5 systemd[1]: mdadm-last-resort@md0.timer:
Installed new job mdadm-last-resort@md0.timer/stop as 292
Jan 28 14:18:12 linux-ffk5 systemd[1]: mdadm-last-resort@md0.timer:
Enqueued job mdadm-last-resort@md0.timer/stop as 292
Jan 28 14:18:12 linux-ffk5 systemd[1]: mdadm-last-resort@md0.timer:
Changed waiting -> dead
Jan 28 14:18:12 linux-ffk5 systemd[1]: mdadm-last-resort@md0.timer: Job
mdadm-last-resort@md0.timer/stop finished, result=done
Jan 28 14:18:12 linux-ffk5 systemd[1]: Stopped Timer to wait for more
drives before activating degraded array..
Jan 28 14:19:34 10 systemd[1692]: dev-vda1.device: Changed dead -> plugged
Jan 28 14:19:34 10 systemd[1692]: dev-vdb1.device: Changed dead -> plugged


On your system apparently timer is not stopped when md device appears so
that when later last-resort service runs, it causes attempt to stop md
device (due to conflict) and transitively mount on top of it.

Could you try run with systemd.log_level=debug on kernel command line
and upload journal again. We can only hope that it will not skew timings
enough but it may prove my hypothesis.
