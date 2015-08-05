From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: read errors aren't corrected
Date: Wed, 5 Aug 2015 19:43:46 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1508032020560.11810@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

again, I have encountered drive with pending sectors, where a echo "check" 
would complete, errors were reported, but sectors were not corrected:

Linux 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt11-1 (2015-05-24) x86_64 GNU/Linux

mdadm - v3.3.2 - 21st August 2014

[4915870.008999] md: data-check of RAID array md0
[4915870.009006] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[4915870.009010] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[4915870.009021] md: using 128k window, over a total of 1953512960k.
[4944694.439086] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
(repeat of above line approx 20 times)
[4944694.439167] sd 0:0:11:0: [sdl] Unhandled sense code
[4944694.439173] sd 0:0:11:0: [sdl]
[4944694.439178] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[4944694.439183] sd 0:0:11:0: [sdl]
[4944694.439188] Sense Key : Medium Error [current]
[4944694.439195] Info fld=0xddc6ccf0
[4944694.439202] sd 0:0:11:0: [sdl]
[4944694.439207] Add. Sense: Unrecovered read error
[4944694.439212] sd 0:0:11:0: [sdl] CDB:
[4944694.439216] Read(10): 28 00 dd c6 cb 28 00 04 00 00
[4944694.439231] end_request: critical medium error, dev sdl, sector 3720792872
[4946407.483424] md: md0: data-check done.

I ran the check 3 times, but still the pending sectors wouldn't go away.

Some of the times it would say it corrected errors:

[4828415.776842] sd 0:0:11:0: [sdl] Unhandled sense code
[4828415.776848] sd 0:0:11:0: [sdl]
[4828415.776852] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[4828415.776860] sd 0:0:11:0: [sdl]
[4828415.776864] Sense Key : Medium Error [current]
[4828415.776871] Info fld=0xddc44018
[4828415.776876] sd 0:0:11:0: [sdl]
[4828415.776881] Add. Sense: Unrecovered read error
[4828415.776886] sd 0:0:11:0: [sdl] CDB:
[4828415.776890] Read(10): 28 00 dd c4 40 00 00 00 80 00
[4828415.776905] end_request: critical medium error, dev sdl, sector 3720626176
[4828416.853170] raid5_end_read_request: 22 callbacks suppressed
[4828416.853189] md/raid:md0: read error corrected (8 sectors at 3720626176 on sdl)
[4828416.853198] md/raid:md0: read error corrected (8 sectors at 3720626184 on sdl)
[4828416.853203] md/raid:md0: read error corrected (8 sectors at 3720626192 on sdl)
[4828416.853208] md/raid:md0: read error corrected (8 sectors at 3720626200 on sdl)
[4828416.853213] md/raid:md0: read error corrected (8 sectors at 3720626208 on sdl)
[4828416.853217] md/raid:md0: read error corrected (8 sectors at 3720626216 on sdl)
[4828416.853223] md/raid:md0: read error corrected (8 sectors at 3720626224 on sdl)
[4828416.853228] md/raid:md0: read error corrected (8 sectors at 3720626232 on sdl)
[4828416.853236] md/raid:md0: read error corrected (8 sectors at 3720626240 on sdl)
[4828416.853242] md/raid:md0: read error corrected (8 sectors at 3720626248 on sdl)

I then gave up, proceeded to --replace the drive, take it out of the 
md-array completely, do a destructive badblocks write test to it, it wrote 
to the entire drive, and that made pending sectors go to 0.

What's weird is that there aren't any mentions of UNC in "smartctl -a" 
error log. The drive is a Samsung HD204UI with 1AQ10001 firmware if that 
makes any difference.

At no time was the drive kicked out of the array during any of these 
tests. I run with 180 seconds timeouts in the kernel.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
