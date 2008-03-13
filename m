From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: software for making initrd's with raid support
Date: Thu, 13 Mar 2008 14:00:42 +0100
Message-ID: <20080313130042.GA11858@rap.rap.dk>
References: <20080312235641.GA7109@rap.rap.dk> <20080313111538.GB4229@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080313111538.GB4229@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 13, 2008 at 12:15:39PM +0100, Luca Berra wrote:
> On Thu, Mar 13, 2008 at 12:56:41AM +0100, Keld J=F8rn Simonsen wrote:
> >Hi
> >
> >I have been looking at making my system working with raid, and booti=
ng
> >from raid. I succeded, but I had to hack a number of things, includi=
ng
> >making a new initrd by hand.
> >
> >I used mkinitrd, but it did not treat sw raid, only in the md sense.
> >this is a redhat/mandriva/pclinuxos(keldix thing, I wonder if it als=
o
> >used in the dbian/ubuntu world.
>=20
> could you please explain what you mean in the above sentence,
> i have being maintaining mandriva mkinitrd packages for some years, a=
nd
> would really love to know.

Good!  I was working on a mandriva professional 2006 system 2.6.12
kernel, and I hacked the mkinitrd to have it generate mdadm.conf etc
- it did not at all look at this. I can send you my patches, but they
  are in no way clean.

There was no mention of raid10 in the code either.

I thied to contact Erik Troan - the main author of mkinitrd (and lots o=
f
other stuff:-) - but got a bouncing message for his redhat address.

And I was about to report this om qa.mandriva.com - but it seems that I
already made contact!

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
