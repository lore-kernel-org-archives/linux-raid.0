From: Andrew Burgess <aab@cichlid.com>
Subject: Re: /proc/mdstat bug: 2.6.14.2
Date: Wed, 30 Nov 2005 15:14:33 -0800
Message-ID: <200511302314.jAUNEXjA022037@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>On Tuesday November 29, aab@cichlid.com wrote:
>> The time and speed display for resync is wrong, the recovery numbers are fine.
>> The resync is actually running at a few MB/sec.
>> 
>> md1 : active raid6 sdn1[8](S) sde1[9] sdq1[0] sdu1[6] sdo1[5] sdaa3[4] sdab1[2] sds1[1]
>>       1757815296 blocks level 6, 128k chunk, algorithm 2 [8/6] [UUU_UUU_]
>>       [>....................]  recovery =  3.6% (10616704/292969216) finish=840.3min speed=5597K/sec
>>       
>> md0 : active raid6 sdac2[0] sdz1[4] sdy1[2] sdx1[1] sdw1[3] sdv1[5] sdr2[6]
>>       1875299328 blocks level 6, 128k chunk, algorithm 2 [8/7] [UUUUUUU_]
>>       [======>..............]  resync = 33.1% (103563392/312549888) finish=1.5min speed=2288625K/sec
>> 
>> This is a amd64 x2 but running in single processor mode because of all the
>> timer problems with dual cpus

>Weird.....
>Does it always report wrong numbers, or was this a once-off?

Always, they change slightly each time.

>Are there any interesting kernel messages during the resync?

None that I recall.

>I'm stumped, so any extra info you might be able to provide will
>probably be useful.

Its probably my system, its a new motherboard and I've been having alot of
trouble with it. Its the first time I ever saw a resync and it started by
itself early in the boot so maybe the clock jumped during the boot -- I see
that sometimes.

Thank you for the reply and sorry for the most likely false alarm. It was a
frustrating day...

