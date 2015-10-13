From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 00/14] md-cluster: A better way for METADATA_UPDATED processing
Date: Wed, 14 Oct 2015 07:12:15 +1100
Message-ID: <87h9luzfxc.fsf@notabene.neil.brown.name>
References: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: rgoldwyn@suse.de, linux-raid@vger.kernel.org
Cc: gqjiang@suse.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

rgoldwyn@suse.de writes:

> The processing of METADATA_UPDATED message is too simple and prone to
> errors. Besides, it would not update the internal data structures as
> required.
>
> This set of patches reads the superblock from one of the device of the MD
> and checks for changes in the in-memory data structures. If there is a change,
> it performs the necessary actions to keep the internal data structures
> as it would be in the primary node.
>
> An example is if a devices turns faulty. The algorithm is:
>
> 1. The initiator node marks the device as faulty and updates the superblock
> 2. The initiator node sends METADATA_UPDATED with an advisory  device number to the rest of the nodes.
> 3. The receiving node on receiving the METADATA_UPDATED message
>   3.1 Reads the superblock
>   3.2 Detects a device has failed by comparing with memory structure
>   3.3 Calls the necessary functions to record the failure and get the device out of the active array.
>   3.4 Acknowledges the message.
>
> The patch series also fixes adding the disk which was impacted because of
> the changes.
>
> Patches can also be found at
> https://github.com/goldwynr/linux branch md-next
>
> Changes since V2:
>  - Fix status synchrnoization after --add and --re-add operations
>  - Included Guoqing's patches on endian correctness, zeroing cmsg etc
>  - Restructure add_new_disk() and cancel()

Thanks a lots.  Looks good.

I have pull all this in and will push it out shortly.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWHWWfAAoJEDnsnt1WYoG59pQQALmLamm68APBg4W9BisrzOjF
tFGzdgm8TTlDOFnrcekEdMGQHqyFhLeA8eMm3E0lhrB20N4tFCyCEGMpaWiRULX9
PDzvdWKS6beUgcdWnS5a8hPhp35sPS2G8npH/0vA51ZWZa0NHdqQndWgUdwxbcQd
ALWCq2RhjUEIbSF7SN1IIq0WGiHhBjOqho/fz+uG+PEHaSm1gYZbVlWBFb0rQkLR
Q6DIqOTJdwIVqzzwVs5EE3pwAJTpFB2Men8BYbt/vh+U8GH/xV42CBVcRoc7S7ya
DYf+s3IVWM6bE8JE0Bq6Vi+/JfNt2rV6Yqu/3Om9SJaN6ZMRTYddLgXzqDouXmGz
MNhPlr5sVQDSUIgB/DPVPAIkww8qj0qQvNqqXc3OOQhH+tH3Rnpu9tiolBdzO5DG
PZPSX4MZhp5hcY+bgZLStd7prUza9PdSVtDIbpetwLjBUqFrDj25V7pEZ/ZuAUtw
yhKwoxf03QDgz00y4MCfPwUCBzAcrnz1+DKQkr3dpPAURImCJrPFAhyrVnGF6iYC
IgfC/GekY4h71dbLxgFKzpO6Z/Hf6c8vrqYe/Nfk2bDUIxDQ9le4VX26bQN02TlL
+175Dd/b8jENlEfwbex2O0JtR2B+wjVsf+QtsRp0RfWtxaHXzSkwDxCNruEuKbIm
CaKIxecwBdS4laT7aBb3
=Yx0H
-----END PGP SIGNATURE-----
--=-=-=--
