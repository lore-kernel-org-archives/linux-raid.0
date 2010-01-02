From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: Raid 5 to 6 reshape q
Date: Sat, 2 Jan 2010 12:19:44 +0000
Message-ID: <73e903671001020419x47a07e69ucb5a01b99dc1fc03@mail.gmail.com>
References: <625563.35920.qm@web51308.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <625563.35920.qm@web51308.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@ehardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jan 2, 2010 at 8:52 AM, Jon Hardcastle <jd_hardcastle@yahoo.com=
> wrote:
> Hi guys, thanks for your help getting me going with this over the las=
t week. I kicked it off last night and all is well.
> ...
> The only Q i have is it seems to be abit slow?
> ...
> md4 : active raid6 sdg1[4] sdf1[0] sde1[1] sdd1[2] sdc1[5] sdb1[3] sd=
a1[6]
> =A0 =A0 =A02441919680 blocks super 0.91 level 6, 64k chunk, algorithm=
 18 [7/6] [UUUUUU_]
> =A0 =A0 =A0[=3D=3D=3D>.................] =A0reshape =3D 17.9% (876008=
96/488383936) finish=3D2881.3min speed=3D2317K/sec

That's very slow. An order of magnitude too slow in my view. I was
initially seeing speeds like this during my recent reshape, but got it
up to around 30MBps. I can't recall exactly what I did to get it
running better - it was the equivalent of giving the television a good
whack - but I seem to recall that increasing the md stripe cache size
helped the most.

I don't currently have access to my work computer where the command
history lives, so this is all I have for now. If I find anything more
to try, I'll chime in.

-- Kristleifur
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
