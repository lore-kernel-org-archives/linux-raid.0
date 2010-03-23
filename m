From: Doug Ledford <dledford@redhat.com>
Subject: Re: Minor mdadm fixes
Date: Tue, 23 Mar 2010 15:20:10 -0400
Message-ID: <4BA9146A.2050901@redhat.com>
References: <4BA2DDB2.2040508@redhat.com> <20100319070153.GA12455@maude.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1894B364D44EFF8EF7A4F118"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100319070153.GA12455@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1894B364D44EFF8EF7A4F118
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/19/2010 03:01 AM, Luca Berra wrote:
> On Thu, Mar 18, 2010 at 10:13:06PM -0400, Doug Ledford wrote:
>> Second: mdadm-3.1.2-mapfile.patch
>> Problem: Neil's support for putting the mdadm map file wherever you ne=
ed
>> it is nice, but one place in particular needs a special case.
>> Specifically, mdadm already creates /dev/md if needed to store symlink=
s,
>> or in the case of mdmon needing to create pid/sock files (if ALT_RUN i=
s
> why on earth do you want to set ALT_RUN=3D/dev/md ?

Because on Fedora /lib/init/rw doesn't exist, and neither does any other
early rw area other than /dev, and it's too late to create a new one, so
I need to use someplace in /dev.  However, I agree with Neil that if you
are hiding things under . names then you are admitting something isn't
right.  So, I'm perfectly happy putting the map file in /dev/md as I
think it has a perfect right to exist there.

> it is messy enough as it is, let's keep assuming /dev/md contains only
> array device files.

I don't know how many arrays you have on your system, but I would hardly
call /dev/md messy.

> besides that you will discover that the only way to make mdmon work is
> setting VAR_RUN and ALT_RUN to the same value,

[ citation needed ]

> something we can
> guarantee to be writable even in the direst situation, and i'd keep
> /dev/.mdadm

There is no guarantee /dev/.mdadm exists on a clean install, where as I
have made sure that all possible places that might need /dev/md will
create it if it doesn't exist.  Hence, the direst of situations is
handled better with /dev/md than with /dev/.mdadm

>> Fourth: mdadm-3.1.2-mapname.patch
>> Feature: If we are able to easily select the location of the mapfile v=
ia
>> the use of ALT_RUN at compile time, it makes sense to also be able to
> this "hunt the mapfile" thing is already ugly as it is, why do we need
> an ALT_MAPNAME?

Because /dev/md/map is too easy a name to conflict with a legitimate md
array device name, and that's what it defaults to if you set ALT_RUN to
/dev/md.

> if there was any value (except for allowing to set
> ALT_RUN to /dev/md) to having the mapfile named differently, just force=

> it to be called mdadm.map everywere (or incremental.map so the name
> reflects the need for the file existance)

Except I set it to md-device-map.  Aside from not conflicting with md
device names, the map file name is mostly irrelevant except to indicate
to people perusing the directory what the file is for as nothing uses it
besides mdadm and mdadm will gladly use it with whatever name you call
it as it both creates and uses the file from the same compile time
configuration setting.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig1894B364D44EFF8EF7A4F118
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkupFGoACgkQg6WylM+/8ZTy7wCfUMTL+cJZbMF/gSzdtsKiVSCj
DRAAoI4lz4GvOaqDMcwdSwp0RjghDht5
=tAS1
-----END PGP SIGNATURE-----

--------------enig1894B364D44EFF8EF7A4F118--
