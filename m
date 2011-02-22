From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: SSD - TRIM command
Date: Mon, 21 Feb 2011 22:46:34 -0300
Message-ID: <AANLkTinH+2fbEHmO2CNrBtg2MEPCMG3Q-qcsMW5Ccce9@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110222003610.GB29101@bounceswoosh.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Eric D. Mudama" <edmudama@bounceswoosh.org>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Phillip Susi <psusi@cfl.rr.com>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

if it make sense on ssd, harddisk make sense too, it's a block device
like ssd, the diference of ssd/harddisk? access time,
bytes(bits)/block, life time
bad block exist in ssd and harddisk, ssd can realloc online, some hardd=
isks too


> no, because the host may immediately write to a trim'd sector
yes, filesystem know where exists a unused sector
if device (harddisk/ssd) know and have a reallocation algorithm, it
can realloc without telling filesystem to do it (that's why TRIM is
interesting)
since today ssd use NAND (not NOR) the block size isn't 1 bit like a
harddisk head. trim for harddisk only make sense for badblock
reallocation

--------------------------
getting back to the first question, can MD support trim? yes/no/not
now/some levels and layouts only?


2011/2/21 Eric D. Mudama <edmudama@bounceswoosh.org>:
> On Mon, Feb 21 at 20:52, Roberto Spadim wrote:
>>
>> trim tell harddisk that those block are not in use
>
> yes
>
>> not in use block can be used by harddisk reallocation algorithm, lik=
e
>> spare sectors
>
> no, because the host may immediately write to a trim'd sector
>
> The spares in an HDD can never be accessed outside of special tools,
> they're swap-in replacements for regions of the media that have
> developed defects.
>
>> hard disks can use TRIM command to 'create' 'good' blocks like spare
>> sectors
>
> this doesn't make sense to me
>
>
> --
> Eric D. Mudama
> edmudama@bounceswoosh.org
>
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
