From: Doug Ledford <dledford@redhat.com>
Subject: Re: Port Multipliers
Date: Tue, 15 Sep 2009 21:26:57 -0400
Message-ID: <11531516-3A7D-4858-B198-A1393B898218@redhat.com>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com>  <70ed7c3e0909100911q926fa9cs9185854b15dd8764@mail.gmail.com>  <c268e4660909101135w4b933cbaj3e6a18e6b586fd62@mail.gmail.com>  <70ed7c3e0909101144u2c42a1b2scf69e83df931035d@mail.gmail.com>  <B1A260D7-B6A2-40D3-83FF-9571D80B66B8@redhat.com> <87f94c370909151328j1f88ab4fi452fcbeb5f1e9172@mail.gmail.com>  <FE87C12A-00E6-4DF6-80CF-56850AFFE656@redhat.com> <4AAFFDC4.5090806@sauce.co.nz>  <B15861F4-3F63-4D23-8B9A-DCB809C56C0C@redhat.com> <c268e4660909151632i56e9f3f9n48f17cc827d974f0@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-35--120689226"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c268e4660909151632i56e9f3f9n48f17cc827d974f0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: Richard Scobie <richard@sauce.co.nz>, Greg Freemyer <greg.freemyer@gmail.com>, "Majed B." <majedb@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-35--120689226
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Sep 15, 2009, at 7:32 PM, Drew wrote:
> Thanks for the input.
>
> Sounds from your testing like PMs can deliver the sorts of speeds that
> are adequate for our needs.

Given a decent SATA port (like the Sil3132) and a motherboard that  
allows this port to run at full speed (one that can up the max PCI-e  
payload limit above 128 bytes), then yes.  I'm sure other port types  
out there would work without the PCI-e requirement, but I don't have  
any of those for testing.

> Have you done any testing as far as md
> RAID using member disks from each PM?

I've only got one PM at the moment.

> Given we're expecting a mix of online and archival data going onto
> this enclosure I was thinking about making up RAID arrays composed of
> disks from each PM for online use and arrays composed of disks from a
> PM for archival use.

Well, I might suggest something like doing 3 disks from each PM as  
part of the archive and one disk from each PM as the online storage.   
In a scenario like that, the archive system will run slower than the  
online system, but as long as the online system and archive system  
aren't currently fighting for bandwidth, the online system will get  
full speed (assuming the online disks can't go faster than 120MB/s  
each).  And that's without having to find a motherboard that lets you  
set the PCI-e payload size.  Another option is the online disks can be  
internal disks, with at most one disk per PM.  That array would be  
blindingly fast.  You can then make the archive array(s) use the  
remaining PM connected drives.

> I'm sorry if I keep throwing questions out without doing my own
> testing. As I alluded to earlier I don't have an R&D budget for
> testing so I have to be reasonably sure of my system before I can get
> authorization to purchase kit.


--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-35--120689226
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.12 (Darwin)

iEYEARECAAYFAkqwPuEACgkQg6WylM+/8ZS7vgCgkHPJkJV5NDt10AUyy+H4BjMo
yu8An0aDwJoBZkcof44ssZzbhCDQSqGx
=hOsH
-----END PGP SIGNATURE-----

--Apple-Mail-35--120689226--
