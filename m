From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: SSD - TRIM command
Date: Wed, 9 Feb 2011 19:24:26 +0100
Message-ID: <20110209182426.GA2724@lazy.lzy>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
 <4D517F4F.4060003@gmail.com>
 <4D5245DF.4020401@hardwarefreak.com>
 <iiu4rc$9ju$1@dough.gmane.org>
 <AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>
 <AANLkTik6D-r1ZbgxEACHZK9760pcUBB+3e7wVX3oqrKP@mail.gmail.com>
 <20110209161916.GB8632@bounceswoosh.org>
 <AANLkTimQ+B2sXt0AZiUYW2QrWqpUvt7PLnkVCOwZqx0k@mail.gmail.com>
 <20110209171744.GC8632@bounceswoosh.org>
 <AANLkTik4=Kq+r3H8p8n5gmtB2BJT8bGtZocVF=xPHkEs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTik4=Kq+r3H8p8n5gmtB2BJT8bGtZocVF=xPHkEs@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: "Eric D. Mudama" <edmudama@bounceswoosh.org>, "Scott E. Armitage" <launchpad@scott.armitage.name>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> ext4 send trim commands to device (disk/md raid/nbd)
> kernel swap send this commands (when possible) to device too
> for internal raid5 parity disk this could be done by md, for data
> disks this should be done by ext4

That's an interesting point.

On which basis should a parity "block" get a TRIM?

If you ask me, I think the complete TRIM story is, at
best, a temporary patch.

IMHO the wear levelling should be handled by the filesystem
and, with awarness of this, by the underlining device drivers.
Reason is that the FS knows better what's going on with the
blocks and what will happen.

bye,

pg

>=20
> the other question... about resync with only write what is different
> this is very good since write and read speed can be different for ssd
> (hd don=B4t have this 'problem')
> but i=B4m sure that just write what is diff is better than write all
> (ssd life will be bigger, hd maybe... i think that will be bigger too=
)
>=20
>=20
> 2011/2/9 Eric D. Mudama <edmudama@bounceswoosh.org>:
> > On Wed, Feb =A09 at 11:28, Scott E. Armitage wrote:
> >>
> >> Who sends this command? If md can assume that determinate mode is
> >> always set, then RAID 1 at least would remain consistent. For RAID=
 5,
> >> consistency of the parity information depends on the determinate
> >> pattern used and the number of disks. If you used determinate
> >> all-zero, then parity information would always be consistent, but =
this
> >> is probably not preferable since every TRIM command would incur an
> >> extra write for each bit in each page of the block.
> >
> > True, and there are several solutions. =A0Maybe track space used vi=
a
> > some mechanism, such that when you trim you're only trimming the
> > entire stripe width so no parity is required for the trimmed region=
s.
> > Or, trust the drive's wear leveling and endurance rating, combined
> > with SMART data, to indicate when you need to replace the device
> > preemptive to eventual failure.
> >
> > It's not an unsolvable issue. =A0If the RAID5 used distributed pari=
ty,
> > you could expect wear leveling to wear all the devices evenly, sinc=
e
> > on average, the # of writes to all devices will be the same. =A0Onl=
y a
> > RAID4 setup would see a lopsided amount of writes to a single devic=
e.
> >
> > --eric
> >
> > --
> > Eric D. Mudama
> > edmudama@bounceswoosh.org
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>=20
>=20
>=20
> --=20
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20

piergiorgio
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
