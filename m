From: Neil Brown <neilb@suse.de>
Subject: Re: [GIT BISECT] kernel early crash in 2.6.34~2.6.35-rc1
Date: Wed, 2 Jun 2010 11:29:21 +1000
Message-ID: <20100602112921.2e6a51cd@notabene.brown>
References: <4C05B081.2000904@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C05B081.2000904@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: legolas558 <legolas558@users.sourceforge.net>
Cc: stable@kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 02 Jun 2010 03:14:41 +0200
"Daniele C." <legolas558@users.sourceforge.net> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hello there,
> 
> I have individuated a bad commit which causes an early crash in some SSB/CPI routine; sorry can't be more precise right now, it would require serial debugging to get the dump.
> 
> Last good commit: 240ed68eb567d80dd6bab739341999a5ab0ad55d
> First bad commit: 6e4513972a5ad28517477d21f301a02ac7a0df76

% git log 240ed68..6e451397 | grep -c '^commit'
6609

There are over 6000 commits in there - are you sure you cannot narrow it
down a bit more with git-bisect?

NeilBrown


> 
> Hardware: laptop Maxdata PRO 7000DX (apparently Fujitsu Amilo V2000 clone)
> 
> Crash is also present in HEAD (currently 67a3e12b05e055c0415c556a315a3d3eb637e29e).
> 
> I have given a look to the commitdiff but it looks too much complex for me to individuate where's the issue at first glance.
> 
> Can somebody please give a look and/or narrow it down to a patch?
> 
> Thanks,
> - --
>   Daniele C.
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
> 
> iQEcBAEBAgAGBQJMBbCBAAoJEON28As9epPATXIH/RbBVXobBPXhon529E5Cov2m
> Rw9d3/VhY9pNLIk9UbtkuJslG6o96GQjTqqNK4M95RE43QYpzqx1Gw5r84H1j2NZ
> qxEb+GmHYj8ltdsUmQJXc4b4iIrqJVSjfInbzftKrgKdFybxDJF1Byl1FpXXyFqC
> TVEHsXhaTpnqylVTbQuweCPgv7MDWBO9MxMJoBQSvXNqefqlfyrgWeT5Eimg73mz
> mgNQKE8aAOYF3d3ZxgIN43jun5VmFxMC8t4E8d68/yA0g9VFW04iSecY9ZeJgmZR
> gHNrhwP/JzEja+FErRDGliQdyeFleV3rcsmWH7xwHecc2HcVt73BkpWR1qYwdwQ=
> =Dtjt
> -----END PGP SIGNATURE-----

