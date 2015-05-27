From: NeilBrown <neilb@suse.de>
Subject: Re: raid5 reshape is stuck
Date: Wed, 27 May 2015 11:10:04 +1000
Message-ID: <20150527111004.5f136f23@notabene.brown>
References: <1612858661.15347659.1431671671467.JavaMail.zimbra@redhat.com>
	<2043891461.15360424.1431673224036.JavaMail.zimbra@redhat.com>
	<20150521094837.6a2d29c4@notabene.brown>
	<1552584910.2141570.1432179477679.JavaMail.zimbra@redhat.com>
	<1822959676.2432469.1432211518647.JavaMail.zimbra@redhat.com>
	<20150525135001.43d1083a@notabene.brown>
	<427651758.4121803.1432637303447.JavaMail.zimbra@redhat.com>
	<20150527100253.221ab553@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/tCeo7yYvR3Iacclk+/GglJQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150527100253.221ab553@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/tCeo7yYvR3Iacclk+/GglJQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 May 2015 10:02:53 +1000 NeilBrown <neilb@suse.de> wrote:

> On Tue, 26 May 2015 06:48:23 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:
>=20
>=20
> > > >   =20
> > > >    In the function continue_via_systemd the parent find pid is bigg=
er than
> > > >    0 and
> > > > status is 0. So it return 1. So it have no opportunity to call
> > > > child_monitor.
> > >
> > > If continue_via_systemd succeeded, that implies that
> > >   systemctl start mdadm-grow-continue@mdXXX.service
> > >
> > > succeeded.  So
> > >    mdadm --grow --continue /dev/mdXXX
> > >
> > > was run, so that mdadm should call 'child_monitor' and update sync_ma=
x when
> > > appropriate.  Can you check if it does?
> >=20
> > The service is not running.
> >=20
> > [root@intel-waimeabay-hedt-01 create_assemble]# systemctl start mdadm-g=
row-continue@md0.service
> > [root@intel-waimeabay-hedt-01 create_assemble]# echo $?
> > 0
> > [root@intel-waimeabay-hedt-01 create_assemble]# systemctl status mdadm-=
grow-continue@md0.service
> > mdadm-grow-continue@md0.service - Manage MD Reshape on /dev/md0
> >    Loaded: loaded (/usr/lib/systemd/system/mdadm-grow-continue@.service=
; static)
> >    Active: failed (Result: exit-code) since Tue 2015-05-26 05:33:59 EDT=
; 21s ago
> >   Process: 5374 ExecStart=3D/usr/sbin/mdadm --grow --continue /dev/%I (=
code=3Dexited, status=3D1/FAILURE)
> >  Main PID: 5374 (code=3Dexited, status=3D1/FAILURE)
> >=20
> > May 26 05:33:59 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[=
1]: Started Manage MD Reshape on /dev/md0.
> > May 26 05:33:59 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[=
1]: mdadm-grow-continue@md0.service: main process exited, ...URE
> > May 26 05:33:59 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[=
1]: Unit mdadm-grow-continue@md0.service entered failed state.
> > Hint: Some lines were ellipsized, use -l to show in full.
>=20
> Hmm.. I wonder why systemctl isn't reporting the error message from mdadm.
>=20
>=20
> >=20
> > [root@intel-waimeabay-hedt-01 create_assemble]# mdadm --grow --continue=
 /dev/md0 --backup-file=3Dtmp0
> > mdadm: Need to backup 6144K of critical section..
> >=20
> > Now the reshape start.
> >=20
> > Try modify the service file :
> > ExecStart=3D/usr/sbin/mdadm --grow --continue /dev/%I --backup-file=3D/=
root/tmp0
> >=20
> > It doesn't work too.
>=20
> I tried that change and it make it work.
>=20
> >=20
> > [root@intel-waimeabay-hedt-01 ~]# systemctl daemon-reload
> > [root@intel-waimeabay-hedt-01 ~]# systemctl start mdadm-grow-continue@m=
d0.service
> > [root@intel-waimeabay-hedt-01 ~]# systemctl status mdadm-grow-continue@=
md0.service
> > mdadm-grow-continue@md0.service - Manage MD Reshape on /dev/md0
> >    Loaded: loaded (/usr/lib/systemd/system/mdadm-grow-continue@.service=
; static)
> >    Active: failed (Result: exit-code) since Tue 2015-05-26 05:50:22 EDT=
; 10s ago
> >   Process: 6475 ExecStart=3D/usr/sbin/mdadm --grow --continue /dev/%I -=
-backup-file=3D/root/tmp0 (code=3Dexited, status=3D1/FAILURE)
> >  Main PID: 6475 (code=3Dexited, status=3D1/FAILURE)
> >=20
> > May 26 05:50:22 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[=
1]: Started Manage MD Reshape on /dev/md0.
> > May 26 05:50:22 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[=
1]: mdadm-grow-continue@md0.service: main process exited, ...URE
> > May 26 05:50:22 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[=
1]: Unit mdadm-grow-continue@md0.service entered failed state.
> > Hint: Some lines were ellipsized, use -l to show in full.
> >=20
> >=20
> >  =20
> > >
> > >
> > > >
> > > >
> > > >    And if it want to set sync_max to 0 until the backup has been ta=
ken. Why
> > > >    does not
> > > > set sync_max to 0 directly, but use the value reshape_progress? The=
re is a
> > > > little confused.
> > >
> > > When reshaping an array to a different array of the same size, such a=
s a
> > > 4-driver RAID5 to a 5-driver RAID6, then mdadm needs to backup, one p=
iece at
> > > a time, the entire array (unless it can change data_offset, which is a
> > > relatively new ability).
> > >
> > > If you stop an array when it is in the middle of such a reshape, and =
then
> > > reassemble the array, the backup process need to recommence where it =
left
> > > off.
> > > So it tells the kernel that the reshape can progress as far as where =
it was
> > > up to before.  So 'sync_max' is set based on the value of 'reshape_pr=
ogress'.
> > > (This will happen almost instantly).
> > >
> > > Then the background mdadm (or the mdadm started by systemd) will back=
up the
> > > next few stripes, update sync_max, wait for those stripes to be resha=
ped,
> > > then
> > > discard the old backup, create a new one of the few stripes after tha=
t, and
> > > continue.
> > >
> > > Does that make it a little clearer?
> >=20
> > This is a big dinner for me. I need digest this for a while. Thanks ver=
y much
> > for this. What's the "backup process"?
> >=20
> > Could you explain backup in detail. I read the man about backup file.
> >=20
> > When  relocating the first few stripes on a RAID5 or RAID6, it is not p=
ossible to keep the data on disk completely
> > consistent and crash-proof.  To provide the required safety, mdadm disa=
bles writes to the array while this "critical =20
> > section"  is reshaped, and takes a backup of the data that is in that s=
ection. =20
> >=20
> > What's the reason about data consistent when relocate data?
>=20
> If you are reshaping a RAID5 from 3 drives to 4 drives, then the first st=
ripe
> will start out as:
>=20
>    D0  D1   P   -
>=20
> and you want to change it to
>=20
>    D0  D1   D2  P
>=20
> If the system crashes while that is happening, you won't know if either or
> both of D2 and P were written, but it is fairly safe just to assume they
> weren't and recalculate the parity.
> However the second stripe will initially be:
>=20
>    P  D2  D3=20
>=20
> and you want to change it to
>=20
>    P  D3  D4  D5
>=20
> If you crash in the middle of doing that you cannot know which block is D3
> - if either.  D4 might have been written, and D3 not yet written.  So D3 =
is
> lost. =20
>=20
> So mdadm takes a copy of a whole stripe, allows the kernel to reshape that
> one stripe, updates the metadata to record that the stripe has been fully
> reshaped, and then discards the backup.
> So if you crash in the middle of reshaping the second stripe above, mdadm
> will restore it from the backup.
>=20
> The backup can be stored in a separate file, or in a device which is being
> added to the array.
>=20
>=20
> The reason why "mdadm --grow --continue" doesn't work unless you add the
> "--backup=3D...." is because it doesn't find the "device  being added" - =
it
> looks for a spare, but there aren't any spares any more.   That should be
> easy enough to fix.

That wasn't too painful - I think this fixes the problem.
Could you confirm?

Thanks,
NeilBrown


diff --git a/Grow.c b/Grow.c
index a20ff3e70142..85de1d27f03a 100644
--- a/Grow.c
+++ b/Grow.c
@@ -850,7 +850,8 @@ int reshape_prepare_fdlist(char *devname,
 	for (sd =3D sra->devs; sd; sd =3D sd->next) {
 		if (sd->disk.state & (1<<MD_DISK_FAULTY))
 			continue;
-		if (sd->disk.state & (1<<MD_DISK_SYNC)) {
+		if (sd->disk.state & (1<<MD_DISK_SYNC) &&
+		    sd->disk.raid_disk < raid_disks) {
 			char *dn =3D map_dev(sd->disk.major,
 					   sd->disk.minor, 1);
 			fdlist[sd->disk.raid_disk]
@@ -3184,7 +3185,7 @@ started:
 	d =3D reshape_prepare_fdlist(devname, sra, odisks,
 				   nrdisks, blocks, backup_file,
 				   fdlist, offsets);
-	if (d < 0) {
+	if (d < odisks) {
 		goto release;
 	}
 	if ((st->ss->manage_reshape =3D=3D NULL) ||
@@ -3196,7 +3197,7 @@ started:
 				       devname);
 				pr_err(" Please provide one with \"--backup=3D...\"\n");
 				goto release;
-			} else if (sra->array.spare_disks =3D=3D 0) {
+			} else if (d =3D=3D odisks) {
 				pr_err("%s: Cannot grow - need a spare or backup-file to backup critic=
al section\n", devname);
 				goto release;
 			}


--Sig_/tCeo7yYvR3Iacclk+/GglJQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWUZbDnsnt1WYoG5AQJqkhAAhzWKBAzsSxAUfB5GkHn9YsvFiH/oRs5W
SHjIGW+C272fKgi7aF75kPJQA098YwCcy7GcZakFYKak27OzQOmGL3WlWS4ifFLz
l6SpWwHhy2CXA/xgplPs2imBUnt4wR3qHwSE78gabfCRlH3XrJvPQqf0VWEfPb7e
laTzQf4IBpJSfbV+FbuJw6rpDU+Bfg4hkOBjnNFI3gQgWMGN2lOGULtKPSRo8y+T
5SPi/Ct5hiPpi7lsmOw5WtOHvSTHujtDg36ghgueMXqSEmN2+y8UaIAGBIHBCcP/
ZT7Ft+9E8IV2OWqNmcgKMmL/JHkzkxofc5EjwENmQB40EdjzQrUDR5jCDtaVwVf8
gvS7g018x/HeBo6RWALa8M9T3gF9aL4ZtFPNr66fJQx2jDnH8Ucj2qMArcR3b5nI
AqbTEPXBkoh255xqpAspy3LcxeS419lFtIGJkDs2uv0jfSLuc84U+vGtmj+1Y3H4
cOGiECQvueYPmZejIu6G5VOJxSUac3Qeu2R3OamZf+yec9Ctf+AcP7K92PLY1prK
khOpZMni9/F2Nsh2mFo4XzF/AAvbuQB8B/fGmrHmu8QXbW8FGR7wQPfrU+GqCi0k
C7ECa6drxaRj0OyR24nn4wGieFu8wzHInb0GfknNn/QW2l5brfOsApybdjHIollG
6dYScRnpUqA=
=bmfh
-----END PGP SIGNATURE-----

--Sig_/tCeo7yYvR3Iacclk+/GglJQ--
