From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: SSD - TRIM command
Date: Wed, 9 Feb 2011 17:16:41 -0200
Message-ID: <AANLkTina-4yvjFgR4dxvvYvNZ56gfZ4S324OWh-zBjji@mail.gmail.com>
References: <AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>
	<AANLkTik6D-r1ZbgxEACHZK9760pcUBB+3e7wVX3oqrKP@mail.gmail.com>
	<20110209161916.GB8632@bounceswoosh.org>
	<AANLkTimQ+B2sXt0AZiUYW2QrWqpUvt7PLnkVCOwZqx0k@mail.gmail.com>
	<20110209171744.GC8632@bounceswoosh.org>
	<AANLkTik4=Kq+r3H8p8n5gmtB2BJT8bGtZocVF=xPHkEs@mail.gmail.com>
	<20110209182426.GA2724@lazy.lzy>
	<AANLkTimtdL31Nx+XCBy3EUiewnq87vF1SWjv3K_25=E_@mail.gmail.com>
	<20110209183814.GA7142@lazy.lzy>
	<AANLkTi=TYtG62P0ANb_3OohYsLTCpunHu-yjEw26chwc@mail.gmail.com>
	<20110209191359.GB7169@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110209191359.GB7169@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: "Eric D. Mudama" <edmudama@bounceswoosh.org>, "Scott E. Armitage" <launchpad@scott.armitage.name>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

yeah =3D)
a question...
if i send a TRIM to a sector
if i read from it
what i have?
0x00000000000000000000000000000000000 ?
if yes, we could translate TRIM to WRITE on devices without TRIM (hard =
disks)
just to have the same READ information

2011/2/9 Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>:
>> it=B4s just a discussion, right? no implementation yet, right?
>
> Of course...
>
>> what i think....
>> if device accept TRIM, we can use TRIM.
>> if not, we must translate TRIM to something similar (maybe many WRIT=
ES
>> ?), and when we READ from disk we get the same information
>
> TRIM is not about writing at all. TRIM tells the
> device that the addressed block is not anymore used,
> so it (the SSD) can do whatever it wants with it.
>
> The only software layer having the same "knowledge"
> is the filesystem, the other layers, do not have
> any decisional power about the block allocation.
> Except for metadata, of course.
>
> So, IMHO, a software TRIM can only be in the FS.
>
> bye,
>
> pg
>
>> the translation coulbe be done by kernel (not md) maybe options on
>> libata, nbd device....
>> other option is do it with md, internal (md) TRIM translate function
>>
>> who send trim?
>> internal md information: md can generate it (if necessary, maybe it=B4=
s
>> not...) for parity disks (not data disks)
>> filesystem/or another upper layer program (database with direct devi=
ce
>> access), we could accept TRIM from filesystem/database, and send it =
to
>> disks/mirrors, when necessary translate it (internal or kernel
>> translate function)
>>
>>
>> 2011/2/9 Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>:
>> > On Wed, Feb 09, 2011 at 04:30:15PM -0200, Roberto Spadim wrote:
>> >> nice =3D)
>> >> but check that parity block is a raid information, not a filesyst=
em information
>> >> for raid we could implement trim when possible (like swap)
>> >> and implement a trim that we receive from filesystem, and send to=
 all
>> >> disks (if it=B4s a raid1 with mirrors, we should sent to all mirr=
ors)
>> >
>> > To all disk also in case of RAID-5?
>> >
>> > What if the TRIM belongs only to a single SDD block
>> > belonging to a single chunk of a stripe?
>> > That is a *single* SSD of the RAID-5.
>> >
>> > Should md re-read the block and re-write (not TRIM)
>> > the parity?
>> >
>> > I think anything that has to do with checking &
>> > repairing must be carefully considered...
>> >
>> > bye,
>> >
>> > pg
>> >
>> >> i don=B4t know what trim do very well, but i think it=B4s a very =
big write
>> >> with only some bits for example:
>> >> set sector1=3D'00000000000000000000000000000000000000000000000000=
'
>> >> could be replace by:
>> >> trim sector1
>> >> it=B4s faster for sata communication, and it=B4s a good informati=
on for
>> >> hard disk (it can put a single '0' at the start of the sector and=
 know
>> >> that all sector is 0, if it try to read any information it can us=
e
>> >> internal memory (don=B4t read hard disk), if a write is done it s=
hould
>> >> write 0000 to bits, and after after the write operation, but it=B4=
s
>> >> internal function of hard disk/ssd, not a problem of md raid... m=
d
>> >> raid should need know how to optimize and use it =3D] )
>> >>
>> >> 2011/2/9 Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>:
>> >> >> ext4 send trim commands to device (disk/md raid/nbd)
>> >> >> kernel swap send this commands (when possible) to device too
>> >> >> for internal raid5 parity disk this could be done by md, for d=
ata
>> >> >> disks this should be done by ext4
>> >> >
>> >> > That's an interesting point.
>> >> >
>> >> > On which basis should a parity "block" get a TRIM?
>> >> >
>> >> > If you ask me, I think the complete TRIM story is, at
>> >> > best, a temporary patch.
>> >> >
>> >> > IMHO the wear levelling should be handled by the filesystem
>> >> > and, with awarness of this, by the underlining device drivers.
>> >> > Reason is that the FS knows better what's going on with the
>> >> > blocks and what will happen.
>> >> >
>> >> > bye,
>> >> >
>> >> > pg
>> >> >
>> >> >>
>> >> >> the other question... about resync with only write what is dif=
ferent
>> >> >> this is very good since write and read speed can be different =
for ssd
>> >> >> (hd don=B4t have this 'problem')
>> >> >> but i=B4m sure that just write what is diff is better than wri=
te all
>> >> >> (ssd life will be bigger, hd maybe... i think that will be big=
ger too)
>> >> >>
>> >> >>
>> >> >> 2011/2/9 Eric D. Mudama <edmudama@bounceswoosh.org>:
>> >> >> > On Wed, Feb =A09 at 11:28, Scott E. Armitage wrote:
>> >> >> >>
>> >> >> >> Who sends this command? If md can assume that determinate m=
ode is
>> >> >> >> always set, then RAID 1 at least would remain consistent. F=
or RAID 5,
>> >> >> >> consistency of the parity information depends on the determ=
inate
>> >> >> >> pattern used and the number of disks. If you used determina=
te
>> >> >> >> all-zero, then parity information would always be consisten=
t, but this
>> >> >> >> is probably not preferable since every TRIM command would i=
ncur an
>> >> >> >> extra write for each bit in each page of the block.
>> >> >> >
>> >> >> > True, and there are several solutions. =A0Maybe track space =
used via
>> >> >> > some mechanism, such that when you trim you're only trimming=
 the
>> >> >> > entire stripe width so no parity is required for the trimmed=
 regions.
>> >> >> > Or, trust the drive's wear leveling and endurance rating, co=
mbined
>> >> >> > with SMART data, to indicate when you need to replace the de=
vice
>> >> >> > preemptive to eventual failure.
>> >> >> >
>> >> >> > It's not an unsolvable issue. =A0If the RAID5 used distribut=
ed parity,
>> >> >> > you could expect wear leveling to wear all the devices evenl=
y, since
>> >> >> > on average, the # of writes to all devices will be the same.=
 =A0Only a
>> >> >> > RAID4 setup would see a lopsided amount of writes to a singl=
e device.
>> >> >> >
>> >> >> > --eric
>> >> >> >
>> >> >> > --
>> >> >> > Eric D. Mudama
>> >> >> > edmudama@bounceswoosh.org
>> >> >> >
>> >> >> > --
>> >> >> > To unsubscribe from this list: send the line "unsubscribe li=
nux-raid" in
>> >> >> > the body of a message to majordomo@vger.kernel.org
>> >> >> > More majordomo info at =A0http://vger.kernel.org/majordomo-i=
nfo.html
>> >> >> >
>> >> >>
>> >> >>
>> >> >>
>> >> >> --
>> >> >> Roberto Spadim
>> >> >> Spadim Technology / SPAEmpresarial
>> >> >> --
>> >> >> To unsubscribe from this list: send the line "unsubscribe linu=
x-raid" in
>> >> >> the body of a message to majordomo@vger.kernel.org
>> >> >> More majordomo info at =A0http://vger.kernel.org/majordomo-inf=
o.html
>> >> >
>> >> > --
>> >> >
>> >> > piergiorgio
>> >> > --
>> >> > To unsubscribe from this list: send the line "unsubscribe linux=
-raid" in
>> >> > the body of a message to majordomo@vger.kernel.org
>> >> > More majordomo info at =A0http://vger.kernel.org/majordomo-info=
=2Ehtml
>> >> >
>> >>
>> >>
>> >>
>> >> --
>> >> Roberto Spadim
>> >> Spadim Technology / SPAEmpresarial
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-r=
aid" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>> >
>> > --
>> >
>> > piergiorgio
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>> >
>>
>>
>>
>> --
>> Roberto Spadim
>> Spadim Technology / SPAEmpresarial
>
> --
>
> piergiorgio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
