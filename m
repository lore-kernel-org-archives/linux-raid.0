From: NeilBrown <neilb@suse.de>
Subject: Re: md disk fault communication code
Date: Fri, 18 Apr 2014 17:16:26 +1000
Message-ID: <20140418171626.236a1e01@notabene.brown>
References: <CAAcCrhQEW4Yzz2YQri3hzNExQVWqquvN8dzzxZN+5DBZbAtcRw@mail.gmail.com>
	<20140418161334.025262bb@notabene.brown>
	<CAAcCrhTeVEbK4LptB32teOSaqbQXQ=gYmnw5RzWv1RcbB7=u_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WAidpUx10mQfb=yB+cEve5N"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAcCrhTeVEbK4LptB32teOSaqbQXQ=gYmnw5RzWv1RcbB7=u_Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sonu a <p10sonu@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WAidpUx10mQfb=yB+cEve5N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Apr 2014 14:47:06 +0800 Sonu a <p10sonu@gmail.com> wrote:

> Yes it does when there is IO failure But.
>=20
> But my question was when disk fail silently with out IO as show below.
>=20
> The md sysfs interface /sys/block/mdY/md/dev-sdX/state is written with
> faulty when sd corresponding disk is deleted with..
>=20
> echo 1 >  /sys/block/sdc/device/delete
>=20
> kernel: [21853.981735] sd 2:0:0:0: [sdc] Synchronizing SCSI cache
> kernel: [21854.049967] md: md0 still in use.
> kernel: [21854.051201] md/raid1:md0: Disk failure on sdc, disabling devic=
e.
> kernel: [21854.051201] md/raid1:md0: Operation continuing on 1 devices.
> kernel: [21854.308355] sd 2:0:0:0: [sdc] Stopping disk
> kernel: [21854.415122] ata3.00: disabled
> kernel: [21854.467540] md: unbind<sdc>
> kernel: [21854.467544] md: export_rdev(sdc)
>=20
> earlier stack dump which shows the sysfs write interface
>=20
> there has to be code monitoring block disk state, and propagating that
> state to the md ?

I understand your question now.

This is handled by used.  /usr/lib/udev/rules.d/64-md-raid-assembly.rules or
some file name like that contains a line like

ACTION=3D=3D"remove", ENV{ID_PATH}!=3D"?*", RUN+=3D"/sbin/mdadm -If $name"

so when the device is removed, udev runs "mdadm -If /dev/devicename".
mdadm finds which array this device is in, marks it as faulty via sysfs, and
then removes the device from the array if it can.

NeilBrown


>=20
> Thx.
>=20
> On Fri, Apr 18, 2014 at 2:13 PM, NeilBrown <neilb@suse.de> wrote:
> > On Fri, 18 Apr 2014 13:38:58 +0800 Sonu a <p10sonu@gmail.com> wrote:
> >
> >> when disk is removed with out mdadm as I see from the stack below the
> >> communication reaching the md driver.
> >>
> >> dump_stack+0x49/0x5e
> >> md_error+0x50/0x110 [md_mod]
> >> state_store+0x43/0x300 [md_mod]
> >> rdev_attr_store+0xad/0xd0 [md_mod]
> >> ? sysfs_write_file+0x62/0x1c0
> >> sysfs_write_file+0x138/0x1c0
> >> vfs_write+0xc0/0x1e0
> >> SyS_write+0x5a/0xa0
> >> ? __audit_syscall_exit+0x246/0x2f0
> >> system_call_fastpath+0x16/0x1b
> >>
> >> could someone point me to the code which is monitoring scsi disks
> >> status and thus calling md driver sysfs interface accordingly ?
> >
> > I think you ask asking how md_error gets called when a SCSI device fail=
s,
> > having already discovered how it is called when you explicitly write to=
 a
> > sysfs file.
> >
> > Nothing monitors the scsi disks.  md only discovers failure if it sends=
 a
> > request to a disk, and the request signals an error.  If you search for
> > 'bi_end_io', functions assigned to this field are called when a request
> > finishes.  Those functions might call md_error if the request failed, o=
r they
> > might schedule some other handling first to try to correct the error.
> >
> > NeilBrown


--Sig_/WAidpUx10mQfb=yB+cEve5N
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU1DRSjnsnt1WYoG5AQITthAAtPnfZ3M/D9BdBKzUBmqk9FFvRztudTpO
oxDH/+dS/1X4DqdNdd2qtT2ad3Ctmq0wjWx/RSvvH7LfUKfye/Wm1j/JELAG9cUy
eREl88BsrlEZ0H2OT4GBu/nAQolqDlKMjj4nBuKeHtNENXpQG6pAVoW16G1P8b0u
ENcHFy2deic7Yh1AwzXo/R9Sb7kL297im0j6cwqJBCbqmB+LWkmPhGv3pAB5HOd/
ik/Jj1eYMN5QzT4YPmyfk2kWracLndWmT4IuOIojSTB9AXdKZpEx94vR3zgtSP8q
3GP5mVd9uua/ofcEjLCxBWyt5NY6qSOSpQr8URrzMfnQJc2rRDBidkp58m67CZjA
1GLrYctaAcvHXgLVl2LapyrTMmEOjoCpyWfwh/mxv7QPYAmmETV3w1GpHcHAcP4c
+NLoFraRymMLthPorqRKutdE1J30/MPgWZt5NReXMwFxFStpvKZqVuCJsFgvNJ6s
vcRxH1tolLXAozLaaF7SuJAK6kVAg8qMZeJ/YcCy7LKCQpD52S3ozLcg6kseWjeH
zZQWBdud7BD2Jxspq/SBnrVpKEUJZ986B+zhzLdQZffI0KOfd0Jvv91OIQt4Ui/C
DlnnkRZT66e75IA3b3HxYWvqYaOfXrSK4GP10dJEFDNcaKw0vjW60KpCgnEymLEn
SRf8hgIh0wI=
=Ptig
-----END PGP SIGNATURE-----

--Sig_/WAidpUx10mQfb=yB+cEve5N--
