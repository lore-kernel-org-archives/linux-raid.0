From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Update documentation for sync_min and sync_max entries
Date: Thu, 12 May 2011 09:11:33 +1000
Message-ID: <20110512091133.63811ea6@notabene.brown>
References: <AANLkTinEzjxW6ZFkBWYc6UY6Pus1NoY_O+bKyCoDgC6w@mail.gmail.com>
	<BANLkTi=qU-7UX6SGrfLX3wNRUPOKzDSwgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=qU-7UX6SGrfLX3wNRUPOKzDSwgg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 11 May 2011 21:11:39 +0400 CoolCold <coolthecold@gmail.com> wro=
te:

> There is orthographical mistake in patch, in word "withing", should b=
e
> "within". I guess this is too little for one more emailed patch, so
> just notifying & marking line.
>=20
> On Tue, Mar 15, 2011 at 3:30 PM, CoolCold <coolthecold@gmail.com> wro=
te:
> > This patch is against 2.6.37 (
> > git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y=
=2Egit
> > , commit id 97b197f07d15dbcd53328e75754e2f947814c733 ) but I didn't
> > notice any changes in 2.6.38 though.
> >
> > linux/Documentation/md.txt is missing description for sync_min and
> > sync_max entries.
> > This patch adds description for sync_min and sync_max entries.
> >
> > Signed-off-by: Roman Ovchinnikov <coolthecold@gmail.com>
> > ---
> > =A0Documentation/md.txt | =A0 10 ++++++++++
> > =A01 files changed, 10 insertions(+), 0 deletions(-)
> >
> > diff --git a/Documentation/md.txt b/Documentation/md.txt
> > index a81c7b4..8f8cb4f 100644
> > --- a/Documentation/md.txt
> > +++ b/Documentation/md.txt
> > @@ -552,6 +552,16 @@ also have
> > =A0 =A0 =A0within the array where IO will be blocked. =A0This is cu=
rrently
> > =A0 =A0 =A0only supported for raid4/5/6.
> >
> > + =A0 sync_min
> > + =A0 sync_max
> > + =A0 =A0 The two values, given as numbers of sectors, indicate a r=
ange
> -+ =A0 =A0 withing the array where 'check'/'repair' will operate. Mus=
t be
> ++     within the array where 'check'/'repair' will operate. Must be
> > + =A0 =A0 a multiple of chunk_size. When it reaches "sync_max" it w=
ill
> > + =A0 =A0 pause, rather than complete.
> > + =A0 =A0 You can use 'select' or 'poll' on "sync_completed" to wai=
t for
> > + =A0 =A0 that number to reach sync_max. =A0Then you can either inc=
rease
> > + =A0 =A0 "sync_max", or can write 'idle' to "sync_action".
> > +
> >
> > =A0Each active md device may also have attributes specific to the
> > =A0personality module that manages it.
> >
>=20
>=20
>=20

Thanks.  I have added this to my queue.  I might go through the whole f=
ile
and see what else needs fixing before submitting it though.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
