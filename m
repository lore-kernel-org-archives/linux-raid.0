From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: SSD - TRIM command
Date: Tue, 22 Feb 2011 01:37:38 -0300
Message-ID: <AANLkTimdWwW6c2J7q5_nUabX=kWCbSbbh0MA41trSqdH@mail.gmail.com>
References: <AANLkTim6qJRZABYj4y_1sL6xq7y_w-STbaC4MK3U05ug@mail.gmail.com>
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
	<AANLkTi=910JELnSik=pGiN9Yz0YVUNLyWCmJSiFZotSM@mail.gmail.com>
	<20110222144540.7cd53e7d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110222144540.7cd53e7d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Guy Watkins <linux-raid@watkins-home.com>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

thanks neil, i will try to read and make some patch, my focus is ssd
optimization, at hardware level (hw raid) i didn't see any good
improvement
good =3D a good read balance (based on queue and disk read rate), trim =
support

----
good read balance =3D round robin or another time based algorithm (can
be cpu intensive), i didn't found yet how to get queue of linux bio
(mirrors)
trim support - nothing to report, it's a 'feature request' for long
term (after badblock and others features)

-----

ps...
neil what are you thinking about badblock and layout?
for example... reading from a bad block will be internaly (md source
code) remapped to a good block? or just try read/write to another
device?

in other words we will have 'dynamic' layout?


2011/2/22 NeilBrown <neilb@suse.de>:
> On Mon, 21 Feb 2011 23:27:26 -0300 Roberto Spadim <roberto@spadim.com=
=2Ebr>
> wrote:
>
>> tape drive =3D harddisk with only one head, the head can't move, onl=
y
>> the tape (disk/plate or any other name you want)
>>
>> could we get back and answer the main question?
>> --------------------------
>> getting back to the first question, can MD support trim? yes/no/not
>> now/some levels and layouts only?
>>
>
> MD currently doesn't accept 'discard' requests.
>
> RAID0 and LINEAR could be made to accept 'discard' if any
> member device accepted 'discard'. =A0Patches welcome.
>
> Other levels need md to know not to try to resync/recover regions tha=
t
> have been discarded. =A0See "non-sync bitmap" section of the recent
> md roadmap.
>
> NeilBrown
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
