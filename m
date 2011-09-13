From: Andriano <chief000@gmail.com>
Subject: Re: RAID6 issues
Date: Tue, 13 Sep 2011 17:51:56 +1000
Message-ID: <CAGZH0-f+e80W36VMZMHrTakTxUHO2nppO9xHSTmHh6QV_Mo2Fg@mail.gmail.com>
References: <CAGZH0-dz9y5=vH7PQr8VRy15i1WsuAxKjPPpmx8-1UqCaJnRxg@mail.gmail.com>
	<20110913082511.3c34dec9@notabene.brown>
	<CAGZH0-fEU+NTdAF1AWcU6SnyBPYgd51zjizaiZT_toV=k4EDFg@mail.gmail.com>
	<20110913084419.380babcc@notabene.brown>
	<CAGZH0-fRTkKOL8ofLbChmNH3fuiYwHkC0LAv1-VVyb22O7UnwA@mail.gmail.com>
	<20110913093850.606efa70@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110913093850.606efa70@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 13, 2011 at 5:38 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 13 Sep 2011 17:05:06 +1000 Andriano <chief000@gmail.com> wrot=
e:
>
>> On Tue, Sep 13, 2011 at 4:44 PM, NeilBrown <neilb@suse.de> wrote:
>> > On Tue, 13 Sep 2011 16:33:36 +1000 Andriano <chief000@gmail.com> w=
rote:
>> >
>> >> >
>> >> >> Hello Linux-RAID mailing list,
>> >> >>
>> >> >> I have an issue with my RAID6 array.
>> >> >> Here goes a short description of the system:
>> >> >>
>> >> >> opensuse 11.4
>> >> >> Linux 3.0.4-2-desktop #1 SMP PREEMPT Wed Aug 31 09:30:44 UTC 2=
011
>> >> >> (a432f18) x86_64 x86_64 x86_64 GNU/Linux
>> >> >> Gigabyte EP35C-DS3 motherboard with 8 SATA ports + SuperMicro
>> >> >> AOC-SASLP-MV8 based on Marvel 6480, firmware updated to 3.1.0.=
21
>> >> >> running mdadm 3.2.2, single array consists of 10 2T disks, 8 o=
f them
>> >> >> connected to the HBA, 2 - motherboard ports
>> >> >>
>> >> >> I had some issues with one of the onboard connected disks, so =
tried to
>> >> >> plug it to different ports, just to eliminate possibly faulty =
port.
>> >> >> After reboot, suddenly other drives got kicked out from the ar=
ray.
>> >> >> Re-assembling them gives weird errors.
>> >> >>
>> >> >> --- some output ---
>> >> >> [3:0:0:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST2000DL003-9VT1 C=
C32 =A0/dev/sdb
>> >> >> [5:0:0:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST2000DL003-9VT1 C=
C32 =A0/dev/sdc
>> >> >> [8:0:0:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST32000542AS =A0 =A0=
 CC34 =A0/dev/sdd
>> >> >> [8:0:1:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST32000542AS =A0 =A0=
 CC34 =A0/dev/sde
>> >> >> [8:0:2:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST32000542AS =A0 =A0=
 CC34 =A0/dev/sdf
>> >> >> [8:0:3:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST32000542AS =A0 =A0=
 CC34 =A0/dev/sdg
>> >> >> [8:0:4:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST32000542AS =A0 =A0=
 CC34 =A0/dev/sdh
>> >> >> [8:0:5:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST2000DL003-9VT1 C=
C32 =A0/dev/sdi
>> >> >> [8:0:6:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST2000DL003-9VT1 C=
C32 =A0/dev/sdj
>> >> >> [8:0:7:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST2000DL003-9VT1 C=
C32 =A0/dev/sdk
>> >> >>
>> >> >> #more /etc/mdadm.conf
>> >> >> DEVICE partitions
>> >> >> ARRAY /dev/md0 level=3Draid6 UUID=3D82ac7386:a854194d:81b795d1=
:76c9c9ff
>> >> >>
>> >> >> #mdadm --assemble --force --scan /dev/md0
>> >> >> mdadm: failed to add /dev/sdc to /dev/md0: Invalid argument
>> >> >> mdadm: failed to add /dev/sdb to /dev/md0: Invalid argument
>> >> >> mdadm: failed to add /dev/sdh to /dev/md0: Invalid argument
>> >> >> mdadm: /dev/md0 assembled from 7 drives - not enough to start =
the array.
>> >> >>
>> >> >> dmesg:
>> >> >> [ 8215.651860] md: sdc does not have a valid v1.2 superblock, =
not importing!
>> >> >> [ 8215.651865] md: md_import_device returned -22
>> >> >> [ 8215.652384] md: sdb does not have a valid v1.2 superblock, =
not importing!
>> >> >> [ 8215.652388] md: md_import_device returned -22
>> >> >> [ 8215.653177] md: sdh does not have a valid v1.2 superblock, =
not importing!
>> >> >> [ 8215.653182] md: md_import_device returned -22
>> >> >>
>> >> >> mdadm -E /dev/sd[b..k] gives exactly the same Magic number and=
 Array
>> >> >> UUID for every disk, all checksums are correct,
>> >> >> the only difference is - =A0Avail Dev Size : 3907028896 is the=
 same for
>> >> >> 9 disks, and 3907028864 for sdc
>> >> >
>> >> > Please provide that output so we can see it too - it might be h=
elpful.
>> >> >
>> >> > NeilBrown
>> >>
>> >>
>> >> # mdadm --assemble --force --update summaries /dev/md0 /dev/sdc
>> >> mdadm: --update=3Dsummaries not understood for 1.x metadata
>> >>
>> >
>> > Sorry - I was too terse.
>> >
>> > I meant that output of "mdadm -E ...."
>> >
>> > NeilBrown
>> >
>> >
>> >>
>> >> >
>> >> >>
>> >> >> mdadm --assemble --force --update summaries /dev/sd.. - didn't=
 improve anything
>> >> >>
>> >> >>
>> >> >> I would really appreciate if someone could point me to the rig=
ht direction.
>> >> >>
>> >> >> thanks
>> >> >>
>> >> >> Andrew
>> >> >> --
>> >> >> To unsubscribe from this list: send the line "unsubscribe linu=
x-raid" in
>> >> >> the body of a message to majordomo@vger.kernel.org
>> >> >> More majordomo info at =A0http://vger.kernel.org/majordomo-inf=
o.html
>> >> >
>> >> >
>> >
>> >
>>
>> /dev/sdb:
>> =A0 =A0 =A0 =A0 =A0 Magic : a92b4efc
>> =A0 =A0 =A0 =A0 Version : 1.2
>> =A0 =A0 Feature Map : 0x0
>> =A0 =A0 =A0Array UUID : 82ac7386:a854194d:81b795d1:76c9c9ff
>> =A0 =A0 =A0 =A0 =A0 =A0Name : hnas:0 =A0(local to host hnas)
>> =A0 Creation Time : Wed Jan 19 21:17:33 2011
>> =A0 =A0 =A0Raid Level : raid6
>> =A0 =A0Raid Devices : 10
>>
>> =A0Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
>> =A0 =A0 =A0Array Size : 31256230912 (14904.13 GiB 16003.19 GB)
>> =A0 Used Dev Size : 3907028864 (1863.02 GiB 2000.40 GB)
>> =A0 =A0 Data Offset : 272 sectors
>> =A0 =A0Super Offset : 8 sectors
>> =A0 =A0 =A0 =A0 =A0 State : active
>> =A0 =A0 Device UUID : 4b31edb8:531a4c14:50c954a2:8eda453b
>>
>> =A0 =A0 Update Time : Mon Sep 12 22:36:35 2011
>> =A0 =A0 =A0 =A0Checksum : 205f92e1 - correct
>> =A0 =A0 =A0 =A0 =A0Events : 6446662
>>
>> =A0 =A0 =A0 =A0 =A0Layout : left-symmetric
>> =A0 =A0 =A0Chunk Size : 64K
>>
>> =A0 =A0Device Role : Active device 6
>> =A0 =A0Array State : AAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng)
>> /dev/sdc:
>> =A0 =A0 =A0 =A0 =A0 Magic : a92b4efc
>> =A0 =A0 =A0 =A0 Version : 1.2
>> =A0 =A0 Feature Map : 0x0
>> =A0 =A0 =A0Array UUID : 82ac7386:a854194d:81b795d1:76c9c9ff
>> =A0 =A0 =A0 =A0 =A0 =A0Name : hnas:0 =A0(local to host hnas)
>> =A0 Creation Time : Wed Jan 19 21:17:33 2011
>> =A0 =A0 =A0Raid Level : raid6
>> =A0 =A0Raid Devices : 10
>>
>> =A0Avail Dev Size : 3907028864 (1863.02 GiB 2000.40 GB)
>> =A0 =A0 =A0Array Size : 31256230912 (14904.13 GiB 16003.19 GB)
>> =A0 =A0 Data Offset : 304 sectors
>> =A0 =A0Super Offset : 8 sectors
>> =A0 =A0 =A0 =A0 =A0 State : clean
>> =A0 =A0 Device UUID : afa2f348:88bd0376:29bcfe96:df32a522
>>
>> =A0 =A0 Update Time : Tue Sep 13 11:50:18 2011
>> =A0 =A0 =A0 =A0Checksum : ee1facae - correct
>> =A0 =A0 =A0 =A0 =A0Events : 6446662
>>
>> =A0 =A0 =A0 =A0 =A0Layout : left-symmetric
>> =A0 =A0 =A0Chunk Size : 64K
>>
>> =A0 =A0Device Role : Active device 5
>> =A0 =A0Array State : AAAAAA.AAA ('A' =3D=3D active, '.' =3D=3D missi=
ng)
> (snip)
>
> Thanks.
>
> The only explanation I can come up with is that the devices appear to=
 be
> smaller for some reason.
> Can you run
> =A0blockdev --getsz /dev/sd?
>
> and report the result?
> They should all be 3907029168 (Data Offset + Avail Dev Size).
> If any are smaller - that is the problem.
>
> NeilBrown
>
>

Apparently you're right
blockdev --getsz /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg
/dev/sdh /dev/sdi /dev/sdj /dev/sdk
3907027055
3907027055
3907029168
3907029168
3907029168
3907029168
3907027055
3907029168
3907029168
3907029168

sdb, sdc and sdh - are smaller and they are problem disks

So what would be a solution to fix this issue?

thanks
Andrew
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
