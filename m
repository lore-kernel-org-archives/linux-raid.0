From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: SSD - TRIM command
Date: Tue, 22 Feb 2011 01:52:22 +0000
Message-ID: <AANLkTi=-hJ5SeTsUNT=in0GBNUQB=4uvdumrvuakZXgq@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinH+2fbEHmO2CNrBtg2MEPCMG3Q-qcsMW5Ccce9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: "Eric D. Mudama" <edmudama@bounceswoosh.org>, Phillip Susi <psusi@cfl.rr.com>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22 February 2011 01:46, Roberto Spadim <roberto@spadim.com.br> wrote:
> if it make sense on ssd, harddisk make sense too, it's a block device
> like ssd, the diference of ssd/harddisk? access time,
> bytes(bits)/block, life time
> bad block exist in ssd and harddisk, ssd can realloc online, some harddisks too
>
>> no, because the host may immediately write to a trim'd sector
> yes, filesystem know where exists a unused sector
> if device (harddisk/ssd) know and have a reallocation algorithm, it
> can realloc without telling filesystem to do it (that's why TRIM is
> interesting)
> since today ssd use NAND (not NOR) the block size isn't 1 bit like a
> harddisk head. trim for harddisk only make sense for badblock
> reallocation
> --------------------------
> getting back to the first question, can MD support trim? yes/no/not
> now/some levels and layouts only?
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial

This explains a bit why trim is good for SSDs and has nothing to do
with harddrives at all, since they use spinning platters and not
chips. http://www.anandtech.com/show/2738/10

// Mathias
