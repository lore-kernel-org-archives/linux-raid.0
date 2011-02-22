From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: SSD - TRIM command
Date: Tue, 22 Feb 2011 00:42:03 -0300
Message-ID: <AANLkTinFBdsJnLYJnmZR6RsboRx6usEKDhYJg81eAZu4@mail.gmail.com>
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
	<AANLkTik4qovN19Kv0q6wa54Cd-xCJBMbN491R4u6nbtX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik4qovN19Kv0q6wa54Cd-xCJBMbN491R4u6nbtX@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, "Eric D. Mudama" <edmudama@bounceswoosh.org>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

off topic again...

continue with the idea of optimizations, the last otimization we could
have is implement a filesystem at harddisk
it could implement all filesystem functions, no device function, it
could have many more information about data, not only block 'in
use'/'not in use'. it could understand: file starting at block x
ending at block y, with information w, accestime z, etc etc. it could
be more intelligent than a raw device. in others words, it's a
fileserver...

why implement algorithms at device level? today harddisk processors
(fpga, arm processors, others) have a lot of cpu power not in use, why
not use it? that's why we send trim to device, if it's a harddisk or
ssd or anyother pseudo/real device no problem, we sent the trim
command to otimize it

----------------
getting out of off topic,

please stop sending 'i think it's not a performace feature, it don't
need be implemented in device level', let's implement all functions
that device level could allow (ATA/SCSI specifications or any other)
and optimize when possible
checking neil md roadmap, badblock work will be very good for md
devices, it's a good optimization for raid1 since mirror will only
fail when many blocks fail



can we implement TRIM at MD level? it's a good feature to implement?
we will have a lot of work to implement it?
my opnion
we can, on some raid levels
it's a good feature
we will have a lot of work to implement and test


any answer from raid developers?


-- 
Roberto Spadim
Spadim Technology / SPAEmpresarial
