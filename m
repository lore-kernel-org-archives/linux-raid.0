From: Doug Ledford <dledford@redhat.com>
Subject: Re: RAID1 assembled broken array
Date: Thu, 17 Sep 2009 12:44:44 -0400
Message-ID: <F52A8F4D-66B0-4F97-B2C9-6FF207817718@redhat.com>
References: <h8ophd$n8p$6@ger.gmane.org> <9F2F4760-DF0C-4416-89AC-C689177AD4ED@redhat.com> <65549e07fd6559855af68b60783213c3.squirrel@neil.brown.name> <1253076634.7071.5.camel@kiste>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-74-20777423"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1253076634.7071.5.camel@kiste>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Urlichs <matthias@urlichs.de>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-74-20777423
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Sep 16, 2009, at 12:50 AM, Matthias Urlichs wrote:
> On Wed, 2009-09-16 at 07:01 +1000, NeilBrown wrote:
>> 1.0 also protects from this problem.
>
> So what's the best way to update a 0.9 superblock to 1.0 format?
>
> mdadm --assemble --metadata=1.0 --update=summaries ... ?

I don't think you can.  You just have to create a new array with the  
new superblock.

--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-74-20777423
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.12 (Darwin)

iEYEARECAAYFAkqyZ3wACgkQg6WylM+/8ZRexgCdGqCrkJ3zDem/SqNqEwktmuSB
iDgAn1wFd9k0LEv9hvzfFW52ZvbrNrAF
=IB6H
-----END PGP SIGNATURE-----

--Apple-Mail-74-20777423--
