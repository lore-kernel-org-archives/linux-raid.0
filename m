From: NeilBrown <neilb@suse.de>
Subject: Re: help please - recovering from failed RAID5 rebuild
Date: Fri, 8 Apr 2011 22:01:30 +1000
Message-ID: <20110408220130.4830852d@notabene.brown>
References: <BANLkTinAmEgsbOx4k5yxCdHmM0GBWbXdBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinAmEgsbOx4k5yxCdHmM0GBWbXdBA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: sanktnelson 1 <sanktnelson@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 7 Apr 2011 22:00:58 +0200 sanktnelson 1 <sanktnelson@googlemail=
=2Ecom>
wrote:

> Hi all,
> I need some advice on recovering from a catastrophic RAID5 failure
> (and a possible f***-up on my part in trying to recover). I didn't
> find this covered in any of the howtos out there, so here is my
> problem:
> I was trying to rebuild my RAID5 (5 drives) after I had replaced one
> failed drive (sdc) with a fresh one. During the rebuild another drive
> (sdd) failed. so I was left with the sdc as spare (S) and sdd failed
> (F).
> first question: what should I have done at this point? I'm fairly
> certain that the error that failed sdd was a fluke, loose cable or
> something, so I wanted mdadm to just assume it was clean and retry th=
e
> rebuild.


What I would have done is stop the array (mdadm -S /dev/md0) and re-ass=
emble
it with --force.  This would get you the degraded array back.
Then I would backup and data that I really couldn't live without - just=
 in
case.

Then I would stop the array, dd-rescue sdd to some other device, possib=
le
sdc, and assemble the array with the known-good devices and the new dev=
ice
(which might have been sdc) and NOT sdd.=20
This would give me a degraded array of good devices.
Then I would add another good device - maybe sdc if I thought that it w=
as
just a ready error and writes would work.
Then wait and hope.

>=20
> what I actually did was reboot the machine in the hope it would just
> restart the array in the previous degraded state, which of course it
> did not. Instead all drives except the failed sdd were reported as
> spare(S) in /proc/mdstat.
>=20
> so I tried
>=20
> root@enterprise:~# mdadm --run /dev/md0
> mdadm: failed to run array /dev/md0: Input/output error
>=20
> syslog showed at this point:
>=20
> Apr =A07 20:37:49 localhost kernel: [ =A0893.981851] md: kicking non-=
fresh
> sdd1 from array!
> Apr =A07 20:37:49 localhost kernel: [ =A0893.981864] md: unbind<sdd1>
> Apr =A07 20:37:49 localhost kernel: [ =A0893.992526] md: export_rdev(=
sdd1)
> Apr =A07 20:37:49 localhost kernel: [ =A0893.995844] raid5: device sd=
b1
> operational as raid disk 3
> Apr =A07 20:37:49 localhost kernel: [ =A0893.995848] raid5: device sd=
f1
> operational as raid disk 4
> Apr =A07 20:37:49 localhost kernel: [ =A0893.995852] raid5: device sd=
e1
> operational as raid disk 2
> Apr =A07 20:37:49 localhost kernel: [ =A0893.996353] raid5: allocated=
 5265kB for md0
> Apr =A07 20:37:49 localhost kernel: [ =A0893.996478] 3: w=3D1 pa=3D0 =
pr=3D5 m=3D1
> a=3D2 r=3D5 op1=3D0 op2=3D0
> Apr =A07 20:37:49 localhost kernel: [ =A0893.996482] 4: w=3D2 pa=3D0 =
pr=3D5 m=3D1
> a=3D2 r=3D5 op1=3D0 op2=3D0
> Apr =A07 20:37:49 localhost kernel: [ =A0893.996485] 2: w=3D3 pa=3D0 =
pr=3D5 m=3D1
> a=3D2 r=3D5 op1=3D0 op2=3D0
> Apr =A07 20:37:49 localhost kernel: [ =A0893.996488] raid5: not enoug=
h
> operational devices for md0 (2/5 failed)
> Apr =A07 20:37:49 localhost kernel: [ =A0893.996514] RAID5 conf print=
out:
> Apr =A07 20:37:49 localhost kernel: [ =A0893.996517] =A0--- rd:5 wd:3
> Apr =A07 20:37:49 localhost kernel: [ =A0893.996520] =A0disk 2, o:1, =
dev:sde1
> Apr =A07 20:37:49 localhost kernel: [ =A0893.996522] =A0disk 3, o:1, =
dev:sdb1
> Apr =A07 20:37:49 localhost kernel: [ =A0893.996525] =A0disk 4, o:1, =
dev:sdf1
> Apr =A07 20:37:49 localhost kernel: [ =A0893.996898] raid5: failed to=
 run
> raid set md0
> Apr =A07 20:37:49 localhost kernel: [ =A0893.996901] md: pers->run() =
failed ...
>=20
> so I figured I'd re-add sdd:
>=20
> root@enterprise:~# mdadm --re-add /dev/md0 /dev/sdd1
> mdadm: re-added /dev/sdd1
> root@enterprise:~# mdadm --run /dev/md0
> mdadm: started /dev/md0

This should be effectively equivalent to --assemble --force (I think).


>=20
> Apr =A07 20:44:16 localhost kernel: [ 1281.139654] md: bind<sdd1>
> Apr =A07 20:44:16 localhost mdadm[1523]: SpareActive event detected o=
n
> md device /dev/md0, component device /dev/sdd1
> Apr =A07 20:44:32 localhost kernel: [ 1297.147581] raid5: device sdd1
> operational as raid disk 0
> Apr =A07 20:44:32 localhost kernel: [ 1297.147585] raid5: device sdb1
> operational as raid disk 3
> Apr =A07 20:44:32 localhost kernel: [ 1297.147588] raid5: device sdf1
> operational as raid disk 4
> Apr =A07 20:44:32 localhost kernel: [ 1297.147591] raid5: device sde1
> operational as raid disk 2
> Apr =A07 20:44:32 localhost kernel: [ 1297.148102] raid5: allocated 5=
265kB for md0
> Apr =A07 20:44:32 localhost kernel: [ 1297.148704] 0: w=3D1 pa=3D0 pr=
=3D5 m=3D1
> a=3D2 r=3D5 op1=3D0 op2=3D0
> Apr =A07 20:44:32 localhost kernel: [ 1297.148708] 3: w=3D2 pa=3D0 pr=
=3D5 m=3D1
> a=3D2 r=3D5 op1=3D0 op2=3D0
> Apr =A07 20:44:32 localhost kernel: [ 1297.148712] 4: w=3D3 pa=3D0 pr=
=3D5 m=3D1
> a=3D2 r=3D5 op1=3D0 op2=3D0
> Apr =A07 20:44:32 localhost kernel: [ 1297.148715] 2: w=3D4 pa=3D0 pr=
=3D5 m=3D1
> a=3D2 r=3D5 op1=3D0 op2=3D0
> Apr =A07 20:44:32 localhost kernel: [ 1297.148718] raid5: raid level =
5
> set md0 active with 4 out of 5 devices, algorithm 2
> Apr =A07 20:44:32 localhost kernel: [ 1297.148722] RAID5 conf printou=
t:
> Apr =A07 20:44:32 localhost kernel: [ 1297.148725] =A0--- rd:5 wd:4
> Apr =A07 20:44:32 localhost kernel: [ 1297.148728] =A0disk 0, o:1, de=
v:sdd1
> Apr =A07 20:44:32 localhost kernel: [ 1297.148731] =A0disk 2, o:1, de=
v:sde1
> Apr =A07 20:44:32 localhost kernel: [ 1297.148734] =A0disk 3, o:1, de=
v:sdb1
> Apr =A07 20:44:32 localhost kernel: [ 1297.148737] =A0disk 4, o:1, de=
v:sdf1
> Apr =A07 20:44:32 localhost kernel: [ 1297.148779] md0: detected
> capacity change from 0 to 6001196531712
> Apr =A07 20:44:32 localhost kernel: [ 1297.149047] =A0md0:RAID5 conf =
printout:
> Apr =A07 20:44:32 localhost kernel: [ 1297.149559] =A0--- rd:5 wd:4
> Apr =A07 20:44:32 localhost kernel: [ 1297.149562] =A0disk 0, o:1, de=
v:sdd1
> Apr =A07 20:44:32 localhost kernel: [ 1297.149565] =A0disk 1, o:1, de=
v:sdc1
> Apr =A07 20:44:32 localhost kernel: [ 1297.149568] =A0disk 2, o:1, de=
v:sde1
> Apr =A07 20:44:32 localhost kernel: [ 1297.149570] =A0disk 3, o:1, de=
v:sdb1
> Apr =A07 20:44:32 localhost kernel: [ 1297.149573] =A0disk 4, o:1, de=
v:sdf1
> Apr =A07 20:44:32 localhost kernel: [ 1297.149846] md: recovery of RA=
ID array md0
> Apr =A07 20:44:32 localhost kernel: [ 1297.149849] md: minimum
> _guaranteed_ =A0speed: 1000 KB/sec/disk.
> Apr =A07 20:44:32 localhost kernel: [ 1297.149852] md: using maximum
> available idle IO bandwidth (but not more than 200000 KB/sec) for
> recovery.
> Apr =A07 20:44:32 localhost kernel: [ 1297.149858] md: using 128k
> window, over a total of 1465135872 blocks.
> Apr =A07 20:44:32 localhost kernel: [ 1297.188272] =A0unknown partiti=
on table
> Apr =A07 20:44:32 localhost mdadm[1523]: RebuildStarted event detecte=
d
> on md device /dev/md0
>=20
> I figured this was definitely wrong, since I still couldn't mount
> /dev/md0, so I manually failed sdc and sdd to stop any further
> destruction on my part and to go seek expert help, so here I am. Is m=
y
> data still there or have the first few hundred MB been zeroed to
> initialize a fresh array? how do I force mdadm to assume sdd is fresh
> and give me access to the array without any writes happening to it?
> Sorry to come running to the highest authority on linuxraid here, but
> all the howtos out there are pretty thin when it comes to anything
> more complicated than creating and array and recovering from one
> failed drive.

Well I wouldn't have failed the devices.  I would simply have stopped t=
he
array
  mdamd -S /dev/md0

But I'm very surprised that this didn't work.
md and mdadm never write zeros to initialise anything (Except a bitmap)=
=2E

Maybe the best thing to do at this point is post the output of
  mdadm -E /dev/sd[bcdef]1
and I'll see if I can make sense of it.

NeilBrown


>=20
> Any advice (even if it is just for doing the right thing the next
> time), is greatly appreciated.
>=20
> -Felix
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
