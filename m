From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Thu, 3 Feb 2011 01:13:41 -0200
Message-ID: <AANLkTim6=EFaWFZURc_JD8478QYgROk_hZsZCA0FE=EC@mail.gmail.com>
References: <ii8lcv$3jg$1@dough.gmane.org>
	<AANLkTin1MPYZGMuL75c=_q+ndeiz0F5+eCRudpDdTwu9@mail.gmail.com>
	<4D4883A3.6030605@hardwarefreak.com>
	<AANLkTikcOA3hSwx29H++sayJ4PcY00_mQBw91TyYXO05@mail.gmail.com>
	<20110202092508.GA18517@cthulhu.home.robinhill.me.uk>
	<AANLkTikjKp0C6TnT7TeGRBayS=dYONWNrb-9NA71tDSe@mail.gmail.com>
	<AANLkTi=p_ke0pJhpGBgfbL8Mw9pPtAdKSRLa_AxncGWs@mail.gmail.com>
	<AANLkTink1BTeCCewZe-TywWLQAqhi0=aBF4wnSnGJh7y@mail.gmail.com>
	<AANLkTim5Y3E0=DwBRU2Tk31R-1XNXKv50ZAzpPg73Fy0@mail.gmail.com>
	<AANLkTinUMni5rNWKnc9CTH5rdaV83BQYHG=fikf9QqEV@mail.gmail.com>
	<20110202194456.GA15080@www2.open-std.org>
	<AANLkTin5o5gqogn5xHUfGpCV55D=76efpJQWs3Wmx+D8@mail.gmail.com>
	<4D4A1B80.2090203@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D4A1B80.2090203@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>, Jon Nelson <jnelson-linux-raid@jamponi.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Anyone who would mix drives of such disparate spindle speeds within t=
he same
> array is not concerned with performance.  Anyone who has read enough =
to create
> their first array knows better than to do this.
i don't think that... let's talk about internet link? we can have two
internet links (1 radio, 1 adsl or another), with linux i can load
balance based on network band use, round robin, and many others ideas
it's same for raid1, except, write speed =3D slowest write speed, for
read we can get highers speed (with raid1 we can have same speed than
raid0, or, we should...)

> Why waste effort to optimize such a horrible design decision?
a horrible design decision:
two 1TB ssd with 1,5GB/s and two 1TB  ssd with 2,0GB/s (can be from
texas... or ocz...)
using raid1, it's a horrible design?
or... for hard disks
two 1tb sas with 300MB/s and two 1tb sas with 250MB/s (i never get
more speed than 300mb/s with hard disks)
is it a horrible design?

> This is just silly.
no, it's a option, we could use round robin, near head, and another
read balance algorithms, the closest to read world the faster we get

now it's true for raid1: write speed is poor (that's why we use raid10)
but read can be as fast as raid0 .... even faster since all disks have
the same information... what we need is a good read balance algorithm
(i think for a non balanced array, a time based is the best option...)

2011/2/3 Stan Hoeppner <stan@hardwarefreak.com>:
> Roberto Spadim put forth on 2/2/2011 2:28 PM:
>
>> i don=B4t think, since head, is just for hard disk (rotational) not =
for
>> solid state disks, let=B4s not talk about ssd, just hard disk? a rai=
d
>> with 5000rpm =A0and 10000rpm disk, we will have better i/o read with
>
> Anyone who would mix drives of such disparate spindle speeds within t=
he same
> array is not concerned with performance. =A0Anyone who has read enoug=
h to create
> their first array knows better than to do this.
>
> Why waste effort to optimize such a horrible design decision?
>
>> 10000rpm ? we don=B4t know the model of i/o for that device, but
>> probally will be faster, but when it=B4s busy we could use 5000rpm..=
=2E
>> that=B4s the point, just closest head don=B4t help, we need know wha=
t=B4s
>> the queue (list of i/o being processed) and the time to read the
>> current i/o
>
> This is just silly.
>
> --
> Stan
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
