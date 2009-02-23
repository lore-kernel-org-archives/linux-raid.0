From: Joe Landman <landman@scalableinformatics.com>
Subject: Re: rescue an alien md raid5
Date: Mon, 23 Feb 2009 13:58:48 -0500
Message-ID: <49A2F1E8.6030901@scalableinformatics.com>
References: <200902231013.46082.harry.mangalam@uci.edu>
Reply-To: landman@scalableinformatics.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200902231013.46082.harry.mangalam@uci.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Harry Mangalam <harry.mangalam@uci.edu>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Harry Mangalam wrote:
> Here's an unusual (long) tale of woe.
> 
> We had a USRobotics 8700 NAS appliance with 4 SATA disks in RAID5:
>  <http://www.usr.com/support/product-template.asp?prod=8700>
> which was a fine (if crude) ARM-based Linux NAS until it stroked out 
> at some point, leaving us with a degraded RAID5 and comatose NAS 
> device.
> 
> We'd like to get the files back of course and I've moved the disks to 
> a Linux PC, hooked them up to a cheap Silicon Image 4x SATA 
> controller and brought up the whole frankenmess with mdadm.  It 
> reported a clean but degraded array:
> 
> ===============================================================
> 
> root@pnh-rcs:/# mdadm --detail /dev/md0
> /dev/md0:
>         Version : 00.90.03

> The docs and files on the USR web site imply that the native 
> filesystem was originally XFS, but when i try to mount it as such, I 
> can't:
> 
> mount -vvv -t xfs /dev/md1 /mnt
> mount: fstab path: "/etc/fstab"
> mount: lock path:  "/etc/mtab~"
> mount: temp path:  "/etc/mtab.tmp"
> mount: no LABEL=, no UUID=, going to mount /dev/md1 by path
> mount: spec:  "/dev/md1"
> mount: node:  "/mnt"
> mount: types: "xfs"
> mount: opts:  "(null)"
> mount: mount(2) syscall: source: "/dev/md1", target: "/mnt", 
> filesystemtype: "xfs", mountflags: -1058209792, data: (null)
> mount: wrong fs type, bad option, bad superblock on /dev/md1,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so

Hmmm... is it possible that the journal is external for the XFS 
filesystem in question?  Could you try

	mount -o norecovery,ro /dev/md1 /mountpoint

Otherwise, could you dd the file system off there onto another (large) 
partition, before you try xfs_repair





-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics LLC,
email: landman@scalableinformatics.com
web  : http://www.scalableinformatics.com
        http://jackrabbit.scalableinformatics.com
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
