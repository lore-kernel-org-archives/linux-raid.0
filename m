From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 0/5] misc cleanups for RAID5
Date: Thu, 23 Jun 2011 16:30:37 +0900
Message-ID: <1308814237.1338.18.camel@leonhard>
References: <1308718230-2536-1-git-send-email-namhyung@gmail.com>
	 <20110623105554.19c5fe09@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110623105554.19c5fe09@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2011-06-23 (=EB=AA=A9), 10:55 +1000, NeilBrown:
> Hi,
>  thanks for these.
>=20
>  I have applied the first and the last.
>=20
>  The two "factor out" patches conflict with some much more substantia=
l
>  refactoring I have been doing in raid5.c.  I have just pushed all of=
 that
>  into my for-next branch:
>=20
>       git://neil.brown.name/md for-next
>=20
>  so you can use that as a basis for any further review.

Thanks. I'll have a look at that.


>=20
>  The r5_for_each_bio() patch I'm not 100% sure I'm happy with, and in=
 any
>  case it would have conflicted with my other changes too.
>  I'm not fond of macros that hide details that could be important. A
>  "for_each" macro that purely and simply walks through a list is fine=
=2E  A
>  "for_each" macro that does anything more complicated I start to have=
 doubts
>  about...
>  However if you really do like it and want to rebase it on the for-ne=
xt
>  branch I'll have another look and think harder about it.   Maybe I'l=
l end up
>  liking it after all, but no promises.

I don't have any strong opinion on it. It was just a suggestion that I
think it helps the code cleaner but ...

Anyway, thanks for your comment.


--=20
Regards,
Namhyung Kim


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
