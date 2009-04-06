From: Doug Ledford <dledford@redhat.com>
Subject: Re: RAID halting
Date: Sun, 5 Apr 2009 20:31:32 -0400
Message-ID: <783F1304-DEE5-4495-A81A-B98A5EDCCABF@redhat.com>
References: <20090405203331.FWRT1944.cdptpa-omta02.mail.rr.com@Leslie>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-14-825171704"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090405203331.FWRT1944.cdptpa-omta02.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'David Lethe' <david@santools.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-14-825171704
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Apr 5, 2009, at 4:33 PM, Leslie Rhorer wrote:
> Oh, brother.  Since I personally own outright every last nut, bolt,  
> and
> transistor in these systems, and since the data belongs entirely and
> exclusively to me (with the exception of some copyright  
> restrictions), for
> use by me, exactly who is going to fire me or prosecute me?   
> Enough.  Please
> cease the ad hominem attacks, and point me towards the utilities  
> which will
> allow me to further diagnose the issue.

Well said.  I found it particularly interesting to hear David talk of  
statistical probabilities as he studiously ignored the astronomical  
statistical improbability that sector remapping would strike only on  
file creation, and would simultaneously block a drive up for the  
purpose of file creation but not block it up for the purpose of raid  
sector checking.  David definitely went on a "short bus" rant, I'd  
just ignore the rant part and see if he manages to provide any useful  
data about how to check things as you requested.  Personally, I've  
only ever used badblocks for low level disk checking, but back when I  
used it for diagnosis drives were different than they are today in  
terms of firmware and you could actually trust that badblocks was  
doing something useful.

--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-14-825171704
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAknZTWwACgkQQ9aEs6Ims9hcHQCg9Q+bDFOZDl9bYL9wIx+m8Asd
750An3v5xfaX1l78NtEivHou6pLlGhzw
=XuFk
-----END PGP SIGNATURE-----

--Apple-Mail-14-825171704--
