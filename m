From: Andrew Burgess <aab@cichlid.com>
Subject: Re: reshape changing chunk size won't restart
Date: Tue, 21 Dec 2010 18:59:17 -0800
Message-ID: <1292986757.5543.3@athlon>
References: <20101222132935.01d140c1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101222132935.01d140c1@notabene.brown> (from neilb@suse.de on
	Tue Dec 21 18:29:35 2010)
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/21/2010 06:29:35 PM, Neil Brown wrote:

> > mdadm -E /dev/sdg1
> > mdadm: cannot open /dev/sdg1: No such device or address
> 
> Maybe it has forgotten it's partition table... try
> 
>   blockdev --rereadpt /dev/sdg
> 
> (check man page to make sure I have the right spell.  Definitely sdg,  
> not
> sdg1).

that made the syslog say:

Dec 21 18:33:26 athlon kernel: sdg: sdg1
Dec 21 18:33:26 athlon kernel: md: bind<sdg1>

and mdadm -E likes it and Reshape pos'n matches the rest

> > unless old timestamp is helpful:
> 
> Yes, it is.  Makes sense too.
> I never really didn't get the timestamp logic straight in my mind.
> 
> Try
> 
>   MDADM_GROW_ALLOW_OLD=1  mdadm --verbose -A ....

> and see how that goes.  Requires mdadm-3.1.2 or later which I think  
> you have.

seems happy:

MDADM_GROW_ALLOW_OLD=1  mdadm --verbose -A /dev/md5  
--backup-file=/my/raid/RAID_BACKUP_FILE  /dev/sd[dfcbhljkg]1
mdadm: looking for devices for /dev/md5
mdadm: /dev/sdb1 is identified as a member of /dev/md5, slot 0.
mdadm: /dev/sdc1 is identified as a member of /dev/md5, slot 1.
mdadm: /dev/sdd1 is identified as a member of /dev/md5, slot 2.
mdadm: /dev/sdf1 is identified as a member of /dev/md5, slot 8.
mdadm: /dev/sdg1 is identified as a member of /dev/md5, slot 7.
mdadm: /dev/sdh1 is identified as a member of /dev/md5, slot 4.
mdadm: /dev/sdj1 is identified as a member of /dev/md5, slot 3.
mdadm: /dev/sdk1 is identified as a member of /dev/md5, slot 6.
mdadm: /dev/sdl1 is identified as a member of /dev/md5, slot 5.
mdadm:/dev/md5 has an active reshape - checking if critical section  
needs to be restored
mdadm: accepting backup with timestamp 1292959293 for array with  
timestamp 1292974027
mdadm: restoring critical section
mdadm: added /dev/sdc1 to /dev/md5 as 1
mdadm: added /dev/sdd1 to /dev/md5 as 2
mdadm: added /dev/sdj1 to /dev/md5 as 3
mdadm: added /dev/sdh1 to /dev/md5 as 4
mdadm: added /dev/sdl1 to /dev/md5 as 5
mdadm: added /dev/sdk1 to /dev/md5 as 6
mdadm: added /dev/sdg1 to /dev/md5 as 7
mdadm: added /dev/sdf1 to /dev/md5 as 8
mdadm: added /dev/sdb1 to /dev/md5 as 0
mdadm: /dev/md5 has been started with 9 drives.

It's munching away again.

I'll try an fsck...

Thank you Neil!
