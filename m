From: Nagilum <nagilum@nagilum.org>
Subject: Re: Software Raid 5 work on ROOT ?
Date: Tue, 08 Sep 2009 12:34:22 +0200
Message-ID: <20090908123422.13526q1f9zbd1dcs@cakebox.homeunix.net>
References: <1252059563.4aa0e9ab25de3@imp.free.fr>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary="=_6j2dp6m090kk";
 protocol="application/pgp-signature";
 micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1252059563.4aa0e9ab25de3@imp.free.fr>
Sender: linux-raid-owner@vger.kernel.org
To: lfmarante@free.fr
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_6j2dp6m090kk
Content-Type: text/plain;
 charset=ISO-8859-2;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

The way I worked around this is to boot off of a USB stick.
So grub is installed on the USB stick, reads the kernel and the initrd  
from it, the initrd brings up the disk, the raid, the dm-crypt and the  
lvm, mounts / from the lvm and boots it.
Kind regards,

----- Message from lfmarante@free.fr ---------
     Date: Fri, 04 Sep 2009 12:19:23 +0200
     From: lfmarante@free.fr
  Subject: Software Raid 5 work on ROOT ?
       To: linux-raid@vger.kernel.org


> Hello every body.
>
> I have a question in regard of booting linux under a raid 5. It is possible ?
> All the guides that I found on the net say to have a /boot not  
> stripped, (raid1
> is ok). [EX:  
> http://www.gentoo.org/doc/en/gentoo-x86+raid+lvm2-quickinstall.xml
> ]
>
> They say to have / not stripped too. And these guide show to have an  
> raid 1 boot
> and / and create a LVM volume for /usr /opt /var /whatever that can  
> be raid 5.
> It is not easiest to have directly / in raid 5 format ?
> If it's possible I would prefere to have raid 5 /
> There any particular configuration for grub to boot it?
>
> Thanks in advance.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


----- End message from lfmarante@free.fr -----



========================================================================
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
========================================================================


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..


--=_6j2dp6m090kk
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (FreeBSD)

iEYEABECAAYFAkqmMy4ACgkQAKWN2UY+sLy95QCgreEiLhD1yyr0LuumkSbCnV/H
RaQAoIJoBSqY/3UpOuFLHURJcVxqk9gO
=5ige
-----END PGP SIGNATURE-----

--=_6j2dp6m090kk--
