From: jahammonds prost <gmitch64@yahoo.com>
Subject: mdadm RAID5 array failure
Date: Thu, 8 Feb 2007 11:36:49 +0800 (CST)
Message-ID: <24264.46597.qm@web55801.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm running an FC4 system. I was copying some files on to the server th=
is weekend, and the server locked up hard, and I had to power off. I re=
booted the server, and the array came up fine, but when I tried to fsck=
 the filesystem, fsck just locked up at about 40%. I left it sitting th=
ere for 12 hours, hoping it was going to come back, but I had to power =
off the server again. When I now reboot the server, it is failing to mo=
unt my raid5 array..
=20
      mdadm: /dev/md0 assembled from 3 drives and 1 spare - not enough =
to start the array.
=20
I've added the output from the various files/commands at the bottom...
I am a little confused at the output.. According to /dev/hd[cgh], there=
 is only 1 failed disk in the array, so why does it think that there ar=
e 3 failed disks in the array? It looks like there is only 1 failed dis=
k =96 I got an error from SMARTD about it when I got the server back in=
to multiuser mode, so I know there is an issue with the disk (Device: /=
dev/hde, 8 Offline uncorrectable sectors), but there are still enough d=
isks to bring up the array, and for the spare disk to start rebuilding.
=20
I've spent the last couple of days googling around, and I can't seem to=
 find much on how to recover a failed md arrary. Is there any way to ge=
t the array back and working? Unfortunately I don't have a back up of t=
his array, and I'd really like to try and get the data back (there are =
3 LVM logical volumes on it).
=20
Thanks very much for any help.
=20
=20
Graham
=20
=20
=20
My /etc/mdadm.conf looks like this
=20
]# cat /etc/mdadm.conf
DEVICE /dev/hd*[a-z]
ARRAY /dev/md0 level=3Draid5 num-devices=3D6 UUID=3D96c7d78a:2113ea58:9=
dc237f1:79a60ddf
 =20
devices=3D/dev/hdh,/dev/hdg,/dev/hdf,/dev/hde,/dev/hdd,/dev/hdc,/dev/hd=
b
=20
=20
Looking at /proc/mdstat, I am getting this output
=20
# cat /proc/mdstat
Personalities : [raid5] [raid4]
md0 : inactive hdc[0] hdb[6] hdh[5] hdg[4] hdf[3] hde[2] hdd[1]
      1378888832 blocks super non-persistent
=20
=20
=20
=20
Here's the output when ran on the device that some think have failed...=
=2E.
=20
# mdadm -E /dev/hde
/dev/hde:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 96c7d78a:2113ea58:9dc237f1:79a60ddf
  Creation Time : Wed Feb  1 17:10:39 2006
     Raid Level : raid5
   Raid Devices : 6
  Total Devices : 7
Preferred Minor : 0
=20
    Update Time : Sun Feb  4 17:29:53 2007
          State : active
 Active Devices : 6
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 1
       Checksum : dcab70d - correct
         Events : 0.840944
=20
         Layout : left-symmetric
     Chunk Size : 128K
=20
      Number   Major   Minor   RaidDevice State
this     2      33        0        2      active sync   /dev/hde
=20
   0     0      22        0        0      active sync   /dev/hdc
   1     1      22       64        1      active sync   /dev/hdd
   2     2      33        0        2      active sync   /dev/hde
   3     3      33       64        3      active sync   /dev/hdf
   4     4      34        0        4      active sync   /dev/hdg
   5     5      34       64        5      active sync   /dev/hdh
   6     6       3       64        6      spare   /dev/hdb
=20
=20
Running an mdadm -E on /dev/hd[bcgh] gives this,
=20
=20
      Number   Major   Minor   RaidDevice State
this     6       3       64        6      spare   /dev/hdb
=20
   0     0      22        0        0      active sync   /dev/hdc
   1     1      22       64        1      active sync   /dev/hdd
   2     2       0        0        2      faulty removed
   3     3      33       64        3      active sync   /dev/hdf
   4     4      34        0        4      active sync   /dev/hdg
   5     5      34       64        5      active sync   /dev/hdh
   6     6       3       64        6      spare   /dev/hdb
=20
=20
=20
And running mdadm -E on /dev/hd[def]
=20
      Number   Major   Minor   RaidDevice State
this     3      33       64        3      active sync   /dev/hdf
=20
   0     0      22        0        0      active sync   /dev/hdc
   1     1      22       64        1      active sync   /dev/hdd
   2     2      33        0        2      active sync   /dev/hde
   3     3      33       64        3      active sync   /dev/hdf
   4     4      34        0        4      active sync   /dev/hdg
   5     5      34       64        5      active sync   /dev/hdh
   6     6       3       64        6      spare   /dev/hdb
=20
=20
Looking at /var/log/messages, shows the following
=20
=46eb  6 12:36:42 file01bert kernel: md: bind<hdd>
=46eb  6 12:36:42 file01bert kernel: md: bind<hde>
=46eb  6 12:36:42 file01bert kernel: md: bind<hdf>
=46eb  6 12:36:42 file01bert kernel: md: bind<hdg>
=46eb  6 12:36:42 file01bert kernel: md: bind<hdh>
=46eb  6 12:36:42 file01bert kernel: md: bind<hdb>
=46eb  6 12:36:42 file01bert kernel: md: bind<hdc>
=46eb  6 12:36:42 file01bert kernel: md: kicking non-fresh hdf from arr=
ay!
=46eb  6 12:36:42 file01bert kernel: md: unbind<hdf>
=46eb  6 12:36:42 file01bert kernel: md: export_rdev(hdf)
=46eb  6 12:36:42 file01bert kernel: md: kicking non-fresh hde from arr=
ay!
=46eb  6 12:36:42 file01bert kernel: md: unbind<hde>
=46eb  6 12:36:42 file01bert kernel: md: export_rdev(hde)
=46eb  6 12:36:42 file01bert kernel: md: kicking non-fresh hdd from arr=
ay!
=46eb  6 12:36:42 file01bert kernel: md: unbind<hdd>
=46eb  6 12:36:42 file01bert kernel: md: export_rdev(hdd)
=46eb  6 12:36:42 file01bert kernel: md: md0: raid array is not clean -=
- starting background reconstruction
=46eb  6 12:36:42 file01bert kernel: raid5: device hdc operational as r=
aid disk 0
=46eb  6 12:36:42 file01bert kernel: raid5: device hdh operational as r=
aid disk 5
=46eb  6 12:36:42 file01bert kernel: raid5: device hdg operational as r=
aid disk 4
=46eb  6 12:36:42 file01bert kernel: raid5: not enough operational devi=
ces for md0 (3/6 failed)
=46eb  6 12:36:42 file01bert kernel: RAID5 conf printout:
=46eb  6 12:36:42 file01bert kernel:  --- rd:6 wd:3 fd:3
=46eb  6 12:36:42 file01bert kernel:  disk 0, o:1, dev:hdc
=46eb  6 12:36:42 file01bert kernel:  disk 4, o:1, dev:hdg
=46eb  6 12:36:42 file01bert kernel:  disk 5, o:1, dev:hdh
=46eb  6 12:36:42 file01bert kernel: raid5: failed to run raid set md0
=46eb  6 12:36:42 file01bert kernel: md: pers->run() failed ...


=09
=09
	=09
___________________________________________________________=20
New Yahoo! Mail is the ultimate force in competitive emailing. Find out=
 more at the Yahoo! Mail Championships. Plus: play games and win prizes=
=2E=20
http://uk.rd.yahoo.com/evt=3D44106/*http://mail.yahoo.net/uk=20
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
