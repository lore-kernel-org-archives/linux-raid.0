From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system unresponsive
Date: Wed, 13 Apr 2011 13:30:10 -0700 (PDT)
Message-ID: <89602.52744.qm@web65104.mail.ac2.yahoo.com>
References: <4DA58FD2.8040900@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DA58FD2.8040900@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--- On Wed, 13/4/11, John Robinson <john.robinson@anonymous.org.uk> wro=
te:

> From: John Robinson <john.robinson@anonymous.org.uk>
> Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, s=
ystem unresponsive
> To: "NeilBrown" <neilb@suse.de>
> Cc: "Gavin Flower" <gavinflower@yahoo.com>, linux-raid@vger.kernel.or=
g
> Date: Wednesday, 13 April, 2011, 23:58
> On 13/04/2011 12:13, NeilBrown
> wrote:
> > On Wed, 13 Apr 2011 11:57:24 +0100 John Robinson
> > <john.robinson@anonymous.org.uk>=A0
> wrote:
> >> On 12/04/2011 22:30, Gavin Flower wrote:
> [...]
> >>> md0 : active raid6 sda3[0] sdb3[4] sdd3[3]
> sdc3[5](F) sde3[1]
> >>>=A0 =A0 =A0 =A0=A0=A010751808
> blocks level 6, 64k chunk, algorithm 2 [5/4] [UU_UU]
> >>=20
> >> This one I don't get:
> >> md0 : active raid6 sda3[0] sde3[1] sdd3[3] sdb3[4]
> sdc3[5](F)
> >> which ought to be UUUU_ again...
> >>=20
> >> Perhaps `mdadm -D /dev/md[0-2]` would make things
> clearer...
> >=20
> > This is actually more horrible than you imagine.
>=20
> It isn't really, I was asking for the mdadm -D output
> precisely to get the list of role and slot numbers, having
> noticed there was no slot 2 in Gavin's setup...
>=20
> [...]
> > As the current number is pretty much useless, I should
> probably change it to
> > the slot number, or an arbitrarily assigned larger
> number for spares.
> > This would be an incompatible change, but I very much
> doubt anyone uses the
> > numbers for what they actually are, so I doubt that
> would really matter.
> >=20
> > It has just never really got high on my list of
> priorities....
> >=20
> > Lesson:=A0 Ignore the number in [] - it doesn't
> mean anything useful.
>=20
> It's not useless, it reflects the order in which devices
> were added to the array.
>=20
> Suggestion: Don't change the number in /proc/mdstat, just
> sort the devices by role (i.e. the same order as the UUUU_)
> instead of device node, and show spares at the end (as per
> your arbitrarily-assigned larger number, which this way you
> never have to display).
>=20
> Cheers,
>=20
> John.
>=20

The first time I saw this kind of thing: I was very worried, thinking I=
 had 2 bad drives - until I looked more closely, a few hours later.  I =
am sure I am not the only to initially react that way.

=46rom a user perspective, I think that the list of drives and the [UUU=
U_] string, should be ordered in the alphanumeric order of the logical =
drive names. Also modify the '[...]' string to indicate spares (not hav=
ing spares, not sure what it does now).

e.g.
/dev/sda  /dev/sdb /dev/sdc[F} /dev/sdd /dev/sde[S} /dev/sdf.
would be reflected by:
[aaFaSa]

Not sure what the 'U' stood for. Marking actives disks with 'a' seems t=
o make more sense to me.  The upper and lower case would make it easier=
 to see what is active and what is not.  Similarly, the RAID entries wo=
uld be better, from a user perspective, to be sorted on name.

There are probably lots of technical reasons this can't be done, but us=
ers don't care! :-)  We just want it to look pretty, be easy to underst=
and, and not be scary.

Just my 2 pennies worth...

When I put my developer hat on, I tend to feel that users rate looking =
pretty' and 'not be scary' as being more important than 'be easy to und=
erstand' - or perhaps, I am too cynical


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
