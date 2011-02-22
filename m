From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: SSD - TRIM command
Date: Tue, 22 Feb 2011 00:29:09 -0300
Message-ID: <AANLkTik4qovN19Kv0q6wa54Cd-xCJBMbN491R4u6nbtX@mail.gmail.com>
References: <AANLkTim6qJRZABYj4y_1sL6xq7y_w-STbaC4MK3U05ug@mail.gmail.com>
	<AANLkTimxTBTGupRk_1nSajjoWBstHdzVVpF4kEN3Y6XU@mail.gmail.com>
	<AANLkTikR+bKrGUCxnsnNz0vJVGOWoPiP0b618sZNBdqU@mail.gmail.com>
	<AANLkTik+xMXqA1+bM=AAhsqtCha-rDcVNr3Qkd-AmbNY@mail.gmail.com>
	<4D62CF5F.6080007@cfl.rr.com>
	<AANLkTimCU_g6hL5TX4-w6TPeFo7Wn0D+=t7iAqJ3MWcS@mail.gmail.com>
	<AANLkTincnob7V3ockg2nqO_ddeZ9UXdigoX5ZwVxocqH@mail.gmail.com>
	<AANLkTimrc0Sn8Mn9AM01rjgT1=4DsU6QLQoS3FA7Kn=8@mail.gmail.com>
	<AANLkTim8fxO3M+jEqgBHvQaxgm+MyaVz670au2wG4MkO@mail.gmail.com>
	<AANLkTim-t+69fcnan8HMsSuq+BCvVn2bfK4CRigO_iHn@mail.gmail.com>
	<20110222003610.GB29101@bounceswoosh.org>
	<AANLkTinH+2fbEHmO2CNrBtg2MEPCMG3Q-qcsMW5Ccce9@mail.gmail.com>
	<AANLkTi=-hJ5SeTsUNT=in0GBNUQB=4uvdumrvuakZXgq@mail.gmail.com>
	<AANLkTim_F1wqvLprPvytVAMLnbDcr71ys-38WcsFpFkB@mail.gmail.com>
	<4D63218F.2000309@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D63218F.2000309@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, "Eric D. Mudama" <edmudama@bounceswoosh.org>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

getting off topic...
----
they have - reallocation
> Bad blocks are only reallocated when you write to them.  Since they a=
re bad,
> you can't read the previous contents anyway, so it does not matter wh=
ether
> the OS cared about it before or not.

when you write, if bad, mark block as bad. how? internal disk memory,
spare blocks. it's a device level problem, if device can't correct
move the problem to filesystem level.

what device level could do? use a 'good block' (if exists) =3D> dynamic
reallocation
'good block' =3D block not in use by filesystem, not marked as bad, can
be used by realloc

with trim, you can inform device firmware what blocks are not in use
by filesystem, if harddisk have reallocation it can use 'good blocks'
to store blocks that was realloc on badblock errors.

why implement it? if you have 11111filesystems mounted with bad blocks
at same time you will have >=3D11111 iops to repair this error at
filesystem level. if device can correct you don't need to waste cpu
and memory at filesystem

------
any layer between ATA and [plate,NAND flash,NOR flash] can be
implemented by harddisk/ssd firmware
some layers that can be implemented: online reallocation, queue,
online encrypt/decrypt, online compress/decompress and others, some
ssd have optimizations to get better life time and write/read
performace
how to 'tune' these algorithms? ATA commands, SCSI or anyother
protocol that support tune

why trim? inform harddisk/ssd what block isn't in use

what harddisk/ssd could do with trim information?
dynamic reallocation (badblocks), any other operation that need not
used blocks (some algorithms use it to get better read/write
performace)
on devices with byte read/write level (NAND flash) we could write to
one timmed block without reading the block and write again, NOR flash
and harddisk don't need this they work with bits not bytes/blocks
why send a error to filesystem if it can be corrected at device level.
just send error when can't correct it.


2011/2/21 Phillip Susi <psusi@cfl.rr.com>:
> On 02/21/2011 08:55 PM, Roberto Spadim wrote:
>>
>> it can be used for badblock reallocation if harddisk have it
>> a harddisk is near to NOR ssd with variable accesstime, if head is
>> near sector to be read/write accesstime is small, if sector is far
>> from head, access time increase (normaly<=3D1 disk revolution if hea=
d
>> control system is good, for 7200rpm 1revolution is near to 8.33ms)
>
> Bad blocks are only reallocated when you write to them. =A0Since they=
 are bad,
> you can't read the previous contents anyway, so it does not matter wh=
ether
> the OS cared about it before or not.
>
> You seem to not understand the fundamental purpose of TRIM. =A0Hard d=
isks only
> reallocate blocks when they go bad. =A0SSDs move blocks around all th=
e time.
> =A0That process can be optimized if the drive knows that the OS does =
not care
> about certain blocks. =A0Hard drives don't do this, so they have no r=
eason to
> support TRIM.
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
