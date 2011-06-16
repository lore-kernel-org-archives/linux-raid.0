From: NeilBrown <neilb@suse.de>
Subject: Re: mark spare as active sync device?
Date: Thu, 16 Jun 2011 10:54:23 +1000
Message-ID: <20110616105423.6aefa0f1@notabene.brown>
References: <20110615121026.f689e4b2.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110615121026.f689e4b2.taeuber@bbaw.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lars =?ISO-8859-1?B?VOR1YmVy?= <taeuber@bbaw.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 15 Jun 2011 12:10:26 +0200 Lars T=E4uber <taeuber@bbaw.de> wrot=
e:

> Hi there,
>=20
> is it possible to mark a nearly completly synced device as active in =
sync?
>=20
> There was failing a device shortly before a spare drive was completel=
y
> synced. I want to get the directory structure from the device.
>=20
> md3 : active raid6 sdz[16] sdaf[13] sds[0] sdac[10] sdah[15] sdag[14]=
 sdae[12] sdad [11](F) sdab[9] sdaa[17](F) sdy[6] sdx[5] sdw[4] sdv[3] =
sdu[2] sdt[1]
>       27349202944 blocks level 6, 64k chunk, algorithm 2 [16/13] [UUU=
UUUU__UU_UUUU]
>       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.]  =
recovery =3D 98.3% (1921986020/1953514496) finish=3D25.9min speed=3D202=
44K/sec
>=20
> /dev/sdz was the device that was inserted and is now marked as spare.=
 Is it possible to mark sdz as active and in sync?

Not really.... and should you mark it as the in-sync member number 7, 8=
, or
11 ??

>=20
> Is there any chance to get data from this array?

Your best bet is to try to 'create' the array again using '--assume-cle=
an'
and putting the devices that you thing are working in the correct place=
=2E
e.g. something like:

 mdadm -S /dev/md3
 mdadm -C /dev/md3 --metadata=3D0.90 --level=3D6 --algorithm=3D2 --chun=
k=3D64 \
   --raid-devices=3D16  --assume-clean \
   /dev/sds /dev/sdt /dev/sdu /dev/sdv   \
   /dev/sdw /dev/sdx /dev/sdy /dev/sdz   \
   missing /dev/sdab /dev/sdac missing   \
   /dev/sdae /dev/sdaf /dev/sdag /dev/sdah

Then "fsck -n /dev/md3"  and see if it looks reasonably OK.
If it doesn't, try placing /dev/sdz in place of a different 'missing'.

Of course you should double check the order of devices that I have give=
n
here, and all the other details.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
