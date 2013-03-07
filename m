From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Raid 5/10 discard support broken in 3.8.2
Date: Thu, 7 Mar 2013 19:26:17 +0100 (CET)
Message-ID: <6351179.18.1362680777332.JavaMail.root@zimbra>
References: <CAKHEz2bGDyb2=t5gVycfm9YJcUu9k9943JYQFxAtStwrjehUbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKHEz2bGDyb2=t5gVycfm9YJcUu9k9943JYQFxAtStwrjehUbg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Cundiff <syshackmin@gmail.com>
Cc: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > I'm not sure if TRIM/UNMAP is supported on that controller, even in
> > HBA mode (and with IT firmware). I've also seen scterc fail to work
> > on that controller as well, while working with an ordinary "stupid"
> > controller on the same disk.
> >
>=20
> I had heard that as well. I believe it may have been only older
> firmware or maybe just people trying to TRIM against a RAID. I'm
> running recent firmware and it appears to execute the command
> correctly against a single disk.
>=20
> [root@a2simage:etc]$ mkfs.ext4 /dev/sda3
> mke2fs 1.41.12 (17-May-2010)
> Discarding device blocks: ^C825792/54624256
>=20
>=20
> Mar 7 11:53:08 66 kernel: sd 0:0:0:0: [sda] Send:
> Mar 7 11:53:08 66 kernel: 0xffff8805edd86c80
> Mar 7 11:53:08 66 kernel: sd 0:0:0:0: [sda] CDB:
> Mar 7 11:53:08 66 kernel: Unmap/Read sub-channel: 42 00 00 00 00 00 0=
0
> 00 18 00
> Mar 7 11:53:08 66 kernel: buffer =3D 0xffff88062fe4a280, bufflen =3D =
24,
> queuecommand 0xffffffffa01d27e0

Could it be as simple as the controller trying to send UNMAP to an (S)A=
TA device? TRIM and UNMAP are different commands for ATA and SCSI, resp=
ectively.

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
