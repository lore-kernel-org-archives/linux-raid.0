From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: [PATCH] Make --update=homehost work again.
Date: Wed, 6 Feb 2013 12:16:16 -0800
Message-ID: <CAKgsxVS5cwjK-JEhJtt+cc7CnL8=0A5+aAHMhHM7rNJ0+3boAA@mail.gmail.com>
References: <1359512808-14297-1-git-send-email-jmaggard10@gmail.com>
	<1359542766.5755.46.camel@mattotaupa>
	<CAKgsxVQQYmP_AvoJb8dkNhZEZV-A8z1-twCUx7u3+SbwUHb4ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKgsxVQQYmP_AvoJb8dkNhZEZV-A8z1-twCUx7u3+SbwUHb4ew@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 30, 2013 at 2:46 AM, Paul Menzel <pm.debian@googlemail.com>=
 wrote:
>
> Dear Justin,
>
>
> thank you for your patch.
>
>
> Am Dienstag, den 29.01.2013, 18:26 -0800 schrieb Justin Maggard:
> > Commit 1e2b276535cea41c348292a019bdda8a58cb1679
>
> Please not only add the hash, but also the summary, so people not hav=
ing
> the Linus=92 master checked out know what the original commit was abo=
ut.
> Also CC the original commit author so s/he can comment.
>

Done, and resent with an updated summary.

>
> > broke homehost updating
> > functionality because it depended on each string comparison being d=
one
> > even after we already found a match.  Fix this by using a goto inst=
ead.
> >
> > ---
> >  super0.c |    3 ++-
> >  super1.c |    3 ++-
> >  2 files changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/super0.c b/super0.c
> > index ecb6b38..f15f1e0 100644
> > --- a/super0.c
> > +++ b/super0.c
> > @@ -554,10 +554,11 @@ static int update_super0(struct supertype *st=
, struct mdinfo *info,
> >       } else if (strcmp(update, "homehost") =3D=3D 0 &&
> >                  homehost) {
> >               uuid_set =3D 0;
> > -             update =3D "uuid";
> >               info->uuid[0] =3D sb->set_uuid0;
> >               info->uuid[1] =3D sb->set_uuid1;
> > +             goto update_uuid;
> >       } else if (strcmp(update, "uuid") =3D=3D 0) {
>
> Would changing this from =BBelse if =85=AB to only =BBif=AB also solv=
e this and
> make it subjectively more clear?
>

That would reverse what the breaking commit was trying to fix.  The
only other option I can think of would be to call update_super*()
again from within itself.  But I'm not sure if that would be more or
less clear that using a goto.

Thanks,
-Justin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
