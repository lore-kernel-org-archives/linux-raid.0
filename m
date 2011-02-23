From: Claude Nobs <claudenobs@blunet.cc>
Subject: Re: Likely forced assemby with wrong disk during raid5 grow. Recoverable?
Date: Wed, 23 Feb 2011 01:56:13 +0100
Message-ID: <AANLkTimaemNqVwaLmqYCS+6fHCTVmAqzUe9RUh3rdhvc@mail.gmail.com>
References: <AANLkTikhOAXQ6JAG1fK3x9V3icki8cjn0_ggyQwkGmnt@mail.gmail.com>
 <AANLkTi=5UZcMRKHTiXC3w8joh-qyi50gtTYwRf_scksW@mail.gmail.com>
 <20110220162509.2eb85a03@notabene.brown> <AANLkTi=-guMf-8YJDMvq9ybyY9Fppi+W0pqhH2Of=mKd@mail.gmail.com>
 <20110221115303.4862e093@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110221115303.4862e093@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 21, 2011 at 01:53, NeilBrown <neilb@suse.de> wrote:
>
> When I say "Newer versions" I mean of mdadm, not the kernel.
>
> What does
> =C2=A0 mdadm -V
>
> show? =C2=A0Version 3.0 or later gives less confusing output for "mda=
dm --examine"
> on 1.x metadata.

mdadm - v2.6.7.1 - 15th October 2008
so yes the ubuntu mdadm seems to be a very old version indeed

> Yes, it probably is possible to re-assemble the array to include sdd1=
 and not
> have a degraded array, and still have all your data safe - providing =
you are
> sure that nothing at all changed on the array (e.g. maybe it was unmo=
unted?).
>
> I'm not sure I'd recommend it though.... =C2=A0I cannot see anything =
that would go
> wrong, but it is somewhat unknown territory.
> Up to you...
>
> If you:
>
> % git clone git://neil.brown.name/mdadm master
> % cd mdadm
> % make
> % sudo bash
> # ./mdadm -S /dev/md2
> # ./mdadm -Afvv /dev/md2 /dev/sda1 /dev/md0 /dev/md1 /dev/sdc1
>
> It should restart your array - degraded - and repeat the last stages =
of
> reshape just in case.
>
> Alternately, before you run 'make' you could edit Assemble.c, find:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0while (force && !enough(content->array.lev=
el, content->array.raid_disks,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0content->array.layout, 1,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0avail, okcnt)) {
>
> around line 818, and change the '1,' to '0,', then run make, mdadm -S=
, and
> then
> # ./mdadm -Afvv /dev/md2 /dev/sda1 /dev/md0 /dev/md1 /dev/sdc1 /dev/s=
dd1
>
> it should assemble the array non-degraded and repeat all of the resha=
pe since
> sdd1 fell out of the array.
>
> As you have a backup, this is probably safe because even if to goes b=
ad you
> can restore from backups - not that I expect it to go bad but ....

I tried to recreate the scenario so i could test both versions first
but i just could not recreate this step (resp. it's result (different
reshape posn on the last 3+1 drives)) :

bernstein@server:~$ sudo mdadm --assemble --run /dev/md2 /dev/md0
/dev/sda1 /dev/sdc1 /dev/sdd1
mdadm: Could not open /dev/sda1 for write - cannot Assemble array.
mdadm: Failed to restore critical section for reshape, sorry.

which i think lead to the inconsistent state. all i got was :

$ sudo mdadm --create /dev/md4 --level raid5 --metadata=3D1.2
--raid-devices=3D4 /dev/sde[5678]
$ sudo mkfs.ext4 /dev/md4
$ sudo mdadm --add /dev/md4 /dev/sde9
$ sudo mdadm --grow --raid-devices 5 /dev/md4
$ sudo mdadm /dev/md4 --fail /dev/sde9
$ sudo umount /dev/md4 && sudo mdadm -S /dev/md4
$ sudo reboot
$ sudo mdadm -S /dev/md4
$ sudo mdadm --assemble --run /dev/md4 /dev/sde[6789]
mdadm: failed to RUN_ARRAY /dev/md4: Input/output error
mdadm: Not enough devices to start the array.
$ sudo mdadm --examine /dev/sde[56789]
/dev/sde5:
=C2=A0 Reshape pos'n : 126720 (123.77 MiB 129.76 MB)
=C2=A0 Delta Devices : 1 (4->5)
=C2=A0=C2=A0=C2=A0 Update Time : Tue Feb 22 23:52:56 2011
=C2=A0=C2=A0=C2=A0 Array Slot : 0 (0, 1, 2, failed, failed, failed)
=C2=A0=C2=A0 Array State : Uuu__ 3 failed
/dev/sde6:
=C2=A0 Reshape pos'n : 126720 (123.77 MiB 129.76 MB)
=C2=A0 Delta Devices : 1 (4->5)
=C2=A0=C2=A0=C2=A0 Update Time : Tue Feb 22 23:52:56 2011
=C2=A0=C2=A0=C2=A0 Array Slot : 1 (0, 1, 2, failed, failed, failed)
=C2=A0=C2=A0 Array State : uUu__ 3 failed
/dev/sde7:
=C2=A0 Reshape pos'n : 126720 (123.77 MiB 129.76 MB)
=C2=A0 Delta Devices : 1 (4->5)
=C2=A0=C2=A0=C2=A0 Update Time : Tue Feb 22 23:52:56 2011
=C2=A0=C2=A0=C2=A0 Array Slot : 2 (0, 1, 2, failed, failed, failed)
=C2=A0=C2=A0 Array State : uuU__ 3 failed
/dev/sde8:
=C2=A0 Reshape pos'n : 126720 (123.77 MiB 129.76 MB)
=C2=A0 Delta Devices : 1 (4->5)
=C2=A0=C2=A0=C2=A0 Update Time : Tue Feb 22 23:52:15 2011
=C2=A0=C2=A0=C2=A0 Array Slot : 4 (0, 1, 2, failed, 3, failed)
=C2=A0=C2=A0 Array State : uuuU_ 2 failed
/dev/sde9:
=C2=A0 Reshape pos'n : 54016 (52.76 MiB 55.31 MB)
=C2=A0 Delta Devices : 1 (4->5)
=C2=A0=C2=A0=C2=A0 Update Time : Tue Feb 22 23:52:11 2011
=C2=A0=C2=A0=C2=A0 Array Slot : 5 (0, 1, 2, failed, 3, 4)
=C2=A0=C2=A0 Array State : uuuuU 1 failed

which got instantly correctly reshaped by the freshly compiled
version. without any more real testing, i chose the safer way and went
ahead on the real array :

bernstein@server:~/mdadm$ sudo ./mdadm -Afvv /dev/md2 /dev/sda1
/dev/md0 /dev/md1 /dev/sdc1
mdadm: looking for devices for /dev/md2
mdadm: /dev/sda1 is identified as a member of /dev/md2, slot 4.
mdadm: /dev/md0 is identified as a member of /dev/md2, slot 3.
mdadm: /dev/md1 is identified as a member of /dev/md2, slot 2.
mdadm: /dev/sdc1 is identified as a member of /dev/md2, slot 0.
mdadm: forcing event count in /dev/md1(2) from 133603 upto 133609
mdadm: Cannot open /dev/sdc1: Device or resource busy
bernstein@server:~/mdadm$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md2 : active raid5 md1[3] md0[4] sda1[5] sdc1[0]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2930281920 blocks super 1.2 level 5, 64k=
 chunk, algorithm 2 [5/4] [U_UUU]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [=3D=3D>..................]=C2=A0 reshap=
e =3D 12.8% (125839952/976760640)
finish=3D825.1min speed=3D17186K/sec

md1 : active raid0 sdg1[1] sdf1[0]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 976770944 blocks super 1.2 64k chunks

md0 : active raid0 sdh1[0] sdb1[1]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 976770944 blocks super 1.2 64k chunks

unused devices: <none>

reshape is in progress and is looking good to complete overnight.
although i am a little scared about the "mdadm: forcing event count in
/dev/md1(2) from 133603 upto 133609" and the "device busy" line. is
this the way it's supposed to be? i assumed that when it's repeating
all the reshape it would be like : forcing event count in /dev/sda1,
md0, sdc1 from 133609 downto 133603...

this i not strictly a raid/mdadm question, but do you know a simple
way to ckeck everything went ok? i think that an e2fsck (ext4 fs) and
checksumming some random files located behind the interruption point
should verify all went ok. plus just to be sure i'd like to check
files located at the interruption point. is the offset to the
interruption point into the md device simply the reshape pos'n (e.g.
502815488K) ?

> All part of the service... :-)

Well then, great service!
Thanks a lot.

Claude
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
