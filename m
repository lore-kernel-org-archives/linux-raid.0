From: Benedikt Fraunhofer
	<benedikt.fraunhofer.lists.mdadm.67B-ACM@traced.net>
Subject: raid6 caught in rebuild loop
Date: Thu, 30 Jan 2014 19:10:41 +0100
Message-ID: <CAD_6HTEiHUVLFV1zCvn+--8wWSbocgGX7vExX5He0vu59cCAnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello List,

Hope that hasn't been answered elsewhere; searching for "mdadm rebuild loop"
refers to all sorts of mdadm loopback related posts :)

recently, one of my raid6-arrays came up with one drive missing.
No big deal, I just re-added the drive and thanks to the bitmap, rebuild
was quite fast. At ~100% it got caught in a loop of
"rebuild finished -> rebuilding" and /proc/mdstat showed something like
"Rebuild: DELAYED" and "rebuild 100%"

I didn't want to have the raid with one drive missing for long, so i just
cleared  the superblock of the drive and re-added it. Some time later the
drive (now for real) failed and I decided to get a new one.

In the meantime the raid came online with one of the cables not fully plugged
in. Again no big deal but again this endless rebuild loop.
I'm running 3.2.0-58 with mdadm 3.2.5 (but tried 3.3 as well)
and syslog says something like:

Jan 30 18:08:29 zmurcht kernel: [  140.550455] md: bind<sdd>
Jan 30 18:08:29 zmurcht kernel: [  140.598177] RAID conf printout:
Jan 30 18:08:29 zmurcht kernel: [  140.598182]  --- level:6 rd:8 wd:6
Jan 30 18:08:29 zmurcht kernel: [  140.598185]  disk 0, o:1, dev:sde
Jan 30 18:08:29 zmurcht kernel: [  140.598188]  disk 1, o:1, dev:sdg
Jan 30 18:08:29 zmurcht kernel: [  140.598191]  disk 2, o:1, dev:sdi
Jan 30 18:08:29 zmurcht kernel: [  140.598194]  disk 4, o:1, dev:sdh
Jan 30 18:08:29 zmurcht kernel: [  140.598197]  disk 5, o:1, dev:sdd
Jan 30 18:08:29 zmurcht kernel: [  140.598200]  disk 6, o:1, dev:sdf
Jan 30 18:08:29 zmurcht kernel: [  140.598203]  disk 7, o:1, dev:sdc
Jan 30 18:08:29 zmurcht kernel: [  140.598404] md: recovery of RAID array md127
Jan 30 18:08:29 zmurcht kernel: [  140.598409] md: minimum
_guaranteed_  speed: 1000 KB/sec/disk.
Jan 30 18:08:29 zmurcht kernel: [  140.598413] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jan 30 18:08:29 zmurcht kernel: [  140.598430] md: using 128k window,
over a total of 3906887168k.
Jan 30 18:08:30 zmurcht mdadm[2220]: RebuildStarted event detected on
md device /dev/md127
Jan 30 18:09:26 zmurcht kernel: [  197.719647] md: md127: recovery done.
Jan 30 18:09:27 zmurcht kernel: [  198.044326] RAID conf printout:
Jan 30 18:09:27 zmurcht kernel: [  198.044330]  --- level:6 rd:8 wd:6
Jan 30 18:09:27 zmurcht kernel: [  198.044333]  disk 0, o:1, dev:sde
Jan 30 18:09:27 zmurcht kernel: [  198.044335]  disk 1, o:1, dev:sdg
Jan 30 18:09:27 zmurcht kernel: [  198.044337]  disk 2, o:1, dev:sdi
Jan 30 18:09:27 zmurcht kernel: [  198.044339]  disk 4, o:1, dev:sdh
Jan 30 18:09:27 zmurcht kernel: [  198.044341]  disk 5, o:1, dev:sdd
Jan 30 18:09:27 zmurcht kernel: [  198.044343]  disk 6, o:1, dev:sdf
Jan 30 18:09:27 zmurcht kernel: [  198.044345]  disk 7, o:1, dev:sdc
Jan 30 18:09:27 zmurcht kernel: [  198.044346] RAID conf printout:
Jan 30 18:09:27 zmurcht kernel: [  198.044348]  --- level:6 rd:8 wd:6
Jan 30 18:09:27 zmurcht kernel: [  198.044350]  disk 0, o:1, dev:sde
Jan 30 18:09:27 zmurcht kernel: [  198.044352]  disk 1, o:1, dev:sdg
Jan 30 18:09:27 zmurcht kernel: [  198.044354]  disk 2, o:1, dev:sdi
Jan 30 18:09:27 zmurcht kernel: [  198.044356]  disk 4, o:1, dev:sdh
Jan 30 18:09:27 zmurcht kernel: [  198.044358]  disk 5, o:1, dev:sdd
Jan 30 18:09:27 zmurcht kernel: [  198.044360]  disk 6, o:1, dev:sdf
Jan 30 18:09:27 zmurcht kernel: [  198.044362]  disk 7, o:1, dev:sdc
Jan 30 18:09:27 zmurcht kernel: [  198.044590] md: recovery of RAID array md127
Jan 30 18:09:27 zmurcht kernel: [  198.044595] md: minimum
_guaranteed_  speed: 1000 KB/sec/disk.
Jan 30 18:09:27 zmurcht kernel: [  198.044599] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jan 30 18:09:27 zmurcht kernel: [  198.044613] md: using 128k window,
over a total of 3906887168k.
Jan 30 18:09:27 zmurcht kernel: [  198.044616] md: resuming recovery
of md127 from checkpoint.
Jan 30 18:09:27 zmurcht kernel: [  198.044663] md: md127: recovery done.
Jan 30 18:09:27 zmurcht kernel: [  198.145718] RAID conf printout:


which repeats over and over in rapid succession:

bf@zmurcht:/tmp$ grep -e "recovery done" -e "recovery of" a | head
Jan 30 18:08:29 zmurcht kernel: [  140.598404] md: recovery of RAID array md127
Jan 30 18:09:26 zmurcht kernel: [  197.719647] md: md127: recovery done.
Jan 30 18:09:27 zmurcht kernel: [  198.044590] md: recovery of RAID array md127
Jan 30 18:09:27 zmurcht kernel: [  198.044616] md: resuming recovery
of md127 from checkpoint.
Jan 30 18:09:27 zmurcht kernel: [  198.044663] md: md127: recovery done.
Jan 30 18:09:27 zmurcht kernel: [  198.145988] md: recovery of RAID array md127
Jan 30 18:09:27 zmurcht kernel: [  198.146006] md: resuming recovery
of md127 from checkpoint.
Jan 30 18:09:27 zmurcht kernel: [  198.146016] md: md127: recovery done.
Jan 30 18:09:27 zmurcht kernel: [  198.245932] md: recovery of RAID array md127
Jan 30 18:09:27 zmurcht kernel: [  198.245950] md: resuming recovery
of md127 from checkpoint.
bf@zmurcht:/tmp$ grep -e "recovery done" -e "recovery of" a | tail
Jan 30 18:10:01 zmurcht kernel: [  232.350503] md: resuming recovery
of md127 from checkpoint.
Jan 30 18:10:01 zmurcht kernel: [  232.350571] md: md127: recovery done.
Jan 30 18:10:01 zmurcht kernel: [  232.450390] md: recovery of RAID array md127
Jan 30 18:10:01 zmurcht kernel: [  232.450471] md: resuming recovery
of md127 from checkpoint.
Jan 30 18:10:01 zmurcht kernel: [  232.450539] md: md127: recovery done.
Jan 30 18:10:01 zmurcht kernel: [  232.583628] md: recovery of RAID array md127
Jan 30 18:10:01 zmurcht kernel: [  232.583706] md: resuming recovery
of md127 from checkpoint.
Jan 30 18:10:01 zmurcht kernel: [  232.583715] md: md127: recovery done.
Jan 30 18:10:01 zmurcht kernel: [  232.690245] md: recovery of RAID array md127
Jan 30 18:10:01 zmurcht kernel: [  232.690320] md: resuming recovery
of md127 from checkpoint.
bf@zmurcht:/tmp$ grep -e "recovery done" -e "recovery of" a | wc -l
979

until stopped with mdadm --stop /dev/md127 (which takes a long time)


I don't want to make the same mistake as I did with the first drive,
so any advice is welcome.

Maybe the checkpoint is pointing to something wrong or isn't updated
on completion?

May it be safe to clear the bitmap and re-add the drive with --assume-clean?

Thx in advance

 Benedikt
