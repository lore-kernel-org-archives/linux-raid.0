From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: The chunk size paradox
Date: Thu, 02 Jan 2014 15:08:17 -0500
Message-ID: <52C5C731.2070209@ubuntu.com>
References: <52C1C01A.7010407@ubuntu.com> <21186.996.238486.690328@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21186.996.238486.690328@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Peter, please make sure to use your mail client's reply-to-all feature
and avoid any BS reply-to-list command, which breaks cross posted
threads, and delays my seeing your reply since I didn't get a copy.

On 12/30/2013 6:38 PM, Peter Grandi wrote:

> Therefore a larger chunk size increases the amount of data that can
> be fetched on each device without waiting for the other device to
> get to the desires angular position. It has of course the advnatage
> that you mention, but also the advantage that random IO might be
> improved.

Yes, and that is a good reason not to use 4k chunk size.  I believe
that 64k is plenty large enough for this purpose though.

>> and in the case of raid5 you run into problems with the stripe 
>> cache.
> 
> IIRC the stripe cache can be up to 32MB for RAID device, and that's
> a lot of stripes for any sensible-sized RAID set. But it never
> stopped people who "know better" to do very wide RAID5 or RAID6
> sets :-).

That's kind of my point: you don't want a *very* large stripe cache,
but limiting the chunk size means you get seek overhead to skip the
redundant data, so you are stuck between a rock and a hard place.  It
isn't as big of a deal on a 5 disk raid5/6 but on a 2 or 3 disk
raid10, a 512k chunk size has a hefty seek overhead.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSxccxAAoJEI5FoCIzSKrwQU4H/RXeLoFe74YFIKaLIc2gs9CM
S/RJ2P6ht5ZDR0uWge1t80PcIt46AG61KDoe4uqKeJ8i9j2pnEo74jP4uy8FpIg+
YgwZ114iAthiuA/vL/pQPbbnjJ5t/cG0TBmAviiGEyjckirc6/JO1kwcy3+dL+Fx
gfD4f7Vt7CNAkuJyJiyk87cRxJ8o0v643YFuGMnmCdlWr6GDVm/dDOhgtoepK7Mq
9yKm/VLm1Yr5XdCdogK7K7ZnGHLVMKQG8U2+fC1AgsulNtQoEeZmfU47RcK0LSdE
Oxb2w5aQb5AwxI6mukpAFTihbKR1qevpffs5qBNSCuTSgiCExj4KAe6BwcAlu9s=
=/GBo
-----END PGP SIGNATURE-----
