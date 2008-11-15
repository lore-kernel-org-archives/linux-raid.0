From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: mail notification of raid problems on 2.6.12
Date: Sat, 15 Nov 2008 16:23:44 +0100
Message-ID: <20081115152343.GA7822@rap.rap.dk>
References: <20081023133959.GA29695@rap.rap.dk> <20081114154741.GA20271@rap.rap.dk> <491EE295.6060101@panix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <491EE295.6060101@panix.com>
Sender: linux-raid-owner@vger.kernel.org
To: berk walker <berk@panix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Nov 15, 2008 at 09:54:13AM -0500, berk walker wrote:
> Keld J=F8rn Simonsen wrote:
> >On Thu, Oct 23, 2008 at 03:40:00PM +0200, Keld J=F8rn Simonsen wrote=
:
> > =20
> >>Hi list
> >>
> >>how do I get mail notification on kernel 2.6.12, mdadm v1.12.0?
> >>I have looked in the man pages and tried various ways, but
> >>without luck till now.
> >>   =20
> >
> >I got no answers for this. Is it really not possible, or is this
> >irrelevant to this list?
> >
>=20
> Look a bit deeper into mdadm manage -m (mail)  the delivery of the ma=
il,=20
> sound effects, etc need to be excecuted by your system.

Well, --manage -m did not work, mdadm says:

mdadm: option m not valid in manage mode

mdadm - v1.12.0 - 14 June 2005=20
That is the version I run as this is maintained by my OS vendor.

And I did test mdadm --manage -m before asking my first question.

Now mdadm --monitor --scan did not complain about my MAILADDR
line in /etc/mdadm.conf . But I would like to test it, and=20
mdadm --manage -t is not allowed. How do I trigger a message?

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
