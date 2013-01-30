From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Persistent failures with simple md setup
Date: Wed, 30 Jan 2013 10:20:36 +0100 (CET)
Message-ID: <14351602.2.1359537635927.JavaMail.root@zimbra>
References: <1565063.1kpR7lz4Ph@xrated>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1565063.1kpR7lz4Ph@xrated>
Sender: linux-raid-owner@vger.kernel.org
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> ~# cat /proc/mdstat
> Personalities : [raid1] [raid0] [raid10] [raid6] [raid5] [raid4]
> md3 : active raid1 sda4[0]
> 869702736 blocks super 1.0 [2/1] [U_]
> bitmap: 57/415 pages [228KB], 1024KB chunk
>=20
> md0 : active raid1 sda1[0]
> 96376 blocks super 1.0 [2/1] [U_]
> bitmap: 1/6 pages [4KB], 8KB chunk
>=20
> md1 : active (auto-read-only) raid1 sdb2[1] sda2[0]
> 2096468 blocks super 1.0 [2/2] [UU]
> bitmap: 0/8 pages [0KB], 128KB chunk
>=20
> md124 : active raid1 sdb3[1] sda3[0]
> 104856180 blocks super 1.0 [2/2] [UU]
> bitmap: 8/200 pages [32KB], 256KB chunk
=2E..
> for this case, but the behavior which partition is affected is random=
,
> only md124 seems stable (the root fs). The strange md naming was the
> result of an upgrade installation. The device details are attached as
> well.
>=20
> It happens, that the active device even *switches* between boots,
> which
> is a perfect recipe for actually loosing data, hence this md doesn't
> raise data security, it is the reason for loosing them.
>=20
> Could some kind soul tell me, what's going on here?

This looks somewhat familiar. I had a similar issue after install Ubunt=
u 12.04 on my home server. IIRC udev/mdadm was out of sync, so that the=
 raid was started before all drives were ready. This was fixed around u=
buntu 12.04.1. But then again, since it finds some of the partitions, a=
nd not losing whole drives, this seems somewhat unlikely.

Vennlige hilsener / Best regards

roy
--
Roy Sigurd Karlsbakk
(+47) 98013356
roy@karlsbakk.net
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt.=
 Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5=
 eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilf=
eller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
