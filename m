From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: [PATCH 1/2] md bitmap bug fixes
Date: Sat, 19 Mar 2005 12:44:14 -0500
Message-ID: <200503191744.j2JHiKT25357@www.watkins-home.com>
References: <20050319162443.GR18819@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
In-Reply-To: <20050319162443.GR18819@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: 'Lars Marowsky-Bree' <lmb@suse.de>, "'Peter T. Breuer'" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You said:
"Wrong model. They know that at one point in time they've been in sync,
and that they have since diverged, and so they can figure out where
those differences occur."

I agree, but I don't think a block device can to a re-sync without
corrupting both.  How do you merge a superset at the block level?  AND =
the 2
blocks and update both?  :)  I don't think a filesystem would like that=
=2E  It
would be real bad to re-sync if the filesystem is mounted!

In the case of a split brain, I think one must be 100% voided, and a fu=
ll
re-sync must be done.

Guy

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Lars Marowsky-Br=
ee
Sent: Saturday, March 19, 2005 11:25 AM
To: Peter T. Breuer; linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/2] md bitmap bug fixes

On 2005-03-19T16:06:29, "Peter T. Breuer" <ptb@lab.it.uc3m.es> wrote:

I'm cutting out those parts of the discussion which are irrelevant (or
which I don't consider worth pursuing; maybe you'll find someone else
to explain with more patience).

> > > Hmm. I don't believe it can detect it reliably. It is always poss=
ible
> > > for both sides to have written different data in the ame places, =
etc.
> >=20
> > drbd can detect this reliably by its generation counters;
>=20
> It doesn't matter what words are used - it can't. If you split the tw=
o
> systems and carry on writing to both, then both "generation counters"
> will increment in the same way, but you don't have to write the same
> data to both!

That flag gets said (as part of the generation counter tuple) on both
sides when that happens, and if it is set on both sides, they know
something went wrong.

And then they can consult their bitmaps to figure out the set of blocks
which diverge. (Granted, it's a superset, but typically it'll be a much
smaller set than the entire volume.)

That part is really simple in theory.

> I can tell what can and cannot happen without having to experience it=
 -
> that's the whole point of theory :-(. (well, you did ask).

Your theory is flawed.

> Quite probably, but all the writings in the world can't change the
> semantics of the universe :(.  Two systems disconnected from each oth=
er
> cannot reliably be told apart without consulting a third "observer" w=
ho
> has been experiencing their actions throughout.  You'd have to have t=
hem
> logging to a third node to figure out which is "right" (and which is
> "left" :-).

Wrong model. They know that at one point in time they've been in sync,
and that they have since diverged, and so they can figure out where
those differences occur.



Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
