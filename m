From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v2 1/5] md/raid10: optimize read_balance() for 'far
 offset' arrays
Date: Thu, 16 Jun 2011 09:56:07 +1000
Message-ID: <20110616095607.4869fbde@notabene.brown>
References: <1308103324-2375-1-git-send-email-namhyung@gmail.com>
	<1308103324-2375-2-git-send-email-namhyung@gmail.com>
	<20110615065144.GA28174@www2.open-std.org>
	<1308140733.1358.41.camel@leonhard>
	<87aadj9n7a.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87aadj9n7a.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: Keld =?ISO-8859-1?B?Svhybg==?= Simonsen <keld@keldix.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 15 Jun 2011 23:35:53 +0900 Namhyung Kim <namhyung@gmail.com> wr=
ote:

> Namhyung Kim <namhyung@gmail.com> writes:
> > 2011-06-15 (=EC=88=98), 08:51 +0200, Keld J=C3=B8rn Simonsen:
> >> On Wed, Jun 15, 2011 at 11:02:00AM +0900, Namhyung Kim wrote:
> >> > If @conf->far_offset > 0, there is only 1 stripe so that we can =
treat
> >> > the array same as 'near' arrays.
> >>=20
> >> does it also work with more than 2 copies - eg 3 copies?
> >> I think the original code just takes the available data blocks wit=
h the=20
> >> lowest address.
> >>=20
> >
> > Hi,
> >
> > Let me clarify this: AFAIK, 'far offset' array saves redundant data=
 in
> > the diagonally adjacent chunk/disk, so it could be roughly thought =
as
> > 'raid0' array with reduced size - just ignore redundant chunks here=
=2E It
> > was my mistake considering it as 'near' array. :(
> >
>=20
> I'm confused again. If fo > 0 && fc > 1 && nc > 1 then it turns out t=
o
> a near array with reduced size, no? Does it still need to be treaded
> as RAID0?

This would be a mix of near and offset.  I'm not at all sure what the "=
best"
read balancing approach would be.  But as I don't think anyone would ev=
er
actually use it, I don't think it really matters.

Thanks,
NeilBrown



>=20
>=20
> > Therefore, it makes more sense distributing reads over the array ba=
sed
> > on some criteria - here, the address of starting sector - like RAID=
0
> > does. Now I see that the same goes to the 'far copies' array exactl=
y, so
> > the original code is correct.
> >
> > Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
