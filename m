From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Sat, 19 Mar 2005 17:24:43 +0100
Message-ID: <20050319162443.GR18819@marowsky-bree.de>
References: <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <d1f8fr$k8f$1@sea.gmane.org> <e1nrg2-os1.ln1@news.it.uc3m.es> <d1fd9v$7h6$1@sea.gmane.org> <dsftg2-8cr.ln1@news.it.uc3m.es> <20050319125821.GO18819@marowsky-bree.de> <hvltg2-ss8.ln1@news.it.uc3m.es> <20050319140754.GP18819@marowsky-bree.de> <lortg2-9th.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-Disposition: inline
In-Reply-To: <lortg2-9th.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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
