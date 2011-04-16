From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Recommended pci-e 1x SATA cards.
Date: Sat, 16 Apr 2011 11:15:54 +0600
Message-ID: <20110416111554.09066e73@natsu>
References: <4DA6CCFE.8020708@crc.id.au>
	<20110414185304.5bc1cca5@natsu>
	<4DA6F3B2.8080402@crc.id.au>
	<4DA7513C.5020505@hardwarefreak.com>
	<20110415105846.1c4ec630@natsu>
	<4DA8B91C.8050005@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/sXK+1COADtg6px=nk6upgKb"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DA8B91C.8050005@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Steven Haigh <netwiz@crc.id.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/sXK+1COADtg6px=nk6upgKb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 15 Apr 2011 16:31:08 -0500
Stan Hoeppner <stan@hardwarefreak.com> wrote:

> The overall Newegg rating for the Syba card you deride is 4/5 eggs

I am not deriding anything... but from the way you react to it, I get a
feeling I am talking to a Silicon Image or Syba employee. :)

> across 109 reviews.  If the card was as horrible as you make it out to
> be, the rating would be 1/5 not 4/5, and people would stop buying it.

What is the probability most simply won't notice it? Or they don't use 2 di=
sks
on this card, or don't use them both at full speed. Also I agree that most
likely the bug isn't present on 100% of boards, if you remember the initial
reporter (in Russia) had the problem only on 2 boards of 5 identical ones he
bought.

> Note that the user who posted the read corruption issue referred to a
> single application in Windows 7 where this error occurred, TeraCopy.
> It's far more likely he was up against an application or driver issue
> than a hardware issue with the Syba card.  He did not state whether a
> Windows Explorer copy would also cause the problem, nor xcopy, nor
> Robocopy, etc.

Yes, and still, this is an extremely valuable report. The problem described=
 is
exactly the same what was reported on previous two occasions: "two ports us=
ed
at full speed =3D> silent corruption in files". And now we know the problem=
 is
not limited to the Linux driver, it also appears in Windows 7. But waving it
off as "just a bug in TeraCopy" or whatever, against two previous
confirmations of exactly this type of corruption on exactly this hardware (=
the
3132 controller) in the same circumstances, seems unreasonable to me.

> BTW, did you even read the BackBlaze blog I posted?  They run hundreds
> of this exact Syba 3132 card, with Linux, with mdraid, and have reported
> zero problems.  And they're using a 5:1 PMP on each 3132 port.  If these
> cards, or the 3132 were junk, as you state, surely BackBlaze would have
> run into problems in 2+ years of full production, no?

Again, can you quote where I used the word "junk"...
Regarding the Backblaze blog - yes, I read it. Dunno - did they post any
follow-up if they had to replace some cards? Would they even publish someth=
ing
like that? Would they actually pinpoint some mysterious corruptions now and
then to the controller card? Also if we're talking a hardware bug here(and I
think we do) -- maybe it doesn't surface when PMPs are used instead of disks
directly? Or maybe it doesn't happen with the server-grade Intel motherboard
(which AFAIR they use), but only when the card is combined with PCI-E
implementation of more common chipsets?

> Again, you're taking isolated incidents and assuming they are the norm,
> when they most certainly are not.

"Significant percentage of 3132 cards" is enough to me. Where I'd define
"significant" even as 0.01% of cards. But actually it is likely to be more
widespread than that, given this exact problem was already reported by 3
people on 3 continents with 2 different OSes and 4 controller boards,
including a brand-name one. If this is not a wide sampling, I don't know wh=
at
is...

--=20
With respect,
Roman

--Sig_/sXK+1COADtg6px=nk6upgKb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2pJgoACgkQTLKSvz+PZwjoewCffM++vOtC8gVQAnmvIqdI/VHB
VQUAn0kpzRigpowiuJdTMidb6CDaMD9p
=RyDh
-----END PGP SIGNATURE-----

--Sig_/sXK+1COADtg6px=nk6upgKb--
