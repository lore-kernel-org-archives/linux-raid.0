From: NeilBrown <neilb@suse.de>
Subject: Re: non-persistent superblocks?  [WORKAROUND]
Date: Tue, 25 Feb 2014 16:11:28 +1100
Message-ID: <20140225161128.7acdd4a5@notabene.brown>
References: <52E9D9CC.9000908@cas.homelinux.org>
	<BLU0-SMTP148F6E0422558E051D1067198AF0@phx.gbl>
	<52EA81E7.7010906@cas.homelinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nRZsmZiibr+/iN3Yilff/Q+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52EA81E7.7010906@cas.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Schanzle <mdadm@cas.homelinux.org>
Cc: Wilson Jonathan <piercing_male@hotmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/nRZsmZiibr+/iN3Yilff/Q+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Jan 2014 11:46:31 -0500 Chris Schanzle <mdadm@cas.homelinux.org>
wrote:

> On 01/30/2014 05:16 AM, Wilson Jonathan wrote:
> > On Wed, 2014-01-29 at 23:49 -0500, Chris Schanzle wrote:
> >
> > <snip, as my reply might be relevent, or not>
> >
> > Two things come to mind, the first is if you updated the mdadm.conf
> > (/etc/mdadm/mdadm.conf or /etc/mdadm.conf)
> >
> > The second is, update-initramfs -u to make sure things are setup for the
> > boot process. (I tend to do this when ever i change something that
> > "might" change a boot process... even if it does not, its pure habit as
> > apposed to correct procedure)
>=20
> Thanks for these suggestions. Fedora's /etc/mdadm.confshouldn't be necess=
ary to start the array (yes for mdadm monitoring): this is not a boot devic=
e and the kernel was finding the lone single late-added parity disk on boot.
>=20
> As for updating the initramfs, it didn't make sense to try this as the la=
te-added parity disk was being discovered so the kernel modules were availa=
ble.  It seems update-initramfs is for Ubuntu, for Fedora it's dracut.  BTW=
, rebooting with (the non-hostonly) rescue kernel made no difference; it co=
uld have since the original install was on a non-raid device so it has no r=
eason to include raid kernel modules.
>=20
>=20
> I got inspiration from https://raid.wiki.kernel.org/index.php/RAID_superb=
lock_formats to switch superblock format from 1.2 (4k into the device) to t=
he beginning of the device.  Success!
>=20
> Precisely what I did after a reboot, starting/recreating md0 as mentioned=
 previously:
>=20
> mdadm --detail /dev/md0
> vgchange -an
> mdadm --stop /dev/md0
> # supply info from above 'mdadm --detail' to parameters below
> mdadm --create /dev/md0 --assume-clean --level=3D5 --raid-devices=3D5 --c=
hunk=3D512 --layout=3Dleft-symmetric --metadata=3D1.1  /dev/sd{a,b,c,d,e}
>=20
> At this point I had an array with a new UUID, could mount stuff, see data=
, all was good.
>=20
> mdadm --detail --scan >> /etc/mdadm.conf
> emacs !$ # commented out the previous entry
> cat /etc/mdadm.conf
> #ARRAY /dev/md0 metadata=3D1.2 name=3Dd130.localdomain:0 UUID=3D011323af:=
44ef25e9:54dccc7c:b9c66978
> ARRAY /dev/md0 metadata=3D1.1 name=3Dd130.localdomain:0 UUID=3D6fe3cb23:7=
32852d5:358f8b9e:b3820c6b
>=20
> Rebooted and my array was started!
>=20
> cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdc[2] sdb[1] sda[0] sdd[3] sde[4]
>        15627548672 blocks super 1.1 level 5, 512k chunk, algorithm 2 [5/5=
] [UUUUU]
>        bitmap: 0/30 pages [0KB], 65536KB chunk
>=20
> I believe there is something broken with having a gpt-labeled disk (witho=
ut partitions defined) that is incompatible with superblock version 1.2.

Not surprising - it is a meaningless configuration.
If you tell mdadm to use a whole device, it assumes that it owns the whole
device.
If you put a gpt label on the device, then gpt will assume that it owns the
whole device (and can divide it into partitions or whatever).
If both md and gpt think they own the whole device, they will get confused.

When you created the 1.1 metadata, that over-wrote the gpt label, so
gpt is ignoring the device now and not confusing md any more.

NeilBrown

--Sig_/nRZsmZiibr+/iN3Yilff/Q+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUwwmADnsnt1WYoG5AQKnyBAAstHd49jFuvwBOees8fUpk7dKAVsHd0oK
W0Xa/Q7xqVr0Up978s/FjZRPet+Ar1idsXdJQ1GSQ9SU8qJLlFV0U4zQR0/9X8R5
OED5wYw7DbwvlXCU5lOB32GZ2b9L+iXKcIOa23doYPsyjw3iWivHAo5VsxoeC+qn
mrtYbMMnuIAeQ0/kLRbGjr1RRLIAi+vnMT/gZxctqrpRxR1I6Gv8lg62JPXES1dP
jo4pmrSoBlSmijJsJtsRTiuOWFxtZ2WdXynFtQAVM8pgnP//j9Cc2aFUr5u6mQ51
MPClfYQx2XP1j3Si+d6L6SUu+h5vuzbc9bzvh+MHbZSVbFF7WCDfZumnbxO0xNJg
P+wQWt/c6mSNx2K+rxpTG/XaWitAE1bMv8D8Z8YSik/eHX840EcW/fKAJJqoJNeh
eRRk+17cQr+PSVbO44F3u8aj/oDAQwRRVZXnF2eP/ev7CyzyERG/E9xOjqRlVd0m
w/BPr+xjf823NPQdU4pkZYSMnxhEjPKUWRhIjJQNA9bnHWwtDjjhfjrXTcfik5So
kRtcK7TPIIA3PIFHIShC+rVrnMLHB0yYseAaoTHmngwM1ilGTizX+uKTk3OwSnFw
t25+6bqdhJ/6Erwt7Im4OYpsMgUomuWaJx4m08JEDQD7FheoV+xCa0cC6XF3wJ3Q
cB/1031mkiY=
=VqAy
-----END PGP SIGNATURE-----

--Sig_/nRZsmZiibr+/iN3Yilff/Q+--
