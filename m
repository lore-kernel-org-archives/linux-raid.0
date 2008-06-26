From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: Slowww raid check (raid10, f2)
Date: Thu, 26 Jun 2008 15:03:56 -0500
Message-ID: <cccedfc60806261303u3a614680xa3e8a0c636452e42@mail.gmail.com>
References: <cccedfc60806260621ud3af517j959f5ce3c2e521ef@mail.gmail.com>
	 <20080626140726.GB5462@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080626140726.GB5462@rap.rap.dk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jun 26, 2008 at 9:07 AM, Keld J=F8rn Simonsen <keld@dkuug.dk> w=
rote:

> It could be random IO, sort of. I am not sure how the checking is don=
e,
> but if it does it in sequential block order there will be a lot of
> head moving because of the striping layout of raid10,f2.

That's exactly what I was thinking. When I get some time, perhaps I'll
dig into the source.

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
