From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: SSD - TRIM command
Date: Mon, 21 Feb 2011 21:22:35 -0500
Message-ID: <FA27C2E0242645B795811DDF282BFA05@m5>
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
 <alpine.DEB.1.10.1102220300400.11974@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <alpine.DEB.1.10.1102220300400.11974@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mikael Abrahamsson' <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Mikael Abrahamsson
} Sent: Monday, February 21, 2011 9:02 PM
} To: linux-raid@vger.kernel.org
} Subject: Re: SSD - TRIM command
} 
} On Mon, 21 Feb 2011, Roberto Spadim wrote:
} 
} > it can be used for badblock reallocation if harddisk have it a harddisk
} > is near to NOR ssd with variable accesstime, if head is near sector to
} > be read/write accesstime is small, if sector is far from head, access
} > time increase (normaly <=1 disk revolution if head control system is
} > good, for 7200rpm 1revolution is near to 8.33ms)
} 
} Could we please stop this discussion. If you think HDDs should have this
} kind of bad sector reallocation scheme, please go to the HDD manufacturers
} and lobby to them. It is not on-topic for linux-raid ml.
} 
} --
} Mikael Abrahamsson    email: swmike@swm.pp.se

What about tape drives?  :)

