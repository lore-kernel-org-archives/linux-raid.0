From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 - RMW logic
Date: Mon, 4 Aug 2014 11:22:28 +1000
Message-ID: <20140804112228.6ef95b10@notabene.brown>
References: <12EF8D94C6F8734FB2FF37B9FBEDD17358639B87@EXCHANGE.collogia.de>
	<20140731073007.3fe4817a@notabene.brown>
	<12EF8D94C6F8734FB2FF37B9FBEDD17358639D05@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/CIl4p692T0r6juZyc_uN=sX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD17358639D05@EXCHANGE.collogia.de>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/CIl4p692T0r6juZyc_uN=sX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Jul 2014 06:43:52 +0000 Markus Stockhausen
<stockhausen@collogia.de> wrote:

> > Von: linux-raid-owner@vger.kernel.org=20
> > Gesendet: Mittwoch, 30. Juli 2014 23:30
> > An: Markus Stockhausen
> > Cc: linux-raid@vger.kernel.org
> > Betreff: Re: RAID6 - RMW logic
> >=20
> > On Wed, 30 Jul 2014 20:24:30 +0000 Markus Stockhausen
> > <stockhausen@collogia.de> wrote:
> >=20
> > > Hi,
> > >
> > > the last days I tried to understand the RAID6 logic when recalculating
> > > P/Q parity (or syndrome) if only parts of a stripe are updated. As far
> > > ...
> >
> > Please see
> >   http://comments.gmane.org/gmane.linux.raid/42559
> >=20
> > Yes, this is something we probably want.
> > The previous effort stalled somehow.  Maybe it just needs someone to st=
art
> > pushing again.
> >=20
> > NeilBrown
>=20
> Hi,
>=20
> thanks for the link. Crawling through the modifcation I isolated two steps
> that we must achieve in first place to get it on track. I'm far away from
> implementing a full patch so I focus on what I understand.
>=20
> 1) Implement a generic switch so we can configure rmw/rcw handling
> on the fly. Without any RAID6 rmw patches yet it will simply focus on the
> current RAID5 implementation. Later on RAID6 can use it too and we
> are able to  compare rmw versus rcw performance in all cases.
> I would name the parameter enable_rmw and default it to 1. In RAID6 case=
=20
> it will be ignored.
>=20
> -> Ok with that?

No, sorry.  Or not very.

In that email thread I pointed you to I wrote:

- Can you  explain *why* rcw is sometimes better than rmw even on large
  arrays? Even a fairly hand-wavy arguement would help.  And it would go in
  the comment at the top of the patch that adds enable_rmw.


I see you've posted a patch, but there is no "why".
I don't like adding configuration options.  If there is some clear and easy
to understand benefit, like "this trades throughput against latency", then I
might be able to live with one, because it would be easy to tell people how
to tune it.

Why would I ever disable rmw?  Don't say "choose the option that performs b=
est
for your workload", because that is nearly meaningless: workloads change fr=
om
moment to moment.  If rwm is good in some cases and bad in others, then we
should at least make sure we understand why, and then hopefully get the md
driver  to auto-detect the different cases.

There might be a case for allowing an option like that to support a
"developer only preview" of the code.  i.e.  Add the rmw-for-RAID6 code, fi=
nd
that is slows down some workloads, get confused about why, ask for help,
people are only happy to  test if it is in mainline, so use a developer-only
config option.
Then at least I could tell people when to turn it on: only if you are a
developer.

NeilBrown


>=20
> 2) The previous patch was quite tricky with handling the P/Q calculation.
> It combined a gen_syndrome run with 2 extra xor runs. Additionally it
> saved P/Q delta in spare pages. Maybe to avoid patching gen_syndrome=20
> functions. I understand the discussion that the flag "subtract" and the h=
andling
> of the second spare page is not easy to understand. As explained in my
> last mail I would enhance the syndrome functions with the option to XOR t=
he=20
> target P/Q pages instead of only storing the calculated values. This woul=
d allow=20
> to work the same way the RAID5 shortcut does. See ops_run_prexor that use=
s=20
> parity page to store the interim result.
>=20
> >From a performance perspective I would write separate logic in /lib/raid=
6=20
> by copying the existing functions. Another approach could be to change=20
> all gen_syndrome functions to xor the destination page - and empty the
> target page in advance for the rcw case. In all cases this patch will be =
quite=20
> huge but I should be easy to understand and to verify.
>=20
> -> Suggestions?
>=20
> Best regards.
>=20
> Markus


--Sig_/CIl4p692T0r6juZyc_uN=sX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU97gVDnsnt1WYoG5AQI6VA//Qq0Kh8Vo699Z+x0UEhJ46J513wokpfoc
Jy2Pj5oGa4LiVn34LFQQdPVRfAzLKaRhE7XTJ8qtGoV7kfy86Ksi1V3G+NEIB4rR
VBctQvCs958H4fr28d2DrP+Px90CkSZAznQL/1oMrrXEVxLlpsLAW6zpcFwBoT6m
Tg4gzOSI/oxj8jzGxSThDZf/IchUGMvZzHkghGvC0GHMt4YBNg0Nax3U6eMW2NJS
pqGVa8haMpPfGchGeG+1KbZibz7kvff+PDjpmksoD+P5uX5taO50GKTqg/FOy96R
PvjgtOzQQwol1xISYfgrb31zNTUkZALHtQgGAaAaqylb9AxsOi4DmdCXbsSqYSLx
1KO4IfuFMrxQcAloRBBIfplIKJbK2KOXAumWRAslJpncBY2lGtrgnSYThS0MGL27
9J1swKYYAo/PdQ0jEzlhD9ilg9iKMHd8s1/mWgeEBzKSMPhj/wx1fGw4u8bGXcI6
wkNWiJTG9SjSPcj5akoT5ulx6bQoS8pAn8yMeM9MDOeeLdkXpd1fNLVw8Ux3zBkD
M9Si9kMe/Ao1MvCihlOF/Mf/jLlsdydTEUnTCJNqhm3OoVTYpNvnsMcUE5VUGDDi
rfDhjbTb/UFBAKrPoBYZqhK+xAHGFaS6mwTyT5SnkeAj/EgATDLv7eMWsKJtN41v
8sNx1xehR8g=
=Ld2m
-----END PGP SIGNATURE-----

--Sig_/CIl4p692T0r6juZyc_uN=sX--
