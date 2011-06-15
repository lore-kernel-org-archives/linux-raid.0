From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH RESEND 0/5] md/raid10 changes
Date: Wed, 15 Jun 2011 12:33:01 +0900
Message-ID: <1308108781.1341.15.camel@leonhard>
References: <1308103324-2375-1-git-send-email-namhyung@gmail.com>
	 <20110615130954.3e58a12c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110615130954.3e58a12c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2011-06-15 (=EC=88=98), 13:09 +1000, NeilBrown:
> On Wed, 15 Jun 2011 11:01:59 +0900 Namhyung Kim <namhyung@gmail.com> =
wrote:
>=20
> > Hello Neil,
> >=20
> > This is a resend of my previous raid10 patches. Some of them are re=
vised
> > according to your comments and some of them are not reviewed at all=
=2E
> > Please take a look.
> >=20
> > Thanks.
> >=20
> >=20
> > Namhyung Kim (5):
> >   md/raid10: optimize read_balance() for 'far offset' arrays
> >   md/raid10: get rid of duplicated conditional expression
> >   md/raid10: factor out common bio handling code
> >   md/raid10: share pages between read and write bio's during recove=
ry
> >   md/raid10: spread read for subordinate r10bios during recovery
> >=20
>=20
> Thanks.
>  I've reject the first and last as explained separately but the other=
s look
>  good and I have added them to my tree.  They will probably be submit=
ted in
>  the next merge window.
>=20
> Thanks,
> NeilBrown
>=20

Hi,

Thanks for reviewing them. As I said before, I don't have any realistic
test environment for those patches. They've just come from the code
inspection, and I (wrongly) thought they would be somewhat helpful,
sorry. :)


--=20
Regards,
Namhyung Kim


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
