From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: What's the typical RAID10 setup?
Date: Fri, 4 Feb 2011 23:05:07 +0100
Message-ID: <20110204220507.GA6876@www2.open-std.org>
References: <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com> <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com> <4D475AB5.10600@hardwarefreak.com> <20110203110428.GA26762@www2.open-std.org> <4D4B3DAE.3070502@hardwarefreak.com> <20110204070613.GA3788@www2.open-std.org> <4D4BB87A.30800@hardwarefreak.com> <20110204090602.GA4017@www2.open-std.org> <20110204204251.GB6603@www2.open-std.org> <4D4C6C7B.2020304@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D4C6C7B.2020304@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>, Jon Nelson <jnelson-linux-raid@jamponi.net>, Mathias =?iso-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>, Roberto Spadim <roberto@spadim.com.br>, Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Feb 04, 2011 at 03:15:39PM -0600, Stan Hoeppner wrote:
> Keld J=F8rn Simonsen put forth on 2/4/2011 2:42 PM:
>=20
> >>> So apparently their Disk Data Format specification doesn't includ=
e hybrid RAID
> >>> levels.  This makes sense, as the _on disk_ layout of RAID 10 is =
identical to
> >>> RAID 1.
> >=20
> > I was puzzled here. I think you mean:
> >=20
> > "the _on disk_ layout of RAID 10 is identical to RAID 1 and RAID 0"
> >=20
> > If that is what you meant, I think we agree on most things here.
>=20
> I set a trap for you, of sorts. ;)

And I deliberately fell into your trap, tongue in cheek:-)

Maybe we should avoid traps and fooling around in them, as it
just confuses others and waistes our time. I do think there are valid
points coming out of our discussion here. I have tried to avoid your
ad hominem remarks and traps, and just try to be constructive.

> If what you say is true, then RAID 10 should
> be covered in the DDF, as migration from one device to another isn't =
possible
> without the RAID 10 on disk layout being defined in the DDF as with a=
ll the
> other RAID levels.  True?

I am a little puzzled with what you mean here. RAID 1+0 is covered
in DDF 2.0 as a description of RAID-1 or RAID-1E , and then striping it
according to 4.3.1 . I do think they should add something about calling
it RAID 1+0 or maybe RAID-1E+0 or some such. And then explain something
about the term "RAID10" and why you should rather call it
RAID-1+0 or RAID-1E+0, to indicate it is a Secondary RAID level, and
to avoid ambiguity.=20

I have given some remarks on RAID10 on=20
http://www.snia.org/tech_activities/feedback/

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
