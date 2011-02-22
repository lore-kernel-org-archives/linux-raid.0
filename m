From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: SSD - TRIM command
Date: Mon, 21 Feb 2011 22:55:24 -0300
Message-ID: <AANLkTim_F1wqvLprPvytVAMLnbDcr71ys-38WcsFpFkB@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=-hJ5SeTsUNT=in0GBNUQB=4uvdumrvuakZXgq@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: "Eric D. Mudama" <edmudama@bounceswoosh.org>, Phillip Susi <psusi@cfl.rr.com>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

it can be used for badblock reallocation if harddisk have it
a harddisk is near to NOR ssd with variable accesstime, if head is
near sector to be read/write accesstime is small, if sector is far
from head, access time increase (normaly <=3D1 disk revolution if head
control system is good, for 7200rpm 1revolution is near to 8.33ms)

2011/2/21 Mathias Bur=E9n <mathias.buren@gmail.com>:
> On 22 February 2011 01:46, Roberto Spadim <roberto@spadim.com.br> wro=
te:
>> if it make sense on ssd, harddisk make sense too, it's a block devic=
e
>> like ssd, the diference of ssd/harddisk? access time,
>> bytes(bits)/block, life time
>> bad block exist in ssd and harddisk, ssd can realloc online, some ha=
rddisks too
>>
>>> no, because the host may immediately write to a trim'd sector
>> yes, filesystem know where exists a unused sector
>> if device (harddisk/ssd) know and have a reallocation algorithm, it
>> can realloc without telling filesystem to do it (that's why TRIM is
>> interesting)
>> since today ssd use NAND (not NOR) the block size isn't 1 bit like a
>> harddisk head. trim for harddisk only make sense for badblock
>> reallocation
>> --------------------------
>> getting back to the first question, can MD support trim? yes/no/not
>> now/some levels and layouts only?
>> --
>> Roberto Spadim
>> Spadim Technology / SPAEmpresarial
>
> This explains a bit why trim is good for SSDs and has nothing to do
> with harddrives at all, since they use spinning platters and not
> chips. http://www.anandtech.com/show/2738/10
>
> // Mathias
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
