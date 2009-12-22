From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: Linux MD RAID 1 read performance tunning
Date: Tue, 22 Dec 2009 20:22:49 +0200
Message-ID: <20091222182248.GA5719@rap.rap.dk>
References: <8e04b5820912220834m595f1aa6sf0071f99b4a5a144@mail.gmail.com>
 <20091222165225.GA2684@rap.rap.dk>
 <8e04b5820912220908s233c3bf9yf0fa9ba8deda693b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8e04b5820912220908s233c3bf9yf0fa9ba8deda693b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Ciprian Dorin, Craciun" <ciprian.craciun@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Dec 22, 2009 at 07:08:25PM +0200, Ciprian Dorin, Craciun wrote:
> 2009/12/22 Keld J=F8rn Simonsen <keld@keldix.com>:
> > On Tue, Dec 22, 2009 at 06:34:55PM +0200, Ciprian Dorin, Craciun wr=
ote:
> >> =A0 =A0 Hello all!
> >>
> >> =A0 =A0 I've created a 64G RAID 1 matrix from 3 real disks. (I int=
end to
> >> use this as a target for backups.)
> >> =A0 =A0 Now while playing around with this array, I've observed th=
at the
> >> read performance is quite low because it always reads from the dis=
k in
> >> the first slot (which happens to be the slowest...)
> >>
> >> =A0 =A0 So my questions are:
> >> =A0 =A0 * is there any way to tell the MD driver to load-balance t=
he reads
> >> between the three disks?
> >
> > It does not make sense to do distributed reading in raid1 for seque=
ntial
> > files. This is because it will not be faster to read from more driv=
es,
> > as this will only make the reading from one drive skipping blocks o=
n
> > that drive. In other words, in the time you use for skipping blocks=
 on
> > one drive, you could just as well have read the blocks. So then bet=
ter
> > just read all the blocks off one drive, and then do other possible =
IO
> > from other drives.
>=20
>     Aha. It makes sens now. But, does it mean that if I have parallel
> IO's (from different read operations) they are going to be distribute=
d
> between the disks?

It should, but I am not fully sure it does.
But try it out with two concurrent reads of two big files, and then
watch it with iostat=20

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
