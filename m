From: Neil Brown <neilb@suse.de>
Subject: Re: problems with raid=noautodetect
Date: Tue, 23 May 2006 08:39:26 +1000
Message-ID: <17522.15774.526526.244768@cse.unsw.edu.au>
References: <4471B188.3060400@umit.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Florian Dazinger on Monday May 22
Sender: linux-raid-owner@vger.kernel.org
To: Florian Dazinger <florian.dazinger@umit.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 22, florian.dazinger@umit.at wrote:
> hi list,
> I read somewhere that it would be better not to rely on the=20
> autodetect-mechanism in the kernel at boot time, but rather to set up=
=20
> /etc/mdadm.conf accordingly and boot with raid=3Dnoautodetect. Well, =
I=20
> tried that :)
>=20
> I set up /etc/mdadm.conf for my 2 raid5 arrays:
>=20
> ---- snip ----
> # mountpoint: /home/media
> ARRAY  /dev/md0
>     level=3Draid5
>     UUID=3D86ed1434:43380717:4abf124e:970d843a
>     devices=3D/dev/sda1,/dev/sdb1,/dev/sdd3
>=20
> # mountpoint: /mnt/raid
> ARRAY  /dev/md1
>     level=3Draid5
>     UUID=3Dbaf59fb5:f4805e7a:91a77644:af3dde17
> #   devices=3D/dev/sda2,/dev/sdb2,/dev/sdd2
> ---- snap ----

Presumably you have a 'DEVICE' line in mdadm.conf too?  What is it.
My first guess is that it isn't listing /dev/sdd? somehow.

Otherwise, can you add a '-v' to the mdadm command that assembles the
array, and capture the output.  That might be helpful.

NeilBrown


>=20
> and rebooted with raid=3Dnoautodetect. It booted fine, but the 3rd di=
sks=20
> from each array (/dev/sdd2 and /dev/sdd3) were removed, so I had 2=20
> degraded raid5 arrays. It was possible to readd them with sth. like:
>=20
> mdadm /dev/md0 -a /dev/sdd3
> (synced and /proc/mdstat showed [UUU])
>=20
> but after the next reboot, the two partitions were again removed=20
> ([UU_])?! This was a reproducible error, I tried it several times wit=
h=20
> different /etc/mdadm.conf settings (ARRAY-statement with UUID=3D,=20
> devices=3D, UUID+devices, etc.).
>=20
> I=B4m now running autodetect again, all raid arrays are working fine,=
 but=20
> can anyone explain this strange behaviour?
> (kernel-2.6.16.14, amd64)
>=20
> thanks,
> florian
>=20
> PS: please cc me, as I=B4m not subscribed to the list
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
