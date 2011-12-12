From: NeilBrown <neilb@suse.de>
Subject: Re: raid6 rebuild not starting
Date: Mon, 12 Dec 2011 16:42:40 +1100
Message-ID: <20111212164240.01e8d1fb@notabene.brown>
References: <4EE455B2.2040105@iki.fi>
	<20111212140119.35dbf92e@notabene.brown>
	<CAP+ghcLLkAbPVy8LO4Hq6ncNr3=tvGGHB1tJ9Wih=Cjbty+zuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cy20aAiIRTdmsjq9Og0Uyip"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAP+ghcLLkAbPVy8LO4Hq6ncNr3=tvGGHB1tJ9Wih=Cjbty+zuw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/cy20aAiIRTdmsjq9Og0Uyip
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Dec 2011 07:22:17 +0200 Anssi Hannula <anssi.hannula@iki.fi> wro=
te:

> On Mon, Dec 12, 2011 at 5:01 AM, NeilBrown <neilb@suse.de> wrote:
> > On Sun, 11 Dec 2011 09:03:14 +0200 Anssi Hannula <anssi.hannula@iki.fi>=
 wrote:
> >
> >> Hi!
> >>
> >> After I rebooted during a raid6 rebuild, the rebuild didn't start agai=
n.
> >> Instead, there is a flood of "RAID conf printout"s that seemingly happ=
en
> >> on array activity.
> >>
> >> All the devices show up properly in --detail and two devices are marked
> >> as "spare rebuilding", and I can access the contents of the array just
> >> fine, but the rebuild doesn't actually start. Is this a bug or am I
> >> missing something? :)
> >>
> >> I was initially on 2.6.38.8, but also tried 3.1.4 which seems to have
> >> the same issue. mdadm is 3.1.5.
> >>
> >> I'm not using start_ro and writing to the array doesn't trigger a
> >> rebuild either.
> >>
> >> Attached are --examine outputs before assembly, kernel log output on
> >> assembly, /proc/mdstat and --detail after assembly (on 3.1.4).
> >>
> >
> > Thank you for the very detailed problem report.
>=20
> Thanks for the quick response :)
>=20
> > Unfortunately it is a complete mystery to me what is happening.
> >
> > The repeated "RAID conf printout" messages are almost certainly coming =
from
> > the end of raid5_remove_disk.
> > It is being called from remove_and_add_spares for each of the two devic=
es
> > that are being rebuilt. =C2=A0raid5_remove_disk declines to remove them=
 because it
> > can keep rebuilding them.
> >
> > remove_and_add_spares then counts them and notes there are 2.
> > md_check_recovery notes that this is > 0, so it should create a thread =
to run
> > md_do_sync.
> >
> > md_do_sync should then print out a message like
> > =C2=A0md: recovery of RAID array md0
> >
> > but it doesn't. =C2=A0So something went wrong.
> > There are three reasons that md_do_sync might not print a message:
> >
> > 1/ MD_RECOVERY_DONE is set. =C2=A0As only md_do_sync ever sets it, that=
 is
> > =C2=A0 =C2=A0unlikely, and in any case md_check_recovery clears it.
> > 2/ mddev->ro !=3D 0. =C2=A0It is only ever set to 0, 1, or 2. =C2=A0If =
it is 1 or 2
> > =C2=A0 then we would be able to see that in /proc/mdstat as a "(readonl=
y)"
> > =C2=A0 status. =C2=A0But we don't.
> > 3/ MD_RECOVERY_INTR is set. Again, md_check_recovery clears this. =C2=
=A0It does
> > =C2=A0 get set if kthread_should_stop() returns 'true', but that should=
 only
> > =C2=A0 happen if kthread_stop() was called. =C2=A0That is only called by
> > =C2=A0 md_unregister_thread and I cannot see any way that could be call.
> >
> > So. =C2=A0No idea.
> >
> > Are you compiling these kernels yourself?
>=20
> Nope (used Mageia kernels), but I did now (3.1.5).
>=20
> > If so, could you:
> > =C2=A0- put a printk in the top of md_do_sync to report the values of
> > =C2=A0 mddev->recovery and mddev->ro
> > =C2=A0- print a message whenever md_unregister_thread is called
> > =C2=A0- in md_check_recovery, in the
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mddev->ro) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0/* Only thing we do on a ro array is remove
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 * failed devices.
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0mdk_rdev_t *rdev;
> >
> > =C2=A0in statement, print the value of mddev->ro.
> >
> > Then see which of those printk's fire, and what they tell us.
>=20
> Only the last one does, and mddev->ro =3D=3D 0.
>=20
> For reference, attached is the used patch and resulting log output.
>=20

Thanks.

So it isn't running md_do_sync at all. Odd.

Could please add:
  - call "WARN_ON(1);" in print_raid5_conf() so we get a stack trace and can
    see who is calling it.
  - print the value that remove_and_add_spares is going to return.

Thanks,
NeilBrown

--Sig_/cy20aAiIRTdmsjq9Og0Uyip
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuWUUDnsnt1WYoG5AQLuLQ//eBjGy1zLVCOQMlSJv8IbZcKuGtSO7X3x
ypAzGvvkpdN9CXBmYJ+lqiqfTNluWGTjjesmarSGU+TMayR6Yxb36EseO77lKZn1
lIXveZK0FPVk+0b8H3Xe6DO/nbhP8KCswMx/7OT0lN0FiNXA5TcMCHsCeaG9Utmb
iuqmtSXXLFE7e1VkFlhGyKER8rDTG+87wfEzQ1CQcjft2MrUgREYLLKmqhAHkuXp
ZvfD/25+3IKhhRYER+kx9BkA0jDKdSFTh6IN8WMBa8YyBhSjWEbZP2JUyXHU3Hg4
v4ubRKr1yOLdkkRQ6Xt5EXtYJzXHU10JyKKDtJ62Z418ay7CHAOLy8te/nb7xktf
f9FqKq6jvejNDQ82DWBIhsqONDrR4wCdRtfK1i+rvcfWpSEuKqxOMim6OCee441j
RAHZqnHS9/OnxNYxMdoB8prKVnmwdP1PO2j8Op+BiyEJjjy2LLlQsIzgRohcjh0w
FGxxnL4zneVpvBxZmDn6Ob7Uby8E8IIMRPB02vnfO2oKY6tgqgoVFKaspTuiyJ0P
A354Av8BWiN2H0gL8xwc9a2RvxxG1k2xi8g8BQkmoF7U7AShSWnfe34Y6nK/ZKJb
1bJROGNrsAXMiKcbOo2PC/L3jU9gcHcueaP4TVmLSAMx475axW6lr9+BMJL9/CfK
+R8COSKyT5g=
=57hq
-----END PGP SIGNATURE-----

--Sig_/cy20aAiIRTdmsjq9Og0Uyip--
