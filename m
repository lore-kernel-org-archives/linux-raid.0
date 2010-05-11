From: Neil Brown <neilb@suse.de>
Subject: Re: [RFC PATCH 0/2] a couple of readonly handling fixups
Date: Wed, 12 May 2010 08:33:32 +1000
Message-ID: <20100512083332.45e71edf@notabene.brown>
References: <20090108072023.9577.3585.stgit@dwillia2-linux.ch.intel.com>
	<18803.46655.134295.118861@nbeee.brown>
	<AANLkTilViY9QWurh9QN07zShPt9rPlfCOVVtH7896yoz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTilViY9QWurh9QN07zShPt9rPlfCOVVtH7896yoz@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 11 May 2010 11:06:48 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> On Sun, Jan 18, 2009 at 4:07 PM, Neil Brown <neilb@suse.de> wrote:
> > On Thursday January 8, dan.j.williams@intel.com wrote:
> >> The BUG_ON(mddev->ro =3D=3D 1) in md_write_start can be triggered =
under two
> >> circumstances in recent kernels. =C2=A0One was reported by Justin =
Maggard:
> >
> > Hi Dan,
> > =C2=A0Thanks for following up with this.....
> >
> > (I meant to send this over a week ago, but I've been on vaction
> > in Tasmania and my mobile has no coverage....)
> >
> [..]
> >> =C2=A0 =C2=A0 =C2=A0 md: set mddev readonly flag on blkdev BLKROSE=
T ioctl
> >
> > This one I'm happy with. =C2=A0I'll make sure it gets through.
>=20
> This slippery bugger seems to have evaded upstream, do you want me to=
 resend?

No thanks, the link below is good enough.
That patch is now in my for-next branch and will go for-linus in
2.6.whatevercomesnext.

I normally stick that sort of thing somewhere in my stack before replyi=
ng
that "I will make it so".  I guess I failed that time.


>=20
> Here is a link for reference:
> http://marc.info/?l=3Dlinux-raid&m=3D123139948817348&w=3D2
>=20
> I have seen another report of the md_write_start() BUG_ON triggering
> so I'm wondering if there are other ways for mddev->ro and
> bdev->bd_part->policy to get out of sync, or if they are just hitting
> the bug that this patch fixes?

Maybe we should just get rid of the BUG_ON??=20
Let's set how it goes once this patch is really in.

Thanks,
NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
