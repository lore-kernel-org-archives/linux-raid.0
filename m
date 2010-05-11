From: Keld Simonsen <keld@keldix.com>
Subject: Re: layout of far blocks in raid10
Date: Wed, 12 May 2010 00:35:49 +0200
Message-ID: <20100511223549.GA3646@rap.rap.dk>
References: <20100511151204.GA3781@rap.rap.dk>
 <AANLkTimKPeTgUGLosNXJScE73agrlxL8NgO0W44OwlVh@mail.gmail.com>
 <20100512075656.45257d16@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100512075656.45257d16@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Aryeh Gregor <Simetrical+list@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 12, 2010 at 07:56:56AM +1000, Neil Brown wrote:
> On Tue, 11 May 2010 13:13:06 -0400
> Aryeh Gregor <Simetrical+list@gmail.com> wrote:
>=20
> > On Tue, May 11, 2010 at 11:12 AM, Keld Simonsen <keld@keldix.com> w=
rote:
> > > There is a question on block layout in the raid10 far layout,
> > > that I would like to know more about.
> > > For 4 drives, and with 2 copies (-n 4 -p n2) =A0I see several
> > > possible layouts, 3 of them are, showing the beginning of each ra=
id0 section:
> >=20
> > There are only two layouts possible here: cyclic, and
> > double-transposition.  The first can be summarized in cycle notatio=
n
> > <http://en.wikipedia.org/wiki/Cycle_notation> as (abcd), where two
> > letters are adjacent if the extra copy of the first letter is on th=
e
> > same disk as the second letter, and it's assumed the letters wrap
> > around in the parentheses (so the extra copy of d is on the same di=
sk
> > as a).  The second is (ab)(cd).  So for instance, your example 1 is
> > (1432), example 2 is (13)(24), and example 3 is (1234).  For larger
> > numbers you have more possibilities, like (abc)(def) or (abcd)(ef) =
for
> > six drives.  The exact number of possibilities is the number of
> > partitions of the number of drives
> > <http://en.wikipedia.org/wiki/Partition_(number_theory)> that don't
> > include 1.
> >=20
> > As far as I know (hopefully someone will correct me if I'm wrong),
> > RAID10 in mdadm stores data like (ab)(cd)(ef)..., at least if you h=
ave
> > an even number of drives.=20
>=20
> I'm not quite sure how to respond to this...  As a mathematician I wo=
uld
> expect you to understand the important of precision in choosing words=
, yet
> you use the word "know" for something that is exactly wrong.  Either =
you mean
> "guess" or you have been seriously misinformed.  If it is the latter,=
 then
> please let me know where this misinformation came from so I can see a=
bout
> getting it corrected.
>=20
> md/raid10 uses a simple cyclic layout in all cases.  It does so becau=
se this
> layout is completely general and works for all numbers of devices and=
 copies.
>=20
> So you can only survive multiple device failures where are most N-1 a=
re
> adjacent where N is the number of copies, and the first and last devi=
ces are
> treated as adjacent.


Hmm, I think there is then room for improvement here.
=46or a 4 drive raid10,f2 I do think it is a significant enhancement to
go from 33 % chance of recovery with 2 failing disks, to 67 %.
This would also go for raid10,n2, I think. And a 4 drive raid1+0 would
then have better probabilities than a 4 drive raid10,n2...

Enhancements would probably be even better for raid10 with more drives.
Any bid on the order of improvements to be theoretically obtainable?

It would also be interesting to find out what could be done for the cas=
e
where you want to protect controller failure or the like, that is, a=20
failure of a whole group of drives within an array.

I would like to have some kind of guidance written up for the wiki.

best regards
keld

> NeilBrown
>=20
> >                            Thus one disk out of every pair can fail
> > and you'll still have your data, where the pairs are determined by =
the
> > order you specify on the command line.  I don't know if this behavi=
or
> > is guaranteed, but you can verify it by leaving some devices missin=
g
> > -- trying to create a RAID10 with "/dev/sda1 /dev/sdb1 missing
> > missing" will fail, but "/dev/sda1 missing /dev/sdb1 missing" will
> > succeed, at least in my limited experience.
> >=20
> > I don't know what mdadm does if there are an odd number of drives -=
-
> > perhaps something like (ab)(cd)(efg), perhaps something more
> > complicated.  I know more about mathematics than about mdadm.  :)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
