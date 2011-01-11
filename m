From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: fix sync_completed reporting for very large drives
 (>2TB)
Date: Tue, 11 Jan 2011 22:01:50 +1100
Message-ID: <20110111220150.6444d493@notabene.brown>
References: <1294155883-31421-1-git-send-email-remi.rerolle@gmail.com>
	<4D2C3302.2090708@lacie.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D2C3302.2090708@lacie.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?B?UultaSBS6XJvbGxl?= <rrerolle@lacie.com>
Cc: =?ISO-8859-1?B?UultaSBS6XJvbGxl?= <remi.rerolle@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 11 Jan 2011 11:37:54 +0100 R=E9mi R=E9rolle <rrerolle@lacie.com=
> wrote:

> Le 04/01/2011 16:44, R=E9mi R=E9rolle a =E9crit :
> > From: R=E9mi R=E9rolle<rrerolle@lacie.com>
> >
> > The values exported in the sync_completed file are unsigned long, w=
hich
> > overflows with very large drives, resulting in wrong values reporte=
d.
> >
> > Since sync_completed uses sectors as unit, we'll start getting wron=
g
> > values with components larger than 2TB.
> >
> > This patch simply replaces the use of unsigned long by unsigned lon=
g long.
> >
>=20
> Hi Neil,
>=20
> What is the status for this patch ?
>=20
> Thanks in advance!

Perfect timing!!

The status is that I had completely forgotten about it, but I have just=
 been
assembling some md patches for the current merge window, so I have just=
 added
your patch - it should appear in -next in a day or so and go to Linus b=
y the
end of the week.

Thanks!

NeilBrown


>=20
> > Signed-off-by: R=E9mi R=E9rolle<rrerolle@lacie.com>
> > ---
> >   drivers/md/md.c |    4 ++--
> >   1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 175c424..ea46b3b 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -3912,7 +3912,7 @@ static struct md_sysfs_entry md_sync_speed =3D=
 __ATTR_RO(sync_speed);
> >   static ssize_t
> >   sync_completed_show(mddev_t *mddev, char *page)
> >   {
> > -	unsigned long max_sectors, resync;
> > +	unsigned long long max_sectors, resync;
> >
> >   	if (!test_bit(MD_RECOVERY_RUNNING,&mddev->recovery))
> >   		return sprintf(page, "none\n");
> > @@ -3923,7 +3923,7 @@ sync_completed_show(mddev_t *mddev, char *pag=
e)
> >   		max_sectors =3D mddev->dev_sectors;
> >
> >   	resync =3D mddev->curr_resync_completed;
> > -	return sprintf(page, "%lu / %lu\n", resync, max_sectors);
> > +	return sprintf(page, "%llu / %llu\n", resync, max_sectors);
> >   }
> >
> >   static struct md_sysfs_entry md_sync_completed =3D __ATTR_RO(sync=
_completed);
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
