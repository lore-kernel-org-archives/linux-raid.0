From: Doug Ledford <dledford@redhat.com>
Subject: Re: Port Multipliers
Date: Wed, 16 Sep 2009 12:21:56 -0400
Message-ID: <2A664E3E-639E-4DCD-86EA-7DF2B6E96962@redhat.com>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com>  <70ed7c3e0909100911q926fa9cs9185854b15dd8764@mail.gmail.com>  <c268e4660909101135w4b933cbaj3e6a18e6b586fd62@mail.gmail.com> <70ed7c3e0909101144u2c42a1b2scf69e83df931035d@mail.gmail.com> <B1A260D7-B6A2-40D3-83FF-9571D80B66B8@redhat.com> <4AB1059A.4010705@anonymous.org.uk>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-55--66990458"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AB1059A.4010705@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-55--66990458
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Sep 16, 2009, at 11:34 AM, John Robinson wrote:
> Were you using a SiI3124-1 (1.5Gbps, they claim 150MB/s) or  
> SiI3124-2 (3Gbps/300MB/s)?

Actually, it's a 3132 (which is just the PCI-e version of the 3124-2).

> What throughput can you get using all 4 channels of the SiI3124  
> simultaneously, not using the port multiplier - does that top out at  
> 120MB/s too?

It's only got two ports enabled, and they're both eSATA ports.  So, I  
can't really answer that question.  However, given that these are  
known to top out at 120MB/s in a PCI-e slot that doesn't support  
payload size increase, I would guess it would.

> And have you done similar testing of your port multiplier hanging  
> off a motherboard SATA port? Do you get anywhere nearer the 3Gbps?


Yes, I tested an eSATA port on one motherboard and an internal SATA  
port to eSATA setup on another motherboard.  In both cases, the  
motherboards used the ahci driver for the port under test, and in both  
cases the ahci ports didn't support FIS command switching.  As a  
result, they both performed even worse, capping out at around 80MB/s.   
FIS switching is more or less mandatory if you want good performance  
of a port multiplier link.

--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-55--66990458
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.12 (Darwin)

iEYEARECAAYFAkqxEKoACgkQg6WylM+/8ZT5IACgm8FqU/3qm0MEi0RaNGwDHpgO
9lcAn0GZFxNiPHRjGdA/I17pQ0k5U9sm
=dcvC
-----END PGP SIGNATURE-----

--Apple-Mail-55--66990458--
