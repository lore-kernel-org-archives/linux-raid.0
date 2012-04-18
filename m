From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Wed, 18 Apr 2012 22:39:42 +0200
Message-ID: <20120418203942.GA7731@lazy.lzy>
References: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com>
 <4F8D228D.8060005@westcontrol.com>
 <20120417171609.GA2859@lazy.lzy>
 <4F8DD02F.1060504@westcontrol.com>
 <20120418182201.GA2733@lazy.lzy>
 <4F8F21F3.5060108@westcontrol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F8F21F3.5060108@westcontrol.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi David,

> I know that 8 is not a generator, and therefore you cannot expect to
> get a full set of (256 - noOfParities) disks.  But picking another
> generator (such as 16) is not enough to guarantee you the full range
> - it is a requirement, but not sufficient.  The generators need to
> be independent of each other, in the sense that all the simultaneous
> equations for all the combinations of failed disks need to be
> soluble.

uhm, than how can RS(255,223) or the equivalent RS(160,128) work?

In all the papers I saw, it was never mentioned the "indepence"
of the GF generators, do you have any reference I can look into?
=20
> It turns out that if you pick 16 as the forth parity generator here
> (1, 2, 4, 16), then you can only have 5 data disks.  In fact, there
> are no other values for g3 that give significantly more than 21 data
> disks in combination with (1, 2, 4), whether or not they happen to
> be a generator for all of GF(2=E2=81=B8).

That's really interesting, but, again, I fail to see how
this could be, given that there are larger range codes.

Maybe they do not use the polynomial 285, in fact AES uses
283, but the first generator is 3 and not 2, actually no
powers of two appears, if I remember correctly.

> When I started out with this, I thought it was as simple as you are
> suggesting.  But it is not - picking a set of generators for GF(2=E2=81=
=B8)
> is not enough.  You have to check that all the solution matrices are
> invertible for all combinations of failed disks.

Check or prove? How do you do that?
And what do you mean exactly?
I mean with "all combination of failed disks".

As already wrote, par2 implements a generic RS
parity generator, and it works with very little
limitations. Do they something different?
=20
> In fact, it is a little surprising that (1, 2, 4) works so well for
> triple parity.  I don't know whether it is just luck, or genius in
> Peter Anvin's choice of the multiply operation.

The GF(256) with polynomial 285 seems quite a
structure of choice, I wonder if the polynomial
must fullfill specific conditions in order to
allow a wider range of parities...

bye,

--=20

piergiorgio
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
