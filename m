From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: mark spare as active sync device?
Date: Thu, 16 Jun 2011 11:29:05 +0200
Message-ID: <20110616112905.a1e14f26.taeuber@bbaw.de>
References: <20110615121026.f689e4b2.taeuber@bbaw.de>
	<20110616105423.6aefa0f1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110616105423.6aefa0f1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello NeilBrown,

thank you really very much. You saved my day.

Am Thu, 16 Jun 2011 10:54:23 +1000
NeilBrown <neilb@suse.de> schrieb:

> On Wed, 15 Jun 2011 12:10:26 +0200 Lars T=C3=A4uber <taeuber@bbaw.de>=
 wrote:
>=20
> > Hi there,
> >=20
> > is it possible to mark a nearly completly synced device as active i=
n sync?
> >=20
> > There was failing a device shortly before a spare drive was complet=
ely
> > synced. I want to get the directory structure from the device.
> >=20
> > md3 : active raid6 sdz[16] sdaf[13] sds[0] sdac[10] sdah[15] sdag[1=
4] sdae
> > [12] sdad [11](F) sdab[9] sdaa[17](F) sdy[6] sdx[5] sdw[4] sdv[3] s=
du[2]
> > sdt[1] 27349202944 blocks level 6, 64k chunk, algorithm 2 [16/13]
> > [UUUUUUU__UU_UUUU] [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D>.]  recovery =3D 98.3%
> > (1921986020/1953514496) finish=3D25.9min speed=3D20244K/sec
> >=20
> > /dev/sdz was the device that was inserted and is now marked as spar=
e. Is
> > it possible to mark sdz as active and in sync?
>=20
> Not really.... and should you mark it as the in-sync member number 7,=
 8, or
> 11 ??

I can reconstruct the member number of sdz from the previous failure ma=
ils
from mdadm. What a nice feature!

> >=20
> > Is there any chance to get data from this array?
>=20
> Your best bet is to try to 'create' the array again using '--assume-c=
lean'
> and putting the devices that you thing are working in the correct pla=
ce.
> e.g. something like:
>=20
>  mdadm -S /dev/md3
>  mdadm -C /dev/md3 --metadata=3D0.90 --level=3D6 --algorithm=3D2 --ch=
unk=3D64 \
>    --raid-devices=3D16  --assume-clean \
>    /dev/sds /dev/sdt /dev/sdu /dev/sdv   \
>    /dev/sdw /dev/sdx /dev/sdy /dev/sdz   \
>    missing /dev/sdab /dev/sdac missing   \
>    /dev/sdae /dev/sdaf /dev/sdag /dev/sdah

This was the very right command line except for the algorithm option. T=
his is
not available in my version.

> Then "fsck -n /dev/md3"  and see if it looks reasonably OK.
> If it doesn't, try placing /dev/sdz in place of a different 'missing'=
=2E
>=20
> Of course you should double check the order of devices that I have gi=
ven
> here, and all the other details.

Of course!

> NeilBrown

Thanks again for your help and your great tool!
Lars
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
