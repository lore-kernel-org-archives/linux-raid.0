From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Distributed spares
Date: Tue, 14 Oct 2008 15:06:44 +0200
Message-ID: <20081014130644.GC3176@rap.rap.dk>
References: <48F3C2A1.3080607@tmr.com> <alpine.DEB.1.10.0810131810570.16807@p34.internal.lan> <a43edf1b0810131530x36a69089la0d5d26a2228b796@mail.gmail.com> <20081013232921.GB22265@rap.rap.dk> <yq11vyjcwoi.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq11vyjcwoi.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Billy Crook <billycrook@gmail.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Oct 14, 2008 at 06:12:29AM -0400, Martin K. Petersen wrote:
> >>>>> "Keld" =3D=3D Keld J=F8rn Simonsen <keld@dkuug.dk> writes:
>=20
> Keld> I have also been thinking a little on this. My idea is that if
> Keld> bit errors develop on disks, then there is first maybe one bit
> Keld> error, and the crc check on the disk sectors then finds and
> Keld> corrects these.
>=20
> Keld> If you rewrite such bit errors, then that bit error will be
> Keld> corrected, and you prevent the one-bit error from developing to
> Keld> a two-bit error that is not correctable by the CRC.
>=20
> I think you are assuming that disks are much simpler than they
> actually are.
>=20
> A modern disk drive protects a 512-byte sector with a pretty strong
> ECC that's capable of correcting errors up to ~50 bytes.  Yes, that's
> bytes.
>=20
> Also, many drive firmwares will internally keep track of problematic
> media areas and rewrite or reallocate affected blocks.  That includes
> stuff like rewriting sectors that are susceptible to bleed due to
> being adjacent to write hot spots.

Good to know. Could yo tell me if this is actually true for normal
state-of-the art SATA disks, or only true for more expensive disks?
Do you have a good reference for it.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
