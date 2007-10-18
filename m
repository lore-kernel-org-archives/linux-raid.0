From: Ming Zhang <blackmagic02881@gmail.com>
Subject: Re: [Iscsitarget-devel] Abort Task ?
Date: Thu, 18 Oct 2007 13:30:38 -0400
Message-ID: <1192728638.3596.28.camel@dhcp-117.ibrix.com>
References: <471720F1.40409@systella.fr> <471727F3.2080500@systella.fr>
	 <471734C5.8090405@systella.fr>
	 <E2BB8074E5500C42984D980D4BD78EF9017A2958@MFG-NYC-EXCH2.mfg.prv>
	 <1192721909.3596.15.camel@dhcp-117.ibrix.com>
	 <47178ABF.1040500@systella.fr>
Reply-To: blackmagic02881@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47178ABF.1040500@systella.fr>
Sender: linux-raid-owner@vger.kernel.org
To: BERTRAND =?ISO-8859-1?Q?Jo=EBl?= <joel.bertrand@systella.fr>
Cc: "Ross S. W. Walker" <rwalker@medallion.com>, iscsitarget-devel@lists.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2007-10-18 at 18:33 +0200, BERTRAND Jo=C3=ABl wrote:
> Ming Zhang wrote:
> > On Thu, 2007-10-18 at 11:33 -0400, Ross S. W. Walker wrote:
> >> BERTRAND Jo=C3=ABl wrote:
> >>> BERTRAND Jo=C3=ABl wrote:
> >>>> BERTRAND Jo=C3=ABl wrote:
> >>>>> 	Hello,
> >>>>>
> >>>>> 	When I try to create a raid1 volume over iscsi, process=20
> >>> aborts with :
> >>>>> - on target side:
> >>>>>
> >>>>> iscsi_trgt: cmnd_abort(1156) 29 1 0 42 57344 0 0
> >>>>> iscsi_trgt: Abort Task (01) issued on tid:1 lun:0 by=20
> >>> sid:630024457682948=20
> >>>>> (Unknown Task)
> >>>> 	Next run:
> >>>> iscsi_trgt: cmnd_abort(1156) 13 1 0 42 57344 0 0
> >>>> iscsi_trgt: Abort Task (01) issued on tid:1 lun:0 by=20
> >>> sid:630058817421315=20
> >>>> (Unknown Task)
> >>>>
> >>>> 	You can see that both lines are very similar. I shall=20
> >>> try to use=20
> >>>> blockio instead fileio.
> >>> 	With blockio, I got the following message...
> >>>
> >>> iscsi_trgt: cmnd_abort(1156) c 1 0 42 8192 0 0
> >>> iscsi_trgt: Abort Task (01) issued on tid:1 lun:0 by=20
> >>> sid:630024457682946=20
> >>> (Unknown Task)
> >>>
> >>> Command is the same. What is the signification of 1156 ?
> >> Both outputs are from the same Abort Task management function
> >> the 1156 refers to the line in iscsi.c where the debug printf
> >> was issued.
> >>
> >> The other is the more verbose informative message that says
> >> an Abort Task command was issued, but the task was not found.
> >=20
> > pure guess, this might because the sparc64 you are using.
> >=20
> > could you export a NULLIO target and do some intensive io tests? so=
rt
> > out these platform issues first...
>=20
> 	I can format serveral times (mkfs.ext3) a 1.5 TB volume over iSCSI=20
> without any trouble. I can read and write on this virtual disk withou=
t=20
> any trouble.
>=20
> 	Now, I have configured ietd with :
>=20
> Lun 0 Sectors=3D1464725758,Type=3Dnullio
>=20
> and I run on initiator side :
>=20
> Root gershwin:[/dev] > dd if=3D/dev/zero of=3D/dev/sdj bs=3D8192
> 479482+0 records in
> 479482+0 records out
> 3927916544 bytes (3.9 GB) copied, 153.222 seconds, 25.6 MB/s

25MB/s over a NULLIO is a very slow result...


>=20
> Root gershwin:[/dev] > dd if=3D/dev/zero of=3D/dev/sdj bs=3D8192
>=20
> 	I'm waitinfor a crash. No one when I write these lines.	I suspect an=
=20
> interaction between raid and iscsi.
>=20
> 	Regards,
>=20
> 	JKB
--=20
Ming Zhang


@#$%^ purging memory... (*!%
http://blackmagic02881.wordpress.com/
http://www.linkedin.com/in/blackmagic02881
--------------------------------------------

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
