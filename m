From: "Tomi Orava" <tomimo+linux-raid@ncircle.nullnet.fi>
Subject: Re: Raid1 recovery problem - need help!
Date: Fri, 26 Sep 2003 09:25:02 +0300 (EEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <61251.194.237.142.24.1064557502.squirrel@ncircle.nullnet.fi>
References: <40408.194.237.142.24.1064555851.squirrel@ncircle.nullnet.fi>
    <16243.55544.424789.503682@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16243.55544.424789.503682@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Neil,

Thank you very much for your fast reply.

>> The problem occurred while resynccing the /dev/md4 RAID1-mirror
>> and of course the "master" device was the faulty one.
>> The question now is, is someone capable of describing how to get
>> this /dev/md4-mirror started so that I can continue copying data
>> out of RAID1+0 (dev/md5) mirror ?
>
> You need to assemble the array before it can run, so maybe:
>
>    mdadm --assemble /dev/md4 --uid=d5c2d1f7:cf7cb245:2d9e7057:097ec133
> /dev/sd*

The command: mdadm --assemble /dev/md4
--uuid=d5c2d1f7:cf7cb245:2d9e7057:097ec133 /dev/sdc2

Results:
mdadm: /dev/md4 assembled from 0 drives and 1 spare - not enough to start
the array.

/proc/mdstat:
Personalities : [linear] [raid0] [raid1] [raid5]
read_ahead 1024 sectors
md4 : inactive sdc2[2]
      0 blocks

The thing is that I have no spare-discs available in my system and
that "spare" disc _is_ the one that has always been the second mirror
of /dev/md4.


> then
>    mdadm --assemble /dev/md5 /dev/md3 /dev/md4

Regards,
Tomi Orava
