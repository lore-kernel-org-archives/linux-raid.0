From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Strange behaviour on "toy array"
Date: Sun, 15 May 2005 18:13:02 -0400
Message-ID: <200505152213.j4FMD7m13616@www.watkins-home.com>
References: <4287B731.1080101@ucolick.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4287B731.1080101@ucolick.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Patrik Jonsson' <patrik@ucolick.org>, 'David Greaves' <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok, now put more files on your filesystem.

I think you are correct and the buffer cache is handling the reads.

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Patrik Jonsson
> Sent: Sunday, May 15, 2005 4:55 PM
> To: David Greaves; linux-raid@vger.kernel.org
> Subject: Re: Strange behaviour on "toy array"
> 
> 
> 
> David Greaves wrote:
> 
> >
> >I think you'd need to post the commands you used and the results of
> >things like mdadm --detail and cat /proc/mdstat
> >also kernel version, mdadm version etc.
> >
> >That way we can ensure you really did fail the right drives etc etc.
> >
> >Right now it could be anything from (allowed!) user error to a weird ppc
> >thing...
> >
> >
> sure thing:
> [root@localhost junk]# uname -a
> Linux localhost.localdomain 2.6.9-prep #1 Tue Apr 19 16:00:33 PDT 2005
> ppc ppc ppc GNU/Linux
> [root@localhost junk]# mdadm --version
> mdadm - v1.6.0 - 4 June 2004
> 
> now I do (loop1-5 are files):
> losetup /dev/loop0 loop1
> losetup /dev/loop1 loop2
> losetup /dev/loop2 loop3
> losetup /dev/loop3 loop4
> losetup /dev/loop4 loop5
> mdadm --create /dev/md0 -l 5 -n 5 /dev/loop0 /dev/loop1 /dev/loop2
> /dev/loop3 /dev/loop4
> mkfs.ext3 /dev/md0
> mount -t ext3 /dev/md0 junk
> 
> at this point, mdadm shows:
> [root@localhost junk]# mdadm --detail /dev/md0
> /dev/md0:
>         Version : 00.90.01
>   Creation Time : Sun May 15 13:41:24 2005
>      Raid Level : raid5
>      Array Size : 3840
>     Device Size : 960
>    Raid Devices : 5
>   Total Devices : 5
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Sun May 15 13:45:34 2005
>           State : clean
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>     Number   Major   Minor   RaidDevice State
>        0       7        0        0      active sync   /dev/loop0
>        1       7        1        1      active sync   /dev/loop1
>        2       7        2        2      active sync   /dev/loop2
>        3       7        3        3      active sync   /dev/loop3
>        4       7        4        4      active sync   /dev/loop4
>            UUID : b89aa5de:da1054f5:b052cc51:393d7435
>          Events : 0.24
> 
> and /proc/mdstat:
> [root@localhost junk]# cat /proc/mdstat
> Personalities : [raid5]
> md0 : active raid5 loop4[4] loop3[3] loop2[2] loop1[1] loop0[0]
>       3840 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
> 
> unused devices: <none>
> 
> Now I fail (e.g.) /dev/loop0:
> mdadm -f /dev/md0 /dev/loop0
> 
> and get:
> [root@localhost junk]# mdadm --detail /dev/md0
> /dev/md0:
>         Version : 00.90.01
>   Creation Time : Sun May 15 13:41:24 2005
>      Raid Level : raid5
>      Array Size : 3840
>     Device Size : 960
>    Raid Devices : 5
>   Total Devices : 5
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Sun May 15 13:49:20 2005
>           State : clean, degraded
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 1
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>     Number   Major   Minor   RaidDevice State
>        0       0        0       -1      removed
>        1       7        1        1      active sync   /dev/loop1
>        2       7        2        2      active sync   /dev/loop2
>        3       7        3        3      active sync   /dev/loop3
>        4       7        4        4      active sync   /dev/loop4
>        5       7        0       -1      faulty   /dev/loop0
>            UUID : b89aa5de:da1054f5:b052cc51:393d7435
>          Events : 0.27
> 
> and:
> [root@localhost junk]# cat /proc/mdstat
> Personalities : [raid5]
> md0 : active raid5 loop4[4] loop3[3] loop2[2] loop1[1] loop0[5](F)
>       3840 blocks level 5, 64k chunk, algorithm 2 [5/4] [_UUUU]
> 
> unused devices: <none>
> 
> continue failing drives:
> [root@localhost junk]# mdadm -f /dev/md0 /dev/loop1
> mdadm: set /dev/loop1 faulty in /dev/md0
> [root@localhost junk]# mdadm -f /dev/md0 /dev/loop2
> mdadm: set /dev/loop2 faulty in /dev/md0
> [root@localhost junk]# mdadm -f /dev/md0 /dev/loop3
> mdadm: set /dev/loop3 faulty in /dev/md0
> [root@localhost junk]# mdadm -f /dev/md0 /dev/loop4
> mdadm: set /dev/loop4 faulty in /dev/md0
> 
> now I get:
> [root@localhost junk]# mdadm --detail /dev/md0
> /dev/md0:
>         Version : 00.90.01
>   Creation Time : Sun May 15 13:41:24 2005
>      Raid Level : raid5
>      Array Size : 3840
>     Device Size : 960
>    Raid Devices : 5
>   Total Devices : 5
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Sun May 15 13:51:09 2005
>           State : clean, degraded
>  Active Devices : 0
> Working Devices : 0
>  Failed Devices : 5
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>     Number   Major   Minor   RaidDevice State
>        0       0        0       -1      removed
>        1       0        0       -1      removed
>        2       0        0       -1      removed
>        3       0        0       -1      removed
>        4       0        0       -1      removed
>        5       7        4       -1      faulty   /dev/loop4
>        6       7        3       -1      faulty   /dev/loop3
>        7       7        2       -1      faulty   /dev/loop2
>        8       7        1       -1      faulty   /dev/loop1
>        9       7        0       -1      faulty   /dev/loop0
> 
> and:
> Personalities : [raid5]
> md0 : active raid5 loop4[5](F) loop3[6](F) loop2[7](F) loop1[8](F)
> loop0[9](F)
>       3840 blocks level 5, 64k chunk, algorithm 2 [5/0] [_____]
> 
> unused devices: <none>
> 
> but I can still read the file on the filesystem that is mounted (ie in
> the "junk" dir).
> 
> Hope that contains all the info you need.
> 
> /Patrik
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

