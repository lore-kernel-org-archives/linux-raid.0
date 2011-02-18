From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: md road-map: 2011
Date: Fri, 18 Feb 2011 02:27:59 -0200
Message-ID: <AANLkTinTfvPVR1+nAS5wh25Mj+91hZmmJ3J+74JhfS6e@mail.gmail.com>
References: <20110217083531.3090a348@notabene.brown>
	<ijhje3$ocd$1@dough.gmane.org>
	<20110217100139.7520893d@notabene.brown>
	<ijhq7p$pjv$1@dough.gmane.org>
	<20110217010455.GA16324@www2.open-std.org>
	<ijiu99$ill$1@dough.gmane.org>
	<20110217105815.GA24580@www2.open-std.org>
	<4D5D0A66.80608@texsoft.it>
	<20110217154440.GA24982@www2.open-std.org>
	<4D5DB9AC.10106@texsoft.it>
	<20110218025623.GA26387@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110218025623.GA26387@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Giovanni Tessore <giotex@texsoft.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think we should be more intelligent than ordinary HW RAID:-)
that=B4s why SW RAID is better =3D)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
some IDEAS for badblock:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
the point here is: MD is a virtual harddisk, and must operate like one
harddisk (or ssd disk, or mixed ssd+hd)
raid0 =3D many disks (inside a hard disk we have many disks and many
heads, right? it=B4s something like it without the control of head
positioning and SATA interface)
raid1 =3D something that don=B4t exist in harddisks: mirrors (maybe som=
e
disks use it as a badblock solution and we don=B4t know, but mirrors ar=
e
used today as a device redundancy)
raid456 =3D a ecc or checksum of the 'disk'?! maybe something like it..=
=2E

the badblock problem/solution:
many disks have it internally, some disks have online reallocate, some
report the block is failed and filesystem must workaround it (disks
report that the block is failed because they couldn=B4t reallocate or
don=B4t have this feature, filesystem must stop or write to another
device, maybe a end of space problem for app level... in mosts cases
user must tell what to do, or report to kernel log or user space log).

my opnion... since badblock is a device block problem, md must handle
this problem (today with mirror marked as failed, in near future with
badblocks)
filesystem must know that if a badblock exist the device will get
smaller (with less space)
some filesystem know about the badblock problem and try to store the
information on another sector without data
(filesystem should report the nonused sector to device with a TRIM
command, but they don=B4t (today just ext4 with discard and swap have
it))

for sw raid badblock...
maybe we need not only badblock list, but online realloc (for the
first step a badblock list is good, for second step a online realloc)

types of realloc (in all cases md array must will get smaller, if not,
mark the smaller mirror as 'badblocked')
1)device realloc: reallocate device block just on the bad mirror
2)md mirror realloc: if one mirror have a badblock, md will use
another mirror to read that sector (maybe the first option is better,
but when the first fail we use this option and mark md array as
'insync with badblocks' maybe a per mirror flag about bad block is a
nice feature, and maybe a per mirror export badblock list is nice too,
for md level a badblock list of virtual badblock (all mirror with the
same sector badblock, like a single harddisk without mirror))

check that we must implement layout in all raid levels (badblock
realocation is a dynamic layout)

check that for realocation we must use a TRIM like command (here our
friend told that badblock is a filesystem problem, i don=B4t see as a
filesystem problem, but device and filesystem problem, since SSD can
use non allocated sectors and optimize the speed and life time of NAND
cells)

the trim command tell us if a sector with 00000000000...000 value is
in use or not
when in use? when we write to sector
when not in use? at array startup, when filesystem send a trim command
to a MD device and MD mark the block as not in use. check that MD must
not send TRIM command to data blocks, it can send TRIM to parity
devices (raid456), not in use =3D 0 to TRIM bit + 0000 to sector bytes

howto make trim command?
internally we need a 0/1 bit value that tell us the block is in use or
not. the problem: for file system that need a block size of 4096bytes
=3D md will use 4096+1bit
the first solution (a filesystem problem): use 4095block size for
filesystem and use 1 byte for trim information
second solution (a md problem): group many bits in one block.
4096bytes=3D32768 bits in a block of 4096bytes, after 32768blocks we
have a TRIM block

check that TRIM block(bit) can be in a badblock hehehe =3DP check this
for more ideas:
http://en.wikipedia.org/wiki/TRIM_%28SSD_command%29
http://t13.org/Documents/UploadedDocuments/docs2008/e07154r6-Data_Set_M=
anagement_Proposal_for_ATA-ACS2.doc



when filesystem should know if a block have problem (a badblock)? when
all disks have the badblock and can=B4t be reallocated, in other words,
when device get smaller (with less space)



2011/2/18 Keld J=F8rn Simonsen <keld@keldix.com>:
> On Fri, Feb 18, 2011 at 01:13:32AM +0100, Giovanni Tessore wrote:
>> On 02/17/2011 04:44 PM, Keld J=F8rn Simonsen wrote:
>> >It should be possible to run a periodic check of if any bad sectors=
 have
>> >occurred in an array. Then the half-damaged file should be moved aw=
ay from
>> >this area with the bad block by copying it and relinking it, and be=
fore
>> >relinking it to the proper place the good block corresponding to th=
e bad
>> >block should be marked as a corresponding good block on the healthy=
 disk
>> >drive, so that it not be allocated again. This action could even be
>> >triggered by the event of the detection of the bad block. This woul=
d
>> >probably meean that ther need to be a system call to mark a
>> >corresponding good block. The whole thing should be able to run in
>> >userland and somewhat independent of the file system type, except f=
or
>> >the lookup of the corresponding file fram a damaged block.
>>
>> I don't follow this.. if a file has some damaged blocks, they are go=
ne,
>> moving it elsewhere does not help.
>
> Remember the file is in a RAID. So you can lose one disk drive and yo=
ur
> data is still intact.
>
>> And however, this is a task of the filesystem.
>
> No, it is the task of the raid, as it is the raid that gives the
> functionality that you can lose a drive and still have your data inta=
ct.
> the raid level knows what is lost, and =A0what is still good, and whe=
re
> this stuff is.
>
> If we are then operating on the file level, then doing something clev=
er could
> be a cooperation between the raid leven ald the filesystem level, as
> described above.
>
>
>> md is just a block device (more reliable than a single disk due to s=
ome
>> level of redundancy), and it should be indipendent from the kind of =
file
>> system on it (as the file system should be indipendent from the kind=
 of
>> block device it resides on [md, hd, flash, iscsi, ...]).
>
> true
>
>> Then what you suggest should be done for every block device that can
>> have bad blocks (that is, every block device). Again, this is a
>> filesystem issue. And of which file system type, as there are many?
>
> yes, it is a cooperation between the file system layer, and the raid
> layer, I propose this be done in userland.
>
>> The Bad Block Log allows md to behave 'like' a read hard disk would =
do
>> with smart data:
>> - unreadable blocks/stripes are recorded into the log, as unreadable
>> sectors are recorder into smart data
>> - unrecoverable read errors are reported to the caller for both
>> - the device still works if it has unrecoverable read errors for bot=
h
>> (now the whole md device fails, this is the problem)
>> - if a block/stripe if rewritten with success =A0the block/stripe is
>> removed from Bad Block Log (and the counter of relocated blocks/stri=
pes
>> is incremented); as if a sector is rewritten with succes on a disk t=
he
>> sector is removed from list of unreadable sector, and the counter of
>> relocated sector is incremented (smart data)
>
> Smart drives also reallocate bad blocks, hiding the errors from the S=
W
> level.
>
>> A filesystem on a disk does not know what the firmware of the disk d=
oes
>> about sectors relocation.
>> The same applies for a hardware (not fake) raid controller firmware.
>> The same should apply for md. It is transparent to the filesystem.
>
> Yes, normally the raid layer and the fs layer are independent.
>
> But you can add better recovery with what I suggest.
>
>> IMHO a more interesting issue whould be: a write error occurs on a d=
isk
>> participating to an already degraded array; failing the disk would f=
ail
>> the whole array. What to do? Put the array into read only mode, stil=
l
>> allowing read access to data on it for easy backup? In such situatio=
n,
>> what would do a hardware raid controller?
>>
>> Hm, yes.... how do behave hardware raid controllers with uncorrectab=
le
>> read errors?
>> And how they behave with write error on a disk of an already degrade=
d array?
>> I guess md should replicate these behaviours.
>
> I think we should be more intelligent than ordinary HW RAID:-)
>
> Best regards
> keld
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
