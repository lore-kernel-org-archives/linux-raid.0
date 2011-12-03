From: Kenneth Emerson <kenneth.emerson@gmail.com>
Subject: md metadata nightmare
Date: Sat, 3 Dec 2011 11:02:24 -0600
Message-ID: <CADzwnhXq5KKO5chdVVODbJH7_HMHFxa0uOa7dBgoNWzS72RGXw@mail.gmail.com>
References: <CADzwnhXWvkVC13ZEJj8L0O6PLXLS6uhoBXqoLp67YwmeU60sQQ@mail.gmail.com>
	<20111123114743.1085889e@notabene.brown>
	<CADzwnhUJ7HbZH9yqa6x9sHFLo8Vg=1k_SyzvZyq2=iQ5YRLhZQ@mail.gmail.com>
	<20111124093637.0c3bb2eb@notabene.brown>
	<CADzwnhXuW7ShBNGf+kqnZYrtRnWMPSRDWzb2h4Gt69Cih0-yGA@mail.gmail.com>
	<CADzwnhUmHACPJA+c23AeRs3AW_ExuAUQST9jew_=5U1xdMqEFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzwnhUmHACPJA+c23AeRs3AW_ExuAUQST9jew_=5U1xdMqEFA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > I will do this conversion; but I will backup my data as best I can =
first,
> > just in case.
> > I still have the 5 1TB drives and my data should fit on there, just=
 a PIA
> > to do it.
> > (Ahh, that's what weekends are for, right?)
> > After the RAID6 is repaired and running OK, I believe I will rebuil=
d the 2
> > RAID1 arrays
> > as that will be an easy project (since I have 5 copies of everythin=
g) which
> > will get rid of
> > all vestiges of previous raid arrays. =A0Do I need to anything spec=
ial other
> > than zeroing
> > the superblocks (--zero-superblock)? =A0Also, shouldn't I do that o=
n the
> > RAID6 array before
> > doing the create or is that done automagically?
>
> It is done automatically. =A0When you use "--create", mdadm will zero=
 any
> superblocks it finds of any format that it recognises, then write the=
 new
> metadata it wants.
>
I am still waiting for my replacement Hitachi drive. My RAID6
configuration is made up of a total of 5 drives and I am currently
running degraded (missing one drive). =A0Can I recreate this raid set,
changing the metadata version missing one drive or should I just be
patient and wait for the replacement to arrive?

-- Ken Emerson
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
