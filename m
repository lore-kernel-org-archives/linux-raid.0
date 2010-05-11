From: Neil Brown <neilb@suse.de>
Subject: Re: layout of far blocks in raid10
Date: Wed, 12 May 2010 07:56:56 +1000
Message-ID: <20100512075656.45257d16@notabene.brown>
References: <20100511151204.GA3781@rap.rap.dk>
	<AANLkTimKPeTgUGLosNXJScE73agrlxL8NgO0W44OwlVh@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimKPeTgUGLosNXJScE73agrlxL8NgO0W44OwlVh@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aryeh Gregor <Simetrical+list@gmail.com>
Cc: Keld Simonsen <keld@keldix.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 11 May 2010 13:13:06 -0400
Aryeh Gregor <Simetrical+list@gmail.com> wrote:

> On Tue, May 11, 2010 at 11:12 AM, Keld Simonsen <keld@keldix.com> wro=
te:
> > There is a quesition on block layout in the raid10 far layout,
> > that I would like to know more about.
> > For 4 drives, and with 2 copies (-n 4 -p n2) =C2=A0I see several
> > possible layouts, 3 of them are, showing the beginning of each raid=
0 section:
>=20
> There are only two layouts possible here: cyclic, and
> double-transposition.  The first can be summarized in cycle notation
> <http://en.wikipedia.org/wiki/Cycle_notation> as (abcd), where two
> letters are adjacent if the extra copy of the first letter is on the
> same disk as the second letter, and it's assumed the letters wrap
> around in the parentheses (so the extra copy of d is on the same disk
> as a).  The second is (ab)(cd).  So for instance, your example 1 is
> (1432), example 2 is (13)(24), and example 3 is (1234).  For larger
> numbers you have more possibilities, like (abc)(def) or (abcd)(ef) fo=
r
> six drives.  The exact number of possibilities is the number of
> partitions of the number of drives
> <http://en.wikipedia.org/wiki/Partition_(number_theory)> that don't
> include 1.
>=20
> As far as I know (hopefully someone will correct me if I'm wrong),
> RAID10 in mdadm stores data like (ab)(cd)(ef)..., at least if you hav=
e
> an even number of drives.=20

I'm not quite sure how to respond to this...  As a mathematician I woul=
d
expect you to understand the important of precision in choosing words, =
yet
you use the word "know" for something that is exactly wrong.  Either yo=
u mean
"guess" or you have been seriously misinformed.  If it is the latter, t=
hen
please let me know where this misinformation came from so I can see abo=
ut
getting it corrected.

md/raid10 uses a simple cyclic layout in all cases.  It does so because=
 this
layout is completely general and works for all numbers of devices and c=
opies.

So you can only survive multiple device failures where are most N-1 are
adjacent where N is the number of copies, and the first and last device=
s are
treated as adjacent.

NeilBrown

>                            Thus one disk out of every pair can fail
> and you'll still have your data, where the pairs are determined by th=
e
> order you specify on the command line.  I don't know if this behavior
> is guaranteed, but you can verify it by leaving some devices missing
> -- trying to create a RAID10 with "/dev/sda1 /dev/sdb1 missing
> missing" will fail, but "/dev/sda1 missing /dev/sdb1 missing" will
> succeed, at least in my limited experience.
>=20
> I don't know what mdadm does if there are an odd number of drives --
> perhaps something like (ab)(cd)(efg), perhaps something more
> complicated.  I know more about mathematics than about mdadm.  :)
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
