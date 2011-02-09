From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: SSD - TRIM command
Date: Wed, 9 Feb 2011 16:46:24 -0200
Message-ID: <AANLkTi=TYtG62P0ANb_3OohYsLTCpunHu-yjEw26chwc@mail.gmail.com>
References: <4D5245DF.4020401@hardwarefreak.com>
	<iiu4rc$9ju$1@dough.gmane.org>
	<AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>
	<AANLkTik6D-r1ZbgxEACHZK9760pcUBB+3e7wVX3oqrKP@mail.gmail.com>
	<20110209161916.GB8632@bounceswoosh.org>
	<AANLkTimQ+B2sXt0AZiUYW2QrWqpUvt7PLnkVCOwZqx0k@mail.gmail.com>
	<20110209171744.GC8632@bounceswoosh.org>
	<AANLkTik4=Kq+r3H8p8n5gmtB2BJT8bGtZocVF=xPHkEs@mail.gmail.com>
	<20110209182426.GA2724@lazy.lzy>
	<AANLkTimtdL31Nx+XCBy3EUiewnq87vF1SWjv3K_25=E_@mail.gmail.com>
	<20110209183814.GA7142@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110209183814.GA7142@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: "Eric D. Mudama" <edmudama@bounceswoosh.org>, "Scott E. Armitage" <launchpad@scott.armitage.name>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

it=B4s just a discussion, right? no implementation yet, right?

what i think....
if device accept TRIM, we can use TRIM.
if not, we must translate TRIM to something similar (maybe many WRITES
?), and when we READ from disk we get the same information
the translation coulbe be done by kernel (not md) maybe options on
libata, nbd device....
other option is do it with md, internal (md) TRIM translate function

who send trim?
internal md information: md can generate it (if necessary, maybe it=B4s
not...) for parity disks (not data disks)
filesystem/or another upper layer program (database with direct device
access), we could accept TRIM from filesystem/database, and send it to
disks/mirrors, when necessary translate it (internal or kernel
translate function)


2011/2/9 Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>:
> On Wed, Feb 09, 2011 at 04:30:15PM -0200, Roberto Spadim wrote:
>> nice =3D)
>> but check that parity block is a raid information, not a filesystem =
information
>> for raid we could implement trim when possible (like swap)
>> and implement a trim that we receive from filesystem, and send to al=
l
>> disks (if it=B4s a raid1 with mirrors, we should sent to all mirrors=
)
>
> To all disk also in case of RAID-5?
>
> What if the TRIM belongs only to a single SDD block
> belonging to a single chunk of a stripe?
> That is a *single* SSD of the RAID-5.
>
> Should md re-read the block and re-write (not TRIM)
> the parity?
>
> I think anything that has to do with checking &
> repairing must be carefully considered...
>
> bye,
>
> pg
>
>> i don=B4t know what trim do very well, but i think it=B4s a very big=
 write
>> with only some bits for example:
>> set sector1=3D'00000000000000000000000000000000000000000000000000'
>> could be replace by:
>> trim sector1
>> it=B4s faster for sata communication, and it=B4s a good information =
for
>> hard disk (it can put a single '0' at the start of the sector and kn=
ow
>> that all sector is 0, if it try to read any information it can use
>> internal memory (don=B4t read hard disk), if a write is done it shou=
ld
>> write 0000 to bits, and after after the write operation, but it=B4s
>> internal function of hard disk/ssd, not a problem of md raid... md
>> raid should need know how to optimize and use it =3D] )
>>
>> 2011/2/9 Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>:
>> >> ext4 send trim commands to device (disk/md raid/nbd)
>> >> kernel swap send this commands (when possible) to device too
>> >> for internal raid5 parity disk this could be done by md, for data
>> >> disks this should be done by ext4
>> >
>> > That's an interesting point.
>> >
>> > On which basis should a parity "block" get a TRIM?
>> >
>> > If you ask me, I think the complete TRIM story is, at
>> > best, a temporary patch.
>> >
>> > IMHO the wear levelling should be handled by the filesystem
>> > and, with awarness of this, by the underlining device drivers.
>> > Reason is that the FS knows better what's going on with the
>> > blocks and what will happen.
>> >
>> > bye,
>> >
>> > pg
>> >
>> >>
>> >> the other question... about resync with only write what is differ=
ent
>> >> this is very good since write and read speed can be different for=
 ssd
>> >> (hd don=B4t have this 'problem')
>> >> but i=B4m sure that just write what is diff is better than write =
all
>> >> (ssd life will be bigger, hd maybe... i think that will be bigger=
 too)
>> >>
>> >>
>> >> 2011/2/9 Eric D. Mudama <edmudama@bounceswoosh.org>:
>> >> > On Wed, Feb =A09 at 11:28, Scott E. Armitage wrote:
>> >> >>
>> >> >> Who sends this command? If md can assume that determinate mode=
 is
>> >> >> always set, then RAID 1 at least would remain consistent. For =
RAID 5,
>> >> >> consistency of the parity information depends on the determina=
te
>> >> >> pattern used and the number of disks. If you used determinate
>> >> >> all-zero, then parity information would always be consistent, =
but this
>> >> >> is probably not preferable since every TRIM command would incu=
r an
>> >> >> extra write for each bit in each page of the block.
>> >> >
>> >> > True, and there are several solutions. =A0Maybe track space use=
d via
>> >> > some mechanism, such that when you trim you're only trimming th=
e
>> >> > entire stripe width so no parity is required for the trimmed re=
gions.
>> >> > Or, trust the drive's wear leveling and endurance rating, combi=
ned
>> >> > with SMART data, to indicate when you need to replace the devic=
e
>> >> > preemptive to eventual failure.
>> >> >
>> >> > It's not an unsolvable issue. =A0If the RAID5 used distributed =
parity,
>> >> > you could expect wear leveling to wear all the devices evenly, =
since
>> >> > on average, the # of writes to all devices will be the same. =A0=
Only a
>> >> > RAID4 setup would see a lopsided amount of writes to a single d=
evice.
>> >> >
>> >> > --eric
>> >> >
>> >> > --
>> >> > Eric D. Mudama
>> >> > edmudama@bounceswoosh.org
>> >> >
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
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
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
