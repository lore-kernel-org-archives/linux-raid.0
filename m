From: Doug Ledford <dledford@redhat.com>
Subject: Re: Port Multipliers
Date: Tue, 15 Sep 2009 21:28:22 -0400
Message-ID: <4D899658-EEA4-4511-87FF-9338E681D956@redhat.com>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com>  <70ed7c3e0909100911q926fa9cs9185854b15dd8764@mail.gmail.com>  <c268e4660909101135w4b933cbaj3e6a18e6b586fd62@mail.gmail.com>  <70ed7c3e0909101144u2c42a1b2scf69e83df931035d@mail.gmail.com>  <B1A260D7-B6A2-40D3-83FF-9571D80B66B8@redhat.com> <87f94c370909151328j1f88ab4fi452fcbeb5f1e9172@mail.gmail.com>  <FE87C12A-00E6-4DF6-80CF-56850AFFE656@redhat.com> <4AAFFDC4.5090806@sauce.co.nz>  <72dbd3150909151452r38087573od156a1965dc0eba1@mail.gmail.com>  <D88C9CE6-0F7D-4E8D-B972-75A5012B921C@redhat.com> <70ed7c3e0909151801y7fe7bbcap872af6c4f9f76590@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-36--120603999"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909151801y7fe7bbcap872af6c4f9f76590@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: David Rees <drees76@gmail.com>, Richard Scobie <richard@sauce.co.nz>, Greg Freemyer <greg.freemyer@gmail.com>, Drew <drew.kay@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-36--120603999
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Sep 15, 2009, at 9:01 PM, Majed B. wrote:
> I think someone mentioned in the mailing list that the Linux kernel
> does sort commands before sending them to the disks, so if the disk
> tries to sort, and its algorithm isn't that good, the performance
> drops and hence disabling them is a good idea. I believe it's also
> mentioned in here: http://linux-raid.osdl.org/index.php/Performance


It depends on the elevator in use.  And regardless, I have yet to see  
a raid5 array ever perform better with queueing turned off instead of  
on.  Although, in many cases, very large queue depths don't help  
much.  Testing I've done showed that only a 4 to 8 queue depth is  
sufficient to get 95% or better of the performance benefit of queueing.

--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-36--120603999
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.12 (Darwin)

iEYEARECAAYFAkqwPzYACgkQg6WylM+/8ZTk/gCeKNQYkCrSnNK2yjVjq+Rc2Pip
fwAAoJuIWfleh6061eSQgweO1GmHBpnc
=C2F/
-----END PGP SIGNATURE-----

--Apple-Mail-36--120603999--
