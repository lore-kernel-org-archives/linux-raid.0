From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: Raid1 where Event Count off my 1 cannot assemble --force
Date: Sun, 08 Dec 2013 22:28:11 -0600
Message-ID: <52A546DB.3090605@suddenlinkmail.com>
References: <52A44778.8040502@suddenlinkmail.com> <alpine.DEB.2.02.1312081157100.24602@uplift.swm.pp.se> <52A4B311.6040204@suddenlinkmail.com> <52A51122.3030604@suddenlinkmail.com> <20131209120040.6464b91b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131209120040.6464b91b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/08/2013 07:00 PM, NeilBrown wrote:
> What version of mdadm do you have?  It looks like it should be cleverer than 
> it is.
> 
> What if you add "--update=no-bitmap" to the --assemble line? As the bitmap
> seems to be causing problem, ignoring it might help.
> 
> NeilBrown

I tried that too Neil, it said:

nemtemp:/mnt # mdadm --verbose --assemble --force --update=no-bitmap /dev/md1
/dev/sd[ab]5
mdadm: '--update=no-bitmap' is invalid.  Valid --update options are:
     'sparc2.2', 'super-minor', 'uuid', 'name', 'resync',
     'summaries', 'homehost', 'byteorder', 'devicesize'.

Like in my reply to Adam, I think the age of mdadm may be the issue. The
openSuSE 11.0 install DVD is pretty old ;-) It just may not be handling the
- --assemble correctly given the Event count difference, and there doesn't seem to
be a way to just tell it:

"The data is correct on both disks, just assemble and run it and be quiet!"

I'll try booting an Arch install CD with 3.3.2 on it and report back. Thank you
and Adam for your help.

If it does assemble with mdadm 3.3.2, anything I need to do on the assembled
array to make sure it stays that way? fsck? Any way to tell it to make sure it
is in sync so it will boot under the openSuSE 11.0 version of mdadm?


- -- 
David C. Rankin, J.D.,P.E.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlKlRtsACgkQZMpuZ8CyrcjDdACeIEoiMdNGQw0IEqg0LlgJ8f2t
vHwAnjLKHnTP1FpEpXwjRZxu+hoAntQV
=iTBQ
-----END PGP SIGNATURE-----
