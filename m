From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid1 recovery problem - need help!
Date: Fri, 26 Sep 2003 17:45:31 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16243.61083.69286.766387@notabene.cse.unsw.edu.au>
References: <40408.194.237.142.24.1064555851.squirrel@ncircle.nullnet.fi>
	<16243.55544.424789.503682@notabene.cse.unsw.edu.au>
	<61251.194.237.142.24.1064557502.squirrel@ncircle.nullnet.fi>
	<16243.57487.124068.470173@notabene.cse.unsw.edu.au>
	<17620.194.237.142.24.1064560221.squirrel@ncircle.nullnet.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tomi Orava on Friday September 26
To: Tomi Orava <tomimo+linux-raid@ncircle.nullnet.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday September 26, tomimo+linux-raid@ncircle.nullnet.fi wrote:
> > superblock and allow you to access what is there.
> 
> Ok, now the status is after the following command:
> 
> >mdadm -v --assemble /dev/md5 /dev/md3 /dev/md4
> 
> mdadm: looking for devices for /dev/md5
> mdadm: /dev/md3 is identified as a member of /dev/md5, slot 0.
> mdadm: /dev/md4 is identified as a member of /dev/md5, slot 1.
> mdadm: added /dev/md4 to /dev/md5 as 1
> mdadm: added /dev/md3 to /dev/md5 as 0
> mdadm: /dev/md5 assembled from 1 drive - not enough to start the array.
> 

Hmm. my guess is that if you "mdadm -E" /dev/md3 and /dev/md4, you
will find that the event numbers a different.  i.e. it things /dev/md4
is too out-of-date.
Presumably the mirror halves fell out-of-sync some time ago and for
some reason never rebuild properly.

You could try
   mdadm --assemble --force /dev/md5 /dev/md3 /dev/md4

It should assemble successfully, but I make not promises about what
sort of data will be on them.

NeilBrown


> 
> /proc/mdstat:
> 
> Personalities : [linear] [raid0] [raid1] [raid5]
> read_ahead 1024 sectors
> md5 : inactive md3[0] md4[1]
>       0 blocks
> 
> md4 : active raid1 sdc2[0]
>       60034880 blocks [2/1] [U_]
> 
> md3 : active raid1 hdg2[2] hde2[1]
>       58616640 blocks [2/1] [_U]
> 
> 
> Any ideas ? :)
> 
> Regards,
> Tomi Orava
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
