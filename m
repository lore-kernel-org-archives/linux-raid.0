From: Christoph Nelles <evilazrael@evilazrael.de>
Subject: Re: RAID5 with 2 drive failure at the same time
Date: Thu, 31 Jan 2013 14:15:00 +0100
Message-ID: <510A6E54.5050001@evilazrael.de>
References: <510A4AAE.6000009@evilazrael.de> <20130131113820.GA20536@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010305000405060305030103"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130131113820.GA20536@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------010305000405060305030103
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hello Robin,

thanks for the answers :)

Am 31.01.2013 12:38, schrieb Robin Hill:
> Probably only one drive failed. If the rebuild was incomplete then a
> single drive failure would cause the array to fail. Can you post the
> errors? If the issue was a read failure then you'll need to fix that
> before the array can be recovered properly.

All drives are available again. And the seecond failed device reports
UREs. I will run badblocks on that device before continuing.
I attached the kernel logs of the first error and of the second error. I
hope i filtered them reasonably.

>> The used drives are from /dev/sdb1 to /dev/sdj1 (9 Drives, RAID5), the
>> failed drives are sdj1 and sdg1
>>
> You also seriously need to look at moving to RAID6. Using RAID5 for a
> 9-drive array is not a good idea, and with 3TB drives it's absolutely
> crazy. The odds of a single read error out of the 24TB that needs to be
> read to recover a drive are not insignificant.

I already thought of switching to RAID6. If I can recover from the
current situation, I will do that.

>> The current situation is that I cannot start the RAID. I wanted to try
>> readding on of the the drives, so removed it beforehand, making it a
>> spare :\ The layout is as follows:
>>
>>     Number   Major   Minor   RaidDevice State
>>        0       8       33        0      active sync   /dev/sdc1
>>        1       0        0        1      removed
>>        2       8      113        2      active sync   /dev/sdh1
>>        3       8       49        3      active sync   /dev/sdd1
>>        4       8      129        4      active sync   /dev/sdi1
>>        5       0        0        5      removed
>>        6       8       17        6      active sync   /dev/sdb1
>>        7       8       81        7      active sync   /dev/sdf1
>>        8       8       65        8      active sync   /dev/sde1
>>
>> Re-adding fails with a simple message:
>> # mdadm -v /dev/md0 --re-add /dev/sdg1
>> mdadm: --re-add for /dev/sdg1 to /dev/md0 is not possible
>>
>> I tried re-adding both failed drives at the same, with the same result.
>>
> That's good anyway - it prevented the loss of the existing metadata
> which would definitely have reduced your chances of recovery.
> 
>> When examining the drives, sdj1 has the information from before the crash:
>>    Device Role : Active device 5
>>    Array State : AAAAAAAAA ('A' == active, '.' == missing)
>>
>> sdg1 looks like this
>>    Device Role : spare
>>    Array State : A.AAA.AAA ('A' == active, '.' == missing)
>>
>> The other look like
>>    Device Role : Active device 6
>>    Array State : A.AAA.AAA ('A' == active, '.' == missing)
>>
> From the looks of it, sdg1 was the drive you were originally adding back
> into the array, and sdj1 is the drive that failed part-way through the
> rebuild?

Exactly. I am running badblocks on that device. SMART reports one
"Pending Sector Count" :(

>> So looks that my repair tries made sdg1 a spare :\ I attached the full
>> output to this mail.
>>
>> Is there anyway to restart the RAID from the information contained in
>> drive sdj1? Perhaps via Incremental Build starting from one drive? Could
>> that work? If the RAID wouldn't have been rebuilding before the crash, i
>> would just recreate it with --assume-clean.
>>
> The first thing to try should _always_ be a forced assemble. Recreating
> the array is very much a last-ditch move and should never be attempted
> before asking the list for help (any mismatch in your create command, or
> in the mdadm/kernel versions could cause data corruption). Stop the
> array, then reassemble with the --force flag. It'll probably restart
> with sdj1 added back into the array, and you can then add sdg1 back in
> again and restart the rebuild.

So
# mdadm -A /dev/md0 -f /dev/sdc1 /dev/sdg1 /dev/sdh1 /dev/sdd1 \
/dev/sdi1 /dev/sdj1 /dev/sdb1 /dev/sdf1 /dev/sde1

should work? That would be a really simple solution :)


On sdj1 there is still a superblock from before the crash, while the
others have newer updated superblocks. are there any means to say that
the RAID should be assembled with the older information from this
particular superblock?

>
> Cheers,
>     Robin


Kind regards

Christoph Nelles


-- 
Christoph Nelles

E-Mail    : evilazrael@evilazrael.de
Jabber    : eazrael@evilazrael.net      ICQ       : 78819723

PGP-Key   : ID 0x424FB55B on subkeys.pgp.net
            or http://evilazrael.net/pgp.txt


--------------010305000405060305030103
Content-Type: text/plain;
 name="error2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="error2.txt"

Jan 28 19:50:44 router kernel: md: unbind<sdg1>
Jan 28 19:50:44 router kernel: md: export_rdev(sdg1)
Jan 30 18:17:57 router kernel:  sdg: sdg1
Jan 30 18:19:17 router kernel: md: bind<sdg1>
Jan 30 18:19:18 router kernel: RAID conf printout:
Jan 30 18:19:18 router kernel:  --- level:5 rd:9 wd:8
Jan 30 18:19:18 router kernel:  disk 0, o:1, dev:sdc1
Jan 30 18:19:18 router kernel:  disk 1, o:1, dev:sdg1
Jan 30 18:19:18 router kernel:  disk 2, o:1, dev:sdh1
Jan 30 18:19:18 router kernel:  disk 3, o:1, dev:sdd1
Jan 30 18:19:18 router kernel:  disk 4, o:1, dev:sdi1
Jan 30 18:19:18 router kernel:  disk 5, o:1, dev:sdj1
Jan 30 18:19:18 router kernel:  disk 6, o:1, dev:sdb1
Jan 30 18:19:18 router kernel:  disk 7, o:1, dev:sdf1
Jan 30 18:19:18 router kernel:  disk 8, o:1, dev:sde1
Jan 30 18:19:18 router kernel: md: recovery of RAID array md0
Jan 30 18:19:18 router kernel: md: minimum _guaranteed_  speed: 500000 KB/sec/disk.
Jan 30 18:19:18 router kernel: md: using maximum available idle IO bandwidth (but not more than 5000000 KB/sec) for recovery.
Jan 30 18:19:18 router kernel: md: using 128k window, over a total of 2930264320k.
Jan 31 00:34:12 router kernel: ata14.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x6
Jan 31 00:34:12 router kernel: ata14.00: edma_err_cause=02000084 pp_flags=00000003, dev error, EDMA self-disable
Jan 31 00:34:12 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:12 router kernel: ata14.00: cmd 60/00:00:08:d3:45/04:00:21:01:00/40 tag 0 ncq 524288 in
Jan 31 00:34:12 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:12 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:12 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:12 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:12 router kernel: ata14.00: cmd 60/00:08:08:d7:45/04:00:21:01:00/40 tag 1 ncq 524288 in
Jan 31 00:34:12 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:12 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:12 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:12 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:12 router kernel: ata14.00: cmd 60/00:10:08:db:45/04:00:21:01:00/40 tag 2 ncq 524288 in
Jan 31 00:34:12 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:12 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:12 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:12 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:12 router kernel: ata14.00: cmd 60/00:18:08:df:45/04:00:21:01:00/40 tag 3 ncq 524288 in
Jan 31 00:34:12 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:12 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:12 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:12 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:12 router kernel: ata14.00: cmd 60/00:20:08:e3:45/04:00:21:01:00/40 tag 4 ncq 524288 in
Jan 31 00:34:12 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:12 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:12 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:12 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:12 router kernel: ata14.00: cmd 60/00:28:08:13:46/04:00:21:01:00/40 tag 5 ncq 524288 in
Jan 31 00:34:12 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:12 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:12 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:12 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:12 router kernel: ata14.00: cmd 60/00:30:08:17:46/04:00:21:01:00/40 tag 6 ncq 524288 in
Jan 31 00:34:12 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:12 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:12 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:12 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:12 router kernel: ata14.00: cmd 60/00:38:08:2b:46/04:00:21:01:00/40 tag 7 ncq 524288 in
Jan 31 00:34:12 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:12 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:12 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:12 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:12 router kernel: ata14.00: cmd 60/00:40:08:2f:46/04:00:21:01:00/40 tag 8 ncq 524288 in
Jan 31 00:34:12 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:12 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:12 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:12 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:12 router kernel: ata14.00: cmd 60/00:48:08:33:46/04:00:21:01:00/40 tag 9 ncq 524288 in
Jan 31 00:34:12 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:12 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:12 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:12 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:12 router kernel: ata14.00: cmd 60/00:50:08:bb:45/04:00:21:01:00/40 tag 10 ncq 524288 in
Jan 31 00:34:12 router kernel:          res 41/40:00:a0:bd:45/00:00:21:01:00/40 Emask 0x409 (media error) <F>
Jan 31 00:34:12 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:12 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:13 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:13 router kernel: ata14.00: cmd 60/00:58:08:bf:45/04:00:21:01:00/40 tag 11 ncq 524288 in
Jan 31 00:34:13 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:13 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:13 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:13 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:13 router kernel: ata14.00: cmd 60/00:60:08:c3:45/04:00:21:01:00/40 tag 12 ncq 524288 in
Jan 31 00:34:13 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:13 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:13 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:13 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:13 router kernel: ata14.00: cmd 60/00:68:08:c7:45/04:00:21:01:00/40 tag 13 ncq 524288 in
Jan 31 00:34:13 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:13 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:13 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:13 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:13 router kernel: ata14.00: cmd 60/00:70:08:cb:45/04:00:21:01:00/40 tag 14 ncq 524288 in
Jan 31 00:34:13 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:13 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:13 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:13 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:13 router kernel: ata14.00: cmd 60/00:78:08:cf:45/04:00:21:01:00/40 tag 15 ncq 524288 in
Jan 31 00:34:13 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:13 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:13 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:13 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:13 router kernel: ata14.00: cmd 60/00:80:08:e7:45/04:00:21:01:00/40 tag 16 ncq 524288 in
Jan 31 00:34:13 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:13 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:13 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:13 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:13 router kernel: ata14.00: cmd 60/00:88:08:eb:45/04:00:21:01:00/40 tag 17 ncq 524288 in
Jan 31 00:34:13 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:13 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:13 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:13 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:13 router kernel: ata14.00: cmd 60/00:90:08:ef:45/04:00:21:01:00/40 tag 18 ncq 524288 in
Jan 31 00:34:13 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:13 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:13 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:13 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:13 router kernel: ata14.00: cmd 60/00:98:08:f3:45/04:00:21:01:00/40 tag 19 ncq 524288 in
Jan 31 00:34:13 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:13 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:13 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:13 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:13 router kernel: ata14.00: cmd 60/00:a0:08:f7:45/04:00:21:01:00/40 tag 20 ncq 524288 in
Jan 31 00:34:13 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:13 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:13 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:13 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:13 router kernel: ata14.00: cmd 60/00:a8:08:fb:45/04:00:21:01:00/40 tag 21 ncq 524288 in
Jan 31 00:34:13 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:13 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:13 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:13 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:13 router kernel: ata14.00: cmd 60/00:b0:08:ff:45/04:00:21:01:00/40 tag 22 ncq 524288 in
Jan 31 00:34:13 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:13 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:13 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:13 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:13 router kernel: ata14.00: cmd 60/00:b8:08:03:46/04:00:21:01:00/40 tag 23 ncq 524288 in
Jan 31 00:34:13 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:13 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:13 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:13 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:13 router kernel: ata14.00: cmd 60/00:c0:08:07:46/04:00:21:01:00/40 tag 24 ncq 524288 in
Jan 31 00:34:13 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:13 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:13 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:13 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:13 router kernel: ata14.00: cmd 60/00:c8:08:0b:46/04:00:21:01:00/40 tag 25 ncq 524288 in
Jan 31 00:34:13 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:13 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:13 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:13 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:13 router kernel: ata14.00: cmd 60/00:d0:08:0f:46/04:00:21:01:00/40 tag 26 ncq 524288 in
Jan 31 00:34:13 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:13 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:13 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:13 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:13 router kernel: ata14.00: cmd 60/00:d8:08:1b:46/04:00:21:01:00/40 tag 27 ncq 524288 in
Jan 31 00:34:13 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:13 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:13 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:13 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:13 router kernel: ata14.00: cmd 60/00:e0:08:1f:46/04:00:21:01:00/40 tag 28 ncq 524288 in
Jan 31 00:34:13 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:13 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:13 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:13 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:13 router kernel: ata14.00: cmd 60/00:e8:08:23:46/04:00:21:01:00/40 tag 29 ncq 524288 in
Jan 31 00:34:13 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:13 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:13 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:13 router kernel: ata14.00: failed command: READ FPDMA QUEUED
Jan 31 00:34:13 router kernel: ata14.00: cmd 60/00:f0:08:27:46/04:00:21:01:00/40 tag 30 ncq 524288 in
Jan 31 00:34:13 router kernel:          res 41/40:44:08:2f:46/40:00:21:01:00/40 Emask 0x9 (media error)
Jan 31 00:34:13 router kernel: ata14.00: status: { DRDY ERR }
Jan 31 00:34:13 router kernel: ata14.00: error: { UNC }
Jan 31 00:34:13 router kernel: ata14: hard resetting link
Jan 31 00:34:13 router kernel: ata14: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jan 31 00:34:13 router kernel: ata14.00: failed to get Identify Device Data, Emask 0x1
Jan 31 00:34:13 router kernel: ata14.00: failed to get Identify Device Data, Emask 0x1
Jan 31 00:34:13 router kernel: ata14.00: configured for UDMA/133
Jan 31 00:34:13 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:13 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:13 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:13 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:13 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:13 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:13 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:13 router kernel:         21 46 2f 08 
Jan 31 00:34:13 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:13 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:13 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:13 router kernel: Read(16): 88 00 00 00 00 01 21 45 d3 08 00 00 04 00 00 00
Jan 31 00:34:13 router kernel: end_request: I/O error, dev sdj, sector 4853191432
Jan 31 00:34:13 router kernel: md/raid:md0: read error not correctable (sector 4853189384 on sdj1).
Jan 31 00:34:13 router kernel: md/raid:md0: Disk failure on sdj1, disabling device.
Jan 31 00:34:13 router kernel: md/raid:md0: Operation continuing on 7 devices.
Jan 31 00:34:13 router kernel: md/raid:md0: read error not correctable (sector 4853189392 on sdj1).
Jan 31 00:34:14 router kernel: md/raid:md0: read error not correctable (sector 4853189400 on sdj1).
Jan 31 00:34:14 router kernel: md/raid:md0: read error not correctable (sector 4853189408 on sdj1).
Jan 31 00:34:14 router kernel: md/raid:md0: read error not correctable (sector 4853189416 on sdj1).
Jan 31 00:34:14 router kernel: md/raid:md0: read error not correctable (sector 4853189424 on sdj1).
Jan 31 00:34:14 router kernel: md/raid:md0: read error not correctable (sector 4853189432 on sdj1).
Jan 31 00:34:14 router kernel: md/raid:md0: read error not correctable (sector 4853189440 on sdj1).
Jan 31 00:34:14 router kernel: md/raid:md0: read error not correctable (sector 4853189448 on sdj1).
Jan 31 00:34:14 router kernel: md/raid:md0: read error not correctable (sector 4853189456 on sdj1).
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:14 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:14 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:14 router kernel:         21 46 2f 08 
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:14 router kernel: Read(16): 88 00 00 00 00 01 21 45 d7 08 00 00 04 00 00 00
Jan 31 00:34:14 router kernel: end_request: I/O error, dev sdj, sector 4853192456
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:14 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:14 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:14 router kernel:         21 46 2f 08 
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:14 router kernel: Read(16): 88 00 00 00 00 01 21 45 db 08 00 00 04 00 00 00
Jan 31 00:34:14 router kernel: end_request: I/O error, dev sdj, sector 4853193480
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:14 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:14 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:14 router kernel:         21 46 2f 08 
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:14 router kernel: Read(16): 88 00 00 00 00 01 21 45 df 08 00 00 04 00 00 00
Jan 31 00:34:14 router kernel: end_request: I/O error, dev sdj, sector 4853194504
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:14 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:14 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:14 router kernel:         21 46 2f 08 
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:14 router kernel: Read(16): 88 00 00 00 00 01 21 45 e3 08 00 00 04 00 00 00
Jan 31 00:34:14 router kernel: end_request: I/O error, dev sdj, sector 4853195528
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:14 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:14 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:14 router kernel:         21 46 2f 08 
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:14 router kernel: Read(16): 88 00 00 00 00 01 21 46 13 08 00 00 04 00 00 00
Jan 31 00:34:14 router kernel: end_request: I/O error, dev sdj, sector 4853207816
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:14 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:14 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:14 router kernel:         21 46 2f 08 
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:14 router kernel: Read(16): 88 00 00 00 00 01 21 46 17 08 00 00 04 00 00 00
Jan 31 00:34:14 router kernel: end_request: I/O error, dev sdj, sector 4853208840
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:14 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:14 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:14 router kernel:         21 46 2f 08 
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:14 router kernel: Read(16): 88 00 00 00 00 01 21 46 2b 08 00 00 04 00 00 00
Jan 31 00:34:14 router kernel: end_request: I/O error, dev sdj, sector 4853213960
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:14 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:14 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:14 router kernel:         21 46 2f 08 
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:14 router kernel: Read(16): 88 00 00 00 00 01 21 46 2f 08 00 00 04 00 00 00
Jan 31 00:34:14 router kernel: end_request: I/O error, dev sdj, sector 4853214984
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:14 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:14 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:14 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:14 router kernel:         21 46 2f 08 
Jan 31 00:34:14 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:15 router kernel: Read(16): 88 00 00 00 00 01 21 46 33 08 00 00 04 00 00 00
Jan 31 00:34:15 router kernel: end_request: I/O error, dev sdj, sector 4853216008
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:15 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:15 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:15 router kernel:         21 45 bd a0 
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:15 router kernel: Read(16): 88 00 00 00 00 01 21 45 bb 08 00 00 04 00 00 00
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:15 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:15 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:15 router kernel:         21 46 2f 08 
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:15 router kernel: Read(16): 88 00 00 00 00 01 21 45 bf 08 00 00 04 00 00 00
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:15 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:15 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:15 router kernel:         21 46 2f 08 
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:15 router kernel: Read(16): 88 00 00 00 00 01 21 45 c3 08 00 00 04 00 00 00
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:15 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:15 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:15 router kernel:         21 46 2f 08 
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:15 router kernel: Read(16): 88 00 00 00 00 01 21 45 c7 08 00 00 04 00 00 00
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:15 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:15 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:15 router kernel:         21 46 2f 08 
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:15 router kernel: Read(16): 88 00 00 00 00 01 21 45 cb 08 00 00 04 00 00 00
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:15 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:15 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:15 router kernel:         21 46 2f 08 
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:15 router kernel: Read(16): 88 00 00 00 00 01 21 45 cf 08 00 00 04 00 00 00
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:15 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:15 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:15 router kernel:         21 46 2f 08 
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:15 router kernel: Read(16): 88 00 00 00 00 01 21 45 e7 08 00 00 04 00 00 00
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:15 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:15 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:15 router kernel:         21 46 2f 08 
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:15 router kernel: Read(16): 88 00 00 00 00 01 21 45 eb 08 00 00 04 00 00 00
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:15 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:15 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:15 router kernel:         21 46 2f 08 
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:15 router kernel: Read(16): 88 00 00 00 00 01 21 45 ef 08 00 00 04 00 00 00
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:15 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:15 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:15 router kernel:         21 46 2f 08 
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:15 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:15 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:16 router kernel: Read(16): 88 00 00 00 00 01 21 45 f3 08 00 00 04 00 00 00
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:16 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:16 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:16 router kernel:         21 46 2f 08 
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:16 router kernel: Read(16): 88 00 00 00 00 01 21 45 f7 08 00 00 04 00 00 00
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:16 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:16 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:16 router kernel:         21 46 2f 08 
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:16 router kernel: Read(16): 88 00 00 00 00 01 21 45 fb 08 00 00 04 00 00 00
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:16 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:16 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:16 router kernel:         21 46 2f 08 
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:16 router kernel: Read(16): 88 00 00 00 00 01 21 45 ff 08 00 00 04 00 00 00
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:16 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:16 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:16 router kernel:         21 46 2f 08 
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:16 router kernel: Read(16): 88 00 00 00 00 01 21 46 03 08 00 00 04 00 00 00
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:16 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:16 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:16 router kernel:         21 46 2f 08 
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:16 router kernel: Read(16): 88 00 00 00 00 01 21 46 07 08 00 00 04 00 00 00
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:16 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:16 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:16 router kernel:         21 46 2f 08 
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:16 router kernel: Read(16): 88 00 00 00 00 01 21 46 0b 08 00 00 04 00 00 00
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:16 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:16 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:16 router kernel:         21 46 2f 08 
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:16 router kernel: Read(16): 88 00 00 00 00 01 21 46 0f 08 00 00 04 00 00 00
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:16 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:16 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:16 router kernel:         21 46 2f 08 
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:16 router kernel: Read(16): 88 00 00 00 00 01 21 46 1b 08 00 00 04 00 00 00
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:16 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:16 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:16 router kernel:         21 46 2f 08 
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:16 router kernel: Read(16): 88 00 00 00 00 01 21 46 1f 08 00 00 04 00 00 00
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:16 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:16 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:16 router kernel:         21 46 2f 08 
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:16 router kernel: Read(16): 88 00 00 00 00 01 21 46 23 08 00 00 04 00 00 00
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj] Unhandled sense code
Jan 31 00:34:16 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:16 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 00:34:17 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:17 router kernel: Sense Key : Medium Error [current] [descriptor]
Jan 31 00:34:17 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 31 00:34:17 router kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
Jan 31 00:34:17 router kernel:         21 46 2f 08 
Jan 31 00:34:17 router kernel: sd 13:0:0:0: [sdj]  
Jan 31 00:34:17 router kernel: Add. Sense: Unrecovered read error - auto reallocate failed
Jan 31 00:34:17 router kernel: sd 13:0:0:0: [sdj] CDB: 
Jan 31 00:34:17 router kernel: Read(16): 88 00 00 00 00 01 21 46 27 08 00 00 04 00 00 00
Jan 31 00:34:17 router kernel: ata14: EH complete
Jan 31 00:34:17 router kernel: md: md0: recovery done.
Jan 31 00:34:17 router kernel: RAID conf printout:
Jan 31 00:34:17 router kernel:  --- level:5 rd:9 wd:7
Jan 31 00:34:17 router kernel:  disk 0, o:1, dev:sdc1
Jan 31 00:34:17 router kernel:  disk 1, o:1, dev:sdg1
Jan 31 00:34:17 router kernel:  disk 2, o:1, dev:sdh1
Jan 31 00:34:17 router kernel:  disk 3, o:1, dev:sdd1
Jan 31 00:34:17 router kernel:  disk 4, o:1, dev:sdi1
Jan 31 00:34:17 router kernel:  disk 5, o:0, dev:sdj1
Jan 31 00:34:17 router kernel:  disk 6, o:1, dev:sdb1
Jan 31 00:34:17 router kernel:  disk 7, o:1, dev:sdf1
Jan 31 00:34:17 router kernel:  disk 8, o:1, dev:sde1

--------------010305000405060305030103
Content-Type: text/plain;
 name="error1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="error1.txt"

Jan 28 00:23:05 router kernel: ata11: illegal qc_active transition (00000001->04000001)
Jan 28 00:23:36 router kernel: ata11.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
Jan 28 00:23:36 router kernel: ata11.00: failed command: WRITE FPDMA QUEUED
Jan 28 00:23:36 router kernel: ata11.00: cmd 61/30:00:50:55:b2/00:00:36:01:00/40 tag 0 ncq 24576 out
Jan 28 00:23:36 router kernel:          res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Jan 28 00:23:36 router kernel: ata11.00: status: { DRDY }
Jan 28 00:23:36 router kernel: ata11: hard resetting link
Jan 28 00:23:36 router kernel: ata11: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jan 28 00:23:36 router kernel: ata11.00: failed to get Identify Device Data, Emask 0x1
Jan 28 00:23:36 router kernel: ata11.00: failed to get Identify Device Data, Emask 0x1
Jan 28 00:23:36 router kernel: ata11.00: configured for UDMA/133
Jan 28 00:23:36 router kernel: ata11.00: device reported invalid CHS sector 0
Jan 28 00:23:36 router kernel: sd 10:0:0:0: [sdg]  
Jan 28 00:23:36 router kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 28 00:23:36 router kernel: sd 10:0:0:0: [sdg]  
Jan 28 00:23:36 router kernel: Sense Key : Aborted Command [current] [descriptor]
Jan 28 00:23:36 router kernel: Descriptor sense data with sense descriptors (in hex):
Jan 28 00:23:36 router kernel:         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
Jan 28 00:23:36 router kernel:         00 00 00 00 
Jan 28 00:23:36 router kernel: sd 10:0:0:0: [sdg]  
Jan 28 00:23:36 router kernel: Add. Sense: No additional sense information
Jan 28 00:23:36 router kernel: sd 10:0:0:0: [sdg] CDB: 
Jan 28 00:23:36 router kernel: Write(16): 8a 00 00 00 00 01 36 b2 55 50 00 00 00 30 00 00
Jan 28 00:23:36 router kernel: end_request: I/O error, dev sdg, sector 5212624208
Jan 28 00:23:36 router kernel: ata11: EH complete
Jan 28 00:23:36 router kernel: md/raid:md0: Disk failure on sdg1, disabling device.
Jan 28 00:23:36 router kernel: md/raid:md0: Operation continuing on 8 devices.
Jan 28 00:23:36 router kernel: RAID conf printout:
Jan 28 00:23:36 router kernel:  --- level:5 rd:9 wd:8
Jan 28 00:23:36 router kernel:  disk 0, o:1, dev:sdc1
Jan 28 00:23:36 router kernel:  disk 1, o:0, dev:sdg1
Jan 28 00:23:36 router kernel:  disk 2, o:1, dev:sdh1
Jan 28 00:23:36 router kernel:  disk 3, o:1, dev:sdd1
Jan 28 00:23:36 router kernel:  disk 4, o:1, dev:sdi1
Jan 28 00:23:36 router kernel:  disk 5, o:1, dev:sdj1
Jan 28 00:23:36 router kernel:  disk 6, o:1, dev:sdb1
Jan 28 00:23:36 router kernel:  disk 7, o:1, dev:sdf1
Jan 28 00:23:36 router kernel:  disk 8, o:1, dev:sde1
Jan 28 00:23:36 router kernel: RAID conf printout:
Jan 28 00:23:36 router kernel:  --- level:5 rd:9 wd:8
Jan 28 00:23:36 router kernel:  disk 0, o:1, dev:sdc1
Jan 28 00:23:36 router kernel:  disk 2, o:1, dev:sdh1
Jan 28 00:23:36 router kernel:  disk 3, o:1, dev:sdd1
Jan 28 00:23:36 router kernel:  disk 4, o:1, dev:sdi1
Jan 28 00:23:36 router kernel:  disk 5, o:1, dev:sdj1
Jan 28 00:23:36 router kernel:  disk 6, o:1, dev:sdb1
Jan 28 00:23:36 router kernel:  disk 7, o:1, dev:sdf1
Jan 28 00:23:36 router kernel:  disk 8, o:1, dev:sde1

--------------010305000405060305030103--
