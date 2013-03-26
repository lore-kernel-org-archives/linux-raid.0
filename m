From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Creating a RAID10 (near) for use in a CentOS 6 system
Date: Tue, 26 Mar 2013 21:21:22 +0100 (CET)
Message-ID: <17910863.12.1364329282837.JavaMail.root@zimbra>
References: <515089B1.9010607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <515089B1.9010607@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: maurice <mhilarius@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If you have 2x4TB and you want to setup the lot for booting and data, I=
'd recommend doing like the NAS boxes I've seen (well, only QNAP 410 II=
RC). On that one, they chose to create partitions for / and swap (and p=
erhaps /boot), and equal-ish partitions for those used for data. On tho=
se, you can place a RAID-10, or perhaps two RAID-1s and use LVM to stri=
pe them. The latter is far more flexible, as RAID-10 lacks most of the =
flexibility other RAID leverls have.

If you don't need the extra IOPS from the RAID-10, I'd recommend using =
RAID-6 instead for even futher safety and flexibility (the ability to c=
hange to RAID-5 in need of more space, easier to grow etc).

roy

----- Opprinnelig melding -----
> I come today, hat in hand, for some suggestions on a new install with
> RAID10.
>=20
> I wish to install CentOS 6 on a new system.
> I am using 4 identical drives, and do not see any need to partition
> them.
> They are 2TB Hitachi Ultrastar (enterprise)drives.
>=20
> I wish to use RAID10, near
>=20
> Questions:
> Syntax: Creating near vs far. Is there a specific syntax to use?
>=20
> I *think* this is what I need:
> mdadm --create /dev/md0 --run --level=3D10 --chunk=3D4 --raid-devices=
=3D4
> /dev/sda /dev/sdb /dev/sdc /dev/sdd
>=20
> Next question is about mdadm versions and kernels.
> CentOS 6 currently uses 2.6.32-358.2.1.el6
> Is there anything in that I should beware of?
>=20
> OTOH, one may get newer kernels by enabling elrepo
>=20
> http://elrepo.org/tiki/tiki-index.php
>=20
> This will get me up to:
> kernel-lt-3.0.70-1.el6.elrepo
> kernel-ml-3.8.4-1.el6.elrepo
>=20
> Is that desirable in this case?
>=20
> Any thoughts and suggestions are most welcome..
>=20
>=20
> --
> Cheers,
> Maurice Hilarius
> eMail: /mhilarius@gmail.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

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
