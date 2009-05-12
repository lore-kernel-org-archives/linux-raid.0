From: fibre raid <fibreraid@gmail.com>
Subject: mdadm issue on Ubuntu Januty 9.04 server
Date: Mon, 11 May 2009 18:32:38 -0700
Message-ID: <5817fbed0905111832u35d39a5au52482cceea53a4cb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I am facing an issue with mdadm on Ubuntu Jaunty 9.04 Server 64-bit edi=
tion.

Host:
- Dual quad-core Xeon 5450 3.0 GHz CPUs
- 16 GB RAM
- Ubuntu 9.04 server (2.6.28-11)
- mdadm 2.6.7.1
- LSI 3801E controller with 12 x Seagate Cheetah 15K.5 300GB drives

I am trying to create a RAID 0 md device from two of the 15K.5 drives.
When I boot my Host, it seems like there is some legacy md data in
/proc/mdstat. However, /etc/mdadm.conf is empty.

root@JAUNTY:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md_d1 : inactive sdx[1](S)
=A0=A0=A0=A0=A0 292968640 blocks

md_d0 : inactive sdj[3](S) sdm[0](S) sdf[7](S) sdg[6](S)
=A0=A0=A0=A0=A0 1171874560 blocks

unused devices: <none>


I proceed to stop and remove these md devices and use /proc/mdstat to
verify that they were removed.

root@JAUNTY:~# mdadm -S /dev/md_d1
mdadm: stopped /dev/md_d1
root@JAUNTY:~# mdadm -S /dev/md_d0
mdadm: stopped /dev/md_d0
root@JAUNTY:~# mdadm -r /dev/md_d1
root@JAUNTY:~# mdadm -r /dev/md_d0
root@JAUNTY:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
unused devices: <none>


Now it appears that the md devices are removed.

I then try to create an md device:

root@JAUNTY:~# mdadm -C -f -e 1.0 -R /dev/md0 -l 0 -n 2 -c 64 /dev/sdd =
/dev/sdg
mdadm: /dev/sdg appears to be part of a raid array:
=A0=A0=A0 level=3Draid0 devices=3D8 ctime=3DSun Mar 22 23:22:03 2009
mdadm: array /dev/md0 started.
root@JAUNTY:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid0 sdg[1] sdd[0]
=A0=A0=A0=A0=A0 585937408 blocks super 1.0 64k chunks

unused devices: <none>


Why does mdadm report /dev/sdg as part of a raid array? I removed all
the md devices as shown above. Thank you for your help!

Thanks!
-Thomas
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
