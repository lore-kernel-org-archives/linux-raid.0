From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid1 recovery problem - need help!
Date: Fri, 26 Sep 2003 16:45:35 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16243.57487.124068.470173@notabene.cse.unsw.edu.au>
References: <40408.194.237.142.24.1064555851.squirrel@ncircle.nullnet.fi>
	<16243.55544.424789.503682@notabene.cse.unsw.edu.au>
	<61251.194.237.142.24.1064557502.squirrel@ncircle.nullnet.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tomi Orava on Friday September 26
To: Tomi Orava <tomimo+linux-raid@ncircle.nullnet.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday September 26, tomimo+linux-raid@ncircle.nullnet.fi wrote:
> 
> Neil,
> 
> Thank you very much for your fast reply.
> 
> >> The problem occurred while resynccing the /dev/md4 RAID1-mirror
> >> and of course the "master" device was the faulty one.
> >> The question now is, is someone capable of describing how to get
> >> this /dev/md4-mirror started so that I can continue copying data
> >> out of RAID1+0 (dev/md5) mirror ?
> >
> > You need to assemble the array before it can run, so maybe:
> >
> >    mdadm --assemble /dev/md4 --uid=d5c2d1f7:cf7cb245:2d9e7057:097ec133
> > /dev/sd*
> 
> The command: mdadm --assemble /dev/md4
> --uuid=d5c2d1f7:cf7cb245:2d9e7057:097ec133 /dev/sdc2
> 
> Results:
> mdadm: /dev/md4 assembled from 0 drives and 1 spare - not enough to start
> the array.
> 
> /proc/mdstat:
> Personalities : [linear] [raid0] [raid1] [raid5]
> read_ahead 1024 sectors
> md4 : inactive sdc2[2]
>       0 blocks
> 
> The thing is that I have no spare-discs available in my system and
> that "spare" disc _is_ the one that has always been the second mirror
> of /dev/md4.
> 

It looks like maybe it was /dev/sdc that failed and when you rebooted
without it, the old sdd was renamed to sdc.

In any case, if the failed drive is really dead, the best you can hope
for it
  mdadm -C /dev/md1 -l 1 -n 2 /dev/sdc2 missing
and hope the data on it is recent enough.
Note: this will not change the data on sdc2.  It will only change the
superblock and allow you to access what is there.

NeilBrown
