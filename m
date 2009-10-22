From: Stephane Bunel <stephane.bunel@forumdesimages.fr>
Subject: Re: mdadm --detail showing annoying device
Date: Thu, 22 Oct 2009 16:17:53 +0200
Message-ID: <4AE06991.5040000@forumdesimages.fr>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan> <alpine.DEB.2.00.0910181607040.27363@p34.internal.lan> <20091019030456.GS9464@discord.disaster> <alpine.DEB.2.00.0910190431180.23395@p34.internal.lan> <20091020003358.GW9464@discord.disaster> <alpine.DEB.2.00.0910200431290.21878@p34.internal.lan> <alpine.DEB.2.00.0910210618210.10288@p34.internal.lan> <4ADF17EC.6090606@forumdesimages.fr> <19167.33065.766493.889406@notabene.brown> <slrnhe0ggc.sn.Mario.Holbe@darkside.dyn.samba-tng.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <slrnhe0ggc.sn.Mario.Holbe@darkside.dyn.samba-tng.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mario 'BitKoenig' Holbe a =E9crit :
> Neil Brown <neilb@suse.de> wrote:
>> On Wednesday October 21, stephane.bunel@forumdesimages.fr wrote:
>>>         0       8        0        0      active sync   /dev/char/21=
:0
>>>         1       8       16        1      active sync   /dev/char/21=
:1
>> What is a block device doing in /dev/char ???  There should only be
>> character devices in there.
>=20
> major 21 are usually SCSI generic devices (/dev/sg) and they are char=
=2E..
> crw-rw----  1 root root  21, 0 Oct 10 21:48 /dev/sg0
> crw-rw----  1 root root  21, 1 Oct 10 21:48 /dev/sg1
>=20
> The question is, why do they appear at mdadm --detail

   mdadm performs a physical walk to not follow symbolic links (cf nftw=
(=20
=46TW_PHYS ) in map_dev() ). But using stat() mdadm finaly follow the s=
ymbolic=20
link and so returns the same type/major/minor as the targeted link.

   lstat() is identical to stat(), except that if path is a symbolic li=
nk,=20
then the link itself is stat-ed, not the file that it refers to.


#ls -la /dev/char/21:0
lrwxrwxrwx 1 root root 13 2009-10-16 18:12 /dev/char/21:0 -> ../raid_di=
sk0

Tested from Python:
 >>> import os, stat

Using stat:
 >>> mode =3D os.stat( '/dev/char/21:0' )[ stat.ST_MODE ]
 >>> stat.S_ISBLK( mode )
True

using lstat():
 >>> mode =3D os.lstat( '/dev/char/21:0' )[ stat.ST_MODE ]
 >>> stat.S_ISBLK( mode )
=46alse



St=E9phane Bunel.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
