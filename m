From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Disks never stop spinning
Date: Thu, 04 Dec 2014 14:33:58 -0500
Message-ID: <5480B726.8070103@ubuntu.com>
References: <54610788.6060103@gautschi.net> <21604.47814.651762.246947@tree.ty.sabi.co.uk> <54657187.6020306@gautschi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54657187.6020306@gautschi.net>
Sender: linux-raid-owner@vger.kernel.org
To: Patrick Gautschi <patrick@gautschi.net>, Peter Grandi <pg@lxra2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/13/2014 10:05 PM, Patrick Gautschi wrote:
>> That means something else is waking up those disks. To verify 
>> this use something like:
> 
> FS are not mounted and arrays stopped. There is nothing that wakes
> them up. If a switch them off manually with hdparm -Y they stay
> off.

Are you running udisks?  If so then that is the culprit.  It polls the
drive's SMART stats every 10 minutes unless the drive is already
asleep, so if the timeout is >= 10 minutes ( which it seems WD drives
refuse to go any lower anyhow ), then the drive will never go to
standby.  I posted some patches to fix this a while back on the
devkit-devel mailing list but I think the udisks maintainer has still
not gotten around to applying them.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUgLcmAAoJENRVrw2cjl5RNkgIAKY2UyBO/I5Tkm9gA6ALn9wx
mcQWsS5gacWitu8ALa/dO7ON75vs+KV0NHjeEc0J+x9jdo02M7gg5PXG3YH1cxzi
mzW78NsSJXwImaZsaCDL4bwYCx6o91wUCuW29Kybvzh+J8u41jW/+5YnX10Mg7jp
o/CMY6O2vgG+MAOd2YIi7LMjgJRWg3my3PPrc4ahaBT4+9L7vHWExy9eRhemQvDN
1e2Q9sDk+uGvG1KCAVG24+2JcNyTEjN53x4FaPkw9EQ0bmUNLrYPksQUl6D/CbGB
mg+Jrcq65cTHp5vpbI3UAd4uKAl2TnoyThIs1cO98spiF6s1MhhRFp+3Vtu8tLg=
=CcWo
-----END PGP SIGNATURE-----
