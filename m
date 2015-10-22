From: Simon Guinot <simon.guinot@sequanux.org>
Subject: Remove inactive array created by open
Date: Thu, 22 Oct 2015 18:24:45 +0200
Message-ID: <20151022162445.GA11904@kw.sim.vm.gnt>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Remi Reroller <remi.rerolle@seagate.com>, Vincent Donnefort <vdonnefort@gmail.com>, Yoann Sculo <yoann@printk.fr>
List-Id: linux-raid.ids


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Neil,

I'd like to have your advice about destroying an array created by open
at close time if not configured, rather than waiting for a ioctl or a
sysfs configuration. This would allow to get rid of the inactive md
devices created by an "accidental" open.

On the Linux distribution embedded in LaCie NAS, we are able to
observe the following scenario:

1. A RAID array is stopped with a command such as mdadm --stop /dev/mdx.
2. The node /dev/mdx is still available because not removed by mdadm at
   stop.
3. /dev/mdx is opened by a process such as udev or mdadm --monitor.
4. An inactive RAID array mdx is created and a "add" uevent is
   broadcasted to userland. It is let to userland to understand that
   this event must be discarded.

You have to admit that this behaviour is at best awkward :)

I read the commit d3374825ce57
"md: make devices disappear when they are no longer needed" in which
you express some concerns about an infinite loop due to udev always
opening newly created devices. Is that still actual ?

In your opinion, how could we get rid of an inactive RAID array created
by open ? Maybe we could switch the hold_active flag from UNTIL_IOCTL to
0 after some delay (enough to prevent udev from looping) ? In addition,
maybe we could remove the device node from mdadm --stop ? Or maybe
something else :)

If you are interested by any of this solutions or one of yours, I'll
be happy to work on it.

Thanks in advance for your thoughts,

Simon

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlYpDc0ACgkQgtp0PDeOcDpERQCgiylkzxr/qECVMsGggZ5Gmgjq
/WQAn24sQj8AZMwQNOtofufydpFfBUBC
=shGT
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
