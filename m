From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: "Rebuild" speed on a forced resync
Date: Tue, 11 Jan 2005 19:48:57 -0500
Message-ID: <200501120047.j0C0l1928164@www.watkins-home.com>
References: <41E3A0B5.209@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41E3A0B5.209@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: 'Brad Campbell' <brad@wasp.net.au>, 'RAID Linux' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On my system, iostat only reports since re-boot.  Not since last run of
iostat.  I use "sar -d" for current speeds.  In the past, sar has agreed
with /dev/mdstat.

Note, with sar -d, sectors/s are 512 bytes.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Brad Campbell
Sent: Tuesday, January 11, 2005 4:48 AM
To: RAID Linux
Subject: "Rebuild" speed on a forced resync

G'day all,

Just started my big raid using mdadm --update resync to ensure the parity
blocks are A-OK after a 
kernel panic, and I have been monitoring my Disk IO with
iostat -k 5

Now this is an average for a 5 second period.
I note I'm seeing about 12,456 Kilobytes/sec from each drive, but a cat
/proc mdstat is giving me 
6716 Kilobytes/sec. Given I'm doing a read consistency check I would expect
an mdstat speed 9/10ths 
of my bulk per-drive read speed. (This array is sda -> sdj)
Am I missing something really obvious?

Kernel 2.6.10-bk10

Regards,
Brad

avg-cpu:  %user   %nice    %sys %iowait   %idle
           39.18    0.00   60.82    0.00    0.00

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
hda               0.00         0.00         0.00          0          0
sda              97.76     12465.67         0.00      33408          0
sdb              97.76     12465.67         0.00      33408          0
sdc              97.76     12465.67         0.00      33408          0
sdd              97.76     12465.67         0.00      33408          0
sde              97.76     12465.67         0.00      33408          0
sdf              98.51     12465.67         0.00      33408          0
sdg              98.51     12465.67         0.00      33408          0
sdh              98.88     12465.67         0.00      33408          0
sdi             107.09     12465.67         0.00      33408          0
sdj             104.85     12465.67         0.00      33408          0
sdk               3.73         5.97        10.45         16         28
sdl               4.10        11.94         5.97         32         16
sdm               5.22        14.93         7.46         40         20
md0               0.00         0.00         0.00          0          0
md2               8.58        26.87         7.46         72         20


srv:/home/brad# cat /proc/mdstat
Personalities : [raid0] [raid5] [raid6]
md2 : active raid5 sdl[0] sdm[2] sdk[1]
       488396800 blocks level 5, 128k chunk, algorithm 2 [3/3] [UUU]

md0 : active raid5 sda1[0] sdj1[9] sdi1[8] sdh1[7] sdg1[6] sdf1[5] sde1[4]
sdd1[3] sdc1[2] sdb1[1]
       2206003968 blocks level 5, 128k chunk, algorithm 0 [10/10]
[UUUUUUUUUU]
       [===>.................]  resync = 17.4% (42765824/245111552)
finish=501.9min speed=6716K/sec
unused devices: <none>
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

