From: Neil Brown <neilb@suse.de>
Subject: Re: How to recreate a dmraid RAID array with mdadm (was: no
 subject)
Date: Wed, 17 Nov 2010 14:15:14 +1100
Message-ID: <20101117141514.759d9eea@notabene.brown>
References: <BAY148-w65577551281F75C185BEBEF380@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY148-w65577551281F75C185BEBEF380@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Viau <viaum@sheridanc.on.ca>
Cc: linux-raid@vger.kernel.org, debian-user@lists.debian.org
List-Id: linux-raid.ids

On Tue, 16 Nov 2010 21:44:10 -0500
Mike Viau <viaum@sheridanc.on.ca> wrote:

>=20
> > On Wed, 17 Nov 2010 12:26:47 +1100  wrote:
> >>
> >>> On Mon, 15 Nov 2010 16:21:22 +1100  wrote:
> >>>> On Sun, 14 Nov 2010 01:50:42 -0500 Mike wrote:
> >>>>
> >>>> How does one fix the problem of not having the array not startin=
g at boot?
> >>>>
> >>>
> >>> To be able to answer that one would need to know exactly what is =
in the
> >>> initramfs. And unfortunately all distros are different and I'm no=
t
> >>> particularly familiar with Ubuntu.
> >>>
> >>> Maybe if you
> >>> mkdir /tmp/initrd
> >>> cd /tmp/initrd
> >>> zcat /boot/initrd.img-2.6.32-5-amd64 | cpio -idv
> >>>
> >>> and then have a look around and particularly report etc/mdadm/mda=
dm.conf
> >>> and anything else that might be interesting.
> >>>
> >>> If the mdadm.conf in the initrd is the same as in /etc/mdadm, the=
n it
> >>> *should* work.
> >>>
> >>
> >> Thanks again Neil. I got a chance to examine my systems initramfs =
to discover two differences in the local copy of mdadm.conf and the ini=
tramfs's copy.
> >>
> >> The initramfs's copy contains:
> >>
> >> DEVICE partitions
> >> HOMEHOST
> >> ARRAY metadata=3Dimsm UUID=3D084b969a:0808f5b8:6c784fb7:62659383
> >> ARRAY /dev/md/OneTB-RAID1-PV container=3D084b969a:0808f5b8:6c784fb=
7:62659383 member=3D0 UUID=3Dae4a1598:72267ed7:3b34867b:9c56497a
> >>
> >> So both ARRAY lines got copied over to the initramfs's copy of mda=
dm.conf, but
> >>
> >> CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
> >>
> >> and
> >>
> >> MAILADDR root
> >>
> >> were not carried over on the update-initramfs command.
> >>
> >>
> >> To your clearly better understanding of all this, does the CREATE =
stanza NEED to be present in the initramfs's copy of mdadm.conf in orde=
r for the array to be created on boot? If so, how can one accomplish th=
is, so that the line is added whenever a new initramfs is created for t=
he kernel?
> >
> > No, those differences couldn't explain it not working.
> >
> > I would really expect that mdadm.conf file to successfully assemble=
 the
> > RAID1.
> >
> > As you have the same in /etc/mdadm/mdadm.conf you could see what is=
 happening
> > by:
> >
> > mdadm -Ss
> >
> > to stop all md arrays, then
> >
> > mdadm -Asvv
> >
> > to auto-start everything in mdadm.conf and be verbose about that is=
 happening.
> >
> > If that fails to start the raid1, then the messages it produces wil=
l be
> > helpful in understanding why.
> > If it succeeds, then there must be something wrong with the initrd.=
=2E.
> > Maybe '/sbin/mdmon' is missing... Or maybe it doesn't run
> > mdadm -As
> > (or equivalently: mdadm --assemble --scan)
> > but doesn't something else. To determine what you would need to sea=
rch for
> > 'mdadm' in all the scripts in the initrd and see what turns up.
> >
>=20
> Using mdadm -Ss stops the array:
>=20
> mdadm: stopped /dev/md127
>=20
>=20
> Where /dev/md127 is the imsm0 device and not the OneTB-RAID1-PV devic=
e.
>=20
>=20
> Then executing mdadm -Asvv shows:
>=20
> mdadm: looking for devices for further assembly
> mdadm: no RAID superblock on /dev/dm-3
> mdadm: /dev/dm-3 has wrong uuid.
> mdadm: no RAID superblock on /dev/dm-2
> mdadm: /dev/dm-2 has wrong uuid.
> mdadm: no RAID superblock on /dev/dm-1
> mdadm: /dev/dm-1 has wrong uuid.
> mdadm: no RAID superblock on /dev/dm-0
> mdadm: /dev/dm-0 has wrong uuid.
> mdadm: no RAID superblock on /dev/loop0
> mdadm: /dev/loop0 has wrong uuid.
> mdadm: cannot open device /dev/sdc7: Device or resource busy
> mdadm: /dev/sdc7 has wrong uuid.
> mdadm: cannot open device /dev/sdc6: Device or resource busy
> mdadm: /dev/sdc6 has wrong uuid.
> mdadm: cannot open device /dev/sdc5: Device or resource busy
> mdadm: /dev/sdc5 has wrong uuid.
> mdadm: no RAID superblock on /dev/sdc2
> mdadm: /dev/sdc2 has wrong uuid.
> mdadm: cannot open device /dev/sdc1: Device or resource busy
> mdadm: /dev/sdc1 has wrong uuid.
> mdadm: cannot open device /dev/sdc: Device or resource busy
> mdadm: /dev/sdc has wrong uuid.
> mdadm: cannot open device /dev/sdb: Device or resource busy
> mdadm: /dev/sdb has wrong uuid.
> mdadm: cannot open device /dev/sda: Device or resource busy
> mdadm: /dev/sda has wrong uuid.

This looks wrong.  mdadm should be looking for the container as listed =
in
mdadm.conf and it should find a matching uuid on sda and sdb, but it do=
esn't.

Can you:

 mdadm -E /dev/sda /dev/sdb ; cat /etc/mdadm/mdadm.conf

so I can compare the uuids?

Thanks,

NeilBrown




> mdadm: looking for devices for /dev/md/OneTB-RAID1-PV
> mdadm: no recogniseable superblock on /dev/dm-3
> mdadm/dev/dm-3 is not a container, and one is required.
> mdadm: no recogniseable superblock on /dev/dm-2
> mdadm/dev/dm-2 is not a container, and one is required.
> mdadm: no recogniseable superblock on /dev/dm-1
> mdadm/dev/dm-1 is not a container, and one is required.
> mdadm: no recogniseable superblock on /dev/dm-0
> mdadm/dev/dm-0 is not a container, and one is required.
> mdadm: no recogniseable superblock on /dev/loop0
> mdadm/dev/loop0 is not a container, and one is required.
> mdadm: cannot open device /dev/sdc7: Device or resource busy
> mdadm/dev/sdc7 is not a container, and one is required.
> mdadm: cannot open device /dev/sdc6: Device or resource busy
> mdadm/dev/sdc6 is not a container, and one is required.
> mdadm: cannot open device /dev/sdc5: Device or resource busy
> mdadm/dev/sdc5 is not a container, and one is required.
> mdadm: no recogniseable superblock on /dev/sdc2
> mdadm/dev/sdc2 is not a container, and one is required.
> mdadm: cannot open device /dev/sdc1: Device or resource busy
> mdadm/dev/sdc1 is not a container, and one is required.
> mdadm: cannot open device /dev/sdc: Device or resource busy
> mdadm/dev/sdc is not a container, and one is required.
> mdadm: cannot open device /dev/sdb: Device or resource busy
> mdadm/dev/sdb is not a container, and one is required.
> mdadm: cannot open device /dev/sda: Device or resource busy
> mdadm/dev/sda is not a container, and one is required.
>=20
>=20
> So I am not really sure if that succeed or not, but it doesn't look l=
ike it has because there is not /dev/md/OneTB-RAID1-PV:
>=20
> ls -al /dev/md/
>=20
> total 0
> drwxr-xr-x=A0 2 root root=A0=A0 60 Nov 16 21:08 .
> drwxr-xr-x 21 root root 3440 Nov 16 21:08 ..
> lrwxrwxrwx=A0 1 root root=A0=A0=A0 8 Nov 16 21:08 imsm0 -> ../md127
>=20
>=20
> But after mdadm -Ivv /dev/md/imsm0:
>=20
>=20
> mdadm: UUID differs from /dev/md/OneTB-RAID1-PV.
> mdadm: match found for member 0
> mdadm: Started /dev/md/OneTB-RAID1-PV with 2 devices
>=20
>=20
> Then ls -al /dev/md/ reveals /dev/md/OneTB-RAID1-PV:
>=20
> total 0
> drwxr-xr-x=A0 2 root root=A0=A0 80 Nov 16 21:40 .
> drwxr-xr-x 21 root root 3480 Nov 16 21:40 ..
> lrwxrwxrwx=A0 1 root root=A0=A0=A0 8 Nov 16 21:08 imsm0 -> ../md127
> lrwxrwxrwx=A0 1 root root=A0=A0=A0 8 Nov 16 21:40 OneTB-RAID1-PV -> .=
=2E/md126
>=20
>=20
>=20
> Regardless some initram disk findings:
>=20
> pwd
>=20
> /tmp/initrd
>=20
> Then:
>=20
> find . -type f | grep md | grep -v amd
>=20
> ./lib/udev/rules.d/64-md-raid.rules
> ./scripts/local-top/mdadm
> ./etc/mdadm/mdadm.conf
> ./conf/conf.d/md
> ./sbin/mdadm
>=20
>=20
>=20
>=20
> ./lib/udev/rules.d/64-md-raid.rules
> http://paste.debian.net/100016/
>=20
> ./scripts/local-top/mdadm
> http://paste.debian.net/100017/
>=20
> ./etc/mdadm/mdadm.conf
> http://paste.debian.net/100018/
>=20
> ./conf/conf.d/md
> http://paste.debian.net/100019/
>=20
> ./sbin/mdadm
> {of course is a binary}
>=20
>=20
> -M
>=20
>  		 	   		 =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
