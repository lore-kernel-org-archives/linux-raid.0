From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Shrinking raid array
Date: Tue, 12 Feb 2013 11:39:46 -0500
Message-ID: <511A7052.9020802@ubuntu.com>
References: <511A6554.1010100@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511A6554.1010100@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/12/2013 10:52 AM, Phillip Susi wrote:
> I'm working on shrinking a raid array and need some clarification
> on where the metadata goes and how large it is.  I have used -G
> with -Z and -z to reduce the used size of each disk, but the man
> page says you need some extra space at the end of the disk for the
> metadata ( format 1.0 ), but doesn't specify exactly how much.  I
> need to know what the exact size of the reduced partition should
> be.

I just noticed that reducing the used dev size has not moved the
metadata, so it is looking like it just isn't possible to shrink the
md partition with metadata format 1.0?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRGnBSAAoJEJrBOlT6nu75u0AIAJybUCaf02hyvAbDUD3JmjIA
MXW8yapXks4Xta5YX7MQlPJu0yLniw++0W1Y76vJ1gEjqN+JNUMN2k4CVeGLSwz+
UznaLejNkGiZ9+n3e1Fq1LKu/6J4Z16AC+If+1kmVpm5hDPkbJ3cPp6ZcfgSZhIp
/diiJrm7cdGMxtMXTqYPPhVwn9QmxNyoLNdN3OdPpKaNadkNksYi/AnbUmGEhuzx
q9TNIJwW4v0WZTZ8AevHvFlgFcgk41pdh8nN6ta/EKRzcfj32ro1HrA1P8zdp6gr
QYTzf+UHa27kZGNKrgD7dgFWFlsZf7zQ6WTV3iKoy/HQIARFzdmonVBTTfg6D8A=
=UCSK
-----END PGP SIGNATURE-----
