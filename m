From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: SSD - TRIM command
Date: Tue, 8 Feb 2011 18:50:17 -0200
Message-ID: <AANLkTikrKCh3X7aLGqt8hDi2SK4LuZUykVRY2Mo4Nvm4@mail.gmail.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
	<4D517F4F.4060003@gmail.com>
	<AANLkTi=sgTjGMvNiZB2aqxpe8-z7V0bUks84+fMxCAoY@mail.gmail.com>
	<AANLkTik5SumqyTN5LZVntna8nunvPe7v38TSFf9eCfcU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik5SumqyTN5LZVntna8nunvPe7v38TSFf9eCfcU@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Scott E. Armitage" <launchpad@scott.armitage.name>
Cc: maurice <mhilarius@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=3D] now the right answer :)
question: maybe in future... could we make trim compatible with md?

obs:
i understanded that trim is just for ssd making sectors clean without
writing 000000000000-000000 at the entire sector (a ssd optimization)
if we translate trim to not supported trim disks at device level could
we send TRIM to all disks on md device?
just a option at mdadm --assemble --allow-trim
and send trim received by filesystem

2011/2/8 Scott E. Armitage <launchpad@scott.armitage.name>:
> The problem as I understand it is that md treats the entire device (o=
r
> partition) as "in use" -- even if the filesystem isn't using a partic=
ular
> set of blocks, those blocks must still be consistent across the array=
=2E The
> SSD TRIM command is used to tell the physical drive which blocks are =
no
> longer in use by the filesystem, so that it can optimize write operat=
ions.
> Running under md, all blocks would be "used", so there would be nothi=
ng to
> send with the TRIM command.
> -Scott
>
> On Tue, Feb 8, 2011 at 1:31 PM, Roberto Spadim <roberto@spadim.com.br=
>
> wrote:
>>
>> it's resync running?
>> i don't think it's a problem...
>> any device will die some day...
>> ssd is faster than hd, why not use it?
>> i'm using hp smart array p212 with 3.0 firmware, it write on all blo=
cks
>> too
>> maybe a just command line option to start array without sync could h=
elp...
>> i don't know if resync is write intensive or just write on diferent
>> blocks, if it's just diff it's not a problem for ssd...
>>
>> again...
>> i know that the 'translate' of trim command to non compatible device=
s
>> is a problem for device layer not md layer, but can md send trim
>> command to all mirrors/disks?
>>
>> 2011/2/8 maurice <mhilarius@gmail.com>:
>> > On 2/7/2011 1:07 PM, Roberto Spadim wrote:
>> >>
>> >> hi guys, could md send TRIM command to ssd? using ext4 discart mo=
unt
>> >> option?
>> >> if i mix ssd and hd, could this TRIM be rewrite to non TRIM compa=
tible
>> >> disks?
>> >>
>> > I have read that using md with SSDs is not a great idea:
>> > Form the Fedora 14 documentation:
>> >
>> > "Take note as well that software RAID levels 1, 4, 5, and 6 are no=
t
>> > recommended for use on SSDs.
>> > During the initialization stage of these RAID levels, some RAID
>> > management
>> > utilities (such as mdadm)
>> > write to all of the blocks on the storage device to ensure that
>> > checksums
>> > operate properly.
>> > This will cause the performance of the SSD to degrade quickly. "
>> >
>> >
>> > https://docs.fedoraproject.org/en-US/Fedora/14/html/Storage_Admini=
stration_Guide/newmds-ssdtuning.html
>> >
>> >
>> > --
>> > Cheers,
>> > Maurice Hilarius
>> > eMail: /mhilarius@gmail.com/
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
>
>
> --
> Scott Armitage, B.A.Sc., M.A.Sc. candidate
> Space Flight Laboratory
> University of Toronto Institute for Aerospace Studies
> 4925 Dufferin Street, Toronto, Ontario, Canada, M3H 5T6
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
