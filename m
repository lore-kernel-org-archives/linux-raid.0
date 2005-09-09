From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: Drive fails & raid6 array is not self rebuild .
Date: Fri, 9 Sep 2005 14:07:55 -0600 (MDT)
Message-ID: <Pine.LNX.4.63.0509091406070.2949@filesrv1.baby-dragons.com>
References: <60F5F1E2B94AD4119F0B00B0D0215FFF01A69F99@bsc.tt.umist.ac.uk>
 <Pine.LNX.4.63.0509081247060.29776@filesrv1.baby-dragons.com>
 <17184.43156.113155.811612@cse.unsw.edu.au>
 <Pine.LNX.4.63.0509081525380.30261@filesrv1.baby-dragons.com>
 <17184.56377.773388.978710@cse.unsw.edu.au>
 <Pine.LNX.4.63.0509082000030.31748@filesrv1.baby-dragons.com>
 <17185.15446.481054.508746@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17185.15446.481054.508746@cse.unsw.edu.au>
Content-ID: <Pine.LNX.4.63.0509091406072.2949@filesrv1.baby-dragons.com>
Content-Description: message body text
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


 	Hello Neil ,  I patched all were successful .  But after a
 	make clean ; make
 	I get ...	Tia ,  JimL
..snip...
gcc -Wall -Werror -Wstrict-prototypes -DCONFFILE=\"/etc/mdadm.conf\" -ggdb -DSendmail=\""/usr/sbin/sendmail -t"\"   -c -o Assemble.o Assemble.c
Assemble.c: In function `Assemble':
Assemble.c:323: error: `nextspare' undeclared (first use in this function)
Assemble.c:323: error: (Each undeclared identifier is reported only once
Assemble.c:323: error: for each function it appears in.)
make: *** [Assemble.o] Error 1


On Fri, 9 Sep 2005, Neil Brown wrote:
> On Thursday September 8, babydr@baby-dragons.com wrote:
>>> What happens if you then
>>>  mdadm /dev/md_d0 -a /dev/sda[pqrs]
>>> ??
>>  	Getting stranger & stranger .
>>
>> root@devel-0:~ # mdadm /dev/md_d0 -a /dev/sda[pqrs]
>> mdadm: re-added /dev/sdap
> Hmm.. mdadm bug.
>
>> root@devel-0:~ # cat /proc/mdstat
>> Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6] [raid10]
>> md_d0 : active raid5 sdap[36] sdc[0] sdao[40] sdan[34] sdam[33]
>> sdal[32] sdak[31] sdaj[30] sdah[29] sdag[28] sdaf[27] sdae[26]
>> sdad[25] sdac[24] sdab[23] sdaa[22] sdz[21] sdy[20] sdw[19] sdv[18]
>> sdu[17] sdt[16] sds[15] sdr[14] sdq[13] sdp[12] sdo[11] sdn[10] sdl[9]
>> sdk[8] sdj[7] sdi[6] sdh[5] sdg[4] sdf[3] sde[2](F) sdd[1]
>>        1244826240 blocks level 5, 64k chunk, algorithm 2 [36/35]
>> [UU_UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU]
>
> Hmm.. obviously hot-add isn't enough to trigger the rebuild in that
> kernel.
> Attached are three patches.
> The first two are needed by 2.6.12.5 to make sure resync happens (this
> is particularly a problem for version-1 superblocks) or just upgrade
> to 2.6.13.
> The last fixes mdadm-v2.0 so that when you add /dev/sda[pqrs] it
> actually adds all of them, and so that when you --assemble a version-1
> array with spares, the spares actually get included.
> NeilBrown

-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network        Engineer | 3542 Broken Yoke Dr. |  Give me Linux  |
| babydr@baby-dragons.com | Billings , MT. 59105 |   only  on  AXP |
+------------------------------------------------------------------+
