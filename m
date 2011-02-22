From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: SSD - TRIM command
Date: Mon, 21 Feb 2011 23:04:38 -0500
Message-ID: <4D6335D6.7000609@cfl.rr.com>
References: <AANLkTim6qJRZABYj4y_1sL6xq7y_w-STbaC4MK3U05ug@mail.gmail.com>	<AANLkTimxTBTGupRk_1nSajjoWBstHdzVVpF4kEN3Y6XU@mail.gmail.com>	<AANLkTikR+bKrGUCxnsnNz0vJVGOWoPiP0b618sZNBdqU@mail.gmail.com>	<AANLkTik+xMXqA1+bM=AAhsqtCha-rDcVNr3Qkd-AmbNY@mail.gmail.com>	<4D62CF5F.6080007@cfl.rr.com>	<AANLkTimCU_g6hL5TX4-w6TPeFo7Wn0D+=t7iAqJ3MWcS@mail.gmail.com>	<AANLkTincnob7V3ockg2nqO_ddeZ9UXdigoX5ZwVxocqH@mail.gmail.com>	<AANLkTimrc0Sn8Mn9AM01rjgT1=4DsU6QLQoS3FA7Kn=8@mail.gmail.com>	<AANLkTim8fxO3M+jEqgBHvQaxgm+MyaVz670au2wG4MkO@mail.gmail.com>	<AANLkTim-t+69fcnan8HMsSuq+BCvVn2bfK4CRigO_iHn@mail.gmail.com>	<20110222003610.GB29101@bounceswoosh.org>	<AANLkTinH+2fbEHmO2CNrBtg2MEPCMG3Q-qcsMW5Ccce9@mail.gmail.com>	<AANLkTi=-hJ5SeTsUNT=in0GBNUQB=4uvdumrvuakZXgq@mail.gmail.com>	<AANLkTim_F1wqvLprPvytV
 AMLnbDcr71ys-38WcsFpFkB@mail.gmail.com>	<4D63218F.2000309@cfl.rr.com> <AANLkTik4qovN19Kv0q6wa54Cd-xCJBMbN491R4u6nbtX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik4qovN19Kv0q6wa54Cd-xCJBMbN491R4u6nbtX@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, "Eric D. Mudama" <edmudama@bounceswoosh.org>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/21/2011 10:29 PM, Roberto Spadim wrote:
> what device level could do? use a 'good block' (if exists) =>  dynamic
> reallocation
> 'good block' = block not in use by filesystem, not marked as bad, can
> be used by realloc

No.  It can only use blocks reserved for spares at manufacture time.  It 
can not use any old block that the fs is not using at the time, because 
the fs may choose to use it in the future.
