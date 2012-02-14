From: NeilBrown <neilb@suse.de>
Subject: Re: SES Enclosure Management.
Date: Wed, 15 Feb 2012 07:31:30 +1100
Message-ID: <20120215073130.792d4fae@notabene.brown>
References: <CAB9NSeUBZXdGRkNNzYjC-KmJjv_AUp4bD_dJH2XyzkuO7PUPcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Y+ob6YCLKTZqHOkz2bFXqbq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB9NSeUBZXdGRkNNzYjC-KmJjv_AUp4bD_dJH2XyzkuO7PUPcw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Woodworth <robertjwoodworth@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Y+ob6YCLKTZqHOkz2bFXqbq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Feb 2012 10:30:37 -0700 Robert Woodworth
<robertjwoodworth@gmail.com> wrote:

> Has anyone ever thought of integrating SES managed enclosures into the
> kernel RAID system?  I briefly looked through the archives and have
> not found anything on the topic.
>=20
> Some HW based RAID controllers do this flawlessly now, there is no
> reason why the kernel RAID cannot also.  (LSI MegaRAID)
>=20
> 1) When a drive is part if a managed enclosure, the RAID system should
> address it by location instead of by enumerated device node.  The SES
> device in the enclosure can map the physical slot to a physical drive.
>  The RAID admin (mdamd) should be able to add/fail/identify devices
> based on slot.

Does this just mean that the admin should using names in /dev/disk/by-path/
rather than /dev/sdXX to address devices?  What can md or mdadm do to help?

>=20
> 2) If the RAID system fails a drive, it should notify the SES
> management and turn on the fail bit and the fail LED.

"mdadm --monitor" will run a script on drive failure.  This could easily
notify the SES management.

So maybe all we need here is a script to plug in to mdadm... Would you like
to write one?

>=20
> 3) The RAID system should be able to turn on the 'identify' bit and
> LEDs for an array or a single drive.

Again, it sounds like you just need a script to ask mdadm which devices are
included in a given array, and then do whatever magic is needed to turn on
the light.
It is fairly easy to extra the device list from the output of
  mdadm --detail --brief --verbose /dev/md/whatever

but it might be good to make it easier to extra from
  mdadm --detail --export /dev/md/whatever

Would you like to write such a script?

>=20
> I'm currently doing firmware on a managed enclosure.  Although my
> vendor only supports LSI MegaRAID, there is no reason why my
> enclosures cannot work in the same manner on a kernel RAID system.
>=20
>=20
>=20
> Request for comments...

It sounds to me like you just need a few scripts to provide some
enclosure-specific functionality.  I would be happy to include them in the
mdadm distribution.

Or maybe there is something that I didn't understand??

Thanks,
NeilBrown



> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/Y+ob6YCLKTZqHOkz2bFXqbq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzrEojnsnt1WYoG5AQIrFRAAsW1oQlE61ijiGYiIOaKwB9ccF9AVIPNq
/cNR0tFHGQPiky96BnBNniAQPH49i5VCxbp5J708ofbeEPKF3rWNil1MHJfEC+qG
2AqrRW/bENqvEHiLYsQXRkeeOSoqXGFQwYEeLtKKpmAtJZ8lCIFBXCfmoN98rCkk
B1we3kxVpo/olZZTCIojtVnTj8kLg8v7mRCqIFO1yF3OKhgvY3R3XBM1Dt4VxSVl
bj/yC/fAQHVvG8UIUIMaJWZW7WSsdww73PXeNnozFvOgu3XHARBlrDPSXo0CK77w
CZ05jOA793drDgKMFSbxirJse57a/1AzC5iEZWhASvcR0oyfCNrNsJ3ERzyd3xB1
n6PPFvT4+XKFPv4haHdieR/Xbcm5ovKLwb55N9yjQBaXuzWrfNiRViBg7xR0zhHE
V8TRzSkYv3PpYQwgy5nn8C0Zoi0yxXkLNhYgikB9mGZ+qCb56QEJXVugAa+MLRv0
VRE/VkbwOKzmHrvTaWYqqGAPhw1wSb6E8IpiMxSxSkEAC/tsbcpBB2/e8d2S9RTC
h6r3AI6SC0Y0pRalGuBso+giMukPra5QnV2iJOp41EPYa75OZ0vAQPcoH+k8Cluc
HUq1uZka93xHARgSgykEPjcMthzDMkYClKgk7IRR1k+Z8x6aNOewbglOnuC9E5LE
i7Ot3HIg5Gs=
=LcPR
-----END PGP SIGNATURE-----

--Sig_/Y+ob6YCLKTZqHOkz2bFXqbq--
