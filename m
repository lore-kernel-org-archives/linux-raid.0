From: Neil Brown <neilb@suse.de>
Subject: Re: question on how to update the super-minor
Date: Fri, 20 Aug 2010 07:40:57 +1000
Message-ID: <20100820074057.519332b7@notabene>
References: <4C6D9B5D.8080705@scalableinformatics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C6D9B5D.8080705@scalableinformatics.com>
Sender: linux-raid-owner@vger.kernel.org
To: landman@scalableinformatics.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 19 Aug 2010 17:00:13 -0400
Joe Landman <landman@scalableinformatics.com> wrote:

> Hi folks
> 
>    Moved an array to a new machine.  For a number or reasons, the arrays 
> which were md0 and md1, are now md1 and md2.
> 
>    I can force the assembly of the arrays, but can't force them to 
> autoassemble, and it looks like the minors are wrong.
> 
>   ~ # mdadm --assemble /dev/md2 --update=super-minor  /dev/sdc2 /dev/sde2
> mdadm: /dev/md2 has been started with 2 drives.
> 
>   ~ # mdadm --assemble --update=super-minor /dev/md1 /dev/sdd2 /dev/sdf2
> mdadm: /dev/md1 has been started with 2 drives.
> 
>   ~ # mdadm --examine --scan
> ARRAY /dev/md/0 metadata=1.0 UUID=6ddbf291:a7344bb6:375a9f38:89b409e9 
> name=jr5.scalableinformatics.com:0
> ARRAY /dev/md/0 metadata=1.2 UUID=2e8b8744:16f038fa:9c4ba1b1:d4a7ee79 name=0
> ARRAY /dev/md/1 metadata=1.2 UUID=04251ae2:ef750917:f71c67b8:152b985b name=1

1.x metadata doesn't store a 'minor number', it stores a name.
So you want
   mdadm --assemble --update=name --name=1 /dev/md1 /dev/sdd2 /dev/sdf2

(assuming you like the name '1' and don't want to use - say - ImportantStuff..

I've made a note to see if I can get '--update=super-minor' to complain when
used on v1.x metadata

NeilBrown

> 
> ~ # cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md1 : active raid0 sdf2[0] sdd2[1]
>        14352793600 blocks super 1.2 2048k chunks
> 
> md2 : active raid0 sde2[0] sdc2[1]
>        1923825664 blocks super 1.2 1024k chunks
> 
> md0 : active raid1 sda1[0] sdb1[1]
>        26217400 blocks super 1.0 [2/2] [UU]
>        bitmap: 0/201 pages [0KB], 64KB chunk
> 
> unused devices: <none>
> 
> How do I force the md1 and md2 to accept the new minors?  The 
> --update=super-minor isn't working on assembly.
> 
> Also, for completeness
> 
> ~ # cat /etc/mdadm.conf
> DEVICE containers partitions
> ARRAY /dev/md0 UUID=6ddbf291:a7344bb6:375a9f38:89b409e9
> name=jr5.scalableinformatics.com:0
> ARRAY /dev/md1 metadata=1.2 UUID=2e8b8744:16f038fa:9c4ba1b1:d4a7ee79 name=1
> ARRAY /dev/md2 metadata=1.2 UUID=04251ae2:ef750917:f71c67b8:152b985b name=2
> 
> ~ # mdadm --examine /dev/sdf2
> /dev/sdf2:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 04251ae2:ef750917:f71c67b8:152b985b
>             Name : 1
>    Creation Time : Sun Feb 15 06:21:14 2009
>       Raid Level : raid0
>     Raid Devices : 2
> 
>   Avail Dev Size : 14352796387 (6843.95 GiB 7348.63 GB)
>    Used Dev Size : 0
>      Data Offset : 16 sectors
>     Super Offset : 8 sectors
>            State : active
>      Device UUID : 80406a02:959d30ee:9d090fd5:c570c9f7
> 
>      Update Time : Sun Feb 15 06:21:14 2009
>         Checksum : 5e70dc7e - correct
>           Events : 0
> 
>       Chunk Size : 2048K
> 
>     Device Role : Active device 0
>     Array State : AA ('A' == active, '.' == missing)
> 
> 
> 

