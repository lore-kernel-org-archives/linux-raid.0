From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Raid5 reshape stuck at 0% - SuSE leap 42.1
Date: Sun, 7 Aug 2016 20:06:05 +0100
Message-ID: <57A7869D.2090203@youngman.org.uk>
References: <57A69012.1010406@youngman.org.uk>
 <alpine.DEB.2.02.1608071154110.3593@uplift.swm.pp.se>
 <57A719CC.6080301@youngman.org.uk> <57A724ED.5070808@youngman.org.uk>
 <alpine.DEB.2.02.1608071630050.3593@uplift.swm.pp.se>
 <57A766DC.4000207@youngman.org.uk>
 <alpine.DEB.2.02.1608071923410.3593@uplift.swm.pp.se>
 <57A776AE.3050308@youngman.org.uk>
 <alpine.DEB.2.02.1608072002400.3593@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1608072002400.3593@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/08/16 19:05, Mikael Abrahamsson wrote:
> On Sun, 7 Aug 2016, Wols Lists wrote:
> 
>> I'm guessing it should be "mdadm --grow --raid-devices=3
>> --backup-file=whatever", but I think I've already tried that, and that's
>> what got me into this mess :-)
> 
> Try without backup file (it shouldn't be needed when growing under these
> circumstances). If it doesn't start rebuilding after issuing --grow, try
> --continue when the array is actually up and running (don't stop it when
> it's "frozen" and says rebuilding but doesn't actually show any
> rebuilding going on). That has worked for others.
> 
> Use latest git version of mdadm.
> 
> Please post output from all commands and dmesg if it still fails.
> 
Guess what ...

Note that I think this dmesg stuff overlaps with the last lot, namely
the start of this is the tail end of the array starting successfully
last time.

I'm using ./mdadm, so that's the version I downloaded from Neil's
repository yesterday ... I'll investigate the source when I get the
chance (wives!!! :-)

So is this virtualbox and fuse playing up? Dunno ... (this vm is
mono-processor - shouldn't make any difference ...)

Cheers,
Wol



mdadm: /dev/md127 has been started with 2 drives and 2 spares.
kanga:/home/anthony/mdadm # mount /dev/md127 /mnt/testarray/
kanga:/home/anthony/mdadm # ./madm /dev/md127 --grow --raid-devices=3
bash: ./madm: No such file or directory
kanga:/home/anthony/mdadm # ./mdadm /dev/md127 --grow --raid-devices=3
mdadm: Failed to initiate reshape!
kanga:/home/anthony/mdadm # ./mdadm /dev/md127 --grow --continue
kanga:/home/anthony/mdadm #


>
[21390.529578] md/raid:md127: device sdb operational as raid disk 0
[21390.529618] md/raid:md127: device sdc operational as raid disk 1
[21390.531258] md/raid:md127: allocated 2250kB
[21390.534250] md/raid:md127: raid level 5 active with 2 out of 2
devices, algorithm 2
[21390.534259] RAID conf printout:
[21390.534263]  --- level:5 rd:2 wd:2
[21390.534269]  disk 0, o:1, dev:sdb
[21390.534273]  disk 1, o:1, dev:sdc
[21390.534419] md127: detected capacity change from 0 to 8581545984
[21390.539650] RAID conf printout:
[21390.539682]  --- level:5 rd:2 wd:2
[21390.539690]  disk 0, o:1, dev:sdb
[21390.539694]  disk 1, o:1, dev:sdc
[21390.539698] RAID conf printout:
[21390.539701]  --- level:5 rd:2 wd:2
[21390.539704]  disk 0, o:1, dev:sdb
[21390.539707]  disk 1, o:1, dev:sdc
[21435.972237] EXT4-fs (md127): mounted filesystem with ordered data
mode. Opts: (null)
[22157.683863] device-mapper: uevent: version 1.0.3
[22157.686018] device-mapper: ioctl: 4.31.0-ioctl (2015-3-12)
initialised: dm-devel@redhat.com
[22165.688223] fuse init (API version 7.23)
[22243.094448] 06:10:19.795789 control  Error: Getting host message
failed with VERR_INTERRUPTED
[22244.094733] 06:10:20.796092 control  Guest control service stopped
[22244.094789] 06:10:20.796207 control  Guest control worker returned
with rc=VERR_INTERRUPTED
[22244.095871] 06:10:20.797229 main     Session 0 is about to close ...
[22244.095922] 06:10:20.797343 main     Stopping all guest processes ...
[22244.095956] 06:10:20.797379 main     Closing all guest files ...
[22244.099090] 06:10:20.800461 main     Ended.
[22244.641855] VBoxService 5.0.24_SUSE r108355 (verbosity: 0)
linux.amd64 (openSUSE Buildservice) release log
00:00:00.000257 main     Log opened 2016-08-07T18:07:43.777555000Z
[22244.641971] 00:00:00.000481 main     OS Product: Linux
[22244.642016] 00:00:00.000526 main     OS Release: 4.1.15-8-default
[22244.642056] 00:00:00.000564 main     OS Version: #1 SMP PREEMPT Wed
Jan 20 16:41:00 UTC 2016 (0e3b3ab)
[22244.642206] 00:00:00.000604 main     Executable: /usr/sbin/VBoxService
00:00:00.000605 main     Process ID: 12443
00:00:00.000606 main     Package type: LINUX_64BITS_GENERIC (OSE)
[22244.643245] 00:00:00.001736 main     5.0.24_SUSE r108355 started.
Verbose level = 0
[22567.452608] SFW2-INext-DROP-DEFLT IN=eth0 OUT=
MAC=08:00:27:0b:0f:57:52:54:00:12:35:02:08:00 SRC=10.0.2.2 DST=10.0.2.15
LEN=576 TOS=0x10 PREC=0x00 TTL=64 ID=2252 PROTO=UDP SPT=67 DPT=68 LEN=556
[25196.727211] RAID conf printout:
[25196.727217]  --- level:5 rd:2 wd:2
[25196.727238]  disk 0, o:1, dev:sdb
[25196.727240]  disk 1, o:1, dev:sdc
[25196.727246] RAID conf printout:
[25196.727248]  --- level:5 rd:2 wd:2
[25196.727250]  disk 0, o:1, dev:sdb
[25196.727251]  disk 1, o:1, dev:sdc
anthony@kanga:/mnt/anthony>


