From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: SSD - TRIM command
Date: Mon, 21 Feb 2011 23:27:26 -0300
Message-ID: <AANLkTi=910JELnSik=pGiN9Yz0YVUNLyWCmJSiFZotSM@mail.gmail.com>
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
	<FA27C2E0242645B795811DDF282BFA05@m5>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FA27C2E0242645B795811DDF282BFA05@m5>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <linux-raid@watkins-home.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

tape drive =3D harddisk with only one head, the head can't move, only
the tape (disk/plate or any other name you want)

could we get back and answer the main question?
--------------------------
getting back to the first question, can MD support trim? yes/no/not
now/some levels and layouts only?


2011/2/21 Guy Watkins <linux-raid@watkins-home.com>:
> } -----Original Message-----
> } From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> } owner@vger.kernel.org] On Behalf Of Mikael Abrahamsson
> } Sent: Monday, February 21, 2011 9:02 PM
> } To: linux-raid@vger.kernel.org
> } Subject: Re: SSD - TRIM command
> }
> } On Mon, 21 Feb 2011, Roberto Spadim wrote:
> }
> } > it can be used for badblock reallocation if harddisk have it a ha=
rddisk
> } > is near to NOR ssd with variable accesstime, if head is near sect=
or to
> } > be read/write accesstime is small, if sector is far from head, ac=
cess
> } > time increase (normaly <=3D1 disk revolution if head control syst=
em is
> } > good, for 7200rpm 1revolution is near to 8.33ms)
> }
> } Could we please stop this discussion. If you think HDDs should have=
 this
> } kind of bad sector reallocation scheme, please go to the HDD manufa=
cturers
> } and lobby to them. It is not on-topic for linux-raid ml.
> }
> } --
> } Mikael Abrahamsson =A0 =A0email: swmike@swm.pp.se
>
> What about tape drives? =A0:)
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
