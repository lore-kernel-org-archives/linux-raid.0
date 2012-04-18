From: Johannes Truschnigg <johannes@truschnigg.info>
Subject: Re: mdadm: sending ioctl 800c0910 to a partition!
Date: Wed, 18 Apr 2012 10:21:21 +0200
Message-ID: <20120418082121.GA6690@vault.local>
References: <CAK2H+efFUYqX98KBSdJAu-wH5c+Aec2+1K40uQVostDgyh8PYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK2H+efFUYqX98KBSdJAu-wH5c+Aec2+1K40uQVostDgyh8PYQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 17, 2012 at 08:48:06PM -0700, Mark Knecht wrote:
> Wondering if I should be concerned about these new messages?
>=20
> [...]

Not a reason for concern; this was introduced into the kernel to detect (and
then hopefully fix) misbehaving userspace, afaik. Having these messages in =
the
debug ringbuffer is annyoing for sure, but seeing it make its way into your
syslog is what really drove me a bit mad (esp. as Proxmox seems to poll blo=
ck
devices in a weird way, which generated such messages at a rate of several
dozen entries per minute...).

I made rsyslog (on Debian Squeeze) discard the kind of message by introduci=
ng
a regex filter to its chain of rules by creating a file
"/etc/rsyslog.d/zz-local.conf" with the following lines as its content:

:msg, regex, ".*sending ioctl [0-9][0-9]* to a partition.*" ~
:msg, regex, ".*scsi_verify_blk_ioctl: [0-9][0-9]* callbacks suppressed.*" ~

Maybe that's helpful for someone who doesn't like getting their logs spammed
with pretty meaningless noise, too.

--=20
with best regards:
- Johannes Truschnigg ( johannes@truschnigg.info )

www:   http://johannes.truschnigg.info/
phone: +43 650 2 133337
xmpp:  johannes@truschnigg.info

Please do not bother me with HTML-email or attachments. Thank you.

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk+OeYAACgkQnnUApj8OcoKSAACgjNI4eXUkUo0gWawJZpG1entK
WvwAmgIKjitVr4tyMUjILXqVfqKw0CEX
=t5Qj
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
