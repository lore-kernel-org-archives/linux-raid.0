From: Andre Noll <maan@systemlinux.org>
Subject: Re: A random initramfs script
Date: Wed, 15 Mar 2006 01:25:27 +0100
Message-ID: <20060315002527.GO27173@skl-net.de>
References: <87u0a0so6w.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibvzjYYg+QDzMCy1"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87u0a0so6w.fsf@hades.wkstn.nix>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--ibvzjYYg+QDzMCy1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21:37, Nix wrote:

> In the interests of pushing people away from in-kernel autodetection,
> I thought I'd provide the initramfs script I just knocked up to boot
> my RAID+LVM system.  It's had a whole four days of testing so it must
> work. :)

I'm using a similar setup since December or so with no problems so
far. However, all my systems have initramfs as their rootfs.

>  - it doesn't waste memory. initramfs isn't like initrd:
>    if you just chroot into the new root filesystem, the
>    data in the initramfs *stays around*, in *nonswappable*
>    kernel memory. And it's not gzipped by that point, either!

If you really care, you can remove almost everything from the initramfs
just before mounting root. But that's not really necessary unless you
are very short on memory. BTW: I'm also using a complete rescue system
(45 MB unpacked) which has everything on initramfs. lilo boots this
25 MB kernel just fine, and so does etherboot.

> The downsides:
>=20
>  - if you link against uClibc (recommended), you need a CVS
>    uClibc too (i.e., one newer than 0.9.27).

glibc works also fine. For the records: You'll need these:

/lib/ld-linux.so.2
/lib/libc.so.6
/lib/libwrap.so.2
/lib/libnsl.so.1
/lib/libnss_nis.so.2
/lib/libnss_files.so.2
/lib/libnss_compat.so.2

>  - it doesn't try to e.g. set up the network, so it can't do really
>    whizzy things like mount a root filesystem situated on a network
>    block device on some other host: if you want to do something like
>    that you've probably already written a script to do it long ago

Yep. Here's what I do for my discless clients (no more nfsroot needed):

ifconfig eth0
route del default
route add default gw $NET.$gw_ip eth0
portmap
ifconfig lo 127.0.0.1
route add -net 127.0.0.0 netmask 255.0.0.0 dev lo
# mount nfs filesystems

>  - you need an /etc/mdadm.conf and an /etc/lvm/lvm.conf, both taken
>    by default from the system you built the kernel on: personally
>    I'd recommend a really simple one with no device=3D lines, like
>=20
> DEVICE partitions
> ARRAY /dev/md0 UUID=3Dsome:long:uuid:here
> ARRAY /dev/md1 UUID=3Danother:long:uuid:here
> ARRAY /dev/md2 UUID=3Dyetanother:long:uuid:here

The following works pretty well for me:

	echo "DEVICE /dev/hd*[0-9] /dev/sd*[0-9] /dev/md[0-9]" > /etc/mdadm.conf
	mdadm --examine --scan --config=3D/etc/mdadm.conf  >> /etc/mdadm.conf
	mdadm --assemble --scan

> Anyway, without further ado, here's usr/init:
>=20

> /sbin/mdev -s

What's mdev? udevstart works too, but it seems to be depreciated now.

> # Assemble the RAID arrays.
> /sbin/mdadm --assemble --scan --auto=3Dmd --run

Minor suggestion:

	if test -e /proc/mdstat; then /sbin/mdadm ...

> # Scan for volume groups.
> /sbin/lvm vgscan --ignorelockingfailure --mknodes && /sbin/lvm vgchange -=
ay --ignorelockingfailure

Similarly,

	if test -c /dev/mapper/control; then ...

> And usr/initramfs (will need adjustment for your system):

> file /sbin/lvm /usr/i686-pc-linux-uclibc/sbin/lvm 0755 0 0

Isn't libdevmapper also needed?

Regards,
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--ibvzjYYg+QDzMCy1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFEF173Wto1QDEAkw8RAnfEAKCQ4+5R2QMqjGdKK3VBiQ2+yH8kFwCZARIg
rhXFNlQochDmDD52tG3SPx8=
=Q2Oy
-----END PGP SIGNATURE-----

--ibvzjYYg+QDzMCy1--
