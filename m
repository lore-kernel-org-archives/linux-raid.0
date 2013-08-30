From: "Tsaousis, Costa" <costa@tsaousis.gr>
Subject: raid 5 with 2 failed drives
Date: Fri, 30 Aug 2013 04:55:56 +0300
Message-ID: <CANL+Vpaxpo8cgT4T69N3TD3fd+-Mup=C144Bmdfn_CqpfZKLGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I have a raid5 with 4 drives: sda, sdb, sdc, sdd.

While I was in vacations sdb powered off (I guess a thermal issue). Anyway,
the raid continued for several days in decreaded mode.

One day before being able to replace the powered off drive, sdd, a second
drive, broke (lots of read errors, including the raid superblock).

sdb (the first drive) works, but it is several days behind the other 3.

I thought the best way to get the most out of a possible reconstrution, is
to ddrescue as much of sdd to sdb the then attempt to re-assemble the array
with the 3 drives (2 fully functional + sdb with as much of sdd's data as
possible), hopping that if I am lucky, the parts that cannot be read from
sdd, will exist in sdb and may not have been changed in the few days that
sdb was offline.

Is this going to work? Can I just "mix" data from 2 raid-5 drives to build
an operational copy of the failed drives?

Thanks.

Costa

PS: I have backup of important data, and I already have restored
operations. However the array was also hosting a few TB of
nice-to-have data, never backed up, which I am trying to rescue if
possible.
