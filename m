From: Neil Brown <neilb@suse.de>
Subject: Re: layout of far blocks in raid10
Date: Wed, 12 May 2010 08:54:14 +1000
Message-ID: <20100512085414.3b137bfc@notabene.brown>
References: <20100511151204.GA3781@rap.rap.dk>
	<AANLkTimKPeTgUGLosNXJScE73agrlxL8NgO0W44OwlVh@mail.gmail.com>
	<20100512075656.45257d16@notabene.brown>
	<AANLkTikJte4n45uDZfKCXF1z-uuVmBhpN3qHPJz19pvV@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikJte4n45uDZfKCXF1z-uuVmBhpN3qHPJz19pvV@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aryeh Gregor <Simetrical+list@gmail.com>
Cc: Keld Simonsen <keld@keldix.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 11 May 2010 18:22:58 -0400
Aryeh Gregor <Simetrical+list@gmail.com> wrote:

> On Tue, May 11, 2010 at 5:56 PM, Neil Brown <neilb@suse.de> wrote:
> > I'm not quite sure how to respond to this... =C2=A0As a mathematici=
an I would
> > expect you to understand the important of precision in choosing wor=
ds, yet
> > you use the word "know" for something that is exactly wrong. =C2=A0=
Either you mean
> > "guess" or you have been seriously misinformed. =C2=A0If it is the =
latter, then
> > please let me know where this misinformation came from so I can see=
 about
> > getting it corrected.
> >
> > md/raid10 uses a simple cyclic layout in all cases. =C2=A0It does s=
o because this
> > layout is completely general and works for all numbers of devices a=
nd copies.
> >
> > So you can only survive multiple device failures where are most N-1=
 are
> > adjacent where N is the number of copies, and the first and last de=
vices are
> > treated as adjacent.
>=20
> Mathematicians are sometimes wrong too, sadly.  :)  (And I'm only a
> grad student!)  I believe this is where I got my info:

A grad student!  You must be over educated:
         http://www.maa.org/devlin/devlin_02_10.html
:-)

>=20
> http://git.debian.org/?p=3Dpkg-mdadm/mdadm.git;a=3Dblob_plain;f=3Ddeb=
ian/FAQ;hb=3DHEAD

Thanks... I guess I should read through that and report errors...

>=20
> The answer to question 20 of that suggests that if you have four
> disks, 0 1 2 3, then 0 and 1 form one pair and 2 and 3 form the other=
=2E
>  If 2 fails, then 0 or 1 could still fail without data loss, but a
> failure of 3 will cause data loss.  Obviously, you know what you're
> talking about better than a Debian FAQ, so unless I'm misunderstandin=
g
> the FAQ or you or both, maybe you should talk to the author of that.

The conclusion stated in question 20 is correct if you are considering =
the
'near' layout, though the reasoning is foggy and doesn't generalise to =
the
'far' or 'offset' layout.

With a 'near 2' layout on 4 drives, the blocks are:

  0  0  1  1
  2  2  3  3

which looks like striping across mirrored pairs, but that is really jus=
t a
coincidence.
On 5 drives it would look like:

  0  0  1  1  2
  2  3  3  4  4

The rule "OK as long as no two adjacent devices fail" still holds, thou=
gh
there are some cases where it is OK even if two adjacent devices fail, =
for
the even-number-of-devices case.

NeilBrown

>=20
> Testing with loopback files does seem to show that failing the second
> and third drives in a four-drive RAID will cause the RAID to fail, as
> I would predict from what you say and contrary to what I interpreted
> that FAQ to mean, so hopefully now I understand correctly.
>=20
> Thanks for the correction.  Next time I'll be more cautious.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
