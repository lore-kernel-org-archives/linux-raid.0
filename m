From: Gilbert Kowarzyk <kowarzyk@grm.polymtl.ca>
Subject: Re: Renaming MD devices (metadata=1.1)
Date: Wed, 11 Jan 2012 11:01:33 -0500
Message-ID: <4F0DB25D.3030805@grm.polymtl.ca>
References: <4F0BD6EA.8010007@grm.polymtl.ca> <4F0C1A03.8020509@ziu.info> <4F0D272A.2060000@grm.polymtl.ca> <20120111172047.6af5571f@notabene.brown> <4F0D2EBF.5070807@grm.polymtl.ca> <20120111180347.0d177edf@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120111180347.0d177edf@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Michal Soltys <soltys@ziu.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello,

>> Why do we have these choices, and when should each be used?
> 
> 1.0 (at the end) is best for RAID1 when booting from the device as
> the boot-load just doesn't see the RAID at all.
> 
> 1.1 (at the start) is generally good because various different
> things have metadata at the start, so there is no chance of
> confusion about what is using that devices - each possible users
> will overwrite the metadata of the others. It is also easier to
> make the devices larger if you don't need to move the metadata.
> 
> 1.2 (4K from the start) has most of the benefits for 1.1 but works
> for booting with newer boot loaders - they still want sector 0 for
> a boot sector but understand the md superblock.

I see. Makes also loads of sense.

I had two more quick questions:

1.- when would one want to turn off bitmaps? I turned them on, but I
haven't found why one may want them off (or for what they should be
turned off).

2.- if I ever have a mismatch_cnt different than zero, how would I go
about finding which drive has the correct info, which was the one that
got corrupted, and how to obtain the correct one?
In the past I've changed the "CHECK" to "REPAIR" in the configuration
script that checks the RAID arrays periodically
(/etc/sysconfig/raid-check), but from what I understood it's a bit of
luck which one the automatic script will choose out of the two drives
(assuming raid1). Should I let it be automatic (with "repair"), and if
not (if I have to check which one is correct manually), where could I
find information to read about how to do this (I am assuming the
answer may be long)?

Thanks!

Gilbert
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (Darwin)
Comment: digital signature
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk8NslwACgkQOYVp1RpLsmXUYQCfcAv/q33vjS2oqrxdey2wTEtn
yzwAnAhd7KT8Ye4JYO65MWm0dZZaa3d0
=yOmI
-----END PGP SIGNATURE-----
