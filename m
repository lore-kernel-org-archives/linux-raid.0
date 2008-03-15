From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: software for making initrd's with raid support
Date: Sat, 15 Mar 2008 13:38:06 +0100
Message-ID: <20080315123806.GA20418@rap.rap.dk>
References: <20080312235641.GA7109@rap.rap.dk> <20080313111538.GB4229@percy.comedia.it> <20080313130042.GA11858@rap.rap.dk> <20080314081516.GB12274@percy.comedia.it> <20080314133045.GB13616@rap.rap.dk> <20080315114912.GA11426@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080315114912.GA11426@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Mar 15, 2008 at 12:49:13PM +0100, Luca Berra wrote:
> On Fri, Mar 14, 2008 at 02:30:45PM +0100, Keld J=F8rn Simonsen wrote:
> >>>Good!  I was working on a mandriva professional 2006 system 2.6.12
> >>2006.0 is EOL
> >
> >2006.0 professional is maintained to 2011
>=20
> you mean cd4?

I mean Corporate Server 4 - cs4.

> >>>kernel, and I hacked the mkinitrd to have it generate mdadm.conf e=
tc
> >>>- it did not at all look at this. I can send you my patches, but t=
hey
> >>> are in no way clean.
> >>mkinitrd in 2006.0 did generate mdadm.conf and use it, so i don't k=
now
> >>what your patches were doing.
> >
> >the code to generate mdadm.conf was not activated. I made some patch=
es
> >to force raid code generation.
>=20
> really?
> if this is the case you should have submitted a bug report.

It is possible that I do. I would like to find out what to do first,
however.

> >>>There was no mention of raid10 in the code either.
> >>yes support for raid10 was added after 2006.0 release
> >>
> >>>I thied to contact Erik Troan - the main author of mkinitrd (and l=
ots of
> >>>other stuff:-) - but got a bouncing message for his redhat address=
=2E
> >>i think Erik does not maintain mkinitrd any more, it is quite an ol=
d
> >>software.
> >
> >OK, who maintains it now, and is mkinitrd still a viable - perhaps t=
he
> >best - way to make initrd's?
> mkinitrd is maintained by RedHat (http://www.redhat.com/)
> afaik the person responsible for that package is Peter Jones.
> Mandriva up to 2008.0 used a version derived from mkinitrd 4.2.17 cod=
ebase,=20
> maintained by me.
> the upcoming 2008.1 will use a version derived from mkinitrd 6 codeba=
se,
> maintained by Olivier Blin.
>=20
> >Where is the latest mkinitrd available from?
> the redhat version is avaliable from any rawhide mirror
> http://mirrors.fedoraproject.org/publiclist/Fedora/development/
> The mandriva version from any cooker mirror
> http://wiki.mandriva.com/en/CookerMirrors
>=20
> >Could I use the latest mkinitrd with my 2006.0 system?
> i don't think so
>=20
> >>>And I was about to report this om qa.mandriva.com - but it seems t=
hat I
> >>>already made contact!
> >>if you want a bug fixed on mandriva please send a bug report on
> >>qa.mandriva.com, same applies for redhat/fedora.
> >>If you have questions to ask, feel free.
> >
> >Is raid10,f2 supported under the latest haddrake2?
>=20
> No.

Thanks for your answers.=20

I filed a feature request for cooker on harddrake2 and drakx.

I think mkinitrd is actually used by the kernel, with a make install.
Is that true? Then mkinitrd is a general script that is used on almost
all linux systems. So I can assume that this is available when I write =
a
howto.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
