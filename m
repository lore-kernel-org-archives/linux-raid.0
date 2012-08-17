From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: Backup file size when migrating from raid5 to raid6?
Date: Thu, 16 Aug 2012 18:45:24 -0600
Message-ID: <201208161845.24219.thomas@fjellstrom.ca>
References: <CAH-e9vLTY2eo0p3ud5FaWNe_2f8hej0aitFuu8K0M1RZdObiXQ@mail.gmail.com> <201208161728.13814.thomas@fjellstrom.ca> <20120817103926.78a37994@notabene.brown>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120817103926.78a37994@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu Aug 16, 2012, NeilBrown wrote:
> On Thu, 16 Aug 2012 17:28:13 -0600 Thomas Fjellstrom <thomas@fjellstr=
om.ca>
>=20
> wrote:
> > On Sun May 6, 2012, NeilBrown wrote:
> > > On Mon, 7 May 2012 00:32:35 +0000 Gar=F0ar Arnarsson <gardar@gira=
ffi.net>
> >=20
> > wrote:
> > > > That's an excellent idea, I was going to add another disk for e=
xtra
> > > > space right after migrating to raid6.
> > > >=20
> > > > Just to be clear, I'll be running the normalize attribute just =
once
> > > > to straighten the array out right? Or will I have to do it for =
every
> > > > extra drive I add in the future?
> > >=20
> > > Just once.
> > >=20
> > > > And what are the N+1 you mention in --raid-devices=3DN+1
> > >=20
> > > By "N+1" I just meant "1 more than the number of devices currentl=
y in
> > > the array".
> > >=20
> > > If you have both new devices ready to go, you just do a single re=
shape
> > > operation that converts to RAID6 and adds more space.  This does =
not
> > > need a backup file and is probably the best approach.
> > >=20
> > > If you currently have a 10-drive RAID5 and want a 12-drive RAID6,=
 then
> > >=20
> > >  mdadm --grow /dev/md0 --raid-devices=3D12 --level=3D6
> > >=20
> > > is what you want.
> >=20
> > I apologize for bringing back a long dead thread, but I've been won=
dering
> > if mdadm does the grow op in this case, in one step? Or does it
> > internally do each step separately, doing a reshape with each one?
> >=20
> > I've currently got a 7x1TB disk raid5, and have a couple more disks=
 to
> > add and I was planning on moving to raid6. I'm hoping to reduce the
> > amount of time the array is "reshaping" because I'm a bit paranoid =
that
> > my bad luck with hard drives will decide to hit right then and ther=
e.
>=20
> If you change the level and the number of devices in the one command,=
 and
> there are already enough spares present to satisfy the requirements o=
f the
> new size, then it will only perform a single reshape operation which =
will
> use the minimal amount of time.

Ah. Thank you for clarifying that for me :) just running the two new dr=
ives=20
through a bit of a stress test. Then I'll get to expanding the array.

Thanks.

> NeilBrown


--=20
Thomas Fjellstrom
thomas@fjellstrom.ca
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
