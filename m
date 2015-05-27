From: NeilBrown <neilb@suse.de>
Subject: Re: raid5 reshape is stuck
Date: Wed, 27 May 2015 10:02:53 +1000
Message-ID: <20150527100253.221ab553@notabene.brown>
References: <1612858661.15347659.1431671671467.JavaMail.zimbra@redhat.com>
	<2043891461.15360424.1431673224036.JavaMail.zimbra@redhat.com>
	<20150521094837.6a2d29c4@notabene.brown>
	<1552584910.2141570.1432179477679.JavaMail.zimbra@redhat.com>
	<1822959676.2432469.1432211518647.JavaMail.zimbra@redhat.com>
	<20150525135001.43d1083a@notabene.brown>
	<427651758.4121803.1432637303447.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/dvYR8GbfUpWFWSHu=MBs5bL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <427651758.4121803.1432637303447.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/dvYR8GbfUpWFWSHu=MBs5bL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 26 May 2015 06:48:23 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:


> > >   =20
> > >    In the function continue_via_systemd the parent find pid is bigger=
 than
> > >    0 and
> > > status is 0. So it return 1. So it have no opportunity to call
> > > child_monitor.
> >
> > If continue_via_systemd succeeded, that implies that
> >   systemctl start mdadm-grow-continue@mdXXX.service
> >
> > succeeded.  So
> >    mdadm --grow --continue /dev/mdXXX
> >
> > was run, so that mdadm should call 'child_monitor' and update sync_max =
when
> > appropriate.  Can you check if it does?
>=20
> The service is not running.
>=20
> [root@intel-waimeabay-hedt-01 create_assemble]# systemctl start mdadm-gro=
w-continue@md0.service
> [root@intel-waimeabay-hedt-01 create_assemble]# echo $?
> 0
> [root@intel-waimeabay-hedt-01 create_assemble]# systemctl status mdadm-gr=
ow-continue@md0.service
> mdadm-grow-continue@md0.service - Manage MD Reshape on /dev/md0
>    Loaded: loaded (/usr/lib/systemd/system/mdadm-grow-continue@.service; =
static)
>    Active: failed (Result: exit-code) since Tue 2015-05-26 05:33:59 EDT; =
21s ago
>   Process: 5374 ExecStart=3D/usr/sbin/mdadm --grow --continue /dev/%I (co=
de=3Dexited, status=3D1/FAILURE)
>  Main PID: 5374 (code=3Dexited, status=3D1/FAILURE)
>=20
> May 26 05:33:59 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[1]=
: Started Manage MD Reshape on /dev/md0.
> May 26 05:33:59 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[1]=
: mdadm-grow-continue@md0.service: main process exited, ...URE
> May 26 05:33:59 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[1]=
: Unit mdadm-grow-continue@md0.service entered failed state.
> Hint: Some lines were ellipsized, use -l to show in full.

Hmm.. I wonder why systemctl isn't reporting the error message from mdadm.


>=20
> [root@intel-waimeabay-hedt-01 create_assemble]# mdadm --grow --continue /=
dev/md0 --backup-file=3Dtmp0
> mdadm: Need to backup 6144K of critical section..
>=20
> Now the reshape start.
>=20
> Try modify the service file :
> ExecStart=3D/usr/sbin/mdadm --grow --continue /dev/%I --backup-file=3D/ro=
ot/tmp0
>=20
> It doesn't work too.

I tried that change and it make it work.

>=20
> [root@intel-waimeabay-hedt-01 ~]# systemctl daemon-reload
> [root@intel-waimeabay-hedt-01 ~]# systemctl start mdadm-grow-continue@md0=
.service
> [root@intel-waimeabay-hedt-01 ~]# systemctl status mdadm-grow-continue@md=
0.service
> mdadm-grow-continue@md0.service - Manage MD Reshape on /dev/md0
>    Loaded: loaded (/usr/lib/systemd/system/mdadm-grow-continue@.service; =
static)
>    Active: failed (Result: exit-code) since Tue 2015-05-26 05:50:22 EDT; =
10s ago
>   Process: 6475 ExecStart=3D/usr/sbin/mdadm --grow --continue /dev/%I --b=
ackup-file=3D/root/tmp0 (code=3Dexited, status=3D1/FAILURE)
>  Main PID: 6475 (code=3Dexited, status=3D1/FAILURE)
>=20
> May 26 05:50:22 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[1]=
: Started Manage MD Reshape on /dev/md0.
> May 26 05:50:22 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[1]=
: mdadm-grow-continue@md0.service: main process exited, ...URE
> May 26 05:50:22 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[1]=
: Unit mdadm-grow-continue@md0.service entered failed state.
> Hint: Some lines were ellipsized, use -l to show in full.
>=20
>=20
>  =20
> >
> >
> > >
> > >
> > >    And if it want to set sync_max to 0 until the backup has been take=
n. Why
> > >    does not
> > > set sync_max to 0 directly, but use the value reshape_progress? There=
 is a
> > > little confused.
> >
> > When reshaping an array to a different array of the same size, such as a
> > 4-driver RAID5 to a 5-driver RAID6, then mdadm needs to backup, one pie=
ce at
> > a time, the entire array (unless it can change data_offset, which is a
> > relatively new ability).
> >
> > If you stop an array when it is in the middle of such a reshape, and th=
en
> > reassemble the array, the backup process need to recommence where it le=
ft
> > off.
> > So it tells the kernel that the reshape can progress as far as where it=
 was
> > up to before.  So 'sync_max' is set based on the value of 'reshape_prog=
ress'.
> > (This will happen almost instantly).
> >
> > Then the background mdadm (or the mdadm started by systemd) will backup=
 the
> > next few stripes, update sync_max, wait for those stripes to be reshape=
d,
> > then
> > discard the old backup, create a new one of the few stripes after that,=
 and
> > continue.
> >
> > Does that make it a little clearer?
>=20
> This is a big dinner for me. I need digest this for a while. Thanks very =
much
> for this. What's the "backup process"?
>=20
> Could you explain backup in detail. I read the man about backup file.
>=20
> When  relocating the first few stripes on a RAID5 or RAID6, it is not pos=
sible to keep the data on disk completely
> consistent and crash-proof.  To provide the required safety, mdadm disabl=
es writes to the array while this "critical =20
> section"  is reshaped, and takes a backup of the data that is in that sec=
tion. =20
>=20
> What's the reason about data consistent when relocate data?

If you are reshaping a RAID5 from 3 drives to 4 drives, then the first stri=
pe
will start out as:

   D0  D1   P   -

and you want to change it to

   D0  D1   D2  P

If the system crashes while that is happening, you won't know if either or
both of D2 and P were written, but it is fairly safe just to assume they
weren't and recalculate the parity.
However the second stripe will initially be:

   P  D2  D3=20

and you want to change it to

   P  D3  D4  D5

If you crash in the middle of doing that you cannot know which block is D3
- if either.  D4 might have been written, and D3 not yet written.  So D3 is
lost. =20

So mdadm takes a copy of a whole stripe, allows the kernel to reshape that
one stripe, updates the metadata to record that the stripe has been fully
reshaped, and then discards the backup.
So if you crash in the middle of reshaping the second stripe above, mdadm
will restore it from the backup.

The backup can be stored in a separate file, or in a device which is being
added to the array.


The reason why "mdadm --grow --continue" doesn't work unless you add the
"--backup=3D...." is because it doesn't find the "device  being added" - it
looks for a spare, but there aren't any spares any more.   That should be
easy enough to fix.

Thanks,
NeilBrown

>=20
> >
> > And in response to your other email:
> > >     Does it should return 1 when pid > 0 and status is not zero?
> >
> > No.  continue_via_systemd should return 1 precisely when the 'systemctl'
> > command was successfully run.  So 'status' must be zero.
> >
> >
>=20
> I got this. So reshape_array should return when continue_via_systemd retu=
rn 1. Then the
> reshape is going on when run the command mdadm --grow --continue. Now the=
 child_monitor
> is called and sync_max is set to max.
>=20
> Best Regards
> Xiao
>=20


--Sig_/dvYR8GbfUpWFWSHu=MBs5bL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWUJrTnsnt1WYoG5AQIpnA//Vj5n6eybPA0C9pjR4FLcLWrLoG0NMPGb
WZ7iDYOZQPfOxw0HOqmjipwPo94xUBWJg0d6HrT63nk0P11Ts4FVNwT7PBw9DxeF
WxWUpVF48MCB7HQjGUmCBFQwOBf6KHGYA6dwkpNCAUnHw6BjtmxS6PdlgvvLNKKZ
4MFR138XgsYLSKh33M8smdxttlsL0PAFWOPi4AnGvZPwwXXr0pmn7xwUW9iLdY27
+TbAbBJAcw5nmO5zowKDy3Vu35Z8oH3EujZl9UDugV+A3Dw3iYRiuxlzfGUXvRrT
fkivUOCREke/fvU5VG3NxTjpgJlie4rBdR6ervQ7X+QdW4ajE29KN0At7Bbq6x63
MLRBQREPpJSgaTKLgDkcg2wE0aoM5C0vi2MM9gwmS4XE5l7cNnL/Nl+/LVEY4/MN
9MFEvBTDFSNxP+UxG9efaP45kM//PjxUmbneDPXz8zDI2z3P0EW/Q37qTjW/qXJK
wHqs//FDAV+y7gdIKybggyTgZbBc5YsA2ud6kGkswcF4g3O9KoW5NFG0buq7du2x
ITCYA694ljKGZZbaO6fBcSBmyQ2NBd6Yjs2gNs2wDXwKZ0/Zv2YuDKh4XAJMwxKd
txLUpiVn0oT223sDtrp5MimTeNpUSkiudS3elWYY8BBjuhsMTeT9fy/bJY2omXGo
kOqNS+SbxYo=
=ydud
-----END PGP SIGNATURE-----

--Sig_/dvYR8GbfUpWFWSHu=MBs5bL--
