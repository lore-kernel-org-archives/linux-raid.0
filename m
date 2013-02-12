From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Shrinking raid array
Date: Tue, 12 Feb 2013 13:11:36 -0500
Message-ID: <511A85D8.5070803@ubuntu.com>
References: <511A6554.1010100@ubuntu.com> <511A7052.9020802@ubuntu.com> <alpine.DEB.2.00.1302121852000.32644@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1302121852000.32644@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/12/2013 12:53 PM, Mikael Abrahamsson wrote:
> On Tue, 12 Feb 2013, Phillip Susi wrote:
> 
>> I just noticed that reducing the used dev size has not moved the 
>> metadata, so it is looking like it just isn't possible to shrink
>> the md partition with metadata format 1.0?
> 
> From "man mdadm"
> 
> "The different sub-versions store the superblock at different
> locations on the device, either at the end (for 1.0), at the start
> (for 1.1) or 4K from the start (for 1.2)"
> 
> I don't really see how it could be shrunk with a superblock at the
> end, then you wouldn't be able to find it next time...

You move the superblock, then shrink the partition...

But it looks like mdadm doesn't move the superblock even though it no
longer is using the full partition.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRGoXXAAoJEJrBOlT6nu75N+YH/R/om3wi5yJ/DidGWJFxd5J2
WuLV0oUqggDZxjM32/usuZwzVCnPnvXDmd9HKavf9Ko8gVnMUsJeVtv6fQDmr4uy
IpPyrHcYa80am3hX5maGt+orJgk4kP4sc2x4Ya/OYBHfiTYn704+bUmP8znrJ5CG
rBzqWaRsdQy4v+ps/7l3VQuyJhDxEoNjz4NDAZC8wWqxoclJVtAE9uxPbdpYRLSV
+SlY76LIoea3YHXYLLu6vXJpQsaDalyVAzuDbEspJQ/fvjUTncCGicBvG/obbGsW
9hrftYoNnhEc7PmRPvbPFW7f6EkpPMbTo/FLhB0r8Fw0AS0AYG12UACH+zO2Rjg=
=hvFb
-----END PGP SIGNATURE-----
