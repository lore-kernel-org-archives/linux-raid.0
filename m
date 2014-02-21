From: "Samer, Michael (I/ET-83, extern)" <extern.michael.samer@audi.de>
Subject: AW: raid 'check' does not provoke expected i/o error
Date: Fri, 21 Feb 2014 08:25:49 +0000
Message-ID: <A2EC67620EC7424F9EC3DD49243E9060466ECD34@AUDIINSX0328.audi.vwg>
References: <5307034E.9080007@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5307034E.9080007@eyal.emu.id.au>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: 'Eyal Lebedinsky' <eyal@eyal.emu.id.au>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>In short: smartctl lists one pending sector. A dd of that disk provokes an i/o error
>as expected. A raid 'sync_action=check' does not find a problem and does *not* trigger
>an i/o error. Why?

Hello Eyal
Why not using ddrescue (or dd_rescue) instead (errorprone).

>My smart log is indicating a pending sector in a component of a 7x4TB (software) raid6
>device. Looking at that component I see:
>
># smartctl -x /dev/sdi
>...
>197 Current_Pending_Sector  -O--CK   200   200   000    -    1
>...
>SMART Extended Self-test Log Version: 1 (1 sectors)
>Num  Test_Description    Status                  Remaining  LifeTime(hours)  >LBA_of_first_error
># 1  Short offline       Completed: read failure       90%      5878         261696
>...
>
>I then test this by attempting to read around the bad sector:
>
># dd if=/dev/sdi of=/dev/null skip=261120 count=2048
>dd: error reading '/dev/sdi': Input/output error
>576+0 records in
>576+0 records out
>294912 bytes (295 kB) copied, 3.18338 s, 92.6 kB/s
>
>and the log shows:
>
># dmesg|tail
>[768141.382189]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
>[768141.461997]         00 03 fe 40
>[768141.503122] sd 6:0:6:0: [sdi]
>[768141.542668] Add. Sense: Unrecovered read error - auto reallocate failed
>[768141.623913] sd 6:0:6:0: [sdi] CDB:
>[768141.667622] Read(16): 88 00 00 00 00 00 00 03 fe 40 00 00 00 08 00 00
>[768141.748586] end_request: I/O error, dev sdi, sector 261696
>[768141.816217] Buffer I/O error on device sdi, logical block 32712
>[768141.889061] ata13: EH complete
>[768141.927696] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
>
>I ran a raid check
>
>Feb 21 00:05:01 e7 kernel: [815562.730457] md: data-check of RAID array md127
>Feb 21 00:05:01 e7 kernel: [815562.745190] md: minimum _guaranteed_  speed: 100000 >KB/sec/disk.
>Feb 21 00:05:01 e7 kernel: [815562.764583] md: using maximum available idle IO bandwidth >(but not more than 200000 KB/sec) for data-check.
>Feb 21 00:05:01 e7 kernel: [815562.795202] md: using 128k window, over a total of >3906885120k.
>Feb 21 09:48:28 e7 kernel: [850585.930844] md: md127: data-check done.
>
>It did not find any problem and did not trigger an i/o error, and the final >mismatch_count=0.
>Neither was the pending cluster reallocated (which would happen if it was written to by
>the raid6 if it saw a read i/o error, I think).
>
>Q1) Why do I *not* see an i/o error from the raid check?
>
>Q2) Do we have a writeup on how to translate the sector (in the i/o error) to a block
>in the raid device (/dev/mdN)?
>
>Here is how I see it:
>I know that /dev/sdi1 starts 2048 sectors into the disk (call it 256 4k blocks).
>Being a 7 disk raid6 means that this block (n=32712-256=32456) is seen by the
>fs near block (b=n*5=162280) and this [n,...,n+4] is the block number to use
>to start tracing with debugfs. I do assume that my ext4 also uses 4k blocks.
>
>I still have the pending sector and am ready to experiment (up to a point...).
>
>TIA
>
>-- 
>Eyal Lebedinsky (eyal@eyal.emu.id.au)
>--
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
