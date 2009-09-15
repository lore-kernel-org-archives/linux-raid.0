From: Doug Ledford <dledford@redhat.com>
Subject: Re: Port Multipliers
Date: Tue, 15 Sep 2009 15:55:05 -0400
Message-ID: <57DEE3F6-E4FF-4D96-901E-7DF5BF232700@redhat.com>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com>  <70ed7c3e0909100911q926fa9cs9185854b15dd8764@mail.gmail.com>  <c268e4660909101135w4b933cbaj3e6a18e6b586fd62@mail.gmail.com>  <70ed7c3e0909101144u2c42a1b2scf69e83df931035d@mail.gmail.com>  <B1A260D7-B6A2-40D3-83FF-9571D80B66B8@redhat.com> <70ed7c3e0909151112m14f5f3a5ge3b3ff20425cc427@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-28--140601047"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909151112m14f5f3a5ge3b3ff20425cc427@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: Drew <drew.kay@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-28--140601047
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Sep 15, 2009, at 2:12 PM, Majed B. wrote:
> Well, just because the PCI-e 1x bus can do 250 MB/s, it doesn't mean
> that the Port Multiplier (PM) can reach that speed, hence me telling
> you to test the card itself with 1 disk to see its max speed, then add
> another and so on.

You didn't tell me, you told Drew.  And I wasn't reporting test  
results I got in response to your instructions, these tests have  
already been done (and well more in fact).  I was just relaying what I  
found on this card and this setup for Drew's benefit.

> Some PMs can communicate with each other. Check the specification
> sheet to see if your PM can do that. If that's the case, keep your
> disks of one array connected to PMs of the same chip, and use the
> built-in ports of the motherboard for another array or just normal
> disks.

This is a test machine I built specifically for testing bare ports  
versus pm setups.  I destroy and create new raid arrays on it all the  
time, and none of them are for real use, just benchmarking.

--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-28--140601047
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.12 (Darwin)

iEYEARECAAYFAkqv8RkACgkQg6WylM+/8ZQv0QCdEPxcxphKZgbMyoBPETQr+xci
P/4AnRlMU+U3OBNJRIVpinZ10rNyQ20x
=a9Pr
-----END PGP SIGNATURE-----

--Apple-Mail-28--140601047--
