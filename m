From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Raid 5 to 6 reshape q
Date: Sun, 3 Jan 2010 10:07:50 -0800 (PST)
Message-ID: <657593.18711.qm@web51308.mail.re2.yahoo.com>
References: <73e903671001020419x47a07e69ucb5a01b99dc1fc03@mail.gmail.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903671001020419x47a07e69ucb5a01b99dc1fc03@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@ehardcastle.com, =?iso-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids




--- On Sat, 2/1/10, Kristleifur Da=F0ason <kristleifur@gmail.com> wrote=
:

> From: Kristleifur Da=F0ason <kristleifur@gmail.com>
> Subject: Re: Raid 5 to 6 reshape q
> To: Jon@ehardcastle.com
> Cc: linux-raid@vger.kernel.org
> Date: Saturday, 2 January, 2010, 12:19
> On Sat, Jan 2, 2010 at 8:52 AM, Jon
> Hardcastle <jd_hardcastle@yahoo.com>
> wrote:
> > Hi guys, thanks for your help getting me going with
> this over the last week. I kicked it off last night and all
> is well.
> > ...
> > The only Q i have is it seems to be abit slow?
> > ...
> > md4 : active raid6 sdg1[4] sdf1[0] sde1[1] sdd1[2]
> sdc1[5] sdb1[3] sda1[6]
> > =A0 =A0 =A02441919680 blocks super 0.91 level 6, 64k
> chunk, algorithm 18 [7/6] [UUUUUU_]
> > =A0 =A0 =A0[=3D=3D=3D>.................] =A0reshape =3D 17.9%
> (87600896/488383936) finish=3D2881.3min speed=3D2317K/sec
>=20
> That's very slow. An order of magnitude too slow in my
> view. I was
> initially seeing speeds like this during my recent reshape,
> but got it
> up to around 30MBps. I can't recall exactly what I did to
> get it
> running better - it was the equivalent of giving the
> television a good
> whack - but I seem to recall that increasing the md stripe
> cache size
> helped the most.
>=20
> I don't currently have access to my work computer where the
> command
> history lives, so this is all I have for now. If I find
> anything more
> to try, I'll chime in.
>=20
> -- Kristleifur
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html
>=20

Well it is trundling along at about that speed still if only i had know=
 that if i was adding 2 drives it would be much quciker as i plan to ad=
d another drive at the end of the week! i figured it was more to potent=
ially go wrong!

Anyways if you can suggest any commands that might speed it up i'd be v=
ery grateful!


-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its ow=
n.'

***********
Please note, I am phasing out jd_hardcastle AT yahoo.com and replacing =
it with jon AT eHardcastle.com
***********

-----------------------


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
