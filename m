From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 00/13] imsm: new imsm metadata features
Date: Fri, 30 Apr 2010 16:45:54 -0400
Message-ID: <4BDB4182.5060805@redhat.com>
References: <66C59AD0932712458090B447266D638CD405E3B1@irsmsx504.ger.corp.intel.com> <t2se9c3a7c21004291757w49c4697dic28f49245c85ba7a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2CCCF207C7F786AEF35A67B0"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <t2se9c3a7c21004291757w49c4697dic28f49245c85ba7a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2CCCF207C7F786AEF35A67B0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/29/2010 08:57 PM, Dan Williams wrote:
> Basically I am looking for a distro person to say "I guess we can live
> with this" or "no, this violates too many assumptions of our storage
> management code".

So here's the scoop on Fedora and Red Hat Enterprise Linux.

Starting with F12 we use dracut instead of mkinitrd to generate an
initramfs instead of an initrd.  Starting with F13, dracut no longer
needs to embed the mdadm.conf in the image and instead uses the grub
command line to tell the image what arrays to start.  All current
versions of Red Hat Enterprise Linux use mkinitrd/initrd and not dracut,
but as of 6.0 that will change to dracut.

mkinitrd (and maybe dracut in F12, I'm fuzzy on F12's version of
dracut): copies mdadm.conf to initrd, uses name of / raid array *during*
mkinitrd run to determine what to start in initrd on next boot.  So,
your statement that the name is wrong until the next assembly totally
blows this out of the water.  You could run mkinitrd to try and update
things for the new mdadm.conf file and uuid, but the name of the array
will be wrong as reported by the running block subsystem and so mkinitrd
will pull out the old name, and mkinitrd will insert mdadm -A
/dev/md/oldname into the initrd image.  Changing the name of the root
raid array with mkinitrd almost always involves building the initrd
using mkinitrd, then decompressing the image, un-cpioing the image back
into a tree, modifying the linuxrc script from the image to have the
proper mdadm commands, then re-cpioing and compressing the image back
into place.

dracut in F13 or later: things are much simpler here...the dracut images
are much larger, but intended to be generic and they only need to be
built once per kernel version so that the right modules are on there,
after that if you want to update the boot process to a different raid
array all you have to do is change the boot command line.  But, that's
where things are kind of ugly.  The dracut command line starts md raid
arrays by passing the uuid of the array on the command line.  My current
dracut boot command looks like this in grub.conf:

title Fedora (2.6.33.1-19.fc13.x86_64)
	root (hd0,0)
	kernel /vmlinuz-2.6.33.1-19.fc13.x86_64 ro
root=3D/dev/mapper/vg_matrix-root
rd_MD_UUID=3D84c5c9ad:a88bff66:1b228240:bccae394
rd_MD_UUID=3Dd6669b87:ee4c7baf:b196130c:ed87340b rd_LVM_LV=3Dvg_matrix/ro=
ot
rd_NO_LUKS rd_NO_DM LANG=3Den_US.UTF-8 SYSFONT=3Dlatarcyrheb-sun16 KEYTAB=
LE=3Dus
	initrd /initramfs-2.6.33.1-19.fc13.x86_64.img

So, for F13 or later and for Enterprise Linux 6 or later, it would just
mean modifying the uuid in grub.conf (and in mdadm.conf if there is an
appropriate ARRAY line as well) to match the new uuid.  That's at least
more doable than the hackish mkinitrd stuff.  But it's still not good
and any failure to update the config file would result in a failed boot.
 And this is just for x86 arches of course, that doesn't begin to cover
other arch boot mechanisms.  In general, changing uuids is just *bad*.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig2CCCF207C7F786AEF35A67B0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvbQYIACgkQg6WylM+/8ZSGuACfUE9lARH9KCJM9hzn0vE0LQUZ
fcUAmwakoFeRB5Eqb6juI5e9+Zm13LKo
=Twva
-----END PGP SIGNATURE-----

--------------enig2CCCF207C7F786AEF35A67B0--
