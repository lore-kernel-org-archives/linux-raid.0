From: Doug Ledford <dledford@redhat.com>
Subject: Re: converting to raid - Error 2
Date: Wed, 05 May 2010 19:57:24 -0400
Message-ID: <4BE205E4.8090308@redhat.com>
References: <4BDB4076.7010909@vorgon.com> <4BDB4358.80009@redhat.com> <4BDB5268.8050102@vorgon.com> <4BE19BEB.1040009@redhat.com> <4BE1B489.1050906@vorgon.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig14C0EEB2E4A9847865D76F35"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BE1B489.1050906@vorgon.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig14C0EEB2E4A9847865D76F35
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/05/2010 02:10 PM, Timothy D. Lenz wrote:

>>> grub>  setup (hd0)
>>>   Checking if "/boot/grub/stage1" exists... yes
>>>   Checking if "/boot/grub/stage2" exists... yes
>>>   Checking if "/boot/grub/e2fs_stage1_5" exists... yes
>>>   Running "embed /boot/grub/e2fs_stage1_5 (hd0)"...  15 sectors are
>>> embedded.
>>> succeeded
>>>   Running "install /boot/grub/stage1 (hd0) (hd0)1+15 p
>>> (hd0,0)/boot/grub/stage2 /boot/grub/menu.l
>>> st"... succeeded
>>> Done.
>>> ---------------------------------------

>> Normally sda would be the one I would use, but sda1 would work as long=

>> as you have a normal DOS master boot record on the drive.
>>

A normal DOS master boot record is one that resides in the master boot
record of the drive and that knows to chain load the next boot sector
from the first sector of the partition that's marked active.  So, if you
install a boot loader on sda1, you have to have the normal DOS master
boot record in the master boot record of the drive.  Once you install
grub on the bare drive (aka, on sda instead of sda1), you wipe out any
other boot loader in the master boot record and replace it with a grub
master boot record.  So, at this point you probably don't have a normal
DOS master boot record (unless the grub one suffices but I don't think
it does) and will need to make sure to install whatever new boot loader
you install to sda versus sda1 or else it won't overwrite the previous
grub master boot record.

> I was thinking making one more try, but ether using su instead of sudo
> or just logging in as root as some stuff doesn't seem to work with sudo=
=2E
> Need to find the time when I'm home long enough with no interruptions t=
o
> try it:).

Sudo versus su versus logging in as root shouldn't matter as long as
whatever command you are running doesn't come back with some sort of
error message.

> Before I try the manual install, do you know what the "1+15 p" is in th=
e
> install line the auto system did?

Prior to the install line that the setup macro does, it embedded the
e2fs_stage1_5 on the disk between the partition table and the start of
the first partition.  The (hd0)1+15 means to load sectors 1 through 15
of (hd0) as the next stage in the boot loader.  The p is separate and
merely means patch the block list for the next part of the boot loader
into the previous part.  It can be omitted as grub does this anyway
based upon the number of stages you specify.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig14C0EEB2E4A9847865D76F35
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkviBe0ACgkQg6WylM+/8ZSd+gCfV+xaZ7IWaciHtPLlCLliToT/
TmYAoIKQCEBJ9QiutEwDs5MyfEN/jC5n
=rNhP
-----END PGP SIGNATURE-----

--------------enig14C0EEB2E4A9847865D76F35--
