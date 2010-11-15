From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 15/17] Monitor: more accurate size check when looking
 for spares
Date: Mon, 15 Nov 2010 16:32:38 +1100
Message-ID: <20101115163238.0f3dd61d@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FD3@irsmsx504.ger.corp.intel.com>
	<4CD39DA7.609@intel.com>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F010BCF917A@irsmsx504.ger.corp.intel.com>
	<AANLkTikWs2Mb5qmY_4tMQhnr4P===W1KJvjgW9xJYVrb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikWs2Mb5qmY_4tMQhnr4P===W1KJvjgW9xJYVrb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Czarnowska, Anna" <anna.czarnowska@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On Tue, 9 Nov 2010 09:23:49 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> On Tue, Nov 9, 2010 at 7:43 AM, Czarnowska, Anna
> <anna.czarnowska@intel.com> wrote:
> >>
> >> Neil wondered if we can repurpose validate_geometry for this case?=
 =A0It
> >> is already charged with checking if a disk is suitable to be added=
 to
> >> an
> >> array.
> >
> > I had a look at validate_geometry and I don't think it makes sense =
to modify it for Monitor.
> > Validate_geometry is made for Create. When creating container valid=
ate_geometry doesn't check much for imsm. When adding to a volume all d=
isks must be already in the same container and have some common free re=
gion. We want the check before we move a spare. And the whole spare is =
free (is not used by any arrays in that container). I think it is bette=
r to have smaller functions and use them as building blocks, than make =
a big function even more complicated for every special case.
>=20
> Yes, and no :-). There is a line to be drawn between refactoring and
> adding complexity, and you are right that all things being equal
> validate_geometry() as it stands today is an awkward fit.  However,
> the architecture rework Neil is doing is coming precisely from the
> realization that we are generating lots of these special case routine=
s
> that are doing not much more than representing the same data to
> slightly different contexts.  The conclusion to be drawn is that our
> interface from generic mdadm to the metadata handler is perhaps too
> fine grained.   Hence the refactoring and why in this case it is
> worthwhile to at least ask the question: can a routine tasked with
> validating disks are proper candidates to be added to an array /
> container be trivially re-purposed to handle the case of validating
> that a spare is suitable for an existing container?  I agree with you=
r
> conclusion, but wanted to share why I think Neil asked the question,
> hopefully I am not putting words in his mouth.
>=20
> --
> Dan


I had a proper look at the code and I think that when I said
"validate_geometry", I should have said "avail_size".

We can probably just use the one method for both 'avail_size' and
'min_acceptable_spare_size' though I'm not sure currently what it would=
 look
like.

So I'm happy to take that patch with min_acceptable_spare_size, and I w=
ill
quite possibly revise it later.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
