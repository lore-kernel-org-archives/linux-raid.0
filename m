From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: SSD - TRIM command
Date: Mon, 21 Feb 2011 21:38:07 -0500
Message-ID: <4D63218F.2000309@cfl.rr.com>
References: <AANLkTim6qJRZABYj4y_1sL6xq7y_w-STbaC4MK3U05ug@mail.gmail.com>	<AANLkTimxTBTGupRk_1nSajjoWBstHdzVVpF4kEN3Y6XU@mail.gmail.com>	<AANLkTikR+bKrGUCxnsnNz0vJVGOWoPiP0b618sZNBdqU@mail.gmail.com>	<AANLkTik+xMXqA1+bM=AAhsqtCha-rDcVNr3Qkd-AmbNY@mail.gmail.com>	<4D62CF5F.6080007@cfl.rr.com>	<AANLkTimCU_g6hL5TX4-w6TPeFo7Wn0D+=t7iAqJ3MWcS@mail.gmail.com>	<AANLkTincnob7V3ockg2nqO_ddeZ9UXdigoX5ZwVxocqH@mail.gmail.com>	<AANLkTimrc0Sn8Mn9AM01rjgT1=4DsU6QLQoS3FA7Kn=8@mail.gmail.com>	<AANLkTim8fxO3M+jEqgBHvQaxgm+MyaVz670au2wG4MkO@mail.gmail.com>	<AANLkTim-t+69fcnan8HMsSuq+BCvVn2bfK4CRigO_iHn@mail.gmail.com>	<20110222003610.GB29101@bounceswoosh.org>	<AANLkTinH+2fbEHmO2CNrBtg2MEPCMG3Q-qcsMW5Ccce9@mail.gmail.com>	<AANLkTi=-hJ5SeTsUNT=in0GBNUQB=4uvdumrvuakZXgq@mail.gmail.com> <AANLkTim_F1wqvLprPvytV
 AMLnbDcr71ys-38WcsFpFkB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim_F1wqvLprPvytVAMLnbDcr71ys-38WcsFpFkB@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, "Eric D. Mudama" <edmudama@bounceswoosh.org>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/21/2011 08:55 PM, Roberto Spadim wrote:
> it can be used for badblock reallocation if harddisk have it
> a harddisk is near to NOR ssd with variable accesstime, if head is
> near sector to be read/write accesstime is small, if sector is far
> from head, access time increase (normaly<=1 disk revolution if head
> control system is good, for 7200rpm 1revolution is near to 8.33ms)

Bad blocks are only reallocated when you write to them.  Since they are 
bad, you can't read the previous contents anyway, so it does not matter 
whether the OS cared about it before or not.

You seem to not understand the fundamental purpose of TRIM.  Hard disks 
only reallocate blocks when they go bad.  SSDs move blocks around all 
the time.  That process can be optimized if the drive knows that the OS 
does not care about certain blocks.  Hard drives don't do this, so they 
have no reason to support TRIM.
