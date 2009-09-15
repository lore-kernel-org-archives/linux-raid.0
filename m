From: Doug Ledford <dledford@redhat.com>
Subject: Re: Port Multipliers
Date: Tue, 15 Sep 2009 16:34:11 -0400
Message-ID: <FE87C12A-00E6-4DF6-80CF-56850AFFE656@redhat.com>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com> <70ed7c3e0909100911q926fa9cs9185854b15dd8764@mail.gmail.com> <c268e4660909101135w4b933cbaj3e6a18e6b586fd62@mail.gmail.com> <70ed7c3e0909101144u2c42a1b2scf69e83df931035d@mail.gmail.com> <B1A260D7-B6A2-40D3-83FF-9571D80B66B8@redhat.com> <87f94c370909151328j1f88ab4fi452fcbeb5f1e9172@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-32--138255042"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370909151328j1f88ab4fi452fcbeb5f1e9172@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: "Majed B." <majedb@gmail.com>, Drew <drew.kay@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-32--138255042
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Sep 15, 2009, at 4:28 PM, Greg Freemyer wrote:
>> I've actually been doing some of those benchmarks here.  Given a  
>> Silicon
>> Image 3124 card in a x1 PCI-e slot, my maximum throughput should be  
>> about
>> 250MB/s (PCI-e limitation).  My drives behind the pm are all  
>> capable of
>> about 80MB/s, and I have 4 drives.  What I've found is that when  
>> accessing
>> one drive by itself, I get 80MB/s.  When accessing more than one  
>> drive, I
>> get a total of about 120MB/s, but it's divided by however many  
>> drives I'm
>> accessing.  So, two drives is roughly 60MB/s each, 3 drives about  
>> 40MB/s
>> each, and 4 drives about 30MB/s each.
>>
> Doug,
>
> I hate to ask the obvious, but you do have a 3Gbit/sec connection
> between the controller and the PM, right?

According to the kernel dmesg output, yes, I have a 3GBit/s  
connection.  However, I had the very same niggling doubts as you, and  
I don't have a SATA bus analyzer to prove it to myself.

> I only ask because your 120MB/sec is about right for a 1.5Gbit/sec
> connection.  I was under the impression you should max out closer to
> 250MB / sec with a good controller and PM and a 3.Gbit/sec connection.
> I have not done any testing myself.

I agree with this sentiment 100%.  I don't have a good answer for why  
it topped out where it did, and that's one of the things I'm still  
trying to get an answer to.


--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-32--138255042
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.12 (Darwin)

iEYEARECAAYFAkqv+kMACgkQg6WylM+/8ZQ2QwCdGjSTWFM2kfqYKD5t02T52XcS
ULEAoKnjXVUnELurmvzmC9kx7vtWE/ts
=D9x/
-----END PGP SIGNATURE-----

--Apple-Mail-32--138255042--
