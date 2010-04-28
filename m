From: Doug Ledford <dledford@redhat.com>
Subject: Re: More Hot Unplug/Plug work
Date: Wed, 28 Apr 2010 17:16:01 -0400
Message-ID: <4BD8A591.3000702@redhat.com>
References: <4BD714A3.9020801@redhat.com> <905EDD02F158D948B186911EB64DB3D11C954788@irsmsx503.ger.corp.intel.com> <4BD874CB.5040803@redhat.com> <20100428205937.GB6065@maude.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig365C32A0EC6D10582FF48A29"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100428205937.GB6065@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig365C32A0EC6D10582FF48A29
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/28/2010 04:59 PM, Luca Berra wrote:
> On Wed, Apr 28, 2010 at 01:47:55PM -0400, Doug Ledford wrote:
>> DOMAIN path=3Dpci-0000:00:1f.2-scsi-[2345]:0:0:0 action=3Dpartition
>>     table=3D/etc/mdadm.table program=3Dsfdisk
> i admit i did not take the time to pull from your git, so tell me to
> rtfc if needed.

rtfc ;-)

> it seems you are assuming program will take table as stdin.

No, table is program specific.  In this case, for sfdisk, it would be
something taken as stdin.  However, in the code, there is a specific
handler for the sfdisk program type.  That handler provides a validate
routine to check the contents of the table=3D entry and make sure it's
valid, a check routine to check the table on a given disk and see if it
matches what it's supposed to be, and a write routine to update the
disks table to what it should be.  How it goes about doing these things
is particular to the sfdisk handler.  I do have plans to add a more
generic simple script handler that would allow you to pass things in as
you suggest, but I have not yet implemented it.  And part of the reason
is that I'm extremely leary of the security implications of allowing a
text file to spell out a program to be called by a root invoked system
daemon.  I can see a million different ways to compromise a system when
a daemon with raw disk access reads a command from a text file.

> would not it be better to use somethink like
> action=3Dinitialize command=3D"sfdisk %d < /etc/mdadm.table" ?
> where command is invoked via a shell and %d is replaced with the device=

> node. (more escapes could also be useful, e.g. the sysfs node)

This is precisely what the sfdisk handler will be doing, only it won't
be reading the command from the text file, it will have the knowledge of
how to invoke sfdisk safely compiled into the program where compromise
is much more difficult.

> besides that is there any provisioning to check that the device really
> is empty before running action?

Yes.  In the code that tries to take new disks, it requires either the
force-partition option or that the device be declared clean, which per
Neil's suggestion is that both the first 4k and last 4k of the device is
comprised entirely of one of three patterns: 0x00, 0x5a, 0xff.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig365C32A0EC6D10582FF48A29
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvYpZEACgkQg6WylM+/8ZRkdQCfdXuPNgAheGhjhRBuiT+R1NpC
we8AnixmLyrkhiJWtPGSWNRfsptmhjXj
=8Q9d
-----END PGP SIGNATURE-----

--------------enig365C32A0EC6D10582FF48A29--
