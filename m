From: Doug Ledford <dledford@redhat.com>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 	support handoff after pivotroot
Date: Sat, 06 Feb 2010 12:51:02 -0500
Message-ID: <4B6DAC06.6060909@redhat.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>	 <1263242294-5353-3-git-send-email-dledford@redhat.com>	 <20100119110930.107ca42e@notabene> <4B55F138.7060008@redhat.com>	 <20100204174009.6072ec07@notabene.brown> <4B6B15B3.8030205@redhat.com> <e9c3a7c21002041504w17565653m5a8b8cd90543cf1e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBD008D7C2D5FE580462B7221"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c21002041504w17565653m5a8b8cd90543cf1e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, initramfs@vger.kernel.org, martin f krafft <madduck@debian.org>, Michal Marek <mmarek@suse.de>, Hans de Goede <hdegoede@redhat.com>, Bill Nottingham <notting@redhat.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBD008D7C2D5FE580462B7221
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/04/2010 06:04 PM, Dan Williams wrote:
> On Thu, Feb 4, 2010 at 11:45 AM, Doug Ledford <dledford@redhat.com> wro=
te:
>> To be fair, if post-hoc versus initial made any difference what so eve=
r,
>> then so would the fact that I wouldn't have chosen to have these files=

>> exist at all.  I would have made incremental assembly work without a m=
ap
>> file and I would have made imsm superblock handling be in the kernel.
>> So, I'm dealing with the consequences of decisions I didn't make and
>> wouldn't have made.  I don't think it's then fair to put some sort of
>> 'premeditated' versus 'dealing with the situation' bias on my response=
=2E
>=20
> On the argument about where to place the mdmon files I am now torn
> between the "Neil" and "Doug" positions, but on the decision of where
> to place imsm superblock handling I stand behind the design decision
> to put it in userspace.
>=20
> 1/ If you take a look at native md superblock support you see that the
> support code is duplicated between kernel-space and user space, having
> it all handled in userspace means only one code base to maintain
> (elegant aspect #1).

Elegance is in the eye of the beholder.  More on that in a minute.

> 2/ The kernel can simply worry about the *mechanism* of providing raid
> while all the assembly *policy* and support for any number of
> superblock formats is relegated to where policy belongs (elegant
> aspect #2).

I would argue that dirty/clean state manipulation is *not* policy and
*is* mechanism.  So, by your definition of what should be in the kernel
combined with my definition of what dirty/clean state manipulation is,
the solution is not only not elegant, it's flat incorrect.

> 2a/ This simply follows in the path of the design decision to not
> support in-kernel auto-assembly of version-1 superblocks which started
> the requirement to use an initramfs to boot software raid.  (this is a
> not so elegant aspect because it mandates an initramfs to boot, but I
> don't think a general purpose distro can ever get away from that
> requirement).

I'm fine with needing mdadm to assemble the device.  I'm not fine with
needing mdmon once it's assembled.

> I will say that needing to touch several software packages (kernel,
> initramfs, initscripts, mdadm) to get imsm superblock support has
> added some excitement to the process in the short term.  Long term I
> think the elegant aspects of the decision will prove their worth.

I will say that needing to touch multiple software packages might not be
a bad thing, but think of *how* they had to be changed.  We had to add
special exceptions for mdmon all over the place: kernel scheduler (for
suspend/resume, mdmon can't be frozen like the rest of user space or
else writing our suspend to disk image doesn't work), initramfs,
initscripts after initramfs, initscripts on halt, SELinux.  In all these
cases, we had to take something that we want to keep simple and add
special case rules and exceptions for mdmon.  That pretty solidly says
that while this arrangement may have been elegant for *you*, it was not
elegant in the overall grand scheme of things.

What would have been smart was to leave array creation, assembly,
verfication, and modification to user space, but to put *all* of the
raid mechanics, including superblock clean/dirty state processing and
array shut down capabilities, in the kernel.  Had you done that, I would
have called your solution elegant.

It's at this point that I feel obliged to mention that, in terms of this
whole big argument, the incremental map file has at least some amount of
sense belonging in /dev, it's really the mdmon .pid and .sock files that
don't, and those files wouldn't even exist had you designed things as I
mention here.  It's the fact that you have two files per device that you
should be placing in a specific place on the filesystem in order for
them to be useful and adhere to standards yet the program they belong to
needs to exist outside the context of any filesystem that I think is
pretty strong evidence of the inelegance of this design.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigBD008D7C2D5FE580462B7221
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkttrAYACgkQg6WylM+/8ZTNFACeOuItYPGEp3RGHQH4y7eS+sD1
feMAoKxJTVKBFH4KghHh8CT5p4ySh+69
=uHhz
-----END PGP SIGNATURE-----

--------------enigBD008D7C2D5FE580462B7221--
