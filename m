From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: raidreconf feedback help (CFM!)
Date: Fri, 8 Nov 2002 00:46:16 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021107234616.GC1729@unthought.net>
References: <20021106121222.GA23946@vtfl.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021106121222.GA23946@vtfl.nu>
To: Rikard Morssing <rimo.nospam@vtfl.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 06, 2002 at 01:12:22PM +0100, Rikard Morssing wrote:
> I just decided to risk it and expand my raid5-set with raidreconf. It
> failed miserably (but that might be due to hw).

Ok  :)

You're not the first to report a failure - and especially on flaky
hardware there are things that raidreconf could do to recover
gracefully, that it doesn't.

>=20
> But it made me think. How should we create meaningful, extensive and
> informative debug reports which is crucial for the developers to debu=
g
> the program? What i think should be on the raidreconf webpage is a li=
st
> of steps to perform BEFORE and AFTER running the raidreconf, and wher=
e
> to send the report.

"developers" currently means "noone", unfortunately.  But I'm probably
the closest thing to what you expected it would mean  :)

I know of a few bugs that can be fixed fairly easily, which would
resolve most of the bug reports I have seen.  And I am willing to do
those fixes.  But I have been too busy (for the past year!) to get thes=
e
things done.

It really hurts to see a potentially useful tool rot away like this.

The tool did change hands once, to Daniel Cox, who fixed some important
bugs that I did not have the time to fix back then. He too, was hit by
the "too busy" syndrome, and I got the code back (with his fixes of
course), but hasn't touched it much since then.

RedHat then took the tool, and did some changes. As far as I know, the
only thing they changed was indentation and perhaps some configuration.
But I haven't looked more closely, and RedHat never at any point
notified me about them using the tool, or even cared to ask if I knew o=
f
any specific bugs in the tool  (go figure...)

I tried convincing the EVMS people (who included the kernel RAID
functionality in their code as well), to take the raidreconf code and
make it do hot-reconfiguration (as part of EVMS).  They too, however,
seems to be hit by the "too busy" syndrome.   (it seems to be
contagious - beware!)

>=20
> good idea?

Yes, very good.

Even better; you or anyone else out there listening;  if you feel that
you have a few weekends to burn, take raidreconf and fix those few bugs
that make this tool eat half the arrays that its used on.

It really should be no more than a few weekends.

I'm sure that there are people on this list who would be more than happ=
y
to help with testing.   And I would of course be delighted to explain
the basic architecture of the tool, talk about the few known problems,
and come with whatever suggestions I might be able to come up with.

If no-one does this - I will fix it myself.  I may do so in three weeks
from now.  Or I may do so in three years from now.  I cannot say.

I guess there is little doubt, that *if* the tool really worked
reliably, it would be useful.

But beware. Anyone who's been in contact with the code so far, have bee=
n
hit by the "too busy" syndrome.  I take no responsibility (to the exten=
t
of applicable law) over any implications contact with the raidreconf
code might have on your daily schedule...   ;)

--=20
=2E...............................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
