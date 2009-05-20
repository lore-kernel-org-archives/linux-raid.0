From: Neil Brown <neilb@suse.de>
Subject: Re: linear raid : mddev not protected in linear_add
Date: Thu, 21 May 2009 08:35:50 +1000
Message-ID: <18964.34246.728698.444419@notabene.brown>
References: <37d33d830905190523l1ae7536al83ed1255cba3050d@mail.gmail.com>
	<18963.14770.706341.139054@notabene.brown>
	<37d33d830905200910u6066b668p968604477991ec5c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from SandeepKsinha on Wednesday May 20
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday May 20, sandeepksinha@gmail.com wrote:
> Hi Neil,
>=20
> On Wed, May 20, 2009 at 4:28 AM, Neil Brown <neilb@suse.de> wrote:
> > On Tuesday May 19, sandeepksinha@gmail.com wrote:
> >> Hi,
> >>
> >> In linear_add( ), the mddev is gets changed.
> >> Don't we require to lock/unlock around mddev inorder to avoid race=
s?
> >>
> >
> > A good question.
> >
> > To be able to answer it, we must also ask "what races do we need to
> > avoid". =A0Did you have some possible races in mind?
> >
>=20
> I see mddev being referenced in md.c (md layer) for lot of operations=
=2E
> Actually for almost all operations we pass through it. i.e get array
> info.

True.  The only field of mddev which linear_add changes, and which
md.c looks at would be ->raid_disks.  Are there any time where it
depends on the value in a way that a race could make dangerous.  I
think not.

> > I suspect in light of this it would be best to:
> > =A01/ insert a barrier() between setting ->private and setting
> > =A0 =A0 =A0->raid_disks
> > =A02/ in which_dev, read ->raid_disks before ->private, and put a
> > =A0 =A0 =A0barrier in between.
> >
>=20
> Do you suggest implementing barrier functions for linear raid?
> Can you elaborate on this a bit more please?

I'm not talking about IO request barriers, though I agree the
terminology is confusing.  I'm talking about memory barriers.
See Documentation/memory-barriers.txt

If one processor writes new values into two variables, 'a' and 'b'.
At about the same time that another processor reads the two variables,
then the second process could obviously get the two old values, or
the two new values, or the new value of 'a' but the old value of 'b'.
What is less obvious is that some times it could get the old value of
'a' and the new value of 'b'.
You can remove some of this indeterminism with memory barriers.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
