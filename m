From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH v2 1/5] md/raid10: optimize read_balance() for 'far
 offset' arrays
Date: Wed, 15 Jun 2011 21:25:33 +0900
Message-ID: <1308140733.1358.41.camel@leonhard>
References: <1308103324-2375-1-git-send-email-namhyung@gmail.com>
	 <1308103324-2375-2-git-send-email-namhyung@gmail.com>
	 <20110615065144.GA28174@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110615065144.GA28174@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?ISO-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2011-06-15 (=EC=88=98), 08:51 +0200, Keld J=C3=B8rn Simonsen:
> On Wed, Jun 15, 2011 at 11:02:00AM +0900, Namhyung Kim wrote:
> > If @conf->far_offset > 0, there is only 1 stripe so that we can tre=
at
> > the array same as 'near' arrays.
>=20
> does it also work with more than 2 copies - eg 3 copies?
> I think the original code just takes the available data blocks with t=
he=20
> lowest address.
>=20

Hi,

Let me clarify this: AFAIK, 'far offset' array saves redundant data in
the diagonally adjacent chunk/disk, so it could be roughly thought as
'raid0' array with reduced size - just ignore redundant chunks here. It
was my mistake considering it as 'near' array. :(

Therefore, it makes more sense distributing reads over the array based
on some criteria - here, the address of starting sector - like RAID0
does. Now I see that the same goes to the 'far copies' array exactly, s=
o
the original code is correct.

Thanks.


--=20
Regards,
Namhyung Kim


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
