From: Mads Peter Bach <mpb@hum.auc.dk>
Subject: Re: Raid1 and mdadm
Date: Sat, 29 Mar 2003 22:54:51 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E86162B.1040906@hum.auc.dk>
References: <005e01c2f631$c5de3620$6b7ba8c0@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <005e01c2f631$c5de3620$6b7ba8c0@max>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Max Booker wrote:
> Hello
>=20
> Everything works well up to the point where I reboot, with kernel par=
ameters
> (md=3D0,/dev/hdd1 root=3D/dev/md0). This is where the kernel panics.
>=20
> I think that I have not edited fstab properly, or GRUB is getting in =
the
> way, or maybe it is not possible to add hda2 to the array because it =
already
> has a filesystem on it.... How do I get hda2 to be part of the Raid a=
rray?
> Nothing attempted so far has made any impression on the fact that mda=
dm
> insists that /dev/hda2 is not an md component.
>=20
> I hope that this is enough info.

It isn't. We'll need to see the panic, and the things leading up to it,=
=20
to be able to diagnose what's happening.

Does your kernel have the software raid compiled in, or as modules? If=20
it's modules, you'll need an initial ramdisk (initrd).

You can add hda2 to the array, after you've successfully booted off the=
=20
array.

--=20
Mads Peter Bach
Systemadministrator,  Det Humanistiske Fakultet, Aalborg Universitet
Kroghstr=E6de 3 - 5.111, DK-9220 Aalborg =D8st
# whois MPB1-DK@whois.dk-hostmaster.dk

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
