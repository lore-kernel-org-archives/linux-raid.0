From: Neil Brown <neilb@suse.de>
Subject: Re: grow fails with 2.6.34 git
Date: Thu, 15 Apr 2010 12:55:35 +1000
Message-ID: <20100415125535.79519c0e@notabene.brown>
References: <hq5efu$mqb$1@dough.gmane.org>
	<20100415110401.22c7a6bf@notabene.brown>
	<r2x4877c76c1004141922y7f8ef8d6h3ae35ce261a45735@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <r2x4877c76c1004141922y7f8ef8d6h3ae35ce261a45735@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 14 Apr 2010 19:22:48 -0700
Michael Evans <mjevans1983@gmail.com> wrote:

> On Wed, Apr 14, 2010 at 6:04 PM, Neil Brown <neilb@suse.de> wrote:
> > What is happening here is that the spare (sdh) is getting the Q blo=
cks
> > written to it. =C2=A0When this completes you will have full 2-disk =
redundancy but
> > the layout will not be optimal and the array wont be any bigger.
> > To fix this you would:
> >
> > =C2=A0mdadm --grow --backup-file=3D/root/backup.md4 --raid-devices=3D=
6 \
> > =C2=A0 =C2=A0 =C2=A0--layout=3Dnormalise /dev/md4
> >
>=20
> Is there some way of telling if the layout is proper, or is that what
> 'level 6' indicates?

mdadm -D  should list the layout.
If it ends "-6" then it is a non-standard layout with Q on the last dev=
ice
and the remainder of the devices laid out like a RAID5.

>=20
> Also is it safe to run something like...
>=20
> mdadm --grow --back-file=3D/some/never/used/file --layout=3Dnormalize=
 /dev/mdX
>=20
> on any raid 5/6 device that isn't undergoing an active reshape? (woul=
d
> it be a null-op if not required)

Yes.  It quite literally looks at the layout name to see if it ends wit=
h "-6".
If it is not needed it will actually report and error:
mdadm: layout normalize not understood for raid6.

I should probably fix that.....  one day.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
