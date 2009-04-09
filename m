From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch] mdadm: move mdadm.map file into /dev/md
Date: Thu, 9 Apr 2009 15:25:29 -0400
Message-ID: <B440D9C9-91D6-4491-A3AF-D9E1478EDBA9@redhat.com>
References: <E2135ED2-AC92-48FE-843E-9E8C83B12729@redhat.com> <87tz51dmmu.fsf@frosties.localdomain> <FF2073B4-6922-4D16-8FA7-90C66071C6F6@redhat.com> <155bf3edda1c2692d316807ff5f58f30.squirrel@neil.brown.name> <87prfof1bp.fsf@frosties.localdomain> <18908.17619.375078.291547@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-73--995075099"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18908.17619.375078.291547@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, LinuxRaid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-73--995075099
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit

On Apr 8, 2009, at 2:31 AM, Neil Brown wrote:
> I'm leaning towards:
>
> - to open for reading, if /var/run/mdadm/map doesn't exist,
>   try /dev/.mdadm.map
> - to open for writing, if opening /var/run/mdadm/map and
>   /var/run/mdadm.map for writing fails, try /dev/.mdadm.map
>
> Note that I don't want to put the file in /dev/md/ as that might not
> exist yet either.
>
> So the idea is to still use /var/run/mdadm{.,/}map, but fall back on
> /dev/.mdadm.map if that is the only option.
>
> Thought?

Fine with me.


--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-73--995075099
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAkneS6kACgkQQ9aEs6Ims9jH7ACeJiJQvgyN/W54kGKjk2MVlcZO
cL0AoOEtholOGGxQs7kMgC7ba30vitQj
=mNL8
-----END PGP SIGNATURE-----

--Apple-Mail-73--995075099--
