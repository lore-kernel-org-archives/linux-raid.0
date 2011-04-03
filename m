From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What the heck happened to my array? (No apparent data loss).
Date: Sun, 3 Apr 2011 12:47:34 -0300
Message-ID: <AANLkTi=2GNYdySbCDXmaDC8-8vF8GU9V3Uoy1qByNq58@mail.gmail.com>
References: <4D9876E4.6080501@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D9876E4.6080501@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

what kernel version? more informations about your linux box?

2011/4/3 Brad Campbell <lists2009@fnarfbargle.com>:
> 2.6.38.2
> x86_64
> 10 x 1TB SATA drives in a single RAID-6
>
> Here is the chain of events.
>
> Saturday morning I started a reshape on a 10 element RAID-6. Simply c=
hanging
> the Chunk size from 512k to 64k. This was going to take about 4.5 day=
s
> according to the initial estimates.
>
> I then went away for the weekend and came home to a wedged array.
> Here is the chain of events that caused it.
>
> This occurred about 1 minute after my scheduled morning SMART long (i=
t is
> Sunday after all) began.
>
> Apr =A03 03:19:08 srv kernel: [288180.455339] sd 0:0:12:0: [sdd] Unha=
ndled
> error code
> Apr =A03 03:19:08 srv kernel: [288180.455359] sd 0:0:12:0: [sdd] =A0R=
esult:
> hostbyte=3D0x04 driverbyte=3D0x00
> Apr =A03 03:19:08 srv kernel: [288180.455377] sd 0:0:12:0: [sdd] CDB:
> cdb[0]=3D0x2a: 2a 00 00 00 00 08 00 00 02 00
> Apr =A03 03:19:08 srv kernel: [288180.455415] end_request: I/O error,=
 dev sdd,
> sector 8
> Apr =A03 03:19:08 srv kernel: [288180.455449] end_request: I/O error,=
 dev sdd,
> sector 8
> Apr =A03 03:19:08 srv kernel: [288180.455462] md: super_written gets =
error=3D-5,
> uptodate=3D0
> Apr =A03 03:19:08 srv kernel: [288180.455477] md/raid:md0: Disk failu=
re on
> sdd, disabling device.
> Apr =A03 03:19:08 srv kernel: [288180.455480] md/raid:md0: Operation
> continuing on 9 devices.
> Apr =A03 03:19:08 srv kernel: [288180.472914] md: md0: reshape done.
> Apr =A03 03:19:08 srv kernel: [288180.472983] md: delaying data-check=
 of md5
> until md3 has finished (they share one or more physical units)
> Apr =A03 03:19:08 srv kernel: [288180.473002] md: delaying data-check=
 of md4
> until md6 has finished (they share one or more physical units)
> Apr =A03 03:19:08 srv kernel: [288180.473030] md: delaying data-check=
 of md6
> until md5 has finished (they share one or more physical units)
> Apr =A03 03:19:08 srv kernel: [288180.473047] md: delaying data-check=
 of md3
> until md1 has finished (they share one or more physical units)
> Apr =A03 03:19:08 srv kernel: [288180.551450] md: reshape of RAID arr=
ay md0
> Apr =A03 03:19:08 srv kernel: [288180.551468] md: minimum _guaranteed=
_ speed:
> 200000 KB/sec/disk.
> Apr =A03 03:19:08 srv kernel: [288180.551483] md: using maximum avail=
able idle
> IO bandwidth (but not more than 200000 KB/sec) for reshape.
> Apr =A03 03:19:08 srv kernel: [288180.551514] md: using 128k window, =
over a
> total of 976759808 blocks.
> Apr =A03 03:19:08 srv kernel: [288180.620089] sd 0:0:12:0: [sdd] Sync=
hronizing
> SCSI cache
> Apr =A03 03:19:08 srv mdadm[4803]: RebuildFinished event detected on =
md device
> /dev/md0
> Apr =A03 03:19:08 srv mdadm[4803]: Fail event detected on md device /=
dev/md0,
> component device /dev/sdd
> Apr =A03 03:19:08 srv mdadm[4803]: RebuildStarted event detected on m=
d device
> /dev/md0
> Apr =A03 03:19:10 srv kernel: [288182.614918] scsi 0:0:12:0: Direct-A=
ccess
> ATA =A0 =A0 =A0MAXTOR STM310003 MX1A PQ: 0 ANSI: 5
> Apr =A03 03:19:10 srv kernel: [288182.615312] sd 0:0:12:0: Attached s=
csi
> generic sg3 type 0
> Apr =A03 03:19:10 srv kernel: [288182.618262] sd 0:0:12:0: [sdq] 1953=
525168
> 512-byte logical blocks: (1.00 TB/931 GiB)
> Apr =A03 03:19:10 srv kernel: [288182.736998] sd 0:0:12:0: [sdq] Writ=
e Protect
> is off
> Apr =A03 03:19:10 srv kernel: [288182.737019] sd 0:0:12:0: [sdq] Mode=
 Sense:
> 73 00 00 08
> Apr =A03 03:19:10 srv kernel: [288182.740521] sd 0:0:12:0: [sdq] Writ=
e cache:
> enabled, read cache: enabled, doesn't support DPO or FUA
> Apr =A03 03:19:10 srv kernel: [288182.848999] =A0sdq: unknown partiti=
on table
> Apr =A03 03:19:10 srv ata_id[28453]: HDIO_GET_IDENTITY failed for '/d=
ev/sdq'
> Apr =A03 03:19:10 srv kernel: [288182.970091] sd 0:0:12:0: [sdq] Atta=
ched SCSI
> disk
> Apr =A03 03:20:01 srv /USR/SBIN/CRON[28624]: (brad) CMD ([ -z "`/usr/=
bin/pgrep
> -u brad collect`" ] && /usr/bin/screen -X -S brad-bot screen
> /home/brad/bin/collect-thermostat)
> Apr =A03 03:20:01 srv /USR/SBIN/CRON[28625]: (root) CMD ([ -z `/usr/b=
in/pgrep
> -u root keepalive` ] && /home/brad/bin/launch-keepalive)
> Apr =A03 03:20:01 srv /USR/SBIN/CRON[28626]: (brad) CMD ([ -z "`scree=
n -list |
> grep brad-bot`" ] && /home/brad/bin/botstart)
> Apr =A03 03:20:01 srv /USR/SBIN/CRON[28628]: (root) CMD (if [ -x /usr=
/bin/mrtg
> ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=3DC
> /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi=
)
> Apr =A03 03:20:01 srv /USR/SBIN/CRON[28627]: (brad) CMD
> (/home/brad/rrd/rrd-create-graphs)
> Apr =A03 03:20:01 srv /USR/SBIN/CRON[28590]: (CRON) error (grandchild=
 #28625
> failed with exit status 1)
> Apr =A03 03:20:01 srv /USR/SBIN/CRON[28589]: (CRON) error (grandchild=
 #28626
> failed with exit status 1)
> Apr =A03 03:20:01 srv /USR/SBIN/CRON[28587]: (CRON) error (grandchild=
 #28624
> failed with exit status 1)
> Apr =A03 03:22:10 srv kernel: [288363.070094] INFO: task jbd2/md0-8:2=
647
> blocked for more than 120 seconds.
> Apr =A03 03:22:10 srv kernel: [288363.070114] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Apr =A03 03:22:10 srv kernel: [288363.070132] jbd2/md0-8 =A0 =A0 =A0D
> ffff88041aa52948 =A0 =A0 0 =A02647 =A0 =A0 =A02 0x00000000
> Apr =A03 03:22:10 srv kernel: [288363.070154] =A0ffff88041aa526f0
> 0000000000000046 0000000000000000 ffff8804196769b0
> Apr =A03 03:22:10 srv kernel: [288363.070178] =A00000000000011180
> ffff88041bdc5fd8 0000000000004000 0000000000011180
> Apr =A03 03:22:10 srv kernel: [288363.070201] =A0ffff88041bdc4010
> ffff88041aa52950 ffff88041bdc5fd8 ffff88041aa52948
> Apr =A03 03:22:10 srv kernel: [288363.070224] Call Trace:
> Apr =A03 03:22:10 srv kernel: [288363.070246] =A0[<ffffffff8104e4c6>]=
 ?
> queue_work_on+0x16/0x20
> Apr =A03 03:22:10 srv kernel: [288363.070266] =A0[<ffffffff812e6bfd>]=
 ?
> md_write_start+0xad/0x190
> Apr =A03 03:22:10 srv kernel: [288363.070283] =A0[<ffffffff81052b90>]=
 ?
> autoremove_wake_function+0x0/0x30
> Apr =A03 03:22:10 srv kernel: [288363.070299] =A0[<ffffffff812e16f5>]=
 ?
> make_request+0x35/0x600
> Apr =A03 03:22:10 srv kernel: [288363.070317] =A0[<ffffffff8108463b>]=
 ?
> __alloc_pages_nodemask+0x10b/0x810
> Apr =A03 03:22:10 srv kernel: [288363.070335] =A0[<ffffffff81142042>]=
 ?
> T.1015+0x32/0x90
> Apr =A03 03:22:10 srv kernel: [288363.070350] =A0[<ffffffff812e6a24>]=
 ?
> md_make_request+0xd4/0x200
> Apr =A03 03:22:10 srv kernel: [288363.070366] =A0[<ffffffff81142218>]=
 ?
> ext4_map_blocks+0x178/0x210
> Apr =A03 03:22:10 srv kernel: [288363.070382] =A0[<ffffffff811b6e84>]=
 ?
> generic_make_request+0x144/0x2f0
> Apr =A03 03:22:10 srv kernel: [288363.070397] =A0[<ffffffff8116e89d>]=
 ?
> jbd2_journal_file_buffer+0x3d/0x70
> Apr =A03 03:22:10 srv kernel: [288363.070413] =A0[<ffffffff811b708c>]=
 ?
> submit_bio+0x5c/0xd0
> Apr =A03 03:22:10 srv kernel: [288363.070430] =A0[<ffffffff810e61d5>]=
 ?
> submit_bh+0xe5/0x120
> Apr =A03 03:22:10 srv kernel: [288363.070445] =A0[<ffffffff811709b1>]=
 ?
> jbd2_journal_commit_transaction+0x441/0x1180
> Apr =A03 03:22:10 srv kernel: [288363.070466] =A0[<ffffffff81044893>]=
 ?
> lock_timer_base+0x33/0x70
> Apr =A03 03:22:10 srv kernel: [288363.070480] =A0[<ffffffff81052b90>]=
 ?
> autoremove_wake_function+0x0/0x30
> Apr =A03 03:22:10 srv kernel: [288363.070498] =A0[<ffffffff81174871>]=
 ?
> kjournald2+0xb1/0x1e0
> Apr =A03 03:22:10 srv kernel: [288363.070511] =A0[<ffffffff81052b90>]=
 ?
> autoremove_wake_function+0x0/0x30
> Apr =A03 03:22:10 srv kernel: [288363.070527] =A0[<ffffffff811747c0>]=
 ?
> kjournald2+0x0/0x1e0
> Apr =A03 03:22:10 srv kernel: [288363.070544] =A0[<ffffffff811747c0>]=
 ?
> kjournald2+0x0/0x1e0
> Apr =A03 03:22:10 srv kernel: [288363.070557] =A0[<ffffffff81052716>]=
 ?
> kthread+0x96/0xa0
> Apr =A03 03:22:10 srv kernel: [288363.070573] =A0[<ffffffff81003154>]=
 ?
> kernel_thread_helper+0x4/0x10
> Apr =A03 03:22:10 srv kernel: [288363.070588] =A0[<ffffffff81052680>]=
 ?
> kthread+0x0/0xa0
> Apr =A03 03:22:10 srv kernel: [288363.070602] =A0[<ffffffff81003150>]=
 ?
> kernel_thread_helper+0x0/0x10
>
> So apparently sdd suffered an unknown failure (it happens) and the ar=
ray
> kicked it out (as it should). But 120 seconds later all tasks accessi=
ng that
> array trigger their 120 second hangcheck warning and are all suck in =
the D
> state.
>
> At the time the array was 12.1% of the way through a reshape. I had t=
o
> reboot the machine to get it back up and it's now continuing the resh=
ape on
> 9 drives.
>
> brad@srv:~$ cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [ra=
id4]
> md0 : active raid6 sdc[0] sdh[9] sda[8] sde[7] sdg[5] sdb[4] sdf[3] s=
dm[2]
> sdl[1]
> =A0 =A0 =A07814078464 blocks super 1.2 level 6, 512k chunk, algorithm=
 2 [10/9]
> [UUUUUU_UUU]
> =A0 =A0 =A0[=3D=3D=3D>.................] =A0reshape =3D 16.5% (162091=
008/976759808)
> finish=3D5778.6min speed=3D2349K/sec
>
>
>
> To make matters more confusing the other arrays on the machine were i=
n the
> middle of their "Debians first Sunday of every month" "check" scrub.
>
> I have the full syslog and can probably procure any other information=
 that
> might be useful. I don't think I've lost any data, the machine contin=
ued
> reshaping and we're all moving along nicely. I just wanted to report =
it and
> offer assistance in diagnosing it should that be requested.
>
> Regards,
> Brad
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
