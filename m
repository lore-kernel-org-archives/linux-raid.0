From: =?ISO-8859-1?Q?Uwe_W=E4chter?= <uwe.waechter@googlemail.com>
Subject: help needed restoring data
Date: Sat, 3 Aug 2013 15:59:38 +0200
Message-ID: <CAHTsmnnifoZAP0x4NhPW6xDiJCF_idp6=gqDKjMY-yNFXQEF2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi list,
I have a problem with my raid 5 array based on 3 harddisks. I need
help to find the best way to recover my data.
So what happens ....
First of all 1 harddisk fails with the message :

A Fail event had been detected on md device /dev/md/0.

It could be related to component device /dev/sde1.


Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sde1[4](F) sdc1[3] sdd1[0]
      1953517568 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [U_U]

unused devices: <none>


No problem at this time, the raid is still running with 2 harddisks.
The reason for the error was the following message of sde1
Jul 27 06:38:31 fed1 kernel: [987606.852610] md/raid:md0: Disk failure
on sde1, disabling device.
Jul 27 06:38:31 fed1 kernel: [987606.852610] md/raid:md0: Operation
continuing on 2 devices.
Jul 27 06:38:31 fed1 kernel: [987606.852613] sd 4:0:0:0: [sde]
Jul 27 06:38:31 fed1 kernel: [987606.852615] Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
Jul 27 06:38:31 fed1 kernel: [987606.852617] sd 4:0:0:0: [sde] CDB:
Jul 27 06:38:31 fed1 kernel: [987606.852618] Read(10): 28 00 36 d4 f0
3f 00 02 98 00
Jul 27 06:38:31 fed1 kernel: [987606.852625] end_request: I/O error,
dev sde, sector 919924799
Jul 27 06:38:31 fed1 kernel: [987606.852629] md/raid:md0: read error
not correctable (sector 919924736 on sde1).
Jul 27 06:38:31 fed1 kernel: [987606.852638] md/raid:md0: read error
not correctable (sector 919924744 on sde1).
Jul 27 06:38:31 fed1 kernel: [987606.852641] md/raid:md0: read error
not correctable (sector 919924752 on sde1).
Jul 27 06:38:31 fed1 kernel: [987606.852643] md/raid:md0: read error
not correctable (sector 919924760 on sde1).
Jul 27 06:38:31 fed1 kernel: [987606.852645] md/raid:md0: read error
not correctable (sector 919924768 on sde1).


A couple of hours later, just when I wanted to start backup the data
partition the sdd also fails :-( with similar failures :

A Fail event had been detected on md device /dev/md/0.

It could be related to component device /dev/sdd1.


Personalities : [raid6] [raid5] [raid4]

md0 : active raid5 sde1[4](F) sdc1[3] sdd1[0](F)
      1953517568 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/1] [__U]

unused devices: <none>


Jul 27 11:24:30 fed1 kernel: [1004773.836964] Add. Sense: Unrecovered
read error - auto reallocate failed
Jul 27 11:24:30 fed1 kernel: [1004773.836966] sd 3:0:0:0: [sdd] CDB:
Jul 27 11:24:30 fed1 kernel: [1004773.836967] Read(10): 28 00 32 f7 0b
6f 00 00 08 00
Jul 27 11:24:30 fed1 kernel: [1004773.836975] end_request: I/O error,
dev sdd, sector 855051119
Jul 27 11:24:30 fed1 kernel: [1004773.836980] raid5_end_read_request:
104 callbacks suppressed
Jul 27 11:24:30 fed1 kernel: [1004773.836982] md/raid:md0: read error
not correctable (sector 855051056 on sdd1).
Jul 27 11:24:30 fed1 kernel: [1004773.836986] md/raid:md0: Disk
failure on sdd1, disabling device.
Jul 27 11:24:30 fed1 kernel: [1004773.836986] md/raid:md0: Operation
continuing on 1 devices.
Jul 27 11:24:30 fed1 kernel: [1004773.837009] ata4: EH complete
Jul 27 11:24:30 fed1 kernel: [1004773.853284] Buffer I/O error on
device dm-2, logical block 213806870
Jul 27 11:24:30 fed1 kernel: [1004773.853291] Buffer I/O error on
device dm-2, logical block 213806871
Jul 27 11:24:30 fed1 kernel: [1004773.853296] EXT4-fs warning (device
dm-2): ext4_end_bio:294: I/O error writing to inode 60040


So I have 2 device sdd and sde with unreadable sectors. sdc has no errors.
smartd[690]: Device: /dev/sde [SAT], 14 Currently unreadable (pending) sectors
smartd[690]: Device: /dev/sdd [SAT], 11 Currently unreadable (pending) sectors

What is the best way to rebuild the array with sdc and sdd only ?
Can I correct unreadable sectors before rebuild the array or does it
destroy the array.
Do I need to change the 2 harddisks ?

I hope you can help me restoring much data as possible.
best regards Uwe
