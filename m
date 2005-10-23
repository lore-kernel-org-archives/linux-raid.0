From: Patrik Jonsson <patrik@ucolick.org>
Subject: Re: [PATCH md ] Better handling of readerrors with raid5.
Date: Sat, 22 Oct 2005 20:57:47 -0700
Message-ID: <435B0A3B.9000801@ucolick.org>
References: <20050916125754.11044.patches@notabene>	<1050916030157.11071@suse.de>	<62b0912f050920171550edcab1@mail.gmail.com> <17201.9323.915024.189868@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17201.9323.915024.189868@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

After having the "dreaded double disk failure", I've decided to upgrade
my kernel and include this patch. I also want to include the "parity
check" option. However, I'm having a hard time figuring out which
patches need to be applied. Is there a collection of all the md patches
somewhere? It's also hard to know which patches have already been
included in the kernel when you upgrade to a newer version.

Any tips for handling this would be much appreciated!

/Patrik
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (MingW32)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFDWwo6T+KvsdUW5p8RAiMeAKCBUJwoXbgmbVggmEh9RMNqsxxc7gCeKg/i
pkbg70VZ00xsnYdKqn2CjZE=
=es3o
-----END PGP SIGNATURE-----
