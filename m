From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: What's the typical RAID10 setup?
Date: Wed, 02 Feb 2011 21:05:36 -0600
Message-ID: <4D4A1B80.2090203@hardwarefreak.com>
References: <ii8lcv$3jg$1@dough.gmane.org>	<AANLkTin1MPYZGMuL75c=_q+ndeiz0F5+eCRudpDdTwu9@mail.gmail.com>	<4D4883A3.6030605@hardwarefreak.com>	<AANLkTikcOA3hSwx29H++sayJ4PcY00_mQBw91TyYXO05@mail.gmail.com>	<20110202092508.GA18517@cthulhu.home.robinhill.me.uk>	<AANLkTikjKp0C6TnT7TeGRBayS=dYONWNrb-9NA71tDSe@mail.gmail.com>	<AANLkTi=p_ke0pJhpGBgfbL8Mw9pPtAdKSRLa_AxncGWs@mail.gmail.com>	<AANLkTink1BTeCCewZe-TywWLQAqhi0=aBF4wnSnGJh7y@mail.gmail.com>	<AANLkTim5Y3E0=DwBRU2Tk31R-1XNXKv50ZAzpPg73Fy0@mail.gmail.com>	<AANLkTinUMni5rNWKnc9CTH5rdaV83BQYHG=fikf9QqEV@mail.gmail.com>	<20110202194456.GA15080@www2.open-std.org> <AANLkTin5o5gqogn5xHUfGpCV55D=76efpJQWs3Wmx+D8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin5o5gqogn5xHUfGpCV55D=76efpJQWs3Wmx+D8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>, Jon Nelson <jnelson-linux-raid@jamponi.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roberto Spadim put forth on 2/2/2011 2:28 PM:

> i don=B4t think, since head, is just for hard disk (rotational) not f=
or
> solid state disks, let=B4s not talk about ssd, just hard disk? a raid
> with 5000rpm  and 10000rpm disk, we will have better i/o read with

Anyone who would mix drives of such disparate spindle speeds within the=
 same
array is not concerned with performance.  Anyone who has read enough to=
 create
their first array knows better than to do this.

Why waste effort to optimize such a horrible design decision?

> 10000rpm ? we don=B4t know the model of i/o for that device, but
> probally will be faster, but when it=B4s busy we could use 5000rpm...
> that=B4s the point, just closest head don=B4t help, we need know what=
=B4s
> the queue (list of i/o being processed) and the time to read the
> current i/o

This is just silly.

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
