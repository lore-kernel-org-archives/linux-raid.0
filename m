From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE:
Date: Sun, 7 Mar 2010 21:20:03 -0600
Message-ID: <0A.0B.21054.6EC649B4@cdptpa-omtalb.mail.rr.com>
References: <4877c76c1003071822r896d8fet350145a673495e36@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1003071822r896d8fet350145a673495e36@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Michael Evans' <mjevans1983@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Michael Evans
> Sent: Sunday, March 07, 2010 8:22 PM
> To: Leslie Rhorer
> Cc: Neil Brown; linux-raid@vger.kernel.org
> Subject: Re:
>=20
> On Sun, Mar 7, 2010 at 6:01 PM, Leslie Rhorer <lrhorer@satx.rr.com> w=
rote:
> > =A0 =A0 =A0 =A0Thanks, Neil. =A0I guess I'll just tear it down and =
rebuild.
> =A0Debian
> > "Squeeze" is definitely not ready for prime time, and I don't think=
 even
> it
> > supplies kernel 2.6.32 or mdadm 3.1.1. =A0Oh, well.
> >
> >> -----Original Message-----
> >> From: Neil Brown [mailto:neilb@suse.de]
> >> Sent: Sunday, March 07, 2010 7:53 PM
> >> To: Leslie Rhorer
> >> Cc: linux-raid@vger.kernel.org
> >> Subject: Re:
> >>
> >> On Sun, 7 Mar 2010 19:37:15 -0600
> >> "Leslie Rhorer" <lrhorer@satx.rr.com> wrote:
> >>
> >> > I am running mdadm 2.6.7.2-1, and 2.6.7.2-3 is available under m=
y
> >> distro.
> >> > Do either of these versions support reshaping an array from RAID=
5 to
> >> RAID6?
> >>
> >> No
> >>
> >> > Does any later version?
> >>
> >> Yes.
> >>
> >>
> >> You need mdadm-3.1.1 plus linux 2.6.32.
> >>
> >> NeilBrown
> >>
> >> >
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-=
raid"
> in
> >> > the body of a message to majordomo@vger.kernel.org
> >> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.=
html
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>=20
> What are you talking about?

	Referring to what, specifically?

> Have you not synced to the online
> repository?  I grabbed this out of the Package.bz2 file.

	Of course.  I'm running "Lenny" for an AMD-64.  The output below is
definitely not for AMD-64, and it looks to me like it might be "Squeeze=
" or
"Sid", not "Lenny".

=46rom the "Lenny" AMD-64 Package.bz2 file:

Package: mdadm
Priority: optional
Section: admin
Installed-Size: 776
Maintainer: Debian mdadm maintainers
<pkg-mdadm-devel@lists.alioth.debian.org>
Architecture: amd64
Version: 2.6.7.2-3
Replaces: mdctl
Depends: libc6 (>=3D 2.7-1), udev | makedev, debconf (>=3D 1.4.72), lsb=
-base (>=3D
3.1-6)
Recommends: exim4 | mail-transport-agent, module-init-tools
Conflicts: initramfs-tools (<< 0.65), mdctl (<< 0.7.2), raidtools2 (<<
1.00.3-12.1)
=46ilename: pool/main/m/mdadm/mdadm_2.6.7.2-3_amd64.deb
Size: 273876
MD5sum: a3755364dcc80be5d940a3d423eb55a9
SHA1: a0ee5083f213f70bbb96cb8fd5b2f89a5cb8ddd3
SHA256: 10add842a74034592b8647c8e70a69502e3d915413a7da640c0172d02ef9ee7=
d
Description: tool to administer Linux MD arrays (software RAID)
 The mdadm utility can be used to create, manage, and monitor MD
 (multi-disk) arrays for software RAID or multipath I/O.
 .
 This package automatically configures mdadm to assemble arrays during =
the
 system startup process. If not needed, this functionality can be disab=
led.
Homepage: http://neil.brown.name/blog/mdadm
Tag: admin::boot, admin::configuring, hardware::storage, implemented-in=
::c,
implemented-in::shell, interface::commandline, interface::daemon,
role::program, scope::utility, use::configuring, use::monitor


	"Lenny" i386 lists the same thing.
=20
> (Yes, BTW, they should probably have a bug filed to get mdadm 3.1
> included before the freeze...)
>=20
> Package: mdadm
> Priority: optional
> Section: admin
> Installed-Size: 1064
> Maintainer: Debian mdadm maintainers <pkg-mdadm-
> devel@lists.alioth.debian.org>
> Architecture: i386
> Version: 3.0.3-2
> Replaces: mdctl
> Depends: libc6 (>=3D 2.3.3), udev | makedev, debconf (>=3D 1.4.72),
> lsb-base (>=3D 3.1-6)
> Recommends: default-mta | mail-transport-agent, module-init-tools
> Conflicts: initramfs-tools (<< 0.65), mdctl (<< 0.7.2), raidtools2 (<=
<
> 1.00.3-12.1)
> Filename: pool/main/m/mdadm/mdadm_3.0.3-2_i386.deb
> Size: 418426
> MD5sum: ab27fb8bfde438bc76dcb42ce8717626
> SHA1: a89f1b90ac08bcf29c6c49cc310db0823edf8562
> SHA256: 5f9fae56cba6aa6dbb747ddf86402615319d32f3d692da64a818f0f1fab39=
9af
> Description: tool to administer Linux MD arrays (software RAID)
>  The mdadm utility can be used to create, manage, and monitor MD
>  (multi-disk) arrays for software RAID or multipath I/O.
>  .
>  This package automatically configures mdadm to assemble arrays durin=
g the
>  system startup process. If not needed, this functionality can be
> disabled.
> Homepage: http://neil.brown.name/blog/mdadm
> Tag: admin::boot, admin::configuring, hardware::storage,
> implemented-in::c, implemented-in::shell, interface::commandline,
> interface::daemon, role::program, scope::utility, use::configuring,
> use::monitor
>=20
>=20
> Package: linux-image-2.6.32-trunk-686
> Priority: optional
> Section: kernel
> Installed-Size: 74220
> Maintainer: Debian Kernel Team <debian-kernel@lists.debian.org>
> Architecture: i386
> Source: linux-2.6
> Version: 2.6.32-5
> Provides: linux-image, linux-image-2.6, linux-modules-2.6.32-trunk-68=
6
> Depends: module-init-tools, initramfs-tools (>=3D 0.55) | linux-initr=
amfs-
> tool
> Pre-Depends: debconf | debconf-2.0
> Recommends: firmware-linux-free (>=3D 2.6.32), libc6-i686
> Suggests: linux-doc-2.6.32, grub | lilo
> Conflicts: initramfs-tools (<< 0.55)
> Filename: pool/main/l/linux-2.6/linux-image-2.6.32-trunk-686_2.6.32-
> 5_i386.deb
> Size: 26282748
> MD5sum: 776c9e57322b9e154bcc0518a9224df3
> SHA1: 210cc48a91120ebd36cb20d9516e6e34e4c52da4
> SHA256: bf8e8936cacf902b09dde1950bf10dcf50b1cceeeb4d1c351250a5c13da42=
e83
> Description: Linux 2.6.32 for modern PCs
>  The Linux kernel 2.6.32 and modules for use on PCs with Intel Pentiu=
m
>  Pro/II/III/4/4M/D/M, Xeon, Celeron, Core or Atom; AMD K6, Geode LX/N=
X,
>  Athlon (K7), Duron, Opteron, Sempron, Turion or Phenom; Transmeta
>  Efficeon; VIA C3 "Nehemiah" or C7 processors.
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
