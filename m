From: Jim Paris <jim@jtan.com>
Subject: Re: Call for RAID-6 users
Date: Fri, 30 Jul 2004 15:39:38 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040730193938.GA5760@jim.sh>
References: <cds76e$ee7$1@terminus.zytor.com> <20040726213811.GA17363@jim.sh> <cedr7a$s2$1@terminus.zytor.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cedr7a$s2$1@terminus.zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> I haven't seen any of those messages, so this is the first case
> happening.

I figured you were just busy, but wanted to see if anyone else could
guide my debugging before my boss made me give up and do RAID-5 :)
Thanks for the reply.

> Can you create failures by creating a full array and then fail out
> drives?  That would rule out problems with the way mdadm creates the
> array.

Yes, same problem.  If I create a full array with 6 devices, wait for
it to finish the synchronizing, then fail the first drive, I see the
same corruption.  See attached r6test-full.sh to demonstrate.

> My current guess based on what I've seen so far is that it's a bug
> in mdadm in creating arrays with exactly 1 missing drive, as opposed
> to a kernel bug.

FWIW, this does occur with an array created with 2 missing drives, as
well.

-jim

--qDbXVdCdHGoSgWSk
Content-Type: application/x-sh
Content-Disposition: attachment; filename="r6test-full.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A=0A# Needs 600 megs of space, plus /dev/loop[1-6] and /dev/md=
6 free=0A=0Aset -e=0A=0Aif [ `id -u` !=3D 0 ] ; then=0A    echo run this as=
 root=0A    exit 1=0Afi=0A=0Aumount /dev/md6 || true=0Amdadm -S /dev/md6 ||=
 true=0Afor i in `seq 1 6` ; do=0A    losetup -d /dev/loop$i || true=0A    =
dd if=3D/dev/zero of=3Ddisk$i bs=3D1M count=3D100=0A    losetup /dev/loop$i=
 disk$i=0Adone=0A=0Amdadm -C /dev/md6 -l 6 -c 128 -n 6 /dev/loop[1-6]=0Awhi=
le ! grep resync /proc/mdstat ; do sleep 1 ; done=0Awhile grep resync /proc=
/mdstat ; do sleep 5 ; done=0Amdadm /dev/md6 -f /dev/loop1=0A=0Amkreiserfs =
-ff /dev/md6=0Amkdir -p mnttmp/=0Amount /dev/md6 mnttmp/=0Add if=3D/dev/zer=
o of=3Dbigfile bs=3D1M count=3D300=0Acp bigfile mnttmp/=0Aumount mnttmp/=0A=
mount /dev/md6 mnttmp/=0A=0Aecho The following md5sums should both equal=0A=
echo 0d97a9cd8bbd7ce75a2a76bb06258915:=0Amd5sum bigfile mnttmp/bigfile=0A=
=0A# uncomment to leave the setup in place=0A#exit 0=0A=0Aumount /dev/md6=
=0Amdadm -S /dev/md6=0Afor i in `seq 1 6` ; do=0A    losetup -d /dev/loop$i=
=0Adone=0Arm disk[1-6] bigfile=0Armdir mnttmp/ || true=0A
--qDbXVdCdHGoSgWSk--
