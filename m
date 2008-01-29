From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 19:01:01 +0100
Message-ID: <20080129180101.GB19527@rap.rap.dk>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <20080129162640.GA16250@rap.rap.dk> <479F5882.8050400@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <479F5882.8050400@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, Moshe Yudkowsky <moshe@pobox.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 29, 2008 at 07:46:58PM +0300, Michael Tokarev wrote:
> Keld J=F8rn Simonsen wrote:
> > On Tue, Jan 29, 2008 at 06:13:41PM +0300, Michael Tokarev wrote:
> >> Linux raid10 MODULE (which implements that standard raid10
> >> LEVEL in full) adds some quite.. unusual extensions to that
> >> standard raid10 LEVEL.  The resulting layout is also called
> >> raid10 in linux (ie, not giving new names), but it's not that
> >> raid10 (which is again the same as raid1+0) as commonly known
> >> in various literature and on the internet.  Yet raid10 module
> >> fully implements STANDARD raid10 LEVEL.
> >=20
> > My understanding is that you can have a linux raid10 of only 2
> > drives, while the standard RAID 1+0 requires 4 drives, so this is a=
 huge
> > difference.
>=20
> Ugh.  2-drive raid10 is effectively just a raid1.  I.e, mirroring
> without any striping. (Or, backwards, striping without mirroring).

OK. =20

uhm, well, I did not understand: "(Or, backwards, striping without
mirroring)."  I don't think a 2 drive vanilla raid10 will do striping.
Please explain.

> Pretty much like with raid5 of 2 disks - it's the same as raid1.

I think in raid5 of 2 disks, half of the chunks are parity chynks which
are evenly distributed over the two disks, and the parity chunk is the
XOR of the data chunk. But maybe I am wrong. Also the behaviour of suce
a raid5 is different from a raid1 as the parity chunk is not used as
data.
>=20
> > I am not sure what vanilla linux raid10 (near=3D2, far=3D1)
> > has of properties. I think it can run with only 1 disk, but I think=
 it
>=20
> number of copies should be <=3D number of disks, so no.

I have a clear understanding that in a vanilla linux raid10 (near=3D2, =
far=3D1)
you can run with one failing disk, that is with only one working disk.
Am I wrong?

> > does not have striping capabilities. It would be nice to have more=20
> > info on this, eg in the man page.=20
>=20
> It's all in there really.  See md(4).  Maybe it's not that
> verbose, but it's not a user's guide (as in: a large book),
> after all.

Some man pages have examples. Or info could be written in the faq or in
wikipedia.

Best regards
keld
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
