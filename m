From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?=
	<phcoder@gmail.com>
Subject: Re: Bug#597563: grub-common: grub-probe segfaults scanning lvm devices
Date: Sat, 08 Jan 2011 13:41:29 +0100
Message-ID: <4D285B79.9040100@gmail.com>
References: <20100920202854.27101.8288.reportbug@cheetah.fastcat.org> <4D274FF9.8010004@gmail.com> <alpine.DEB.2.00.1101072241560.25170@cheetah.fastcat.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig57187BA8571BB9342AE57BB3"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1101072241560.25170@cheetah.fastcat.org>
Sender: linux-raid-owner@vger.kernel.org
To: Matthew Gabeler-Lee <cheetah@cheetah.fastcat.org>
Cc: 597563@bugs.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig57187BA8571BB9342AE57BB3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

As was recommended I forward the remaining part to linux-raid mailing lis=
t.
In short: on his system mdraid, raid5, 4 devices, metadata (presumably)
0.90, two devices have index 0.
If such situation is valid please advice me on how such situation should
be handled.
@Matthew: could you supply mdadm -Q outputput and *last* 64K of every dis=
k?
On 01/08/2011 05:08 AM, Matthew Gabeler-Lee wrote:
> On Fri, 7 Jan 2011, Vladimir '=CF=86-coder/phcoder' Serbinenko wrote:
>
>> I believe it to be a problem with raid5. Could you try the latest
>> upstream? If problem persists I would need following dumps:
>> dd if=3D/dev/sd[abcd]3 of=3D[abcd].img bs=3D1024 count=3D64
>> dd if=3D/dev/md2 of=3D2.img bs=3D1024 count=3D64
>> grub-fstest -c 4 /dev/sda3 /dev/sdb3 /dev/sdc3 /dev/sdd3 hex -l
>> '(md2)+128' > g2.img
>
> OK, built grub from latest bzr trunk.
>
> From my past workarounds, I effectively have a list of all the
> invocations of grub-probe that grub-install/grub-setup runs on my
> system.  Most of those work fine now.  The only thing that isn't fine
> is that most invocations spit out a message "error: found two disks
> with the number 0" but give a correct answer and exit successfully.
>
> If I run grub-probe with enough --verbose arguments, then that message
> gets this context:
>
> grub-core/disk/raid.c:699: Scanning for RAID devices on disk hd2
> grub-core/kern/disk.c:245: Opening `hd2'...
> ./grub-probe: info: the size of hd2 is 1465149168.
> error: found two disks with the number 0.
> grub-core/kern/disk.c:330: Closing `hd2'.
>
> So, it seems maybe you're right that there's something funky with the
> raid5.  The outputs you requested are attached.  The grub-fstest
> invocation complained that -l is not a valid option, I hope the output
> without it is still what you want / need.  I included the full output
> of one of the complaining grub-probe invocations too, on the guess
> that it might be helpful.
>
> FWIW, the raid5 array in question has had every disk swapped at least
> once in its life span, including from growing from 3 to 4 disks, and
> from smaller to larger disks, not to mention one or two disk failures
> along the way.
>


--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko



--------------enig57187BA8571BB9342AE57BB3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF0EAREKAAYFAk0oW3kACgkQNak7dOguQglp4AD4unhg3tQazNTyMUtLCbt7y9mu
bPoALYb6oYtTT7EihAEAgDIELSFp+3hkU8wlKh1mXq+zRDJIyJIPJHzZEgoz4HI=
=/mif
-----END PGP SIGNATURE-----

--------------enig57187BA8571BB9342AE57BB3--
