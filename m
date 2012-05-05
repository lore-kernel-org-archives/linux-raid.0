From: Martin Wegner <mw@mroot.net>
Subject: Re: Script for offsite storeage of RAID info needed for recovery
Date: Sat, 05 May 2012 02:38:49 +0200
Message-ID: <4FA47699.6040208@mroot.net>
References: <1336141317.28212.125.camel@oxygen.netxsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1336141317.28212.125.camel@oxygen.netxsys.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hello, Krzysztof

I'm running the following little script as a cron job every night. It
gives you:
1. the contents of /proc/mdstat
2. mdadm --detail for each md device listed in /proc/mdstat
3. mdadm --examine for each member device listed in /proc/mdstat

- -----8<----------8<----------8<----------8<----------8<----------8<-----
#!/bin/sh

cat /proc/mdstat

for md in $( cat /proc/mdstat | grep '^md' | cut -d' ' -f1 | sort ); do
	echo
	mdadm --detail /dev/${md}
	echo
done

for d in $( cat /proc/mdstat | "grep" -o 'sd.\?[0-9]' | sort ); do
	echo
	mdadm --examine /dev/${d}
	echo
done
- -----8<----------8<----------8<----------8<----------8<----------8<-----

Of course, this could be extended by also listing the models and
vendors of the component devices, but I've not done this for now.

I hope that helps,

Martin

On 05/04/12 16:21, Krzysztof Adamski wrote:
> [...]

- -- 
Get my public GPG key from pgp.mit.edu or wwwkeys.pgp.net
Key ID: 0x177AFD7C
- --
Homepage: http://mwegner.net/
Powered by Gentoo Linux (http://gentoo.org/)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEAREKAAYFAk+kdpcACgkQxZfezBd6/XzyOwCfZ89Fr4XTE6+DNB0tygCJMQNP
BrMAoJGktj1dDq9MBgxmSY/MPolWTWOH
=bBvQ
-----END PGP SIGNATURE-----
