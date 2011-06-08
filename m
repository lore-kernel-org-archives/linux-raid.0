From: Phil Turmel <philip@turmel.org>
Subject: Re: SRaid with 13 Disks crashed
Date: Wed, 08 Jun 2011 10:39:52 -0400
Message-ID: <4DEF89B8.3080201@turmel.org>
References: <20110608142440.139240@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608142440.139240@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Dragon <Sunghost@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Dragon,

On 06/08/2011 10:24 AM, Dragon wrote:
> SRaid with 13 Disks crashed
> Hello,
> 
> 
> this seems to be my last chance to get back all of my data from a sw-raid5 with 12-13 disks.
> i use debian ( 2.6.32-bpo.5-amd64) and last i wanted to grow the raid from 12 to 13 disk with a size at all of 18tb. after run mke2fs i must see that the tool on ext4 allow a maximum size of 16tb. after that i wanted to shrink the size back to 12 disk and now the raid is gone.

Did you actually mean "mke2fs" ?  It destroys existing data.  I hope you meant "resize2fs".

> i tried some assemble and examine things but without success.
> 
> here some information:
>  cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : inactive sdh[0](S) sda[13](S) sdg[12](S) sdf[11](S) sde[10](S) sdd[9](S) sdc[8](S) sdb[6](S) sdm[5](S) sdl[4](S) sdj[3](S) sdi[2](S)
>       17581661952 blocks
> 
> unused devices: <none>
> 
> mdadm --detail /dev/md0
> mdadm: md device /dev/md0 does not appear to be active.
> 
>  mdadm --assemble --force -v /dev/md0 /dev/sdh /dev/sda /dev/sdg /dev/sdf /dev/sde /dev/sdd /dev/sdc /dev/sdb /dev/sdm /dev/sdl /dev/sdj /dev/sdi --update=super-minor /dev/sdh

Was /dev/sdk supposed to be in this list?

> mdadm: looking for devices for /dev/md0
> mdadm: updating superblock of /dev/sdh with minor number 0
> mdadm: /dev/sdh is identified as a member of /dev/md0, slot 0.
> mdadm: updating superblock of /dev/sda with minor number 0
> mdadm: /dev/sda is identified as a member of /dev/md0, slot 13.

This is suspicious.  Looks like sda was added as a spare?

> mdadm: updating superblock of /dev/sdg with minor number 0
> mdadm: /dev/sdg is identified as a member of /dev/md0, slot 12.
> mdadm: updating superblock of /dev/sdf with minor number 0
> mdadm: /dev/sdf is identified as a member of /dev/md0, slot 11.
> mdadm: updating superblock of /dev/sde with minor number 0
> mdadm: /dev/sde is identified as a member of /dev/md0, slot 10.
> mdadm: updating superblock of /dev/sdd with minor number 0
> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 9.
> mdadm: updating superblock of /dev/sdc with minor number 0
> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 8.
> mdadm: updating superblock of /dev/sdb with minor number 0
> mdadm: /dev/sdb is identified as a member of /dev/md0, slot 6.
> mdadm: updating superblock of /dev/sdm with minor number 0
> mdadm: /dev/sdm is identified as a member of /dev/md0, slot 5.
> mdadm: updating superblock of /dev/sdl with minor number 0
> mdadm: /dev/sdl is identified as a member of /dev/md0, slot 4.
> mdadm: updating superblock of /dev/sdj with minor number 0
> mdadm: /dev/sdj is identified as a member of /dev/md0, slot 3.
> mdadm: updating superblock of /dev/sdi with minor number 0
> mdadm: /dev/sdi is identified as a member of /dev/md0, slot 2.
> mdadm: updating superblock of /dev/sdh with minor number 0
> mdadm: /dev/sdh is identified as a member of /dev/md0, slot 0.
> mdadm: no uptodate device for slot 1 of /dev/md0
> mdadm: added /dev/sdi to /dev/md0 as 2
> mdadm: added /dev/sdj to /dev/md0 as 3
> mdadm: added /dev/sdl to /dev/md0 as 4
> mdadm: added /dev/sdm to /dev/md0 as 5
> mdadm: added /dev/sdb to /dev/md0 as 6
> mdadm: no uptodate device for slot 7 of /dev/md0
> mdadm: added /dev/sdc to /dev/md0 as 8
> mdadm: added /dev/sdd to /dev/md0 as 9
> mdadm: added /dev/sde to /dev/md0 as 10
> mdadm: added /dev/sdf to /dev/md0 as 11
> mdadm: added /dev/sdg to /dev/md0 as 12
> mdadm: added /dev/sda to /dev/md0 as 13
> mdadm: added /dev/sdh to /dev/md0 as 0
> mdadm: /dev/md0 assembled from 11 drives and 1 spare - not enough to start the array.

Indeed.  Your problem is likely to be /dev/sda.

> mdadm.conf
> #old=ARRAY /dev/md0 level=raid5 num-devices=13 metadata=0.90 UUID=975d6eb2:285eed11:021df236:c2d05073
> ARRAY /dev/md0 UUID=975d6eb2:285eed11:021df236:c2d05073
> 
> Hope some can help. Thx

Please share the output of "mdadm -E /dev/sd[abcdefghijklm]"

Phil
