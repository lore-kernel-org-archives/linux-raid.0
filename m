From: "Graham Mitchell" <gmitch@woodlea.com>
Subject: RAID 6 recovery issue
Date: Tue, 20 Jan 2015 11:46:45 -0500
Message-ID: <00b101d034d0$ad7dd050$087970f0$@woodlea.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've been having a heck of a time sending this - apologies if anyone se=
es
this email more than once (I've not see it hit the lists either of the =
2
previous times I've sent it).


I=92m having an issue with one of my RAID-6 arrays. For some reason, th=
e email
wasn=92t set up, so I never found out I had a couple of bad drives in t=
he
array until last night.

Originally, when I looked at the output of /proc/mdstat, it showed that=
 the
array was running with 15 out of the 17 drives still running.


[gmitch@file00bert ~]$ cat /proc/mdstat=20
Personalities : [raid6] [raid5] [raid4]=20
md0 : active raid6 sde1[19] sdi1[16] sdh1[12] sdf1[4] sdr1[18] sdg1[5](=
=46)
sdj1[7] sdo1[22] sdt1[14] sdd1[13] sdl1[0](F) sda1[20] sdb1[1] sdk1[21]
sdn1[10] sdc1[2] sdm1[15] sdq1[17]
      7325752320 blocks super 1.2 level 6, 512k chunk, algorithm 2 [17/=
15]
[_UUUU_UUUUUUUUUUU]
      [>....................]  recovery =3D  0.4% (2421508/488383488)
finish=3D180.7min speed=3D44805K/sec


As you can see, device 19 (sde1) is showing as a normal member of the a=
rray.
My original plan was to partition off 500GB from one of the 1TB drives =
I
have spare in the server, add one partition to the array. Once that had=
 been
done, I was going to carve off =A0500GB =A0from the other drive, and le=
t the
array rebuild with that.

I created the partition on one of the drives and was going to add it to=
 the
array, but stopped when I saw that the array was in recovery (I started=
 up=A0
=91watch /proc/mdstat=92 in another window).

I went to have dinner, and came back, and found that the array was now =
very
unhappy, and cat /proc/mdstat showed

[root@file00bert ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sde1[19](S) sdi1[16] sdh1[12] sdf1[4] sdr1[18] sdg1[=
5](F)
sdj1[7] sdt1[14] sdd1[13] sdl1[0](F) sda1[20] sdb1[1] sdk1[21] sdn1[10]
sdc1[2] sdm1[15] sdq1[17]
=A0=A0 =A0=A0=A07325752320 blocks super 1.2 level 6, 512k chunk, algori=
thm 2 [17/14]
[_UUUU_UUUUUUUUUU_]

With device 19 having gone from a live drive to a spare. =A0I=92ve done=
 an
examine of all the drives, and the event counts look to be reasonable

[root@file00bert ~]# mdadm -E /dev/sd[a-z]1 | egrep 'Event|/dev'
/dev/sda1:
         Events : 1452687
/dev/sdb1:
         Events : 1452687
/dev/sdc1:
         Events : 1452687
/dev/sdd1:
         Events : 1452687
/dev/sde1:
         Events : 1452687
/dev/sdf1:
         Events : 1452687
/dev/sdh1:
         Events : 1452687
/dev/sdi1:
         Events : 1452687
/dev/sdj1:
         Events : 1452687
/dev/sdk1:
         Events : 1452687
/dev/sdm1:
         Events : 1452687
/dev/sdn1:
         Events : 1452687
/dev/sdo1:
         Events : 1452661
/dev/sdq1:
         Events : 1452687
/dev/sdr1:
         Events : 1452687
/dev/sdt1:
         Events : 1452687
/dev/sdw1:
         Events : 1431553
/dev/sdx1:
         Events : 1431964
[root@file00bert ~]#


All of the events look to be within acceptable limits (are they?) and d=
evice
19 (sde1) has the same event count as most of the drives, but for some
reason it is now marked as a spare. I=92ve not stopped the array yet, b=
ut I=92ve
not written anything to it either. I=92m not sure if taking the array d=
own
then restarting it with a =96force is the right course of action. My go=
ogling
isn=92t showing a conclusive answer, so I thought I should seek some ad=
vice
before I went and did something that wrecked the array.


What should my next steps to recover the array be? I think all I need t=
o do
is somehow to get device 19 (sde1) back believing that it's a real memb=
er of
the array, rather than a spare? Or should I be kicking it out, and gett=
ing
things running with sdo1?

[root@file00bert ~]# uname -a
Linux file00bert.woodlea.org.uk 2.6.32-358.2.1.el6.x86_64 #1 SMP Wed Ma=
r 13
00:26:49 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
[root@file00bert ~]# mdadm --version
mdadm - v3.2.5 - 18th May 2012



Thanks.


Graham


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
