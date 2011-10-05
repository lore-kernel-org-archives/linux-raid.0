From: NeilBrown <neilb@suse.de>
Subject: Re: potentially lost largeish raid5 array..
Date: Wed, 5 Oct 2011 13:06:46 +1100
Message-ID: <20111005130646.75d95181@notabene.brown>
References: <201109221950.36910.tfjellstrom@shaw.ca>
	<20110923151108.08c1199f@notabene.brown>
	<201109222322.57040.tfjellstrom@shaw.ca>
	<201109230209.36209.thomas@fjellstrom.ca>
	<20110923191539.110b7be1@notabene.brown>
	<4E7E5266.5040205@shiftmail.org>
	<20110925201025.53bc87f7@notabene.brown>
	<4E87A06E.6080109@shiftmail.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.QLO8lz8fh3YKTeB3dOZxlL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E87A06E.6080109@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Aapo Laine <aapo.laine@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/.QLO8lz8fh3YKTeB3dOZxlL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 02 Oct 2011 01:21:18 +0200 Aapo Laine <aapo.laine@shiftmail.org>
wrote:

> >> - it's not clear what the various functions do or in what occasion they
> >> are called. Except from their own name, most of them have no comments
> >> just before the definition.
> > How about this:
> >   - you identify some functions for which the purpose or use isn't clear
> >   - I'll explain to you when/how/why they are used
> >   - You create a patch which adds comments which explains it all
> >   - I'll apply that patch.
> >
> > deal??
>=20
> I would never dare to commit your comments back to you with my name, not=
=20
> even if you ask me to do so :-)

There is absolutely nothing wrong with taking someones work, adding value,
and contributing it.  You would obviously give credit to the original autho=
r.
This is was open/free licensing is all about.

There is a big difference between an answer to a question and piece of clear
coherent documentation.  The later can certainly use text from the former,
but it also involves thinking about what documentation is needed, where to
put it, how to present it etc.  There is real value in doing that.


>=20
> But thanks for offering to explain the things.
> If you do this on the mailing list everybody is going to read that and=20
> this will be useful to everybody.
>=20
> Actually we could even open a new mailing list or maybe there is=20
> something better in web 2.0, like a wiki, for these MD code=20
> explanations. Explanations in a wiki can be longer, there can be user=20
> discussions, and such lines of comments do not need to be pushed as far=20
> as Linus.

 http://raid.wiki.kernel.org

might be an appropriate place ... once kernel.org is fully functional again.

One of the problems with documentation is that it quickly goes out of date.
The best chance of keeping it up-to-date is to have it in the source tree
with the code.
>=20
> >> - last but not least, variables have very short names, and for most of
> >> them, it is not explained what they mean. This is mostly for local
> >> variables, but sometimes even for the structs which go into metadata
> >> e.g. in struct r1_private_data_s most members do not have an
> >> explanation. This is pretty serious, to me at least, for understanding
> >> the code.
> > Does this help?
> >
> > diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
....
>=20
> YES!
> thanks

I've added that patch to my queue - it should go through in the next merge
window.

NeilBrown


--Sig_/.QLO8lz8fh3YKTeB3dOZxlL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOi7u2G5fc6gV+Wb0RAooxAKCr0qccw2VoMiA4I88yeBmqASmMygCaAsNx
UlhG1a5Umyoje+S4FRXeQ5s=
=ZBEd
-----END PGP SIGNATURE-----

--Sig_/.QLO8lz8fh3YKTeB3dOZxlL--
