From: Elmar Weber <lists@elmarweber.org>
Subject: Raid 1 up after raidhotadd without rebuild
Date: Tue, 14 Nov 2006 10:29:45 +0100
Message-ID: <45598C89.6080101@elmarweber.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm trying to rebuild a raid1 array by adding the replacement disk (sda=
)=20
to the old one (sdf). I zero'd the new disk (sda) and created the=20
partition table corresponding to the existing one.

I adapted my raidtab to the new drive node (changed due to other disk=20
replacement) and now I'm trying to add the new disk, but the raid 1 is=20
not rebuilding, the newly added disk is marked as U(p) in the mdstat ou=
tput.

Here's what I do step by step (mdstat output reduced to one raid array,=
=20
but the problem exists with every partition used as a raid 1):

# cat /proc/mdstat

md1 : active raid1 sdf1[1]
       112728000 blocks [2/1] [_U]


# raidhotadd /dev/md1 /dev/sda1 && cat /proc/mdstat

md1 : active raid1 sda1[1] sdf1[0]
       112728000 blocks [2/2] [UU]


Thats it, no resync, nothing. When I do a fsck on the md1 there are=20
errors en masse. raidtools don't even seem to touch sda1, since when I=20
create a filesystem with content on it, I can mount it after adding it=20
to the raid.


Any ideas why this is and how to fix it?


Thanks in advance & ciao,
elm


Here is the entry in the syslog:
=3D=3D
Nov 15 09:34:46 server md: bind<sda1>
Nov 15 09:34:46 server RAID1 conf printout:
Nov 15 09:34:46 server --- wd:1 rd:2
Nov 15 09:34:46 server disk 0, wo:1, o:1, dev:sda1
Nov 15 09:34:46 server disk 1, wo:0, o:1, dev:sdf1
Nov 15 09:34:46 server md: syncing RAID array md2
Nov 15 09:34:46 server md: minimum _guaranteed_ reconstruction speed:=20
1000 KB/sec/disc.
Nov 15 09:34:46 server md: using maximum available idle IO bandwidth=20
(but not more than 200000 KB/sec) for reconstruction.
Nov 15 09:34:46 server md: using 128k window, over a total of 112728000=
=20
blocks.
Nov 15 09:34:46 server md: md1: sync done.
Nov 15 09:34:46 server RAID1 conf printout:
Nov 15 09:34:46 server --- wd:2 rd:2
Nov 15 09:34:46 server disk 0, wo:0, o:1, dev:sda1
Nov 15 09:34:46 server disk 1, wo:0, o:1, dev:sdf1
=3D=3D

Here is the raidtab:
=3D=3D
raiddev /dev/md1
     raid-level              1
     nr-raid-disks           2
     nr-spare-disks          0
     persistent-superblock   1
     chunk-size 8k

     device                  /dev/sda1
         raid-disk               0
     device                  /dev/sdf1
         raid-disk               1
=3D=3D



--=20
"Religion und Familie sind die beiden gr=F6=DFten Feinde des Fortschrit=
ts."
(Andr=E9 Gide (1869 - 1951), franz=F6sischer Schriftsteller)
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
