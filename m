From: "Ross S. W. Walker" <rwalker@medallion.com>
Subject: RE: [Iscsitarget-devel] [BUG] Raid1/5 over iSCSI trouble
Date: Fri, 19 Oct 2007 17:02:45 -0400
Message-ID: <E2BB8074E5500C42984D980D4BD78EF9017A296F@MFG-NYC-EXCH2.mfg.prv>
References: <4714BB92.7040701@systella.fr> <47161CE3.80909@systella.fr>	<e9c3a7c20710170758p4046ca44labe370e94bca6e93@mail.gmail.com>	<e9c3a7c20710170840u2ed8d6a9x26523eec6700ad11@mail.gmail.com>	<47181CB2.1060602@tmr.com> <471864F8.9010209@systella.fr><1192809103.30976.11.camel@dwillia2-linux.ch.intel.com><4718DE66.8000905@tmr.com> <471916B5.6080709@systella.fr> <47191855.4020402@systella.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <47191855.4020402@systella.fr>
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>, Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org, sparclinux@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, iscsitarget-devel@lists.sourceforge.net
List-Id: linux-raid.ids

BERTRAND Jo=EBl wrote:
>=20
> BERTRAND Jo=EBl wrote:
> > Bill Davidsen wrote:
> >> Dan Williams wrote:
> >>> On Fri, 2007-10-19 at 01:04 -0700, BERTRAND Jo=EBl wrote:
> >>> =20
> >>>>         I run for 12 hours some dd's (read and write in nullio)
> >>>> between
> >>>> initiator and target without any disconnection. Thus=20
> iSCSI code seems
> >>>> to
> >>>> be robust. Both initiator and target are alone on a=20
> single gigabit
> >>>> ethernet link (without any switch). I'm investigating...
> >>>>    =20
> >>>
> >>> Can you reproduce on 2.6.22?
> >>>
> >>> Also, I do not think this is the cause of your failure,=20
> but you have
> >>> CONFIG_DMA_ENGINE=3Dy in your config.  Setting this to 'n'=20
> will compile
> >>> out the unneeded checks for offload engines in async_memcpy and
> >>> async_xor.
> >>
> >> Given that offload engines are far less tested code, I=20
> think this is a=20
> >> very good thing to try!
> >=20
> >     I'm trying wihtout CONFIG_DMA_ENGINE=3Dy. istd1 only uses=20
> 40% of one=20
> > CPU when I rebuild my raid1 array. 1% of this array was now=20
> > resynchronized without any hang.
> >=20
> > Root gershwin:[/usr/scripts] > cat /proc/mdstat
> > Personalities : [raid1] [raid6] [raid5] [raid4]
> > md7 : active raid1 sdi1[2] md_d0p1[0]
> >       1464725632 blocks [2/1] [U_]
> >       [>....................]  recovery =3D  1.0%=20
> (15705536/1464725632)=20
> > finish=3D1103.9min speed=3D21875K/sec
>=20
> 	Same result...
>=20
> connection2:0: iscsi: detected conn error (1011)
> =20
>           session2: iscsi: session recovery timed out after 120 secs
> sd 4:0:0:0: scsi: Device offlined - not ready after error recovery
> sd 4:0:0:0: scsi: Device offlined - not ready after error recovery
> sd 4:0:0:0: scsi: Device offlined - not ready after error recovery
> sd 4:0:0:0: scsi: Device offlined - not ready after error recovery
> sd 4:0:0:0: scsi: Device offlined - not ready after error recovery
> sd 4:0:0:0: scsi: Device offlined - not ready after error recovery
> sd 4:0:0:0: scsi: Device offlined - not ready after error recovery

I am unsure why you would want to setup an iSCSI RAID1, but before
doing so I would try to verify that each independant iSCSI session
is bullet proof.

Try testing and benchmarking each session independantly.

-Ross

______________________________________________________________________
This e-mail, and any attachments thereto, is intended only for use by
the addressee(s) named herein and may contain legally privileged
and/or confidential information. If you are not the intended recipient
of this e-mail, you are hereby notified that any dissemination,
distribution or copying of this e-mail, and any attachments thereto,
is strictly prohibited. If you have received this e-mail in error,
please immediately notify the sender and permanently delete the
original and any copy or printout thereof.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
