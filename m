From: "Turbo Fredriksson" <turbo@swe.net>
Subject: Re: RAID5 won't start
Date: Mon, 25 Oct 2004 11:38:15 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <ST8luK49.1098704295.0300840.turbo@emil.swe.net>
References: <9fBHj5pj.1098700926.1885870.turbo@emil.swe.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9fBHj5pj.1098700926.1885870.turbo@emil.swe.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Den 10/25/2004, skrev "Turbo Fredriksson" <turbo@swe.net>:

>sdf1    /dev/scsi/host3/bus0/target8/lun0/part1:  device 1 in 9 device active raid5 md1.
>sdg1    /dev/scsi/host3/bus0/target9/lun0/part1:  device 2 in 9 device active raid5 md1.
>sdp1    /dev/scsi/host4/bus0/target4/lun0/part1:  device 3 in 9 device active raid5 md1.
>sdq1    /dev/scsi/host4/bus0/target5/lun0/part1:  device 4 in 9 device active raid5 md1.
>sdr1    /dev/scsi/host4/bus0/target8/lun0/part1:  device 5 in 9 device active raid5 md1.
>sds1    /dev/scsi/host4/bus0/target9/lun0/part1:  device 6 in 9 device active raid5 md1.
>sdx1    /dev/scsi/host4/bus0/target14/lun0/part1: device 7 in 9 device active raid5 md1.
>sdd1    /dev/scsi/host3/bus0/target4/lun0/part1:  device 9 in 9 device active raid5 md1.

Looking at this and digging up some old boot logs, I see that it got
something wrong
here...

This is what it SHOULD look like:

----- s n i p -----
Oct 22 11:31:22 aurora kernel: raid5: device sdd1 operational as raid
disk 0
Oct 22 11:31:22 aurora kernel: raid5: device sdf1 operational as raid
disk 1
Oct 22 11:31:22 aurora kernel: raid5: device sdg1 operational as raid
disk 2
Oct 22 11:31:22 aurora kernel: raid5: device sdp1 operational as raid
disk 3
Oct 22 11:31:22 aurora kernel: raid5: device sdq1 operational as raid
disk 4
Oct 22 11:31:22 aurora kernel: raid5: device sdr1 operational as raid
disk 5
Oct 22 11:31:22 aurora kernel: raid5: device sds1 operational as raid
disk 6
Oct 22 11:31:22 aurora kernel: raid5: device sdx1 operational as raid
disk 7
Oct 22 11:31:22 aurora kernel: raid5: allocated 18726kB for md1
Oct 22 11:31:22 aurora kernel: raid5: raid level 5 set md1 active with 8
out of 9 devices, algorithm 2
----- s n i p -----

The failed device here is/was on purpose. It hangs the array, so I marked
it
faulty. It never had any data on it (and doesn't have a valid
superblock).

For some reason it beleives that sdd1 should be at the END of the array
and
not at the beginning. Rerunning mdadm with the correct order I get:

----- s n i p -----
aurora:/dev# mdadm --assemble md1 --force --run sdd1 sdf1 sdg1 sdp1 sdq1
sdr1 sds1 sdx1
md: md1 stopped.
md: bind<sdg1>
md: bind<sdp1>
md: bind<sdq1>
md: bind<sdr1>
md: bind<sds1>
md: bind<sdx1>
md: bind<sdd1>
md: bind<sdf1>
raid5: device sdf1 operational as raid disk 1
raid5: device sdx1 operational as raid disk 7
raid5: device sds1 operational as raid disk 6
raid5: device sdr1 operational as raid disk 5
raid5: device sdq1 operational as raid disk 4
raid5: device sdp1 operational as raid disk 3
raid5: device sdg1 operational as raid disk 2
raid5: not enough operational devices for md1 (2/9 failed)
RAID5 conf printout:
 --- rd:9 wd:7 fd:2
 disk 1, o:1, dev:sdf1
 disk 2, o:1, dev:sdg1
 disk 3, o:1, dev:sdp1
 disk 4, o:1, dev:sdq1
 disk 5, o:1, dev:sdr1
 disk 6, o:1, dev:sds1
 disk 7, o:1, dev:sdx1
raid5: failed to run raid set md1
md: pers->run() failed ...
mdadm: failed to RUN_ARRAY md1: Invalid argument
----- s n i p -----

Question is, where the h**l is sdd1!?


This message was sent using Swe.Net webmail
