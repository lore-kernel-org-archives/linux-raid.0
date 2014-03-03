From: =?iso-8859-1?Q?Jan_Kundr=E1t?= <jkt@flaska.net>
Subject: Re: External USB-SATA bridge rewriting logical block sizes
Date: Mon, 03 Mar 2014 16:18:12 +0100
Message-ID: <29626b57-c751-4ba7-8774-b45fc090b4b6@flaska.net>
References: <f533c037-b72b-4039-9ef7-f2c61a0de3e6@flaska.net>
 <53149110.7090008@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53149110.7090008@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday, 3 March 2014 15:26:24 CEST, Stan Hoeppner wrote:
> Presumably you have some md raid level with fault tolerance, since yo=
u
> posted this to the linux-raid list.  Why not simply kick the drive fr=
om
> the array, install it "direct" inside the chassis, repartition it the
> same as the other members of the array that are direct connected to t=
he
> SATA controller, re-add the partition to the array, and rebuild.

Hi Stan, I don't run RAID on these machines. I saw a recent thread deal=
ing=20
with 4k drives on this ML which made me hope that this topic won't be=20
considered OT here. Sorry if this is not appropriate -- do you happen t=
o=20
know a more suitable ML?

> Why you prepped this drive in it with intention of moving it into the=
 PC=20
> chassis leaves me scratching my head.

My primary machine is a T420s laptop which has a USB3 port, but no eSAT=
A.=20
The throughput I can get from a drive attached there is much better tha=
n=20
what I can get via network from my other box with plenty of SATA ports,=
 but=20
only a VIA C7 CPU (even though it has a gigabit NIC). Expected, I guess=
=2E

Another aspect is energy saving -- the tiny power plug which comes with=
 the=20
USB dock eats less than the other PC.

> Is this some habit you developed years ago?  Prepping a new drive
> in a USB before permanently installing it in the chassis?  If so, I'd
> recommend using a hot swap SATA chassis that installs in a 5.25" driv=
e
> bay instead.  They're $15-30 USD, cheaper, and more reliable, than a =
USB
> dock, by far.

Yes, that's what I use for the direct connection. 100% passive, very=20
reliable, appears to be robust, mechanically. However, I cannot connect=
=20
that to the laptop where I do most of my work. I do have a dock, so it'=
s=20
very convenient and ergonomic, but the IO options are a bit limited on =
this=20
model.

Cheers,
Jan

--=20
Trojit=C3=A1, a fast Qt IMAP e-mail client -- http://trojita.flaska.net=
/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
