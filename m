From: "Daniele C." <legolas558@users.sourceforge.net>
Subject: Re: [GIT BISECT] kernel early crash in 2.6.34~2.6.35-rc1
Date: Wed, 02 Jun 2010 18:52:09 +0200
Message-ID: <4C068C39.1000407@users.sourceforge.net>
References: <4C05B081.2000904@users.sourceforge.net> <20100602112921.2e6a51cd@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100602112921.2e6a51cd@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: stable@kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

- -------- Original Message  --------
Subject: Re: [GIT BISECT] kernel early crash in 2.6.34~2.6.35-rc1
From: Neil Brown <neilb@suse.de>
To: legolas558 <legolas558@users.sourceforge.net>
Date: Wed Jun 02 2010 03:29:21 GMT+0200 (CET)

> On Wed, 02 Jun 2010 03:14:41 +0200
> "Daniele C." <legolas558@users.sourceforge.net> wrote:
> 
> Hello there,
> 
> I have individuated a bad commit which causes an early crash in some SSB/CPI routine; sorry can't be more precise right now, it would require serial debugging to get the dump.
> 
> Last good commit: 240ed68eb567d80dd6bab739341999a5ab0ad55d
> First bad commit: 6e4513972a5ad28517477d21f301a02ac7a0df76
> 
>> % git log 240ed68..6e451397 | grep -c '^commit'
>> 6609
> 
>> There are over 6000 commits in there - are you sure you cannot narrow it
>> down a bit more with git-bisect?
> 
Sorry, I have had a bad day with git; the bug was in commit d53cdbb94a52a920d5420ed64d986c3523a56743 and is fixed by commit da1fdb02d9200ff28b6f3a380d21930335fe5429, so it's not affecting stable or either any other repository (perhaps drm-intel only).

By the way, it was at EIP ssb_is_sprom_available+0x40.

Best regards,
- --
  Daniele C.

>> NeilBrown
> 
> 
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
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJMBow4AAoJEON28As9epPAwWAIAIqZkbiO+/0Sjd+uZ7U7wvwO
f+2i/FnUNsRsAsLA8W0dcfrglN93gUdaS43mMVj0TPOclMSiffpuwejy0lu/gJL7
SZQzPZdR+fPmq2MXL4n60DTkYwFvQJKtVmQvUXWCGVALnCXkqVoygGrsMDBBpk4O
0ZQAFvlcpmQb/YbUx6hjTIkhXs7vNHZ6I9A5A2mKW3lGim5Y0OZ9xjWYzLRf6uOi
pJQzvHf53/mzXpI6ieqau1pF6vQBHenkfPnrbfTWbWtgOgnDB4hglGllMfEcrM56
pHFndBTCZHdhVYRnwetzSbMqiD8xEWRSS5rahJNNbbgkzZWqEIKA8jyDYp0c0LE=
=QYPZ
-----END PGP SIGNATURE-----
