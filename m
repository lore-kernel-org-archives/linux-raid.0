From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: mail notification of raid problems on 2.6.12
Date: Sat, 15 Nov 2008 17:06:35 +0100
Message-ID: <20081115160635.GA8176@rap.rap.dk>
References: <20081023133959.GA29695@rap.rap.dk> <20081114154741.GA20271@rap.rap.dk> <491EE295.6060101@panix.com> <20081115152343.GA7822@rap.rap.dk> <1f0f1a960811150741s5a44210cw2867f41444b33081@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1f0f1a960811150741s5a44210cw2867f41444b33081@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Twigathy <twigathy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Nov 15, 2008 at 03:41:43PM +0000, Twigathy wrote:
> >From the mdadm manpage, you need to do "mdadm --monitor --test --sca=
n"
> (Or possible an md device name) to get it to send you some test mails=
=2E
> I just checked it on my ubuntu server machine and it performs as
> expected with the following software:
> kernel 2.6.24-21-generic
> mdadm - v2.6.3 - 20th August 2007 (Yikes! That's pretty old. I really
> ought to dist-upgrade!)

Thanks, that worked, even on my old old setup.

I will add info on this on the wiki.

Best regards
keld

> Tom
>=20
> 2008/11/15 Keld J=F8rn Simonsen <keld@dkuug.dk>:
> > On Sat, Nov 15, 2008 at 09:54:13AM -0500, berk walker wrote:
> >> Keld J=F8rn Simonsen wrote:
> >> >On Thu, Oct 23, 2008 at 03:40:00PM +0200, Keld J=F8rn Simonsen wr=
ote:
> >> >
> >> >>Hi list
> >> >>
> >> >>how do I get mail notification on kernel 2.6.12, mdadm v1.12.0?
> >> >>I have looked in the man pages and tried various ways, but
> >> >>without luck till now.
> >> >>
> >> >
> >> >I got no answers for this. Is it really not possible, or is this
> >> >irrelevant to this list?
> >> >
> >>
> >> Look a bit deeper into mdadm manage -m (mail)  the delivery of the=
 mail,
> >> sound effects, etc need to be excecuted by your system.
> >
> > Well, --manage -m did not work, mdadm says:
> >
> > mdadm: option m not valid in manage mode
> >
> > mdadm - v1.12.0 - 14 June 2005
> > That is the version I run as this is maintained by my OS vendor.
> >
> > And I did test mdadm --manage -m before asking my first question.
> >
> > Now mdadm --monitor --scan did not complain about my MAILADDR
> > line in /etc/mdadm.conf . But I would like to test it, and
> > mdadm --manage -t is not allowed. How do I trigger a message?
> >
> > Best regards
> > keld
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
