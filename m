From: "Tomi Orava" <tomimo+linux-raid@ncircle.nullnet.fi>
Subject: Re: Raid1 recovery problem - need help!
Date: Fri, 26 Sep 2003 10:10:21 +0300 (EEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <17620.194.237.142.24.1064560221.squirrel@ncircle.nullnet.fi>
References: <40408.194.237.142.24.1064555851.squirrel@ncircle.nullnet.fi><16243.55544.424789.503682@notabene.cse.unsw.edu.au><61251.194.237.142.24.1064557502.squirrel@ncircle.nullnet.fi>
    <16243.57487.124068.470173@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16243.57487.124068.470173@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>> /proc/mdstat:
>> Personalities : [linear] [raid0] [raid1] [raid5]
>> read_ahead 1024 sectors
>> md4 : inactive sdc2[2]
>>        blocks
>>
>> The thing is that I have no spare-discs available in my system and
>> that "spare" disc _is_ the one that has always been the second mirror
>> of /dev/md4.
>>
>
> It looks like maybe it was /dev/sdc that failed and when you rebooted
> without it, the old sdd was renamed to sdc.
>
> In any case, if the failed drive is really dead, the best you can hope
> for it
>   mdadm -C /dev/md1 -l 1 -n 2 /dev/sdc2 missing
> and hope the data on it is recent enough.
> Note: this will not change the data on sdc2.  It will only change the
> superblock and allow you to access what is there.

Ok, now the status is after the following command:

>mdadm -v --assemble /dev/md5 /dev/md3 /dev/md4

mdadm: looking for devices for /dev/md5
mdadm: /dev/md3 is identified as a member of /dev/md5, slot 0.
mdadm: /dev/md4 is identified as a member of /dev/md5, slot 1.
mdadm: added /dev/md4 to /dev/md5 as 1
mdadm: added /dev/md3 to /dev/md5 as 0
mdadm: /dev/md5 assembled from 1 drive - not enough to start the array.


/proc/mdstat:

Personalities : [linear] [raid0] [raid1] [raid5]
read_ahead 1024 sectors
md5 : inactive md3[0] md4[1]
      0 blocks

md4 : active raid1 sdc2[0]
      60034880 blocks [2/1] [U_]

md3 : active raid1 hdg2[2] hde2[1]
      58616640 blocks [2/1] [_U]


Any ideas ? :)

Regards,
Tomi Orava

