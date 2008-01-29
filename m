From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 19:46:58 +0300
Message-ID: <479F5882.8050400@msgid.tls.msk.ru>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <20080129162640.GA16250@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080129162640.GA16250@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, Moshe Yudkowsky <moshe@pobox.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:
> On Tue, Jan 29, 2008 at 06:13:41PM +0300, Michael Tokarev wrote:
>> Linux raid10 MODULE (which implements that standard raid10
>> LEVEL in full) adds some quite.. unusual extensions to that
>> standard raid10 LEVEL.  The resulting layout is also called
>> raid10 in linux (ie, not giving new names), but it's not that
>> raid10 (which is again the same as raid1+0) as commonly known
>> in various literature and on the internet.  Yet raid10 module
>> fully implements STANDARD raid10 LEVEL.
>=20
> My understanding is that you can have a linux raid10 of only 2
> drives, while the standard RAID 1+0 requires 4 drives, so this is a h=
uge
> difference.

Ugh.  2-drive raid10 is effectively just a raid1.  I.e, mirroring
without any striping. (Or, backwards, striping without mirroring).

So to say, raid1 is just one particular configuration of raid10 -
with only one mirror.

Pretty much like with raid5 of 2 disks - it's the same as raid1.

> I am not sure what vanilla linux raid10 (near=3D2, far=3D1)
> has of properties. I think it can run with only 1 disk, but I think i=
t

number of copies should be <=3D number of disks, so no.

> does not have striping capabilities. It would be nice to have more=20
> info on this, eg in the man page.=20

It's all in there really.  See md(4).  Maybe it's not that
verbose, but it's not a user's guide (as in: a large book),
after all.

/mjt
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
