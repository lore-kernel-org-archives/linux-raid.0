From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raid1 and raid 10 always writes all data to all disks?
Date: Sun, 3 Feb 2008 18:13:17 +0100
Message-ID: <20080203171317.GA24820@rap.rap.dk>
References: <20080202235335.GA29029@rap.rap.dk> <47A5E411.10208@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47A5E411.10208@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 03, 2008 at 10:56:01AM -0500, Bill Davidsen wrote:
> Keld J=F8rn Simonsen wrote:
> > I found a sentence in the HOWTO:
> >
> >"raid1 and raid 10 always writes all data to all disks"
> >
> >I think this is wrong for raid10.
> >
> >eg
> >
> >a raid10,f2 of 4 disks only writes to two of the disks -
> >not all 4 disks. Is that true?
> > =20
>=20
> I suspect that really should have read "all mirror copies," in the=20
> raid10 case.

OK, I changed the text to:

raid1 always writes all data to all disks.

raid10 always writes all data to the number of copies that the raid hol=
ds.
=46or example on a raid10,f2 or raid10,o2 of 6 disks, the data will onl=
y
be written 2 times.

Best regards
Keld
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
