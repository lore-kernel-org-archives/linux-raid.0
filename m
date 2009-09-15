From: Doug Ledford <dledford@redhat.com>
Subject: Re: Port Multipliers
Date: Tue, 15 Sep 2009 17:29:08 -0400
Message-ID: <B15861F4-3F63-4D23-8B9A-DCB809C56C0C@redhat.com>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com> <70ed7c3e0909100911q926fa9cs9185854b15dd8764@mail.gmail.com> <c268e4660909101135w4b933cbaj3e6a18e6b586fd62@mail.gmail.com> <70ed7c3e0909101144u2c42a1b2scf69e83df931035d@mail.gmail.com> <B1A260D7-B6A2-40D3-83FF-9571D80B66B8@redhat.com> <87f94c370909151328j1f88ab4fi452fcbeb5f1e9172@mail.gmail.com> <FE87C12A-00E6-4DF6-80CF-56850AFFE656@redhat.com> <4AAFFDC4.5090806@sauce.co.nz>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-33--134957893"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AAFFDC4.5090806@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, "Majed B." <majedb@gmail.com>, Drew <drew.kay@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-33--134957893
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Sep 15, 2009, at 4:49 PM, Richard Scobie wrote:
> Doug Ledford wrote:
>
>> I agree with this sentiment 100%.  I don't have a good answer for  
>> why  it topped out where it did, and that's one of the things I'm  
>> still  trying to get an answer to.
>
> I can also confirm this sub par performance on the Sil 3124 - max  
> throughput of around 120MB/s.
>
> If your motherboard is able to set the "PCIe Max Payload Size" you  
> may be able to improve things.
>
> See Note 3 here:
>
> http://ata.wiki.kernel.org/index.php/Hardware,_driver_status#Silicon_Image_3124


Nice, that answers a number of my questions ;-)

--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-33--134957893
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.12 (Darwin)

iEYEARECAAYFAkqwByUACgkQg6WylM+/8ZQ9zACgmOU81zifUYJQ3Q2h8ywveZD8
VQsAn0FbRtO4ShFyR64pzC/h0kNBSVpf
=CGY5
-----END PGP SIGNATURE-----

--Apple-Mail-33--134957893--
