From: NeilBrown <neilb@suse.de>
Subject: Re: /dev/md0 can't be created
Date: Wed, 1 Apr 2015 13:53:21 +1100
Message-ID: <20150401135321.2f421b96@notabene.brown>
References: <1215809785.2787621.1427263359309.JavaMail.zimbra@redhat.com>
	<12135556.2792023.1427264134774.JavaMail.zimbra@redhat.com>
	<20150325173529.13a6efd7@notabene.brown>
	<200110393.3671122.1427355395924.JavaMail.zimbra@redhat.com>
	<160793753.4322898.1427436381735.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/RA61bg.Srbc3a=i_2=flPy7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <160793753.4322898.1427436381735.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/RA61bg.Srbc3a=i_2=flPy7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Mar 2015 02:06:21 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:

>=20
>   I'm lucky, I reproduced it again and I ran the command udevadm monitor =
> monitor before test.
> I'll put it in as an attachment.
>=20
>   I found there is a not whole message in the last line.=20
>=20
> Xiao

The line:

 UDEV  [7083.531441] add      /devices/virtual/block/md0 (block)

confirms that udev saw an 'add' event for /dev/md0.

That should be enough for udev to create the device node.
If it doesn't, you need to look into udev and find out why it doesn't.
I can't really help you there - I don't find udev very easy to debug.

NeilBrown


>=20
> ----- Original Message -----
> > From: "Xiao Ni" <xni@redhat.com>
> > To: "NeilBrown" <neilb@suse.de>
> > Cc: linux-raid@vger.kernel.org
> > Sent: Thursday, March 26, 2015 3:36:35 PM
> > Subject: Re: /dev/md0 can't be created
> >=20
> > Hi Neil
> >=20
> >    I can reproduce it now. Do you want me to run udevadm monitor before=
 the
> >    test?
> > And I checked the /var/log/messages, it show the information:
> >=20
> > Oct 20 19:59:59 ibm-z10-25 kernel: md: bind<dm-2>
> > Oct 20 19:59:59 ibm-z10-25 kernel: md: bind<dm-3>
> > Oct 20 19:59:59 ibm-z10-25 kernel: md: bind<dm-4>
> > Oct 20 19:59:59 ibm-z10-25 kernel: md: bind<dm-5>
> > Oct 20 19:59:59 ibm-z10-25 kernel: md: bind<dm-6>
> > Oct 20 19:59:59 ibm-z10-25 kernel: md: bind<dm-7>
> > Oct 20 19:59:59 ibm-z10-25 kernel: md: bind<dm-9>
> > Oct 20 19:59:59 ibm-z10-25 kernel: md: bind<dm-8>
> > Oct 20 19:59:59 ibm-z10-25 kernel: md/raid:md0: device dm-7 operational=
 as
> > raid disk 5
> > Oct 20 19:59:59 ibm-z10-25 kernel: md/raid:md0: device dm-6 operational=
 as
> > raid disk 4
> > Oct 20 19:59:59 ibm-z10-25 kernel: md/raid:md0: device dm-5 operational=
 as
> > raid disk 3
> > Oct 20 19:59:59 ibm-z10-25 kernel: md/raid:md0: device dm-4 operational=
 as
> > raid disk 2
> > Oct 20 19:59:59 ibm-z10-25 kernel: md/raid:md0: device dm-3 operational=
 as
> > raid disk 1
> > Oct 20 19:59:59 ibm-z10-25 kernel: md/raid:md0: device dm-2 operational=
 as
> > raid disk 0
> > Oct 20 19:59:59 ibm-z10-25 kernel: md/raid:md0: allocated 0kB
> > Oct 20 19:59:59 ibm-z10-25 kernel: md/raid:md0: raid level 5 active wit=
h 6
> > out of 7 devices, algorithm 2
> > Oct 20 19:59:59 ibm-z10-25 kernel: md/raid456: discard support disabled=
 due
> > to uncertainty.
> > Oct 20 19:59:59 ibm-z10-25 kernel: Set
> > raid456.devices_handle_discard_safely=3DY to override.
> > Oct 20 19:59:59 ibm-z10-25 kernel: md0: detected capacity change from 0=
 to
> > 1881145344
> > Oct 20 19:59:59 ibm-z10-25 kernel: md: recovery of RAID array md0
> > Oct 20 19:59:59 ibm-z10-25 kernel: md: minimum _guaranteed_  speed: 1000
> > KB/sec/disk.
> > Oct 20 19:59:59 ibm-z10-25 kernel: md: using maximum available idle IO
> > bandwidth (but not more than 200000 KB/sec) for recovery.
> > Oct 20 19:59:59 ibm-z10-25 kernel: md: using 128k window, over a total =
of
> > 306176k.
> > Oct 20 19:59:59 ibm-z10-25 systemd-udevd: inotify_add_watch(7, /dev/md0=
, 10)
> > failed: No such file or directory
> >  =20
> > Xiao
> >=20
> > ----- Original Message -----
> > > From: "NeilBrown" <neilb@suse.de>
> > > To: "Xiao Ni" <xni@redhat.com>
> > > Cc: linux-raid@vger.kernel.org
> > > Sent: Wednesday, March 25, 2015 2:35:29 PM
> > > Subject: Re: /dev/md0 can't be created
> > >=20
> > > On Wed, 25 Mar 2015 02:15:34 -0400 (EDT) Xiao Ni <xni@redhat.com> wro=
te:
> > >=20
> > > > Hi all
> > > >=20
> > > >    I have encountered so many times, the raid device is created
> > > >    successfully, but the directory
> > > > /dev/md0 can't be created. It can't reproduce 100%.
> > > >=20
> > > > [root@intel-sugarbay-do-01 create_assemble]# cat /proc/mdstat
> > > > Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> > > > md0 : active raid10 loop7[7](S) loop6[6] loop5[5] loop4[4] loop3[3]
> > > > loop2[2] loop1[1] loop0[0]
> > > >       1788416 blocks super 1.2 512K chunks 2 near-copies [7/7] [UUU=
UUUU]
> > > >       bitmap: 0/1 pages [0KB], 65536KB chunk
> > > >=20
> > > > unused devices: <none>
> > > > [root@intel-sugarbay-do-01 create_assemble]# ls /dev/md0
> > > > ls: cannot access /dev/md0: No such file or directory
> > > >=20
> > > >     The underline devices are loop devices which are created with b=
ig
> > > >     file.
> > > >=20
> > > >     The kernel I used is RHEL7 (3.10.0-234.el7.x86_64.debug, mdadm -
> > > >     v3.3.2
> > > >     - 21st August 2014)
> > > > I'll try to reproduce this with upstream kernel and mdadm. But I th=
ink it
> > > > shouldn't be the problem about kernel.
> > > >=20
> > > >     What do you think I should check for this? And which tool is
> > > >     responsible for creating the directory? Maybe
> > > > I can add some log to it to find the reason.
> > > >=20
> > >=20
> > > /dev/md0 is created by udev.
> > > Run
> > >   udevadm monitor
> > >=20
> > > to see the events that udev is processing.  When and ADD event for "m=
d0" is
> > > processed, /dev/md0 should get created.
> > >=20
> > > NeilBrown
> > >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20


--Sig_/RA61bg.Srbc3a=i_2=flPy7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVRtdoTnsnt1WYoG5AQKJChAAul23nttZ26BVxEu030atL1bBNogpDAH/
qquyj8+TxuSb5pPgn0BUDklsptjndWkmcWTbQWjiWTJrQ646ULSjutikeK6Z+iT8
TmO5E861EVhZjEcmYJ0PKSf4xMWdj/hPJKGnGeBEvCMrJyLs2mbihkCBXJ/SpVM2
HA1Rl5qL7CHCqqRl/59tg2u+VBxACDtbbimb/jHhP/29AO287BSvqJ7fDyJSbVIt
sdS65aZaAlivSXBn8b1CPaGpSNgP+A9bDgeTFFvmpoME92J6Cmu/MRoel17ZOPOH
m11m90j3pukoMHbLEs8Pwlu9SUx9rVYVPYYiaJ8zIsdqbyQgmW9fIpH8j4AaDrei
MQpMnVtcIdiJhNoSqCBfD85v3dTpyDPVBCLwH9fuwU4VzTjFCcuwjq2Rp80X7byw
St5n6IVQlqDRAA6PmgmAYKM5oHb4ZruW8aZ6z0bMl48ldXGz7LA7Z8FaAgUHpD/z
OFaxH58OykHeFARbnrp3H5IpqgTROAGV6YdBtMUu0B/2at2vY8u+jKk403Dw2naZ
Fx2tWWP0BZiyEF9Bj89YyZptf2aEkZrT5shMz646EP1uj6FTD6Wv536dKm5DmZNh
w00VkOn4stDEeA5MordAKY6EBslyUe1vE6n3Y/fAA+dIvd38hNxmyCKP1ueIskcM
ysKoKhyEtcI=
=d73h
-----END PGP SIGNATURE-----

--Sig_/RA61bg.Srbc3a=i_2=flPy7--
