From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: software for making initrd's with raid support
Date: Fri, 14 Mar 2008 14:30:45 +0100
Message-ID: <20080314133045.GB13616@rap.rap.dk>
References: <20080312235641.GA7109@rap.rap.dk> <20080313111538.GB4229@percy.comedia.it> <20080313130042.GA11858@rap.rap.dk> <20080314081516.GB12274@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080314081516.GB12274@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 14, 2008 at 09:15:16AM +0100, Luca Berra wrote:
> On Thu, Mar 13, 2008 at 02:00:42PM +0100, Keld J=F8rn Simonsen wrote:
> >On Thu, Mar 13, 2008 at 12:15:39PM +0100, Luca Berra wrote:
> >>On Thu, Mar 13, 2008 at 12:56:41AM +0100, Keld J=F8rn Simonsen wrot=
e:
> >>>Hi
> >>>
> >>>I have been looking at making my system working with raid, and boo=
ting
> >>>from raid. I succeded, but I had to hack a number of things, inclu=
ding
> >>>making a new initrd by hand.
> >>>
> >>>I used mkinitrd, but it did not treat sw raid, only in the md sens=
e.
> >>>this is a redhat/mandriva/pclinuxos(keldix thing, I wonder if it a=
lso
> >>>used in the dbian/ubuntu world.
> >>
> >>could you please explain what you mean in the above sentence,
> >>i have being maintaining mandriva mkinitrd packages for some years,=
 and
> >>would really love to know.
> >
> >Good!  I was working on a mandriva professional 2006 system 2.6.12
> 2006.0 is EOL

2006.0 professional is maintained to 2011

> >kernel, and I hacked the mkinitrd to have it generate mdadm.conf etc
> >- it did not at all look at this. I can send you my patches, but the=
y
> > are in no way clean.
> mkinitrd in 2006.0 did generate mdadm.conf and use it, so i don't kno=
w
> what your patches were doing.

the code to generate mdadm.conf was not activated. I made some patches
to force raid code generation.

> >There was no mention of raid10 in the code either.
> yes support for raid10 was added after 2006.0 release
>=20
> >I thied to contact Erik Troan - the main author of mkinitrd (and lot=
s of
> >other stuff:-) - but got a bouncing message for his redhat address.
> i think Erik does not maintain mkinitrd any more, it is quite an old
> software.

OK, who maintains it now, and is mkinitrd still a viable - perhaps the
best - way to make initrd's?

Where is the latest mkinitrd available from?

Could I use the latest mkinitrd with my 2006.0 system?

> >And I was about to report this om qa.mandriva.com - but it seems tha=
t I
> >already made contact!
> if you want a bug fixed on mandriva please send a bug report on
> qa.mandriva.com, same applies for redhat/fedora.
> If you have questions to ask, feel free.

Is raid10,f2 supported under the latest haddrake2?

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
