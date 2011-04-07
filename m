From: sanktnelson 1 <sanktnelson@googlemail.com>
Subject: help please - recovering from failed RAID5 rebuild
Date: Thu, 7 Apr 2011 22:00:58 +0200
Message-ID: <BANLkTinAmEgsbOx4k5yxCdHmM0GBWbXdBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,
I need some advice on recovering from a catastrophic RAID5 failure
(and a possible f***-up on my part in trying to recover). I didn't
find this covered in any of the howtos out there, so here is my
problem:
I was trying to rebuild my RAID5 (5 drives) after I had replaced one
failed drive (sdc) with a fresh one. During the rebuild another drive
(sdd) failed. so I was left with the sdc as spare (S) and sdd failed
(F).
first question: what should I have done at this point? I'm fairly
certain that the error that failed sdd was a fluke, loose cable or
something, so I wanted mdadm to just assume it was clean and retry the
rebuild.

what I actually did was reboot the machine in the hope it would just
restart the array in the previous degraded state, which of course it
did not. Instead all drives except the failed sdd were reported as
spare(S) in /proc/mdstat.

so I tried

root@enterprise:~# mdadm --run /dev/md0
mdadm: failed to run array /dev/md0: Input/output error

syslog showed at this point:

Apr =A07 20:37:49 localhost kernel: [ =A0893.981851] md: kicking non-fr=
esh
sdd1 from array!
Apr =A07 20:37:49 localhost kernel: [ =A0893.981864] md: unbind<sdd1>
Apr =A07 20:37:49 localhost kernel: [ =A0893.992526] md: export_rdev(sd=
d1)
Apr =A07 20:37:49 localhost kernel: [ =A0893.995844] raid5: device sdb1
operational as raid disk 3
Apr =A07 20:37:49 localhost kernel: [ =A0893.995848] raid5: device sdf1
operational as raid disk 4
Apr =A07 20:37:49 localhost kernel: [ =A0893.995852] raid5: device sde1
operational as raid disk 2
Apr =A07 20:37:49 localhost kernel: [ =A0893.996353] raid5: allocated 5=
265kB for md0
Apr =A07 20:37:49 localhost kernel: [ =A0893.996478] 3: w=3D1 pa=3D0 pr=
=3D5 m=3D1
a=3D2 r=3D5 op1=3D0 op2=3D0
Apr =A07 20:37:49 localhost kernel: [ =A0893.996482] 4: w=3D2 pa=3D0 pr=
=3D5 m=3D1
a=3D2 r=3D5 op1=3D0 op2=3D0
Apr =A07 20:37:49 localhost kernel: [ =A0893.996485] 2: w=3D3 pa=3D0 pr=
=3D5 m=3D1
a=3D2 r=3D5 op1=3D0 op2=3D0
Apr =A07 20:37:49 localhost kernel: [ =A0893.996488] raid5: not enough
operational devices for md0 (2/5 failed)
Apr =A07 20:37:49 localhost kernel: [ =A0893.996514] RAID5 conf printou=
t:
Apr =A07 20:37:49 localhost kernel: [ =A0893.996517] =A0--- rd:5 wd:3
Apr =A07 20:37:49 localhost kernel: [ =A0893.996520] =A0disk 2, o:1, de=
v:sde1
Apr =A07 20:37:49 localhost kernel: [ =A0893.996522] =A0disk 3, o:1, de=
v:sdb1
Apr =A07 20:37:49 localhost kernel: [ =A0893.996525] =A0disk 4, o:1, de=
v:sdf1
Apr =A07 20:37:49 localhost kernel: [ =A0893.996898] raid5: failed to r=
un
raid set md0
Apr =A07 20:37:49 localhost kernel: [ =A0893.996901] md: pers->run() fa=
iled ...

so I figured I'd re-add sdd:

root@enterprise:~# mdadm --re-add /dev/md0 /dev/sdd1
mdadm: re-added /dev/sdd1
root@enterprise:~# mdadm --run /dev/md0
mdadm: started /dev/md0

Apr =A07 20:44:16 localhost kernel: [ 1281.139654] md: bind<sdd1>
Apr =A07 20:44:16 localhost mdadm[1523]: SpareActive event detected on
md device /dev/md0, component device /dev/sdd1
Apr =A07 20:44:32 localhost kernel: [ 1297.147581] raid5: device sdd1
operational as raid disk 0
Apr =A07 20:44:32 localhost kernel: [ 1297.147585] raid5: device sdb1
operational as raid disk 3
Apr =A07 20:44:32 localhost kernel: [ 1297.147588] raid5: device sdf1
operational as raid disk 4
Apr =A07 20:44:32 localhost kernel: [ 1297.147591] raid5: device sde1
operational as raid disk 2
Apr =A07 20:44:32 localhost kernel: [ 1297.148102] raid5: allocated 526=
5kB for md0
Apr =A07 20:44:32 localhost kernel: [ 1297.148704] 0: w=3D1 pa=3D0 pr=3D=
5 m=3D1
a=3D2 r=3D5 op1=3D0 op2=3D0
Apr =A07 20:44:32 localhost kernel: [ 1297.148708] 3: w=3D2 pa=3D0 pr=3D=
5 m=3D1
a=3D2 r=3D5 op1=3D0 op2=3D0
Apr =A07 20:44:32 localhost kernel: [ 1297.148712] 4: w=3D3 pa=3D0 pr=3D=
5 m=3D1
a=3D2 r=3D5 op1=3D0 op2=3D0
Apr =A07 20:44:32 localhost kernel: [ 1297.148715] 2: w=3D4 pa=3D0 pr=3D=
5 m=3D1
a=3D2 r=3D5 op1=3D0 op2=3D0
Apr =A07 20:44:32 localhost kernel: [ 1297.148718] raid5: raid level 5
set md0 active with 4 out of 5 devices, algorithm 2
Apr =A07 20:44:32 localhost kernel: [ 1297.148722] RAID5 conf printout:
Apr =A07 20:44:32 localhost kernel: [ 1297.148725] =A0--- rd:5 wd:4
Apr =A07 20:44:32 localhost kernel: [ 1297.148728] =A0disk 0, o:1, dev:=
sdd1
Apr =A07 20:44:32 localhost kernel: [ 1297.148731] =A0disk 2, o:1, dev:=
sde1
Apr =A07 20:44:32 localhost kernel: [ 1297.148734] =A0disk 3, o:1, dev:=
sdb1
Apr =A07 20:44:32 localhost kernel: [ 1297.148737] =A0disk 4, o:1, dev:=
sdf1
Apr =A07 20:44:32 localhost kernel: [ 1297.148779] md0: detected
capacity change from 0 to 6001196531712
Apr =A07 20:44:32 localhost kernel: [ 1297.149047] =A0md0:RAID5 conf pr=
intout:
Apr =A07 20:44:32 localhost kernel: [ 1297.149559] =A0--- rd:5 wd:4
Apr =A07 20:44:32 localhost kernel: [ 1297.149562] =A0disk 0, o:1, dev:=
sdd1
Apr =A07 20:44:32 localhost kernel: [ 1297.149565] =A0disk 1, o:1, dev:=
sdc1
Apr =A07 20:44:32 localhost kernel: [ 1297.149568] =A0disk 2, o:1, dev:=
sde1
Apr =A07 20:44:32 localhost kernel: [ 1297.149570] =A0disk 3, o:1, dev:=
sdb1
Apr =A07 20:44:32 localhost kernel: [ 1297.149573] =A0disk 4, o:1, dev:=
sdf1
Apr =A07 20:44:32 localhost kernel: [ 1297.149846] md: recovery of RAID=
 array md0
Apr =A07 20:44:32 localhost kernel: [ 1297.149849] md: minimum
_guaranteed_ =A0speed: 1000 KB/sec/disk.
Apr =A07 20:44:32 localhost kernel: [ 1297.149852] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Apr =A07 20:44:32 localhost kernel: [ 1297.149858] md: using 128k
window, over a total of 1465135872 blocks.
Apr =A07 20:44:32 localhost kernel: [ 1297.188272] =A0unknown partition=
 table
Apr =A07 20:44:32 localhost mdadm[1523]: RebuildStarted event detected
on md device /dev/md0

I figured this was definitely wrong, since I still couldn't mount
/dev/md0, so I manually failed sdc and sdd to stop any further
destruction on my part and to go seek expert help, so here I am. Is my
data still there or have the first few hundred MB been zeroed to
initialize a fresh array? how do I force mdadm to assume sdd is fresh
and give me access to the array without any writes happening to it?
Sorry to come running to the highest authority on linuxraid here, but
all the howtos out there are pretty thin when it comes to anything
more complicated than creating and array and recovering from one
failed drive.

Any advice (even if it is just for doing the right thing the next
time), is greatly appreciated.

-Felix
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
