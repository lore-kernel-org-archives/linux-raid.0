From: Neil Brown <neilb@suse.de>
Subject: Re: sdc1 does not have a valid v0.90 superblock, not importing!
Date: Thu, 12 Aug 2010 08:56:33 +1000
Message-ID: <20100812085633.4b9d377b@notabene>
References: <275171.86984.qm@web51303.mail.re2.yahoo.com>
	<4C631DC9.5090004@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C631DC9.5090004@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: st0ff@npl.de
Cc: stefan.huebner@stud.tu-ilmenau.de, Jon@eHardcastle.com, Jon Hardcastle <jd_hardcastle@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 12 Aug 2010 00:01:45 +0200
Stefan /*St0fF*/ H=C3=BCbner <stefan.huebner@stud.tu-ilmenau.de> wrote:

> I had exactly the same problem this week with a costumer raid.  Solve=
d
> it via:
> - calculate the hardware block where the Superblock resides
> - dd if=3D/dev/sdXY of=3Dsuperblock seek=3Dblock_of_superblock bs=3D5=
12
> - hexedit superblock checksum
> - dd of=3D/dev/sdXY if=3Dsuperblock skip=3Dblock_of_superblock bs=3D5=
12
>=20
> this is not the correct way to go.  But noticing that only ONE BIT wa=
s
> skipped in the checksum, but all the other EXAMINE-information seemed
> right, I thought it's the only way to go to get ahold of the data on =
the
> array.

I hope you realise that if one bit is wrong in the checksum, it means t=
here
is a very good chance that one bit is wrong somewhere else in the super=
block.

Maybe this was a bit that was ignored.  Or maybe not.

I guess if you checked the output of --examine very thoroughly you shou=
ld be
safe, but it is worth remembers that the checksum just shows the corrup=
tion,
it probably isn't the source of the corruption.

NeilBrown


>=20
> hope it helps,
> Stefan
>=20
>=20
> Am 10.08.2010 23:35, schrieb Jon Hardcastle:
> > Help!
> >=20
> > Long story short - I was watching a movie off my RAID6 array. Got a=
 smart error warning=20
> >=20
> > 'Device: /dev/sdc [SAT], ATA error count increased from 30 to 31'
> >=20
> > I went to investigate and found:
> >=20
> > Error 31 occurred at disk power-on lifetime: 8461 hours (352 days +=
 13=20
> > hours)
> >=20
> >   When the command that caused the error occurred, the device was a=
ctive
> >  or idle.
> >=20
> >=20
> >=20
> >   After command completion occurred, registers were:
> >=20
> >   ER ST SC SN CL CH DH
> >=20
> >   -- -- -- -- -- -- --
> >=20
> >   84 51 28 50 bd 49 47
> >=20
> >=20
> >=20
> >   Commands leading to the command that caused the error were:
> >=20
> >   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
> >=20
> >   -- -- -- -- -- -- -- --  ----------------  --------------------
> >=20
> >   61 38 08 3f bd 49 40 08      00:38:33.100  WRITE FPDMA QUEUED
> >=20
> >   61 08 00 7f bd 49 40 08      00:38:33.100  WRITE FPDMA QUEUED
> >=20
> >   61 08 00 97 bd 49 40 08      00:38:33.000  WRITE FPDMA QUEUED
> >=20
> >   ea 00 00 00 00 00 a0 08      00:38:33.000  FLUSH CACHE EXT
> >=20
> >   61 08 00 bf 4b 38 40 08      00:38:33.000  WRITE FPDMA QUEUED
> >=20
> > I then emailed myself some error logs and shut the machine down. Th=
is drive has caused me problems before - the last time when the cat kno=
cked the computer over and dislodged the controller card. But several e=
cho "check" sync_action later and several weeks I have not had a peep o=
ut of it.
> >=20
> > ANYWAYS. after the reboot the array wont assemble (is that normal?)
> >=20
> > Aug 10 22:00:07 mangalore kernel: md: running:=20
> > <sdg1><sdf1><sde1><sdd1><sdb1> <sda1>
> >=20
> > Aug 10 22:00:07 mangalore kernel: raid5: md4 is not clean -- starti=
ng=20
> > background reconstruction
> >=20
> > Aug 10 22:00:07 mangalore kernel: raid5: device sdg1 operational as=
 raid
> >  disk 0
> >=20
> > Aug 10 22:00:07 mangalore kernel: raid5: device sdf1 operational as=
 raid
> >  disk 6
> >=20
> > Aug 10 22:00:07 mangalore kernel: raid5: device sde1 operational as=
 raid
> >  disk 2
> >=20
> > Aug 10 22:00:07 mangalore kernel: raid5: device sdd1 operational as=
 raid
> >  disk 4
> >=20
> > Aug 10 22:00:07 mangalore kernel: raid5: device sdb1 operational as=
 raid
> >  disk 5
> >=20
> > Aug 10 22:00:07 mangalore kernel: raid5: device sda1 operational as=
 raid
> >  disk 1
> >=20
> > Aug 10 22:00:07 mangalore kernel: raid5: allocated 7343kB for md4
> >=20
> > Aug 10 22:00:07 mangalore kernel: 0: w=3D1 pa=3D0 pr=3D7 m=3D2 a=3D=
2 r=3D7 op1=3D0=20
> > op2=3D0
> >=20
> > Aug 10 22:00:07 mangalore kernel: 6: w=3D2 pa=3D0 pr=3D7 m=3D2 a=3D=
2 r=3D7 op1=3D0=20
> > op2=3D0
> >=20
> > Aug 10 22:00:07 mangalore kernel: 2: w=3D3 pa=3D0 pr=3D7 m=3D2 a=3D=
2 r=3D7 op1=3D0=20
> > op2=3D0
> >=20
> > Aug 10 22:00:07 mangalore kernel: 4: w=3D4 pa=3D0 pr=3D7 m=3D2 a=3D=
2 r=3D7 op1=3D0=20
> > op2=3D0
> >=20
> > Aug 10 22:00:07 mangalore kernel: 5: w=3D5 pa=3D0 pr=3D7 m=3D2 a=3D=
2 r=3D7 op1=3D0=20
> > op2=3D0
> >=20
> > Aug 10 22:00:07 mangalore kernel: 1: w=3D6 pa=3D0 pr=3D7 m=3D2 a=3D=
2 r=3D7 op1=3D0=20
> > op2=3D0
> >=20
> > Aug 10 22:00:07 mangalore kernel: raid5: cannot start dirty degrade=
d=20
> > array for md4
> >=20
> > Aug 10 22:00:07 mangalore kernel: RAID5 conf printout:
> >=20
> > Aug 10 22:00:07 mangalore kernel: --- rd:7 wd:6
> >=20
> > Aug 10 22:00:07 mangalore kernel: disk 0, o:1, dev:sdg1
> >=20
> > Aug 10 22:00:07 mangalore kernel: disk 1, o:1, dev:sda1
> >=20
> > Aug 10 22:00:07 mangalore kernel: disk 2, o:1, dev:sde1
> >=20
> > Aug 10 22:00:07 mangalore kernel: disk 4, o:1, dev:sdd1
> >=20
> > Aug 10 22:00:07 mangalore kernel: disk 5, o:1, dev:sdb1
> >=20
> > Aug 10 22:00:07 mangalore kernel: disk 6, o:1, dev:sdf1
> >=20
> > Aug 10 22:00:07 mangalore kernel: raid5: failed to run raid set md4
> >=20
> > Aug 10 22:00:07 mangalore kernel: md: pers->run() failed ...
> >=20
> > Aug 10 22:00:07 mangalore kernel: md: do_md_run() returned -5
> >=20
> > Aug 10 22:00:07 mangalore kernel: md: md4 stopped.
> >=20
> > It appears sdc has an invalid superblock?=20
> >=20
> > This is the 'examine' from sdc1 (note the checksum)
> >=20
> > /dev/sdc1:
> >=20
> >           Magic : a92b4efc
> >=20
> >         Version : 0.90.00
> >=20
> >            UUID : 7438efd1:9e6ca2b5:d6b88274: 7003b1d3
> >=20
> >   Creation Time : Thu Oct 11 00:01:49 2007
> >=20
> >      Raid Level : raid6
> >=20
> >   Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
> >=20
> >      Array Size : 2441919680 (2328.80 GiB 2500.53 GB)
> >=20
> >    Raid Devices : 7
> >=20
> >   Total Devices : 7
> >=20
> > Preferred Minor : 4
> >=20
> >=20
> >=20
> >     Update Time : Tue Aug 10 21:39:49 2010
> >=20
> >           State : active
> >=20
> >  Active Devices : 7
> >=20
> > Working Devices : 7
> >=20
> >  Failed Devices : 0
> >=20
> >   Spare Devices : 0
> >=20
> >        Checksum : b335b4e3 - expected b735b4e3
> >=20
> >          Events : 1860555
> >=20
> >=20
> >=20
> >          Layout : left-symmetric
> >=20
> >      Chunk Size : 64K
> >=20
> >=20
> >=20
> >       Number   Major   Minor   RaidDevice State
> >=20
> > this     3       8       33        3      active sync   /dev/sdc1
> >=20
> >=20
> >=20
> >    0     0       8       97        0      active sync   /dev/sdg1
> >=20
> >    1     1       8        1        1      active sync   /dev/sda1
> >=20
> >    2     2       8       65        2      active sync   /dev/sde1
> >=20
> >    3     3       8       33        3      active sync   /dev/sdc1
> >=20
> >    4     4       8       49        4      active sync   /dev/sdd1
> >=20
> >    5     5       8       17        5      active sync   /dev/sdb1
> >=20
> >    6     6       8       81        6      active sync   /dev/sdf1
> > Anyways... I am ASSUMING mdadm has not assembled the array to be on=
 the safe side? i have not done anything.. no force... no assume clean.=
=2E I wanted to be sure?
> >=20
> > Should i remove sdc1 from the array? It should then assemble? I hav=
e 2 spare drives that I am getting around to using to replace this driv=
e and the other 500GB.. so should I remove sdc1... and try and re-add o=
r just put the new drive in?
> >=20
> > atm I have 'stop'ped the array and got badblocks running....
> >=20
> >=20
> >      =20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
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
