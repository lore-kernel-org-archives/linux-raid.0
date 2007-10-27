From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Sat, 27 Oct 2007 17:11:11 -0400
Message-ID: <1193519471.10336.359.camel@firewall.xsintricity.com>
References: <18200.49267.763509.924873@stoffel.org>
	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	 <18200.53593.687483.120827@stoffel.org>
	 <1192810534.1666.68.camel@firewall.xsintricity.com>
	 <18200.56684.14194.630264@stoffel.org>
	 <1192813877.1666.79.camel@firewall.xsintricity.com>
	 <18200.63987.514073.184865@stoffel.org>	<471E7DC6.7050206@tmr.com>
	 <1193184555.10336.3.camel@firewall.xsintricity.com>
	 <18207.56169.769976.512617@notabene.brown>	<471FDEB1.8040401@garzik.org>
	 <47204F45.4010205@dgreaves.com> <18209.34365.375059.602828@notabene.brown>
	 <4721F742.1090301@tmr.com>
	 <1193424116.10336.281.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rNdm1DnxWPg/PdCqTKtV"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193424116.10336.281.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-rNdm1DnxWPg/PdCqTKtV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-26 at 14:41 -0400, Doug Ledford wrote:
> Actually, after doing some research, here's what I've found:

> * When using grub2, there is supposedly already support for raid/lvm
> devices.  However, I do not know if this includes version 1.0, 1.1, or
> 1.2 superblocks.  I intend to find that out today.

It does not include support for any version 1 superblocks.  It's noted
in the code that it should, but doesn't yet.  However, the interesting
bit is that they rearchitected grub so that any reads from a device
during boot are filtered through the stack that provides the device.
So, when you tell grub2 to set root=3Dmd0, then all reads from md0 are
filtered through the raid module, and the raid module then calls the
reads from the IO module, which then does the actual int 13 call.  This
allows the raid module to read superblocks, detect the raid level and
layout, and actually attempt to work on raid0/1/5 devices (at the
moment).  It also means that all the calls from the ext2 module when it
attempts to read from the md device are filtered through the md module
and therefore it would be simple for it to implement an offset into the
real device to get past the version 1.1/1.2 superblocks.

In terms of resilience, the raid module actually tries to utilize the
raid itself during any failure.  On raid1 devices, if it gets a read
failure on any block it attempts to read, then it goes to the next
device in the raid1 array and attempts to read from it.  So, in the
event that your normal boot disk suffers a sector failure in your actual
kernel image, but the raid disk is otherwise fine, grub2 should be able
to boot from the kernel image on the next raid device.  Similarly, on
raid5 it will attempt to recover from a block read failure by using the
parity to generate the missing data unless the array is already in
degraded mode at which point it will bail on any read failure.

The lvm module attempts to properly map extents to physical volumes and
allows you to have your bootable files in lvm logical volume.  In that
case you set root=3Dlogical-volume-name-as-it-appears-in-/dev/mapper and
the lvm module then figures out what physical volumes contain that
logical volume and where the extents are mapped and goes from there.

I should note that both the lvm code and raid code are simplistic at the
moment.  For example, the raid5 mapping only supports the default raid5
layout.  If you use any other layout, game over.  Getting it to work
with version 1.1 or 1.2 superblocks probably wouldn't be that hard, but
getting it to the point where it handles all the relevant setups
properly would require a reasonable amount of coding.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-rNdm1DnxWPg/PdCqTKtV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHI6lvTzP9PM7pjw8RAu4pAJ9yNrwZ9JgX7YL45UsbIV/tDnWhLgCcDbjh
s0+amvmT2q+e3mKEmTKjjm4=
=GXcD
-----END PGP SIGNATURE-----

--=-rNdm1DnxWPg/PdCqTKtV--

