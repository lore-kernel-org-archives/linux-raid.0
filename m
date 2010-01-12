From: Doug Ledford <dledford@redhat.com>
Subject: Re: Minor mdadm fixes
Date: Mon, 11 Jan 2010 22:36:40 -0500
Message-ID: <4B4BEE48.1000305@redhat.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com> <alpine.LNX.2.01.1001111541200.3360@filesrv1.baby-dragons.com> <20100112031027.GL7517@skl-net.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEE1685E5ACDD848EB0C94A2E"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100112031027.GL7517@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: "Mr. James W. Laferriere" <babydr@baby-dragons.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEE1685E5ACDD848EB0C94A2E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/11/2010 10:10 PM, Andre Noll wrote:
> On 15:49, Mr. James W. Laferriere wrote:
>> 	Hello Doug ,
>>
>> On Mon, 11 Jan 2010, Doug Ledford wrote:
>>> These are a number of minor fixes we carry in our mdadm at the moment=
=2E =20
>>> Would
>>> prefer not to carry them ourselves ;-)
>>>
>>> Neil, any clue when you think might release mdadm-3.1.2?
>> 	Would you please annotate the git diffs you sent out ?
>> 	For one I am very confused about the change of
>>
>> -       sprintf(path, "/var/run/mdadm/%s.pid", devname);
>> +       sprintf(path, "/dev/.mdadm/%s.pid", devname);
>>
>> 	why ?  For one .
>>
>> 	None of the other patches has a annotation either .  While if one is =

>> 	a kernel coding guru they are probably very readable .  I am not but =
would=20
>> like to know what the intention is for the change(s) .
>=20
> The annotation is the subject line :)
>=20
> Before switching root it is sometimes desirable to mount --bind (or
> --move) the current /dev into the new root as the programs started
> from the new root will need the device nodes. For example the init
> scripts that run from the intramfs move /dev after it has been mounted
> as a ramfs and populated.
>=20
> I believe (Doug, please correct me if the following is wrong) the
> advantage of storing mdmon's pid files in /dev is that in /dev they
> remain visible after the switch to the new root. That's the "handoff
> after pivotroot" in the subject.

I'm a little fuzzy on this myself.  The original patch was from another
Red Hatter that works on dracut, the new mkinitrd replacement in Fedora
12.  When integrating IMSM support in the md raid stack and dracut,
there became a problem with starting mdmon in the initramfs filesystem
and then transitioning it to the new filesystem.  It turns out that, as
you point out, because /dev is moved from the initramfs to the new root
(mainly because udev is now started in the initramfs), we could avoid a
number of issues caused by mdmon's files being in /var/run instead of
/dev.  This also allowed us to do the mdmon restart *after* the
switchroot had taken place and solved a number of issues with getting
mdmon support to work.  Like I said, I'm a bit fuzzy on the details
myself because it was Hans de Goede that was doing this work, not me,
and I just vaguely recall the problems this patch solved.  But, it's not
surprising given that we already did a similar patch to move the
mdadm.map file from /var/run/mdadm to /dev simply because during the
very early boot stages after you have done the switch root, /var/run is
usually read only while /dev/ is read write and incremental assembly
won't work properly when it can't write to the mdadm.map file.  So,
really this is in the same vein although the specific issues are differen=
t.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigEE1685E5ACDD848EB0C94A2E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktL7kgACgkQg6WylM+/8ZThAACeKAkgIdTaUYL9bNSWSmZch2to
/XEAniEa+xXyc23RFABLL67Fb+46RC3h
=Cg7r
-----END PGP SIGNATURE-----

--------------enigEE1685E5ACDD848EB0C94A2E--
