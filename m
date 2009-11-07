From: Doug Ledford <dledford@redhat.com>
Subject: Re: Clarify /etc/mdadm.conf format and content?
Date: Sat, 07 Nov 2009 12:06:40 -0500
Message-ID: <4AF5A920.1020601@redhat.com>
References: <babafd2f0911042153y427d3194w520f2294f0ff7f53@mail.gmail.com> 	<4877c76c0911042217r76d7e46cg4ceeb391e9098a6@mail.gmail.com> 	<babafd2f0911042321k4dfda707he80f40596fba2a3b@mail.gmail.com> 	<4877c76c0911042331i15f53768s382512200f02c398@mail.gmail.com> <babafd2f0911050824u327c2ca3y43ab557b52f9356@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA4242D998DAFBD87D48F8EB5"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <babafd2f0911050824u327c2ca3y43ab557b52f9356@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ben DJ <bendj095124367913213465@gmail.com>
Cc: Michael Evans <mjevans1983@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA4242D998DAFBD87D48F8EB5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/05/2009 11:24 AM, Ben DJ wrote:
> On Wed, Nov 4, 2009 at 11:31 PM, Michael Evans <mjevans1983@gmail.com> =
wrote:
>> To better cooperate with various initrd and recovery cd you should
>> probably use a numeric only array name, as well as the /dev/mdX
>> numbering scheme.
>=20
> Ok.  That still doesn't address why different commands in mdadm
> generate different numbering schemes.

The answer to that is technical implementation details.  Specifically,
mdadm -D examines the actual raid array you pass in on the command line.
 Since the array is up and running, it knows *exactly* what you want the
name to be because it's already using it.  For mdadm -E, it examines the
superblock on the constituent device.  That superblock only has the name
field to tell it what the device name is (and what it gets assembled as
could be totally different if the mdadm.conf file spelled out that uuid
as having another name).  So, it reports what the mdadm standard name
would be if it were assembled without an mdadm.conf entry to tell it
what it's supposed to be.

> How do I change the name=3D spec'n?  Do I simply add something to
> /etc/mdadm.conf and reboot?  Or do I need to init3, stop the LVM, stop
> the array, assemble-with-update, change in mdadm.conf, then ,
> re-mkinitrd?  Or, since mdadm.conf is ON root ON the arary do I need
> to boot from a rescue disk, then complete all the steps?

When running mdadm -D or -E, the name it outputs is more informative
than anything else.  If you save that output to mdadm.conf, then edit
the ARRAY line to use another name, that name in the array line will
trump the name produced by either mdadm -D or mdadm -E.  So, if you
actually want to change the name of the array as it stands each time you
boot up the machine, then you need to edit the mdadm.conf file to put
the new name in, you need to edit the fstab file and change any
references to the old name to the new name, you need to edit the
grub.conf file (or if you have a different boot loader then the config
file for whatever boot loader that it) and likewise change all
references of the old name to the new name, and finally you will likely
need to remake your initrd images so that they contain the updated
mdadm.conf file and the updated name references.

Now, if you are talking about just changing the name of the array in the
superblock, but leaving how it's referenced alone, then you can assemble
the array with the --update=3Dname option and specify the new name.  As I=

pointed out, this doesn't actually change what name the array gets
created as.  The ARRAY line in mdadm.conf controls that.  However, be
warned that if the ARRAY line in mdadm.conf references the old name,
then now assembly will fail to work because you'll match the UUID of the
array, but not the name, and mdadm will throw it out.  So, if the name=3D=

option is in your mdadm.conf ARRAY line for the array, then changing the
name of the array will require that you do everything I listed above to
update the mdadm.conf file in your mkinitrds and such or else the system
won't boot after you update the name in the superblock.  One last thing,
if this is a / array, then since the only way to update the name is
during assembly, you would have to boot the system from rescue CD and
assemble the array by hand, or else modify the init script in an initrd
image to do the update for you.  Neither of which is a necessarily easy
task if you don't know what you are doing.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigA4242D998DAFBD87D48F8EB5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr1qSAACgkQg6WylM+/8ZSwSwCfdvBINNA5+4G9nYaL4lvBNI6u
nkoAn36+8Y7ZTfnqWFYPniGQwApLEKGV
=Z08y
-----END PGP SIGNATURE-----

--------------enigA4242D998DAFBD87D48F8EB5--
