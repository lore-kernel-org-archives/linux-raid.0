From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: RE: Please help with a special RAID 1 setup
Date: Wed, 7 Jan 2004 13:14:01 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8075D5C3061B9441944E137377645118012F02@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
Cc: "Cress, Andrew R" <andrew.r.cress@intel.com>, Catalin BOIE <util@deuroconsult.ro>, Mircea Ciocan <mirceac@interplus.ro>
List-Id: linux-raid.ids

 

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org 
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Cress, Andrew R
> Sent: Wednesday, January 07, 2004 9:48 AM
> To: Catalin BOIE; Mircea Ciocan
> Cc: linux-raid@vger.kernel.org
> Subject: RE: Please help with a special RAID 1 setup
> 
> 
> Note that RAID-1 will only ever have a maximum of 2 active disks.

I don't believe that the above is a correct statement.  Linux software
RAID1 will allow mirroring across more than 2 devices:

[root@cinshrlnxlap01 ~]# cat /proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
md2 : active raid1 [dev 01:02][2] [dev 01:01][1] [dev 01:00][0]
      4032 blocks [3/3] [UUU]

unused devices: <none>

[root@cinshrlnxlap01 ~]# mount /dev/md2 /mnt/cdrom/
[root@cinshrlnxlap01 ~]# cd /mnt/cdrom/
[root@cinshrlnxlap01 /mnt/cdrom]# dir
total 17
drwxr-xr-x    3 root     root         1024 Jan  7 12:09 .
drwxr-xr-x    4 root     root         4096 Dec 30 07:46 ..
drwx------    2 root     root        12288 Jan  7 12:09 lost+found

[root@cinshrlnxlap01 /mnt/cdrom]# touch hithere
[root@cinshrlnxlap01 /mnt]# umount cdrom/
[root@cinshrlnxlap01 /mnt]# raidstop /dev/md2
[root@cinshrlnxlap01 /mnt]# mount /dev/ram0 /mnt/cdrom/
[root@cinshrlnxlap01 /mnt]# ls -la cdrom/
total 17
drwxr-xr-x    3 root     root         1024 Jan  7 12:10 .
drwxr-xr-x    4 root     root         4096 Dec 30 07:46 ..
-rw-r--r--    1 root     root            0 Jan  7 12:10 hithere
drwx------    2 root     root        12288 Jan  7 12:09 lost+found
[root@cinshrlnxlap01 /mnt]# umount cdrom/
umount: /mnt/cdrom: device is busy
[root@cinshrlnxlap01 /mnt]# umount cdrom/
[root@cinshrlnxlap01 /mnt]# mount /dev/ram1 /mnt/cdrom/
[root@cinshrlnxlap01 /mnt]# ls -la cdrom/
total 17
drwxr-xr-x    3 root     root         1024 Jan  7 12:10 .
drwxr-xr-x    4 root     root         4096 Dec 30 07:46 ..
-rw-r--r--    1 root     root            0 Jan  7 12:10 hithere
drwx------    2 root     root        12288 Jan  7 12:09 lost+found
[root@cinshrlnxlap01 /mnt]# umount cdrom/
[root@cinshrlnxlap01 /mnt]# mount /dev/ram2 /mnt/cdrom/
[root@cinshrlnxlap01 /mnt]# ls -la /mnt/cdrom/
total 17
drwxr-xr-x    3 root     root         1024 Jan  7 12:10 .
drwxr-xr-x    4 root     root         4096 Dec 30 07:46 ..
-rw-r--r--    1 root     root            0 Jan  7 12:10 hithere
drwx------    2 root     root        12288 Jan  7 12:09 lost+found 

We had a "triple" mirror sofware RAID setup on a box as a "poor man's
snapshot" before we started using LVM.  We triple mirrored and then
broke one mirror to backup and then added the removed disk back into the
array and re-synched.  LVM snapshots are much more elegant and LVM
provides more functionality such as extended volumes when you want to
add more space.  You have to be careful using LVM because as of 2.4.18
there was a Linux VM bug that would not allow snapshotting with greater
than about 6GB of system RAM.

However, I would recommend recreating the filesystem on top of LVM and
using snapshots to accomplish what you want.  We use LVM on top of SW
RAID with great success.


> When you add the 3rd disk, it is added to the array as a 
> spare, that's why it doesn't rebuild.
> 
> Andy
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Catalin BOIE
> Sent: Wednesday, January 07, 2004 8:48 AM
> To: Mircea Ciocan
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Please help with a special RAID 1 setup
> 
> 
> > >I think that you must replace:
> > >	nr-raid-disks   2
> > >with
> > >	nr-raid-disks   3
> > >Plus, the correspinding entry:
> > >	device          /dev/sdb3
> > >	raid-disk       2
> > >
> > >Else, the third drive isn't recognized as part of the md array.
> > >Probably, you must restart the array (only first time).
> > >You may want to use mdadm instead of raidtools.
> > >
> > >
> > >
> >
> >     Modified config file, umounted and stoped raid, restarted raid, 
> > hotadded the disk, still the same results :(.
> > Any other ideeas ??
> >
> >     Mircea
> 
> I think you must rebuid the /dec/md0 with mkraid --upgrade.
> Warning! You may destroy all data, so backup first.
> 
> ---
> Catalin(ux) BOIE
> catab@deuroconsult.ro
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-raid" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-raid" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> 
> 
