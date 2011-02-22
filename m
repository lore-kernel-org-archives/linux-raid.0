From: Brendan Conoboy <blc@redhat.com>
Subject: Re: SSD - TRIM command
Date: Mon, 21 Feb 2011 16:30:05 -0800
Message-ID: <4D63038D.6060904@redhat.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>	<4D517F4F.4060003@gmail.com>	<4D5245DF.4020401@hardwarefreak.com>	<iiu4rc$9ju$1@dough.gmane.org>	<AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>	<iiud2r$qci$1@dough.gmane.org>	<4D62ACFE.4020401@cfl.rr.com>	<AANLkTim6qJRZABYj4y_1sL6xq7y_w-STbaC4MK3U05ug@mail.gmail.com>	<AANLkTimxTBTGupRk_1nSajjoWBstHdzVVpF4kEN3Y6XU@mail.gmail.com>	<AANLkTikR+bKrGUCxnsnNz0vJVGOWoPiP0b618sZNBdqU@mail.gmail.com>	<AANLkTik+xMXqA1+bM=AAhsqtCha-rDcVNr3Qkd-AmbNY@mail.gmail.com>	<4D62CF5F.6080007@cfl.rr.com>	<AANLkTimCU_g6hL5TX4-w6TPeFo7Wn0D+=t7iAqJ3MWcS@mail.gmail.com>	<AANLkTincnob7V3ockg2nqO_ddeZ9UXdigoX5ZwVxocqH@mail.gmail.com>	<AANLkTimrc0Sn8Mn9AM01rjgT1=4DsU6QLQoS3FA7Kn=8@mail.gmail.com>	<AANLkTim8fxO3M+jEqgBHvQaxgm+MyaV
 z670au2wG4MkO@mail.gmail.com> <AANLkTim-t+69fcnan8HMsSuq+BCvVn2bfK4CRigO_iHn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim-t+69fcnan8HMsSuq+BCvVn2bfK4CRigO_iHn@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Phillip Susi <psusi@cfl.rr.com>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/21/2011 03:52 PM, Roberto Spadim wrote:
> trim tell harddisk that those block are not in use
>
> not in use block can be used by harddisk reallocation algorithm, like
> spare sectors
>
> hard disks can use TRIM command to 'create' 'good' blocks like spare sectors

I'm trying really hard to follow what this means but just can't grasp 
what you're getting at.  What scenario is there in which trim actually 
does anything for you on an HD?  I can't think of any situation where 
this makes any sense for HDs with current firmware functionality.  If a 
sector is unused, but bad, you won't know until you write to it.  If 
it's bad and you write to it, the write gets reallocated to a good spare 
sector.  Are you proposing to notify the drive what sectors are unused 
so it can check for and reallocate bad blocks before they're used again? 
  Something else?

-- 
Brendan Conoboy / Red Hat, Inc. / blc@redhat.com
