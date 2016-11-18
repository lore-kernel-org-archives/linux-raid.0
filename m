From: NeilBrown <neilb@suse.com>
Subject: Re: Newly-created arrays don't auto-assemble - related to hostname change?
Date: Fri, 18 Nov 2016 15:08:23 +1100
Message-ID: <87k2c1fn0o.fsf@notabene.neil.brown.name>
References: <20161117035230.GG21587@bitfolk.com> <87lgwihc2v.fsf@notabene.neil.brown.name> <20161117150954.GH21587@bitfolk.com> <87d1hthgm7.fsf@notabene.neil.brown.name> <20161118023144.GC1804@bitfolk.com> <87poltfq2d.fsf@notabene.neil.brown.name> <20161118034716.GI21587@bitfolk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161118034716.GI21587@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@strugglers.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Nov 18 2016, Andy Smith wrote:

>
> Am I right in thinking this is not incremental assembly by udev, but
> kernel auto-assembly?

That isn't kernel auto-assembly, but it doesn't look like incremental
assembly either.

 /usr/share/initramfs-tools/scripts/local-block/mdadm

runs
  mdadm -q --assemble --scan --no-degraded
to start all the arrays that the initramfs can find.  So it is
mdadm-based auto-assembly.

>
> Also, in the previous configuration, mpt3sas was being loaded once
> the root filesystem had been mounted. All the drives on the SAS
> controller were then available, so udev should have assembled md5 at
> that point, right? So I think there is still a problem here, just
> one which I have worked around in some other way.

Yes, I think there is still a problem. When the mpt3sas is loaded udev
should trigger the arrays to be created.

>
> If that is the case, would you like me to continue debugging udev?

Up to you, but I have an idea.
The udev rules files depends on 'blkid' having been run.
  /lib/udev/rules.d/60-persistent-storage.rules
does this, but not for
  KERNEL=="fd*|mtd*|nbd*|gnbd*|btibm*|dm-*|md*|zram*|mmcblk[0-9]*rpmb"

... though that wouldn't apply to you.

what does
  udevadm info /dev/sdc

report?

NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYLn63AAoJEDnsnt1WYoG5W64P/iQI9/4pKtb0RpHgy0/stkHg
di1DrwQ3QtxLxNAFiwrH+enA6sswNdIpwEiPVro68B40FXPSBM881lBUabw7RDR3
CeYkz4osKW0UW2C3Zx9gQ0S4xdP9BlS5r2kJKwj98yNhCL17Nf6BhmPHG4cBsxRk
APn+amA657EVf3U3AUC4vxbQMhKWCR9kkwdMYXVBCi1oAnWo/KLmjkUQOozXvZOw
MOYowJcHctkM/HNfLuZBOqOaIRR3yjFsTJi7d9k3wBxnBu2sX38IYDqPwSvv5pGP
e9ToDmYKhDWfBeMAmUbkka9zkO18iYZTnjlPhAnTFXM4ZFUmVPAvjamuZqu/YRvi
AHtCSxYv5eEU1khCdXKAuEaHyfCr6nbq3Oj7WARZwo1Av3JPgHKQHkNphRL3Stl4
x2YPQu0n3YLSZ1OkSlEjwbYfz4z2d5pCKWwrmcvr4UjE/H6tf9sHt888I3AkMHTe
b0MtM41EU77L3RlffhAoXjDXXAkeuSTPubB/vsf+eOsRqN3ZnVrX2Tr06v2NTKi3
FdYs5L/lm+F/kJGSvdiFyNnx2JxKmla3IJymYxHtaJkpCejzzjYGgJvXKfWSM+w0
SzSF0697fqTjAYQRHNLlgGUcJCeLtSvcjWZOSPAjrN4uFgKgQlKRQPfSfgWPRrAF
d4Jr5LfhBnheCKrU3Pf+
=AT8V
-----END PGP SIGNATURE-----
--=-=-=--
