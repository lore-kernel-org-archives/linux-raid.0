From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Mon, 29 Oct 2007 19:05:42 -0400
Message-ID: <1193699142.10336.503.camel@firewall.xsintricity.com>
References: <20071020075349.GA17431@teal.hq.k1024.org>
	 <1192885917.1666.112.camel@firewall.xsintricity.com>
	 <20071026095417.GC32550@percy.comedia.it>
	 <1193424779.10336.287.camel@firewall.xsintricity.com>
	 <20071026223046.GB8210@boogie.lpds.sztaki.hu>
	 <1193531160.10336.397.camel@firewall.xsintricity.com>
	 <20071028141336.GC22861@percy.comedia.it>
	 <1193593675.10336.404.camel@firewall.xsintricity.com>
	 <20071029084118.GC15475@percy.comedia.it>
	 <1193671853.10336.428.camel@firewall.xsintricity.com>
	 <20071029214416.GB24635@percy.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cBMxFhO8UHo3sfDjIkwO"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071029214416.GB24635@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-cBMxFhO8UHo3sfDjIkwO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-10-29 at 22:44 +0100, Luca Berra wrote:
> On Mon, Oct 29, 2007 at 11:30:53AM -0400, Doug Ledford wrote:
> >On Mon, 2007-10-29 at 09:41 +0100, Luca Berra wrote:
> >
> >> >Remaking the initrd installs the new mdadm.conf file, which would hav=
e
> >> >then contained the whole disk devices and it's UUID.  There in would
> >> >have been the problem.
> >> yes, i read the patch, i don't like that code, as i don't like most of
> >> what has been put in mkinitrd from 5.0 onward.
> in case you wonder i am referring to things like
>=20
> emit dm create "$1" $UUID $(/sbin/dmsetup table "$1")

I make no judgments on the dm setup stuff, I know too little about the
dm stack to be qualified.

> >> Imho the correct thing here would not have been copying the existing
> >> mdadm.conf but generating a safe one from output of mdadm -D (note -D,
> >> not -E)
> >
> >I'm not sure I'd want that.  Besides, what makes you say -D is safer
> >than -E?
>=20
> "mdadm -D  /dev/mdX" works on an active md device, so i strongly doubt th=
e information
> gathered from there would be stale
> while "mdadm -Es" will scan disk devices for md superblock, thus
> possibly even finding stale superblocks or leftovers.
> I would strongly recommend against blindly doing "mdadm -Es >>
> /etc/mdadm.conf" and not supervising the result.

Well, I agree that blindly doing mdadm -Esb >> mdadm.conf would be bad,
but that's not what mkinitrd is doing, it's using the mdadm.conf that's
in place so you can update the mdadm.conf whenever you find it
appropriate.

And I agree -D has less chance of finding a stale superblock, but it's
also true that it has no chance of finding non-stale superblocks on
devices that aren't even started.  So, as a method of getting all the
right information in the event of system failure and rescuecd boot, it
leaves something to be desired ;-)  In other words, I'd rather use a
mode that finds everything and lets me remove the stale than a mode that
might miss something.  But, that's a matter of personal choice.
Considering that we only ever update mdadm.conf automatically during
installs, after that the user makes manual mdadm.conf changes
themselves, they are free to use whichever they prefer.

The one thing I *do* like about mdadm -E above -D is it includes the
superblock format in its output.  The one thing I don't like, is it
almost universally gets the name wrong.  What I really want is a brief
query format that both gives me the right name (-D) and the superblock
format (-E).

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-cBMxFhO8UHo3sfDjIkwO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJmdGTzP9PM7pjw8RAv+TAJ4pn7T9ApuQdVsdcGT97405r1XNcACcCnf2
DoozTbm8rPLk2B5dyVCUHO0=
=2awV
-----END PGP SIGNATURE-----

--=-cBMxFhO8UHo3sfDjIkwO--

