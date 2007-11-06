From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
Date: Tue, 6 Nov 2007 06:42:45 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0711060641210.3010@p34.internal.lan>
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
 <18222.16003.92062.970530@notabene.brown>  <Pine.LNX.4.64.0711041651250.23496@p34.internal.lan>
  <e9c3a7c20711051035m78ba90ck68f4fbc10480462a@mail.gmail.com>
 <Pine.LNX.4.64.0711051335450.11422@p34.internal.lan>
 <e9c3a7c20711051619u7054aab9l208b604b9e58fb61@mail.gmail.com>
 <47303FB8.7000801@systella.fr> <Pine.LNX.4.64.0711060628450.3010@p34.internal.lan>
 <47305288.8020307@systella.fr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1918280824-1194349365=:3010"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47305288.8020307@systella.fr>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Cc: Dan Williams <dan.j.williams@intel.com>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1918280824-1194349365=:3010
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 6 Nov 2007, BERTRAND Jo=EBl wrote:

> Justin Piszcz wrote:
>>=20
>>=20
>> On Tue, 6 Nov 2007, BERTRAND Jo=EBl wrote:
>>
>>>     Done. Here is obtained ouput :
>>>=20
>>> [ 1265.899068] check 4: state 0x6 toread 0000000000000000 read=20
>>> 0000000000000000 write fffff800fdd4e360 written 0000000000000000
>>> [ 1265.941328] check 3: state 0x1 toread 0000000000000000 read=20
>>> 0000000000000000 write 0000000000000000 written 0000000000000000
>>> [ 1265.972129] check 2: state 0x1 toread 0000000000000000 read=20
>>> 0000000000000000 write 0000000000000000 written 0000000000000000
>>>=20
>>>
>>>     For information, after crash, I have :
>>>=20
>>> Root poulenc:[/sys/block] > cat /proc/mdstat
>>> Personalities : [raid1] [raid6] [raid5] [raid4]
>>> md_d0 : active raid5 sdc1[0] sdh1[5] sdg1[4] sdf1[3] sde1[2] sdd1[1]
>>>      1464725760 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
>>>
>>>     Regards,
>>>
>>>     JKB
>>=20
>> After the crash it is not 'resyncing' ?
>
> =09No, it isn't...
>
> =09JKB
>

After any crash/unclean shutdown the RAID should resync, if it doesn't,=20
that's not good, I'd suggest running a raid check.

The 'repair' is supposed to clean it, in some cases (md0=3Dswap) it gets=20
dirty again.

Tue May  8 09:19:54 EDT 2007: Executing RAID health check for /dev/md0...
Tue May  8 09:19:55 EDT 2007: Executing RAID health check for /dev/md1...
Tue May  8 09:19:56 EDT 2007: Executing RAID health check for /dev/md2...
Tue May  8 09:19:57 EDT 2007: Executing RAID health check for /dev/md3...
Tue May  8 10:09:58 EDT 2007: cat /sys/block/md0/md/mismatch_cnt
Tue May  8 10:09:58 EDT 2007: 2176
Tue May  8 10:09:58 EDT 2007: cat /sys/block/md1/md/mismatch_cnt
Tue May  8 10:09:58 EDT 2007: 0
Tue May  8 10:09:58 EDT 2007: cat /sys/block/md2/md/mismatch_cnt
Tue May  8 10:09:58 EDT 2007: 0
Tue May  8 10:09:58 EDT 2007: cat /sys/block/md3/md/mismatch_cnt
Tue May  8 10:09:58 EDT 2007: 0
Tue May  8 10:09:58 EDT 2007: The meta-device /dev/md0 has 2176 mismatched=
=20
sectors.
Tue May  8 10:09:58 EDT 2007: Executing repair on /dev/md0
Tue May  8 10:09:59 EDT 2007: The meta-device /dev/md1 has no mismatched=20
sectors.
Tue May  8 10:10:00 EDT 2007: The meta-device /dev/md2 has no mismatched=20
sectors.
Tue May  8 10:10:01 EDT 2007: The meta-device /dev/md3 has no mismatched=20
sectors.
Tue May  8 10:20:02 EDT 2007: All devices are clean...
Tue May  8 10:20:02 EDT 2007: cat /sys/block/md0/md/mismatch_cnt
Tue May  8 10:20:02 EDT 2007: 2176
Tue May  8 10:20:02 EDT 2007: cat /sys/block/md1/md/mismatch_cnt
Tue May  8 10:20:02 EDT 2007: 0
Tue May  8 10:20:02 EDT 2007: cat /sys/block/md2/md/mismatch_cnt
Tue May  8 10:20:02 EDT 2007: 0
Tue May  8 10:20:02 EDT 2007: cat /sys/block/md3/md/mismatch_cnt
Tue May  8 10:20:02 EDT 2007: 0

---1463747160-1918280824-1194349365=:3010--
