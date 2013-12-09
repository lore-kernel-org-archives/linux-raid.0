From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: [SOLVED] Re: Raid1 where Event Count off my 1 cannot assemble --force
Date: Sun, 08 Dec 2013 23:20:27 -0600
Message-ID: <52A5531B.6080702@suddenlinkmail.com>
References: <52A44778.8040502@suddenlinkmail.com> <alpine.DEB.2.02.1312081157100.24602@uplift.swm.pp.se> <52A4B311.6040204@suddenlinkmail.com> <52A51122.3030604@suddenlinkmail.com> <20131209120040.6464b91b@notabene.brown> <52A546DB.3090605@suddenlinkmail.com> <20131209154639.3b9f801c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131209154639.3b9f801c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/08/2013 10:46 PM, NeilBrown wrote:
> Once you get any kernel to successfully assemble the array, any other 
> kernel/mdadm should be able to as well.
> 
> NeilBrown

After 2 days pulling my hair out, the answer was a simple as popping in the
Arch install CD and rebooting!!

After it booted, I checked cat /proc/mdstat and /dev/md1  (md125) on Arch is
active and re-syncing. Perfect.

That was a whole lot of work to find out that it was an old mdadm causing all
the problems -- live and learn...

Perhaps we should add "get the latest release of mdadm" to the Raid Recovery
page with the explanation that sometimes older versions of mdadm just do not
know how to handle simple issues that arise, such as differing Event counts.
Using the latest mdadm can solve those problems immediately.

- -- 
David C. Rankin, J.D.,P.E.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlKlUxsACgkQZMpuZ8CyrchuWgCfR+Lv97xnyE75Yp3iTCfEq7aC
+f8An2d6+MOHw0Bki+kg5IvOIxC7yYsr
=T4Hs
-----END PGP SIGNATURE-----
