From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: RAID50 boot problems
Date: Wed, 24 Apr 2013 13:19:47 +0200 (CEST)
Message-ID: <1164635.0.1366802387038.JavaMail.root@zimbra>
References: <20130424165201.67cc9d1e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130424165201.67cc9d1e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid <linux-raid@vger.kernel.org>, Alexander Zvyagin <zvyagin.alexander@gmail.com>
List-Id: linux-raid.ids

> > > /lib/udev/rules.d/64-md-raid.rules is here
> > > http://paste.ubuntu.com/5592227/
> >
> > Bug tested positive also on Ubuntu Precise (12.04) and reported to
> > https://bugs.launchpad.net/ubuntu/+source/mdadm/+bug/1171945
>=20
> This will run "mdadm --incremental $tempnode" on any device for which
> ID_FS_TYPE is set to "linux_raid_member", which certainly seems
> reasonable.
>=20
> What does:
> udevadm info --query=3Dproperty --path=3D/dev/mdXXX | grep ID_FS_TYPE
>=20
> report for the raid5 arrays?

root@raidtest:~# udevadm info --query=3Dproperty --path=3D/dev/md0
device path not found
root@raidtest:~# udevadm info --query=3Dproperty --path=3D/dev/md1
device path not found

> Looking bug report I see that md0 and md1 have
> ID_FS_TYPE=3Dlinux_raid_member
>=20
> So that should be working.
>=20
> The fact that rootdelay=3D10 makes a difference suggests that it is
> successfully assembling the raid0, but just taking a bit too long.
> Maybe the script in the initrd needs "udevadm settle" just before it
> attempts
> to mount.
>=20
> Can you look inside the initrd and see if "udevadm settle" is used
> anywhere?

mdadm settle doesn't seem to be used there. I really don't know my way =
around the bootup scripts that well, so I'm unsure where to add it=E2=80=
=A6
--=20
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
