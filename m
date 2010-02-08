From: Neil Brown <neilb@suse.de>
Subject: Re: recovery problems, might be driver-related
Date: Mon, 8 Feb 2010 16:52:00 +1100
Message-ID: <20100208165200.3758520a@notabene.brown>
References: <4B6EC24A.9040703@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B6EC24A.9040703@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: stefan.huebner@stud.tu-ilmenau.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 07 Feb 2010 14:38:18 +0100
Stefan H=C3=BCbner <stefan.huebner@stud.tu-ilmenau.de> wrote:

> Hi Everybody,
>=20
> I've recently come across some RAID-Recovery problem that were kind o=
f
> not-so-easy-to-understand.  I was trying to recover damaged RAID5s,
> where one
> disk died and another dropped out (most likely due to read error reco=
very
> timeout / not reporting back while error recovery was active) during
> resync with
> a spare/new disk.  After taking double backups I tried to recreate th=
e
> raid with
> the needed working disk images (to make the superblocks consistent). =
 During
> that action mdadm told me that the last-dropped disk contained a vali=
d ext3
> filesystem and was obviously part of an md-array.

mdadm only checks the superblock at the start of the device to see if i=
t
looks like an ext3 filesystem.  So if an md array has a valid filesyste=
m,
then it is very likely that at least one of the devices in the array wi=
ll
appear to have a valid filesystem to mdadm.

>=20
> This happened with NAS-Devices from 2 different Vendors (namely Thecu=
s and
> Synology), which made me think it must be a md-raid thing.  Does md-r=
aid
> create
> a filesystem after a disk dropped out?  Or may something in the syste=
m
> happen to
> cause this strange behaviour?

No, nothing would try to create a filesystem on a device just because i=
t has
dropped out of a RAID.


>=20
> All in all: after recreating the raids the filesystem contained on it=
 was
> totally damaged (could not even be mounted).  fsck ran multiple days =
with
> excessive data loss.

Maybe there was meant to be another layer between the md array and the
filesystem - maybe LVM ??  If there should have been an LVM and wasn't =
the
filesystem would definitely look very corrupt even though the superbloc=
k
might appear to be in the right place.


NeilBrown


>=20
> P.S.: the mdadm-lines to recreate the RAIDs were derived from mdadm -=
E -
> outputs
> of the original partitions, so I believe that it should have worked (=
on
> other
> recoveries I did before it also worked well).
>=20
> Does anyone have an idea what is going on there?  Or may it have happ=
ened -
> well, I don't want to say something that could get me sued.
>=20
> All the best,
> Stefan H=C3=BCbner
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
