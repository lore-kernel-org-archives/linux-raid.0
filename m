From: "David Lethe" <david@santools.com>
Subject: Re: Distributed spares
Date: Tue, 14 Oct 2008 8:30:00 -0500
Message-ID: <2cda01c92e01$12827a4c$3e01a8c0@exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Billy Crook <billycrook@gmail.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



-----Original Message-----

=46rom:  Keld J=F8rn Simonsen <keld@dkuug.dk>
Subj:  Re: Distributed spares
Date:  Tue Oct 14, 2008 8:06 am
Size:  1K
To:  "Martin K. Petersen" <martin.petersen@oracle.com>
cc:  "Billy Crook" <billycrook@gmail.com>; "Justin Piszcz" <jpiszcz@luc=
idpixels.com>; "Bill Davidsen" <davidsen@tmr.com>; "Neil Brown" <neilb@=
suse.de>; "Linux RAID" <linux-raid@vger.kernel.org>

On Tue, Oct 14, 2008 at 06:12:29AM -0400, Martin K. Petersen wrote:=20
> >>>>> "Keld" =3D=3D Keld J=F8rn Simonsen <keld@dkuug.dk> writes:=20
> =20
> Keld> I have also been thinking a little on this. My idea is that if=20
> Keld> bit errors develop on disks, then there is first maybe one bit=20
> Keld> error, and the crc check on the disk sectors then finds and=20
> Keld> corrects these.=20
> =20
> Keld> If you rewrite such bit errors, then that bit error will be=20
> Keld> corrected, and you prevent the one-bit error from developing to=
=20
> Keld> a two-bit error that is not correctable by the CRC.=20
> =20
> I think you are assuming that disks are much simpler than they=20
> actually are.=20
> =20
> A modern disk drive protects a 512-byte sector with a pretty strong=20
> ECC that's capable of correcting errors up to ~50 bytes.  Yes, that's=
=20
> bytes.=20
> =20
> Also, many drive firmwares will internally keep track of problematic=20
> media areas and rewrite or reallocate affected blocks.  That includes=
=20
> stuff like rewriting sectors that are susceptible to bleed due to=20
> being adjacent to write hot spots.=20
=20
Good to know. Could yo tell me if this is actually true for normal=20
state-of-the art SATA disks, or only true for more expensive disks?=20
Do you have a good reference for it.=20
=20
best regards=20
keld=20
--=20
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n=20
the body of a message to majordomo@vger.kernel.org=20
More majordomo info at  http://vger.kernel.org/majordomo-info.html=20
=20
read the manual for any disk drive... They go into error detection,  co=
rrection recovery algorithms and capability in  great detail. =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
